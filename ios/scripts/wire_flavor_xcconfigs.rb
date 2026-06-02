#!/usr/bin/env ruby
# Wires the Runner target in Runner.xcodeproj for flavors:
#   1. Each per-flavor build configuration → matching Flutter/<Mode>-<flavor>.xcconfig
#   2. Strips inline overrides that would shadow xcconfig values
#   3. Adds the "Copy Firebase config" Run Script Build Phase that drops
#      ios/config/<flavor>/GoogleService-Info.plist into the app bundle
#   4. Removes the static Runner/GoogleService-Info.plist file reference
#      from Copy Bundle Resources so it doesn't compete with the script
#
# Re-runs are idempotent. Run from repo root:
#   ruby ios/scripts/wire_flavor_xcconfigs.rb

require 'xcodeproj'

PROJECT_PATH = File.expand_path('../Runner.xcodeproj', __dir__)
MODES   = %w[Debug Profile Release]
FLAVORS = %w[dev staging production]

# Settings that must come from the per-flavor xcconfig, not the inline
# buildSettings dictionary (Xcode copies them across when you duplicate a
# configuration, which silently shadows the xcconfig).
SHADOWED_SETTINGS = %w[
  PRODUCT_BUNDLE_IDENTIFIER
  INFOPLIST_KEY_CFBundleDisplayName
  FLUTTER_TARGET
].freeze

FIREBASE_PHASE_NAME = 'Copy Firebase config'
FIREBASE_SCRIPT = <<~SH.strip
  "${SRCROOT}/scripts/copy_google_service_info.sh"
SH

project = Xcodeproj::Project.open(PROJECT_PATH)

# ── 1. xcconfig wiring + shadow stripping ────────────────────────────────
flutter_group = project.main_group.find_subpath('Flutter', true)
flutter_group.set_source_tree('SOURCE_ROOT')

MODES.product(FLAVORS).each do |mode, flavor|
  name = "#{mode}-#{flavor}"
  xcconfig_path = "Flutter/#{name}.xcconfig"

  file_ref = flutter_group.files.find { |f| f.path == xcconfig_path }
  unless file_ref
    file_ref = flutter_group.new_reference(xcconfig_path)
    file_ref.last_known_file_type = 'text.xcconfig'
  end

  project
    .objects
    .select { |o| o.isa == 'XCBuildConfiguration' && o.name == name }
    .each do |config|
      config.base_configuration_reference = file_ref
      SHADOWED_SETTINGS.each { |key| config.build_settings.delete(key) }
    end
end

# ── 2. Runner target: Firebase plist Run Script Build Phase ──────────────
runner = project.targets.find { |t| t.name == 'Runner' }
abort 'Runner target not found in project.pbxproj' unless runner

existing_phase = runner.build_phases.find do |p|
  p.isa == 'PBXShellScriptBuildPhase' && p.name == FIREBASE_PHASE_NAME
end

if existing_phase.nil?
  phase = project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
  phase.name = FIREBASE_PHASE_NAME
  phase.shell_path = '/bin/sh'
  phase.shell_script = FIREBASE_SCRIPT
  phase.input_paths = ['$(SRCROOT)/scripts/copy_google_service_info.sh']
  phase.output_paths = ['$(BUILT_PRODUCTS_DIR)/$(PRODUCT_NAME).app/GoogleService-Info.plist']
  phase.show_env_vars_in_log = '0'

  # Place AFTER Copy Bundle Resources so our copy isn't overwritten by it.
  resources_index = runner.build_phases.index do |p|
    p.isa == 'PBXResourcesBuildPhase'
  end
  insert_at = resources_index ? resources_index + 1 : runner.build_phases.length
  runner.build_phases.insert(insert_at, phase)
  firebase_phase_added = true
else
  # Keep script body, input/output paths in sync if the phase already exists.
  existing_phase.shell_script = FIREBASE_SCRIPT
  existing_phase.input_paths = ['$(SRCROOT)/scripts/copy_google_service_info.sh']
  existing_phase.output_paths = ['$(BUILT_PRODUCTS_DIR)/$(PRODUCT_NAME).app/GoogleService-Info.plist']
  firebase_phase_added = false
end

# ── 3. Strip Runner/GoogleService-Info.plist from Copy Bundle Resources ─
removed_static_plist = 0
runner.resources_build_phase.files.dup.each do |bf|
  ref = bf.file_ref
  next unless ref
  basename = File.basename(ref.path.to_s)
  next unless basename == 'GoogleService-Info.plist'
  runner.resources_build_phase.remove_build_file(bf)
  removed_static_plist += 1
end

project.save

puts "Wired #{MODES.size * FLAVORS.size} configurations, " \
     "stripped #{SHADOWED_SETTINGS.size} inline overrides, " \
     "#{firebase_phase_added ? 'added' : 'refreshed'} Firebase Run Script phase, " \
     "removed #{removed_static_plist} static plist resource entries."
