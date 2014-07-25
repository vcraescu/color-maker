class Array
  def to_color(format = :rgb)
    format = format.to_sym
    if format == :rgb
      r, g, b = self.map(&:to_i)
      return Color::Maker::Support::rgb_to_color(r: r, g: g, b: b)
    end

    if format == :hsv
      h, s, v = self.map(&:to_f)
      return Color::Maker::Support::hsv_to_color(h: h, s: s, v: v)
    end
  end
end
