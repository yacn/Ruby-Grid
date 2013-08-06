require 'rubygrid/version'
require 'rubygrid/gridbase'

module RubyGrid

  # Some constant values. These are set as strings instead of
  # integer values to prevent clashes of data.
  OUTSIDE   = "OUTSIDE".freeze
  NOT_VALID = "NOT_VALID".freeze
  NIL_VALUE = "NIL_VALUE".freeze

  # Traversal Vector Constants
  TOP_LEFT = 1
  TOP = 2
  TOP_RIGHT = 3
  LEFT = 4
  CENTER = 5
  RIGHT = 6
  BOTTOM_LEFT = 7
  BOTTOM = 8
  BOTTOM_RIGHT = 9

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
