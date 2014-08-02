class Hash
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

  def replace_key!(needle, replace)
    needle = [needle] unless needle.is_a?(Enumerable)
    needle.each { |key| self[replace] = self.delete(key) if self.key?(key) }
  end
end

