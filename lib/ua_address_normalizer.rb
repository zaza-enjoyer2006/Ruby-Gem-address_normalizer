require_relative "ua_address_normalizer/version"
require_relative "ua_address_normalizer/transliterator"

module UaAddressNormalizer
  class Error < StandardError; end

  class Formatter
    TYPE_TRANSLATIONS = {
      'st' => 'вул', 'st.' => 'вул', 'street' => 'вул',
      'ave' => 'просп', 'ave.' => 'просп', 'avenue' => 'просп',
      'ln' => 'пров', 'ln.' => 'пров', 'lane' => 'пров',
      'sq' => 'майдан', 'sq.' => 'майдан', 'square' => 'майдан',
      'blvd' => 'бул', 'blvd.' => 'бул', 'boulevard' => 'бул'
    }.freeze

    UKR_STREET_TYPES = %w[вул вулиця просп проспект пров провулок бул бульвар майдан наб набережна].freeze

    def self.normalize(city:, street:, house:)
      validate_input!(city, street, house)

      # 1. Місто транслітеруємо одразу
      clean_city = Transliterator.call(city.strip)

      # 2. Вулицю обробляємо розумніше (передаємо оригінал)
      raw_street = street.strip
      formatted_street = process_street(raw_street)

      clean_house = house.strip

      # 3. Збираємо докупи
      "м. #{capitalize_word(clean_city)}, #{formatted_street}, буд. #{clean_house}"
    end

    private

    def self.process_street(street_input)
      parts = street_input.split(' ')
      first_word = parts.first.to_s.downcase

      # Сценарій 1: Це англійський тип (st, ave)?
      if TYPE_TRANSLATIONS.key?(first_word)
        translated_type = TYPE_TRANSLATIONS[first_word] + "."
        # Беремо решту назви, і тільки її транслітеруємо
        rest_of_name = parts[1..].join(' ')
        transliterated_name = Transliterator.call(rest_of_name)

        return "#{translated_type} #{capitalize_word(transliterated_name)}"
      end

      # Якщо це не англійський тип, спочатку транслітеруємо все
      transliterated_full = Transliterator.call(street_input)
      parts_ukr = transliterated_full.split(' ')
      first_word_ukr = parts_ukr.first.downcase

      # Сценарій 2: Це український тип?
      if UKR_STREET_TYPES.include?(first_word_ukr)
        return parts_ukr.map.with_index { |w, i| i == 0 ? w : capitalize_word(w) }.join(' ')
      end

      # Сценарій 3: Типу немає -> Додаємо "вул."
      "вул. #{capitalize_word(transliterated_full)}"
    end

    def self.validate_input!(city, street, house)
      if [city, street, house].any? { |f| f.nil? || f.to_s.strip.empty? }
        raise Error, "Усі поля мають бути заповнені"
      end
      unless house.to_s.strip.match?(/^\d/)
        raise Error, "Номер будинку '#{house}' має починатися з цифри"
      end
    end

    def self.capitalize_word(word)
      word.split(/([- ])/).map do |part|
        part.match?(/[a-zA-Zа-яА-ЯіІїЇєЄґҐ]/) ? part.capitalize : part
      end.join
    end
  end
end