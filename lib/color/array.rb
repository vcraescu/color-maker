# Monkey patch Array class with color conversion utility methods
class Array
  # Converts an array to color
  #
  # @param [Symbol] format color format (:rgb, :hsv, :hsl)
  # @return [Color::RGB]
  # @example
  #   [150, 200, 100].to_color(:rgb) #=> Color::RGB
  #   [200, 0.9, 0.3].to_color(:hsv) #=> Color::RGB
  #   [150, 0.3, 0.1].to_color(:hsl) #=> Color::RGB
  def to_color(format = :rgb)
    format = format.to_sym
    if format == :rgb
      r, g, b = self
      return Color::Maker::Support::rgb_to_color(r: r.to_i, g: g.to_i, b: b.to_i)
    end

    if format == :hsv
      h, s, v = self
      return Color::Maker::Support::hsv_to_color(h: h.to_f, s: s.to_f, v: v.to_f)
    end

    if format == :hsl
      h, s, l = self
      return Color::Maker::Support::hsl_to_color(h: h.to_f, s: s.to_f, l: l.to_f)
    end

    raise "Unknown color format: #{format}"
  end
end
