require 'rubygrid/version'
require 'rubygrid/gridbase'

module RubyGrid
  # Wrapper for GridBase#new
  def RubyGrid.create(x, y, value)
    return GridBase.new(x, y, value)
  end

  # Yields each of the vector constants in turn, from top-left
  # to bottom-right.
  def RubyGrid.get_all_vectors # :yields: vector_constant
    [TOP_LEFT,
     TOP,
     TOP_RIGHT,
     LEFT,
     CENTER,
     RIGHT,
     BOTTOM_LEFT,
     BOTTOM,
     BOTTOM_RIGHT
    ].each do |v|
      yield v # :yields: vector_constant
    end
  end
end
