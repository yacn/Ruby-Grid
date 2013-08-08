require 'minitest/spec'
require 'minitest/autorun'
require_relative './spec_helper'

describe RubyGrid do

  describe '#create(x, y, value)' do
    it 'wraps Grid#create and is functionally equivalent' do
      a = RubyGrid.create(3,3,'a')
      b = RubyGrid::Grid.new(3,3,'a')
      c = Array.new(3, Array.new(3, 'a'))

      a.get_grid.must_equal b.get_grid
      a.get_grid.must_equal c
      b.get_grid.must_equal c

      a.get_x.must_equal b.get_x
      a.get_x.must_equal c[0].length
      b.get_x.must_equal c[0].length

      a.get_y.must_equal b.get_y
      a.get_y.must_equal c.length
      b.get_y.must_equal c.length
    end
  end

  describe '#get_all_vectors' do
    it 'yields each vector from TOP_LEFT to BOTTOM_RIGHT' do
      val = 1
      RubyGrid.get_all_vectors do |v|
        v.must_equal val
        val += 1
      end
    end
  end

end
