require 'simplecov'
SimpleCov.start do
  require 'simplecov-badge'
  SimpleCov::Formatter::BadgeFormatter.generate_groups = true
  SimpleCov::Formatter::BadgeFormatter.strength_foreground = true
  SimpleCov::Formatter::BadgeFormatter.timestamp = true
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::BadgeFormatter,
  ]
end

require_relative '../lib/rubygrid'
module RubyGrid
  class Grid
    def get_grid
      return @grid
    end
    def get_x
      return @size_x
    end
    def get_y
      return @size_y
    end
  end
end
