#!/usr/bin/env ruby
# Wires each per-flavor build configuration in Runner.xcodeproj to its
# matching `Flutter/<Mode>-<flavor>.xcconfig` and strips inline overrides
# that would shadow the xcconfig values. Re-runs are idempotent.
#
# Run from repo root:  ruby ios/scripts/wire_flavor_xcconfigs.rb

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

project = Xcodeproj::Project.open(PROJECT_PATH)

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

project.save
puts "Wired #{MODES.size * FLAVORS.size} configurations and stripped " \
     "#{SHADOWED_SETTINGS.size} inline overrides."
