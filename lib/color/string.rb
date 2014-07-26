class String
  def to_color
    h = self.delete('#').strip
    raise 'Invalid hex color' unless h.hex?
    h = h.hex.to_s(16)
    h = h.rjust(6, '0') unless h.length == 3
    Color::Maker::Support.hex_to_color(h)
  end

  def hex?
    self.include?(self.hex.to_s(16))
  end
end

