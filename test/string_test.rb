require 'test_helper'

describe String do
  describe 'to_color' do
    it 'hex' do
      hex = '0000ff'
      hex.to_color(:hex).hex.must_equal '0000ff'

      hex = '0x0000ff'
      hex.to_color(:hex).hex.must_equal '0000ff'
    end

    it 'html' do
      'fff'.to_color(:html).hex.must_equal 'ffffff' 
      '#fff'.to_color(:html).hex.must_equal 'ffffff' 
    end

    it 'name' do
      'red'.to_color(:name).hex.must_equal 'ff0000'
      'blue'.to_color(:name).hex.must_equal '0000ff'
      'aliceblue'.to_color(:name).hex.must_equal 'f0f8ff'
    end
  end
end
