require 'minitest/spec'
require 'minitest/autorun'
require_relative './spec_helper'

module RubyGrid
  describe Grid do

    before :each do
      @default_test_grid = Grid.new
      @test_grid = Grid.new(4, 4, 'a')
      @test_grid.reset_all
    end

    describe 'default values' do
      it 'creates a 4x4 grid of nil values' do
        grid = Array.new(4, Array.new(4, nil))
        @default_test_grid.grid.must_equal grid
      end

      it 'has a default x and y values as 4' do
        @default_test_grid.sizex.must_equal 4
        @default_test_grid.sizey.must_equal 4
      end
    end

    describe '#sizex' do
      it 'returns the cell width of the grid' do
        @default_test_grid.sizex.must_equal 4
        @test_grid.sizex.must_equal 4
        g = Grid.new(8,8,'a')
        g.sizex.must_equal 8
      end
    end

    describe '#sizey' do
      it 'returns the cell height of the grid' do
        @default_test_grid.sizey.must_equal 4
        @test_grid.sizey.must_equal 4
        g = Grid.new(8,7,'b')
        g.sizey.must_equal 7
      end
    end

    describe '#is_valid?(x, y)' do
      it 'returns false when x is not a number' do
        @test_grid.is_valid?('a', 3).must_equal false
      end
      it 'returns false when y is not a number' do
        @test_grid.is_valid?(3, 'a').must_equal false
      end
      it 'returns false when x,y is out of bounds' do
        @test_grid.is_valid?(5, 5).must_equal false
      end
      it 'returns true when x,y is in bounds' do
        @test_grid.is_valid?(0, 0).must_equal true
        @test_grid.is_valid?(3, 3).must_equal true
      end
    end

    describe '#get_cell(x, y)' do
      it 'returns nil if the cell is not valid' do
        @test_grid.get_cell(5,5).must_equal nil
      end
      it 'returns "a" if the cell is valid' do
        @test_grid.get_cell(0,0).must_equal 'a'
      end
    end

    describe '#get_cells(cells)' do
      it 'returns an empty Array if the the argument is not an array' do
        @test_grid.get_cells('abc').must_equal []
      end
      it 'ignores invalid cells' do
        @test_grid.get_cells([[0,0],[4,4],[0,1]]).must_equal ['a', 'a']
      end
      it 'should return nil if a block is given' do
        cs = [[0,0],[0,1]]
        @test_grid.get_cells(cs) do |cell_data|
        end.must_equal nil
      end
      it 'returns the data in the provided cells' do
        cs = [[0,0],[0,1]]
        @test_grid.get_cells(cs).must_equal ['a', 'a']
      end
    end

    describe '#set_cell(x, y, obj)' do
      it 'returns nil if given cell is not valid' do
        @test_grid.set_cell(4,4,'b').must_equal nil
      end
      it 'sets the given cell to the given object' do
        @test_grid.get_cell(0,0).must_equal 'a'
        @test_grid.set_cell(0,0, 'b')
        @test_grid.get_cell(0,0).must_equal 'b'
      end
    end

    describe '#reset_cell(x, y)' do
      it 'returns nil if the given cell is not valid' do
        @test_grid.reset_cell(4,4).must_equal nil
      end
      it 'resets the given cell to the default value' do
        @test_grid.set_cell(1,1, 'b')
        @test_grid.get_cell(1,1).must_equal 'b'
        @test_grid.reset_cell(1,1)
        @test_grid.get_cell(1,1).must_equal 'a'
      end
    end

    describe '#reset_all' do
      it 'resets the grid to the default value' do
        @test_grid.set_cell(1,2, 'b')
        @test_grid.set_cell(2,0, 'c')
        g = Array.new(4, Array.new(4, 'a'))
        @test_grid.reset_all
        @test_grid.grid.must_equal g
      end
    end

    describe '#populate(data)' do
      it 'returns nil if data is not an Array' do
        @test_grid.populate('abc').must_equal nil
      end
      it 'sets the cell value to the default value if no obj provided' do
        @test_grid.set_cell(0,1,'d')
        @test_grid.get_cell(0,1).must_equal 'd'
        data = [[0,0,'b'],[2,2,'c'], [0,1]]
        @test_grid.populate(data)
        @test_grid.get_cell(0,1).must_equal 'a'
      end
      it 'populates multiple cells with provided data at once' do
        data = [[0,0,'b'],[2,2,'c']]
        @test_grid.populate(data)
        @test_grid.get_cell(0,0).must_equal 'b'
        @test_grid.get_cell(2,2).must_equal 'c'
      end
    end

    describe '#get_contents(no_default=false)' do
      it 'returns nil if a block is given' do
        @test_grid.get_contents do |x, y, cell_data|
        end.must_equal nil
      end
      it 'returns the entire grid\'s contents in a flat array' do
        contents = [[0,0,'a'],[0,1,'a'],[0,2,'a'],[0,3,'a'],[1,0,'a'],
                    [1,1,'a'],[1,2,'a'],[1,3,'a'],[2,0,'a'],[2,1,'a'],
                    [2,2,'a'],[2,3,'a'],[3,0,'a'],[3,1,'a'],[3,2,'a'],
                    [3,3,'a']]
        @test_grid.get_contents.must_equal contents
      end
      it 'doesn\'t return default values when no_default=true' do
        @test_grid.reset_all
        @test_grid.get_contents(no_default=true).must_equal []
      end
    end
  
    describe '#get_vector(vector)' do
      it 'raises NameError for unknown vectors/constants' do
        assert_raises(NameError) { @test_grid.get_vector(ABC) }
      end
      it 'returns the coordinates for the given vector' do
        @test_grid.get_vector(RubyGrid::TOP_LEFT).must_equal [-1, -1]    
        @test_grid.get_vector(RubyGrid::TOP).must_equal [-1, 0]
        @test_grid.get_vector(RubyGrid::TOP_RIGHT).must_equal [-1, 1]
        @test_grid.get_vector(RubyGrid::LEFT).must_equal [0, -1]
        @test_grid.get_vector(RubyGrid::CENTER).must_equal [0, 0]
        @test_grid.get_vector(RubyGrid::RIGHT).must_equal [0, 1]
        @test_grid.get_vector(RubyGrid::BOTTOM_LEFT).must_equal [1, -1]
        @test_grid.get_vector(RubyGrid::BOTTOM).must_equal [1, 0]
        @test_grid.get_vector(RubyGrid::BOTTOM_RIGHT).must_equal [1, 1]
      end
      it 'returns [nil,nil] if the given vector does not exist' do
        @test_grid.get_vector(RubyGrid::VERSION).must_equal [nil, nil]
      end
    end
    
    describe '#get_neighbor(x, y, vector)' do
      it 'returns nil for invalid x,y coordinates' do
        @test_grid.get_neighbor(4,5,TOP).must_equal nil 
      end
      it 'gets the cell\'s neighbor in a given vector' do
        @test_grid.get_neighbor(2,1,TOP).must_equal 'a'
      end
    end
  
    describe '#get_neighbors(x, y)' do
      it 'returns an empty array if x,y are not valid' do
        @test_grid.get_neighbors(4,5).must_equal []
      end
      it 'returns nil if a block is given' do
        @test_grid.get_neighbors(3,2) do |x, y, cell_data|
        end.must_equal nil
      end
      it 'returns an 8-element Array of the cell\'s neighbors' do
        neighbors = [[1,1,'a'],[1,2,'a'],[1,3,'a'],[2,1,'a'],[2,3,'a'],
                     [3,1,'a'],[3,2,'a'],[3,3,'a']]
        @test_grid.get_neighbors(2,2).must_equal neighbors
        @test_grid.get_neighbors(2,2).length.must_equal 8
      end
      it 'returns [nil,nil,OUTSIDE] for neighbors outside the grid' do
        neighbors = [[2,1,'a'],[2,2,'a'],[2,3,'a'],[3,1,'a'],[3,3,'a'],
                    [nil,nil,'OUTSIDE'],[nil,nil,'OUTSIDE'],[nil,nil,
                    'OUTSIDE']]
        @test_grid.get_neighbors(3,2).must_equal neighbors
        @test_grid.get_neighbors(3,2)[5].must_equal [nil,nil,'OUTSIDE']
      end
    end

    describe '#resize(newx, newy)' do
      it 'returns false if x is not a number' do
        @test_grid.resize('a',2).must_equal false
      end
      it 'returns false if y is not a number' do
        @test_grid.resize(2,'a').must_equal false
      end
      it 'returns true after resizing the grid' do
        new_grid = Grid.new(5,5,'a')
        new_grid.resize(4,4).must_equal true
      end
      it 'resizes the grid to be smaller' do
        new_grid = Grid.new(5,5,'a')
        new_grid.grid.length.must_equal 5
        new_grid.resize(4,4)
        new_grid.grid.length.must_equal 4
        new_grid.grid.must_equal @test_grid.grid
      end
      it 'resizes the grid to be larger, filling in the default value for 
          new cells' do
        new_grid = Grid.new(3,3,'a')
        new_grid.grid.length.must_equal 3
        new_grid.set_cell(0,0,'b')
        new_grid.set_cell(2,2,'b')
        new_grid.resize(4,4)
        new_grid.grid.length.must_equal 4
        new_grid.get_cell(0,0).must_equal 'b'
        new_grid.get_cell(2,2).must_equal 'b'
        new_grid.get_cell(3,3).must_equal 'a'
      end
    end

    describe '#get_row(x)' do
      it 'returns nil if a block is given' do
        @test_grid.get_row(0) do |cell_data|
        end.must_equal nil
      end
      it 'returns an empty Array if x is not valid' do
        @test_grid.get_row(4).must_equal []
      end
      it 'returns an Array of the values in the row' do
        @test_grid.get_row(0).must_equal ['a','a','a','a']
        @test_grid.get_row(0).length.must_equal 4
      end
    end

    describe '#get_column(y)' do
      it 'returns nil if a block is given' do
        @test_grid.get_column(0) do |cell_data|
        end.must_equal nil
      end
      it 'returns an empty Array if y is not valid' do
        @test_grid.get_column(4).must_equal []
      end
      it 'returns an Array of the values in the column' do
        @test_grid.get_column(0).must_equal ['a','a','a','a']
        @test_grid.get_column(0).length.must_equal 4
      end
    end

    describe '#traverse(x, y, vector)' do
      it 'returns nil if a block is given' do
        @test_grid.traverse(2,2,TOP) do |x, y, cell_data|
        end.must_equal nil
      end
      it 'returns an Array of the traversed cells' do
        a = Grid.new(5,5,'a')
        traversal = [[1,2,[['a','a','a','a','a'],['a','a','a','a','a']]],
                     [0,2,[['a','a','a','a','a'],['a','a','a','a','a']]]]
        a.traverse(2,2,TOP).must_equal traversal
        a.traverse(2,2,TOP).length.must_equal 2
      end
    end

    describe '#center' do
      it 'returns an Array containing the center coordinates' do
        g = Grid.new(5,5,' ')
        g.center.must_equal [2,2]
      end
      it 'rounds down when sizes are even' do
        @test_grid.center.must_equal [1,1]
      end
    end

  end
end
