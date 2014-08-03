# Monkey patch Hash class with color conversion utility methods
class Hash
  # Convert an Hash to color
  # 
  # @param [Symbol] format color format (:rgb, :hsv, :hsl)
  # @return [Color::RGB]
  # @example
  #   { r: 150, g: 100, b: 200 }.to_colour(:rgb) #=> Color::RGB
  #   { red: 150, green: 100, blue: 200 }.to_colour(:rgb) #=> Color::RGB
  #   { h: 150, s: 100, v: 200 }.to_colour(:hsv) #=> Color::RGB
  #   { hue: 150, saturation: 100, value: 200 }.to_colour(:hsv) #=> Color::RGB
  #   { hue: 150, saturation: 100, lightness: 200 }.to_colour(:hsl) #=> Color::RGB
  #   { h: 150, s: 100, l: 200 }.to_colour(:hsl) #=> Color::RGB
  def to_color(format = :rgb)
    format = format.to_sym
    if format == :rgb
      normalized = Color::Maker::Support.normalize_color_keys(self, format: :rgb)
      r, g, b = normalized[:r].to_i, normalized[:g].to_i, normalized[:b].to_i
      return Color::Maker::Support::rgb_to_color(r: r, g: g, b: b)
    end

    if format == :hsv
      normalized = Color::Maker::Support.normalize_color_keys(self, format: :hsv)
      h, s, v = normalized[:h].to_f, normalized[:s].to_f, normalized[:v].to_f
      return Color::Maker::Support::hsv_to_color(h: h, s: s, v: v)
    end

    if format == :hsl
      normalized = Color::Maker::Support.normalize_color_keys(self, format: :hsl)
      h, s, l = normalized[:h].to_f, normalized[:s].to_f, normalized[:l].to_f
      return Color::Maker::Support::hsl_to_color(h: h, s: s, l: l)
    end
    
    raise "Unknow color format: #{format}"
  end

  # Replace keys
  #
  # @param [Symbol, Array, String] needle The value being searched for, otherwise known 
  #   as the needle. An array may be used to designate multiple needles.
  # @param [Symbol, String] replace The replacement value that replaces found search values.
  # @example
  #   { one: 1, two: 2 }.replace_key!([:one, :two], :three) #=> { three: 2 }
  #   { one: 1, two: 2 }.replace_key!(:one, :three) #=> { three: 1, two: 2 }
  def replace_key!(needle, replace)
    needle = [needle] unless needle.is_a?(Enumerable)
    needle.each { |key| self[replace] = self.delete(key) if self.key?(key) }
    self
  end
end

