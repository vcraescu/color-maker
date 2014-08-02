class String
  def to_color(format = :hex)
    format = format.to_sym

    if format == :hex
      return Color::RGB.by_hex(self)
    end

    if format == :html
      return Color::RGB.from_html(self)
    end

    if format == :name
      return Color::Maker.by_name(self)
    end
    
    raise "Unknown format: #{format}"
  end

  def hex?
    self.include?(self.hex.to_s(16))
  end
end

