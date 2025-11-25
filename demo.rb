if Gem.win_platform?
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8

  # для UTF-8
  system('chcp 65001 > nul')

  # потоки вводу/виводу
  STDOUT.set_encoding(Encoding::UTF_8)
  STDIN.set_encoding(Encoding::UTF_8)
end

require_relative 'lib/ua_address_normalizer'


def print_header
  system('clear') || system('cls') # Очищує консоль
  puts "========================================="
  puts "   NOVA POSHTA STYLE ADDRESS FORMATTER   "
  puts "      (Напишіть 'exit' для виходу)       "
  puts "========================================="
end

print_header

loop do
  puts "\nВведіть назву міста (напр. харків):"
  input_city = gets.chomp
  break if input_city.downcase == 'exit'

  puts "Введіть вулицю (напр. сумська або проспект науки):"
  input_street = gets.chomp
  break if input_street.downcase == 'exit'

  puts "Введіть номер будинку:"
  input_house = gets.chomp
  break if input_house.downcase == 'exit'

  begin
    puts "..."
    # Виклик гема
    result = UaAddressNormalizer::Formatter.normalize(
      city: input_city,
      street: input_street,
      house: input_house
    )

    puts "\n  Результат: #{result}"
    puts "-----------------------------------------"
  rescue StandardError => e
    puts "\n  Помилка: #{e.message}"
  end
end

puts "Вихід..."