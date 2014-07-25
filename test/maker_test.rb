require 'test_helper'

describe Color::Maker do
  it 'golden: false, hue: 12, saturation: 0.7, value: 0.8' do
    color = Color::Maker.new.make(golden: false, hue: 12, saturation: 0.7, value: 0.8)
    color.hex.must_equal 'cc593d'
  end

  it 'golden: true, hue: 16, saturation: 0.5, value: 0.65' do
    color = Color::Maker.new.make(golden: false, hue: 16, saturation: 0.5, value: 0.65)
    color.hex.must_equal 'a56852'
  end

  it 'golden: false, hue: 10, saturation: 0.6, value: 0.80' do
    color = Color::Maker.new.make(golden: false, hue: 10, saturation: 0.6, value: 0.80)
    color.hex.must_equal 'cc6651'
  end

  it 'golden: false, hue: 12, saturation: 0.9, value: 0.3' do
    color = Color::Maker.new.make(golden: false, hue: 12, saturation: 0.9, value: 0.3)
    color.hex.must_equal '4c1507'
  end

  it 'grayscale: true, hue: 12' do
    color = Color::Maker.new.make(grayscale: true, hue: 12, value: 0.3)
    color.hex.must_equal color.hex[0..1] * 3
  end

  it 'base_color: :aliceblue' do
    maker = Color::Maker.new(seed: 1234)
    color = maker.make(:base_color => :aliceblue)
    color.hex.must_equal '306d98'
  end

  it 'base_color: rosybrown' do
    maker = Color::Maker.new(seed: 1234)
    color = maker.make(:base_color => 'rosybrown')
    color.hex.must_equal '983036'
  end

  it 'multiple colors' do

  end
end

