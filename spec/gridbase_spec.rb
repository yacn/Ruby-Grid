require 'minitest/spec'
require 'minitest/autorun'
require_relative './spec_helper'

module RubyGrid
  describe GridBase do

    let(:default_test_grid) { GridBase.new }
    let(:test_grid) { GridBase.new(4, 4, 'a') }
    describe 'default values' do
      it 'creates a 4x4 grid of nil values' do
        grid = Array.new(4, Array.new(4, nil))
        default_test_grid.get_grid.must_equal grid
      end

      it 'has a default x and y values as 4' do
        default_test_grid.get_x.must_equal 4
        default_test_grid.get_y.must_equal 4
      end
    end

    describe '#is_valid?' do
      it 'returns false when x is not a number' do
        test_grid.is_valid?('a', 3).must_equal false
      end
      it 'returns false when y is not a number' do
        test_grid.is_valid?(3, 'a').must_equal false
      end
      it 'returns false when x,y is out of bounds' do
        test_grid.is_valid?(5, 5).must_equal false
      end
      it 'returns true when x,y is in bounds' do
        test_grid.is_valid?(0, 0).must_equal true
        test_grid.is_valid?(3, 3).must_equal true
      end
    end

    describe '#get_cell(x, y)' do
      it 'returns nil if the cell is not valid' do
        test_grid.get_cell(5,5).must_equal nil
      end
      it 'returns "a" if the cell is valid' do
        test_grid.get_cell(0,0).must_equal 'a'
      end
    end

    describe '#get_cells(cells)' do
      it 'returns an empty Array if the the argument is not an array' do
        test_grid.get_cells('abc').must_equal []
      end
      it 'ignores invalid cells' do
        test_grid.get_cells([[0,0],[4,4],[0,1]]).must_equal ['a', 'a']
      end
      it 'should return nil if a block is given' do
        cs = [[0,0],[0,1]]
        test_grid.get_cells(cs) do |cell_data|
          puts cell_data
        end.must_equal nil
      end
      it 'returns the data in the provided cells' do
        cs = [[0,0],[0,1]]
        test_grid.get_cells(cs).must_equal ['a', 'a']
      end
    end

    describe '#set_cell(x, y, obj)' do
      it 'returns nil if given cell is not valid' do
        test_grid.set_cell(4,4,'b').must_equal nil
      end
      it 'sets the given cell to the given object' do
        test_grid.get_cell(0,0).must_equal 'a'
        test_grid.set_cell(0,0, 'b')
        test_grid.get_cell(0,0).must_equal 'b'
      end
    end

    describe '#reset_cell(x, y)' do
      it 'returns nil if the given cell is not valid' do
        test_grid.reset_cell(4,4).must_equal nil
      end
      it 'resets the given cell to the default value' do
        test_grid.set_cell(1,1, 'b')
        test_grid.get_cell(1,1).must_equal 'b'
        test_grid.reset_cell(1,1)
        test_grid.get_cell(1,1).must_equal 'a'
      end
    end

    describe '#reset_all' do
      it 'resets the grid to the default value' do
        test_grid.set_cell(1,2, 'b')
        test_grid.set_cell(2,0, 'c')
        g = Array.new(4, Array.new(4, 'a'))
        test_grid.reset_all
        test_grid.get_grid.must_equal g
      end
    end

    describe '#populate(data)' do
      it 'returns nil if data is not an Array' do
        test_grid.populate('abc').must_equal nil
      end
      it 'sets the cell value to the default value if no obj provided' do
        test_grid.set_cell(0,1,'d')
        test_grid.get_cell(0,1).must_equal 'd'
        data = [[0,0,'b'],[2,2,'c'], [0,1]]
        test_grid.populate(data)
        test_grid.get_cell(0,1).must_equal 'a'
      end
      it 'populates multiple cells with provided data at once' do
        data = [[0,0,'b'],[2,2,'c']]
        test_grid.populate(data)
        test_grid.get_cell(0,0).must_equal 'b'
        test_grid.get_cell(2,2).must_equal 'c'
      end
    end

    describe '#get_contents(no_default=false)' do
    end
  
    describe '#get_vector(vector)' do
    end
    
    describe '#get_neighbor(x, y, vector)' do
    end
  
    describe '#get_neighbors(x, y)' do
    end

    describe '#resize(newx, newy)' do
    end

    describe '#get_row(x)' do
    end

    describe '#get_column(y)' do
    end

    describe '#traverse(x, y, vector)' do
    end

    
  end
end
