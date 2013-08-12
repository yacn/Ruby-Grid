require 'minitest/spec'
require 'minitest/autorun'
require_relative './spec_helper'

describe RubyGrid do

  describe '#create(x, y, value)' do
    it 'wraps Grid#create and is functionally equivalent' do
      a = RubyGrid.create(3,3,'a')
      b = RubyGrid::Grid.new(3,3,'a')
      c = Array.new(3, Array.new(3, 'a'))

      a.grid.must_equal b.grid
      a.grid.must_equal c
      b.grid.must_equal c

      a.sizex.must_equal b.sizex
      a.sizex.must_equal c[0].length
      b.sizex.must_equal c[0].length

      a.sizey.must_equal b.sizey
      a.sizey.must_equal c.length
      b.sizey.must_equal c.length
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
