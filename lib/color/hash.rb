class Hash
  def to_color(format = :rgb)
    format = format.to_sym
    if format == :rgb
      r = self.fetch(:r, self.fetch(:red, 0)).to_i
      g = self.fetch(:g, self.fetch(:green, 0)).to_i
      b = self.fetch(:b, self.fetch(:blue, 0)).to_i
      return Color::Maker::Support::rgb_to_color(r: r, g: g, b: b)
    end

    if format == :hsv
      h = self.fetch(:h, self.fetch(:hue, 0)).to_f
      s = self.fetch(:s, self.fetch(:saturation, 0)).to_f
      v = self.fetch(:v, self.fetch(:value, 0)).to_f
      return Color::Maker::Support::hsv_to_color(h: h, s: s, v: v)
    end
    
    raise "Unknow color format: #{format}"
  end
end

