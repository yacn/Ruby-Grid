module RubyGrid
  class GridBase
    # GridBase constructor.
    # +sizex+ and +sizey+::
    #   These set the desired size of the grid, 4 by default.
    # +def_value+::
    #   The default data to store in a cell by default.
    def initialize(sizex=4, sizey=4, def_value=nil)
      @grid = []
      
      # Default Grid size is 4x4
      sizex = 4 unless sizex.is_a?(Fixnum) or sizex.nil?
      sizey = 4 unless sizey.is_a?(Fixnum) or sizey.nil?

      @size_x = sizex
      @size_y = sizey
      @def_value = def_value

      # Build the grid and insert the default values.
      @size_x.times do |x|
        @grid.push([])
        
        @size_y.times do |y|
          @grid[x].push(def_value)
        end
      end
    end

  public
    
    # This checks to see if a given x,y pair are within 
    # the boundaries of the grid.
    def is_valid?(x, y)
      unless (is_number?(x) and is_number?(y))
        return false
      end
      return ((x >= 0 and x < @size_x) and (y >= 0 and y < @size_y))
    end

    # Get the data in a given x,y cell.
    # Returns nil if the cell is not valid.
    def get_cell(x, y)
      return @grid[x][y] if is_valid?(x,y)
    end

    # This method will return a set of cell data in a table.
    # The 'cells' argument should be an array of x,y pairs of
    # the cells being requested.
    def get_cells(cells) # :yields: cell_data
      data = []

      return data unless cells.is_a?(Array)

      cells.each do |x,y|
        if is_valid?(x,y)
          
          if block_given?
            yield @grid[x][y]
          else
            data.push(@grid[x][y])
          end

        end
      end
      
      return block_given? ? nil : data
    end

    # Sets a given x,y cell to the data object
    def set_cell(x,y, obj)
      @grid[x][y] = obj if is_valid?(x,y)
    end
    
    # Resets a given x,y cell to the grid default value
    def reset_cell(x,y)
      @grid[x][y] = @def_value if is_valid?(x,y)
    end

    # Resets the entire grid to the default value
    def reset_all
      @size_x.times do |x|
        @size_y.times do |y|
          @grid[x][y] = @def_value
        end
      end
    end

    # This method is used to populate multiple cells at once.
    # +data+::
    #   This argument must be an Array, with each element 
    #   consisting of three values: x, y, and the data to 
    #   set the cell to.
    #
    # Example:
    #
    #   d = [[4, 4, "X"], [4, 5, "O"], [5, 4, "O"], [5, 5, "X"]]
    #   grid.populate(d)
    #
    # If the object to be populated is nil, it is replaced with
    # the default value.
    def populate(data)
      return unless data.is_a?(Array)

      data.each do |x, y, obj|
        if is_valid?(x,y)
          obj = @def_value if obj.nil?
          @grid[x][y] = obj
        end
      end
      return
    end

    # This method returns the entire grid's contents in a 
    # flat array suitable for feeding to #populate above.
    # Useful for recreating a grid layout.
    # If the +no_default+ argument is non-false, then the 
    # returned data Array only contains elements who's 
    # cells are not the default value.
    # Returns +nil+ if a block is given.
    def get_contents(no_default=false) # :yields: x, y, cell_data
      data = []
      cell_obj = nil

      @size_x.times do |x|
        @size_y.times do |y|
          cell_obj = @grid[x][y]
          unless no_default and cell_obj == @def_value
            if block_given?
              yield x, y, cell_obj
            else
              data.push([x,y,cell_obj])
            end
          end
        end
      end
      
      return block_given? ? nil : data

    end

    # Convienence method to return an x,y vector pair from the
    # GRID_* vector constants. Or nil if there is no such 
    # constant.
    def get_vector(vector)
      case vector
        when TOP_LEFT     then return -1, -1
        when TOP          then return -1,  0
        when TOP_RIGHT    then return -1,  1
        when LEFT         then return  0, -1
        when CENTER       then return  0,  0
        when RIGHT        then return  0,  1
        when BOTTOM_LEFT  then return  1, -1
        when BOTTOM       then return  1,  0
        when BOTTOM_RIGHT then return  1,  1
      else
        return nil, nil
      end
    end

    # Get a cell's neighbor in a given vector.
    def get_neighbor(x,y, vector)
      vx, vy = get_vector(vector)

      if vx and vy
        x = x + vx
        y = y + vy
        return @grid[x][y] if is_valid?(x,y)
      end
    end

    # Will return an Array of 8 elements, with each element
    # representing one of the 8 neighbors for the given 
    # x,y cell. Each element of the returned Array will consist
    # of the x,y cell pair, plus the data stored there, suitable
    # for use of the populate method. If the neighbor cell is
    # outside the grid, then [nil, nil, OUTSIDE] is used
    # for the value.
    # If the given x,y values are not sane, an empty Array
    # is returned instead.
    def get_neighbors(x,y) # :yields: x, y, cell_data
      data = []
      
      return data unless is_valid?(x,y)

      # The vectors used are x,y pairs between -1 and +1
      # for the given x,y cell.
      # IE:
      # (-1, -1) (0, -1) (1, -1)
      # (-1,  0) (0,  0) (1,  0)
      # (-1,  1) (0,  1) (1,  1)
      # Value of 0,0 is ignored, since that is the cell
      # we are working with! :D
      for gx in -1..1
        for gy in -1..1
          vx = x + gx
          vy = y + gy

          unless gx == 0 and gy == 0
            if is_valid?(vx,vy)
              if block_given?
                yield vx, vy, @grid[vx][vy]
              else
                data.push([vx, vy, @grid[vx][vy]])
              end
            else
              if block_given?
                yield nil, nil, OUTSIDE
              else
                data.push([nil, nil, OUTSIDE])
              end
            end
          end
        end
      end 

      return block_given? ? nil : data
    end

    # This method will change the grid size. If the new size is
    # smaller than the old size, data in the cells now 'outside'
    # the grid is lost. If the grid is now larger, new cells are
    # filled with the default value given when the grid was first
    # created.
    def resize(newx, newy)
      if (not newx.is_a?(Fixnum) or newx.nil?) or (not newy.is_a?(Fixnum) or newy.nil?)
        return false
      end

      # Save old data
      c = get_contents
      
      # Reset grid.
      @grid.clear

      # Set the new sizes.
      @size_x = newx
      @size_y = newy
      
      newx.times do |x|
        @grid.push([])
        
        newy.times do |y|
          @grid[x].push(@def_value)
        end
      end
      
      # Insert the old contents
      populate(c)

      return true
    end

    # This method returns an Array of all values in a given 
    # row 'x' value.
    # If given a block, then the data in each cell in the row
    # is passed to the block.
    def get_row(x) # :yields: cell_data
      row = []

      if x.is_a?(Fixnum) and (x >= 0 and x < @size_x)
        row = @grid[x]
      end

      if block_given?
        row.each do |obj|
          yield obj
        end
      end

      return block_given? ? nil : row
    end

    # This method returns an Array of all values in a given
    # column 'y' value.
    # If given a block, then the data in each cell in the column
    # is passed to the block.
    def get_column(y) # :yields: cell_data
      col = []

      if y.is_a?(Fixnum) and (y >= 0 and y < @size_y)
        @size_x.times do |x|
          if block_given?
            yield @grid[x][y]
          else
            col.push(@grid[x][y])
          end
        end
      end

      return block_given? ? nil : col
    end

    # This method traverses a line of cells, from a given x,y
    # going in +vector+ direction. The vector arg is one of the 
    # Grid::* traversal constants. This will return an Array of
    # the data of the cells along the traversal path or nil if
    # the original x,y is not valid or if the vector is not one
    # of the constant values. The first element of the Array 
    # will be the first cell -after- the x, y cell given as the
    # argument.
    # In the returned Array, each element will be in the format
    # of [x, y, obj], suitable for #populate.
    # If a block is given, then each x, y, and data is passed to
    # the block, and nil is returned.
    def traverse(x, y, vector) # :yields: x, y, cell_data
      data = []

      if is_valid?(x,y)
        vx, vy = get_vector(vector)

        return data unless vx and vy

        gx = x + vx
        gy = y + vy

        while is_valid?(gx, gy)
          obj = @grid[gx,gy]

          if block_given?
            yield gx, gy, obj
          else
            data.push([gx, gy, obj])
          end

          gx = gx + vx
          gy = gy + vy
        end
      end

      return block_given? ? nil : data
    end

  private
    def is_number?(n)
      (n.respond_to?(:even?) and not n.nil?)
    end

  end
end
