#!/usr/bin/env bash

echo "Removing old gem file"
rm *.gem 2>/dev/null
gem uninstall -a RubyGrid

echo "Building gem"
gem build RubyGrid.gemspec

echo "Installing gem to local system"
gem install *.gem
