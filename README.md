RubyGrid
========

[![Build Status](https://travis-ci.org/yacn/Ruby-Grid.png)](https://travis-ci.org/yacn/Ruby-Grid)

Description
-----------

Grid Class for Games or whatever else you can think of.
By [Randy Carnahan](https://github.com/syntruth),
released to the Public Domain.
Lua Version: http://github.com/syntruth/Lua-Grid

Caveats
--------

* The Grid object is data agnostic.  It doesn't care what 
  kind of data you store in a cell. This is meant to be, 
  for abstraction's sake. You could even store functions.
* The class defines -no- display methods. Either sub-class
  the Grid class to add your own, or define functions that
  call the `#get_*` methods.
* Grid coordinates are always x,y number pairs. X is the 
  vertical, starting at the top left, and Y is the 
  horizontal, also starting at the top left. Hence, the 
  top-left cell is always 0,0. One cell to the right is
  0,1. One cell down is 1,0.
* Some Grid constants (`OUTSIDE`, `NOT_VALID`, `NIL_VALUE`) are 
  not numbers, but strings, just in case number data is to 
  be stored in a cell.

Example Usage
-------------
```
require 'grid'
g = RubyGrid.create(8, 8, ' ')
c = [[4, 4, 'O'], [4, 5, 'X'], [5, 4, 'X'], [5, 5, 'O']]
g.populate(c)
g.traverse(0, 0, RubyGrid::BOTTOM_RIGHT) do |x, y, value|
  puts "#{x}, #{y}: #{value}"
end
g.resize(4, 4)
g.get_cell(3, 3)
```
