require 'test_helper'

describe Color::Maker do
  it 'golden: false, hue: 12, saturation: 0.7, value: 0.8' do
    color = Color::Maker.new.make(golden: false, hue: 12, saturation: 0.7, value: 0.8)
    color.hex.must_equal 'cc5a3d'
  end

  it 'golden: true, hue: 16, saturation: 0.5, value: 0.65' do
    color = Color::Maker.new.make(golden: false, hue: 16, saturation: 0.5, value: 0.65)
    color.hex.must_equal 'a66953'
  end

  it 'golden: false, hue: 10, saturation: 0.6, value: 0.80' do
    color = Color::Maker.new.make(golden: false, hue: 10, saturation: 0.6, value: 0.80)
    color.hex.must_equal 'cc6652'
  end

  it 'golden: false, hue: 12, saturation: 0.9, value: 0.3' do
    color = Color::Maker.new.make(golden: false, hue: 12, saturation: 0.9, value: 0.3)
    color.hex.must_equal '4d1508'
  end

  it 'grayscale: true, hue: 12' do
    color = Color::Maker.new.make(grayscale: true, hue: 12, value: 0.3)
    color.hex.must_equal color.hex[0..1] * 3
  end

  it 'base_color: :aliceblue' do
    maker = Color::Maker.new(seed: 1234)
    color = maker.make(:base_color => :aliceblue)
    color.hex.must_equal '316d98'
  end

  it 'base_color: rosybrown' do
    maker = Color::Maker.new(seed: 1234)
    color = maker.make(:base_color => 'rosybrown')
    color.hex.must_equal '983136'
  end

  it 'multiple colors' do
    maker = Color::Maker.new(seed: 1234, count: 5)
    colors = maker.make
    colors.size.must_equal 5

    colors.map!(&:hex)
    colors.must_equal ['aebf73', '73afbf', 'bfb273', '73bf8b', '73bfb8']
  end

  it 'generator can be overriden inside make method' do
    maker = Color::Maker.new(seed: 1234, count: 5)
    colors = maker.make
    colors.size.must_equal 5

    colors.map!(&:hex)
    colors.must_equal ['aebf73', '73afbf', 'bfb273', '73bf8b', '73bfb8']

    maker = Color::Maker.new(seed: 1234, count: 5)
    colors = maker.make(seed: 4444)
    colors.size.must_equal 5
    colors.wont_equal ['aebf72', '72afbf', 'bfb272', '72bf8a', '72bfb7']
  end
end

