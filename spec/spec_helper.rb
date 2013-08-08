require 'coveralls'
Coveralls.wear!

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
