module UaAddressNormalizer
  class Transliterator

    RULES = {
      # Специфічні кейси
      'shch' => 'щ',
      'kyi' => 'киї',
      'lvi' => 'льві',

      'zh' => 'ж', 'kh' => 'х', 'ts' => 'ц', 'ch' => 'ч', 'sh' => 'ш',
      'yu' => 'ю', 'ya' => 'я', 'yi' => 'ї', 'ye' => 'є',

      'a' => 'а', 'b' => 'б', 'v' => 'в', 'g' => 'г', 'd' => 'д', 'e' => 'е',
      'z' => 'з', 'i' => 'і', 'k' => 'к', 'l' => 'л', 'm' => 'м', 'n' => 'н',
      'o' => 'о', 'p' => 'п', 'r' => 'р', 's' => 'с', 't' => 'т', 'u' => 'у',
      'f' => 'ф', 'y' => 'и', 'j' => 'й'
    }.freeze

    def self.call(text)
      return text unless latin?(text)

      result = text.to_s.downcase
      RULES.each do |eng, ukr|
        result = result.gsub(eng, ukr)
      end

      result
    end

    def self.latin?(text)
      !!text.to_s.match(/[a-zA-Z]/)
    end
  end
end