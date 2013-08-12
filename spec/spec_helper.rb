require 'coveralls'
Coveralls.wear!

require 'minitest'
begin
  require 'minitest/pride' # colorful output
rescue LoadError
  # continue w/o color
end
if __FILE__ == $0
  $LOAD_PATH.unshift('lib', 'spec')
  Dir.glob('./spec/*_spec.rb') {|f| require f}
end

require_relative './../lib/rubygrid'
module RubyGrid
  class Grid
    def grid
      return @grid
    end
    def sizex
      return @size_x
    end
    def sizey
      return @size_y
    end
  end
end
