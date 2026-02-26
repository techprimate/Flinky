source "https://rubygems.org"

gem "abbrev" # Required by Ruby v3.4.X
gem "ostruct" # Required by Ruby v3.5.X
gem "benchmark" # Required by Ruby v3.5.X

gem "fastlane"
gem "octokit"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
