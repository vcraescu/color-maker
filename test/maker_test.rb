require 'test_helper'

describe Color::Maker do
  #it 'golden: false, hue: 12, saturation: 0.7, value: 0.8' do
    #color = Color::Maker.new.make(golden: false, hue: 12, saturation: 0.7, value: 0.8)
    #color.hex.must_equal 'cc5a3d'
  #end

  #it 'golden: true, hue: 16, saturation: 0.5, value: 0.65' do
    #color = Color::Maker.new.make(golden: false, hue: 16, saturation: 0.5, value: 0.65)
    #color.hex.must_equal 'a66953'
  #end

  #it 'golden: false, hue: 10, saturation: 0.6, value: 0.80' do
    #color = Color::Maker.new.make(golden: false, hue: 10, saturation: 0.6, value: 0.80)
    #color.hex.must_equal 'cc6652'
  #end

  #it 'golden: false, hue: 12, saturation: 0.9, value: 0.3' do
    #color = Color::Maker.new.make(golden: false, hue: 12, saturation: 0.9, value: 0.3)
    #color.hex.must_equal '4d1508'
  #end

  #it 'grayscale: true, hue: 12' do
    #color = Color::Maker.new.make(grayscale: true, hue: 12, value: 0.3)
    #color.hex.must_equal color.hex[0..1] * 3
  #end

  #it 'base_color: :aliceblue' do
    #maker = Color::Maker.new(seed: 1234)
    #color = maker.make(:base_color => :aliceblue)
    #color.hex.must_equal '316d98'
  #end

  #it 'base_color: rosybrown' do
    #maker = Color::Maker.new(seed: 1234)
    #color = maker.make(:base_color => 'rosybrown')
    #color.hex.must_equal '983136'
  #end

  #it 'multiple colors' do
    #maker = Color::Maker.new(seed: 1234, count: 5)
    #colors = maker.make
    #colors.size.must_equal 5

    #colors.map!(&:hex)
    #colors.must_equal ['aebf73', '73afbf', 'bfb273', '73bf8b', '73bfb8']
  #end

  #it 'generator can be overriden inside make method' do
    #maker = Color::Maker.new(seed: 1234, count: 5)
    #colors = maker.make
    #colors.size.must_equal 5

    #colors.map!(&:hex)
    #colors.must_equal ['aebf73', '73afbf', 'bfb273', '73bf8b', '73bfb8']

    #maker = Color::Maker.new(seed: 1234, count: 5)
    #colors = maker.make(seed: 4444)
    #colors.size.must_equal 5
    #colors.wont_equal ['aebf72', '72afbf', 'bfb272', '72bf8a', '72bfb7']
  #end

  it 'normalize options' do
    maker = Color::Maker.new

    options = { h: 10, s: 0.9, value: 10 }
    normalized = maker.send(:normalize_options, options)
    normalized.must_equal(hue: 10, saturation: 0.9, value: 10)

    options = { hue: 10, s: 0.9, value: 10 }
    normalized = maker.send(:normalize_options, options)
    normalized.must_equal(hue: 10, saturation: 0.9, value: 10)

    options = { red: 200, g: 100, blue: 150 }
    normalized = maker.send(:normalize_options, options)
    normalized.must_equal(red: 200, green: 100, blue: 150)

    options = { h: 200, g: 100, light: 150 }
    normalized = maker.send(:normalize_options, options)
    normalized.must_equal(hue: 200, green: 100, lightness: 150)

    options = { hue: 200, g: 100, lightness: 150, grayscale: true }
    normalized = maker.send(:normalize_options, options)
    normalized.must_equal(hue: 200, green: 100, lightness: 150, greyscale: true)

    options = { hue: 200, g: 100, lightness: 150, gray: true }
    normalized = maker.send(:normalize_options, options)
    normalized.must_equal(hue: 200, green: 100, lightness: 150, greyscale: true)
  end

  it 'extract color' do 
    maker = Color::Maker.new

    options = { hue: 200, g: 100, lightness: 0.9, gray: true }
    color = maker.send(:extract_color, options)
    color.must_equal(h: 0, s: 0, v: 0.004)
  end

  #it 'mixed up color parameters' do
    #color = Color::Maker.new.make(seed: 1234, h: 10, s: 0.9, value: 0.3)
    #color.hex.must_equal '4d1508'
  #end
end

