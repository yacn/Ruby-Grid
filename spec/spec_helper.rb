require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

# Runs tests when this file is executed
if __FILE__ == $0
  $LOAD_PATH.unshift('lib', 'spec')
  Dir.glob('./spec/*_spec.rb') { |f| require f }
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
