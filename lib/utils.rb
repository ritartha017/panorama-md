# frozen_string_literal: true

module Utils # :nodoc:
  def strip_symbol(input)
    # input.gsub!(/[!@%&"]/,'')
    input.send(:strip)
  end

  def split_text(text)
    Array(text.split(' '))
  end

  def alphanumeric_chars
    /[0-9A-Za-z]/
  end

  def rom_diacritics
    /[ățîâșĂÂÎȘȚ]/
  end

  def capitalize_letters_after_dots(text)
    text.each_char.with_index do |c, i|
      if c == "."
        text[i+2] = text[i+2].capitalize if text[i+2].nil? == false
      end
    end
  end
end
