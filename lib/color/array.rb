class Array
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

    raise "Unknown color format: #{format}"
  end
end
