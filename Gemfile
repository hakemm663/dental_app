source "https://rubygems.org"

# Fastlane manages Android + iOS release automation for DocDoc. Pin the
# minor band to avoid surprise major-version breakage in CI.
gem "fastlane", "~> 2.220"

# Plugins discovered by Fastlane via the Pluginfile pattern. Currently empty;
# add `fastlane add_plugin <name>` and commit the resulting Pluginfile when
# we wire Play Store or TestFlight upload lanes.
plugins_path = File.join(File.dirname(__FILE__), "fastlane", "Pluginfile")
eval_gemfile(plugins_path) if File.exist?(plugins_path)
