require 'test_helper'

describe NiceColor do
  it 'golden: false, hue: 12, saturation: 0.7, value: 0.8' do
    color = NiceColor.make(golden: false, hue: 12, saturation: 0.7, value: 0.8)
    color.hex.must_equal 'cc593d'
  end

end
