RSpec.describe UaAddressNormalizer do
  it "has a version number" do
    expect(UaAddressNormalizer::VERSION).not_to be nil
  end

  describe UaAddressNormalizer::Formatter do
    it "транслітерує латиницю (Kyiv -> Київ)" do
      result = UaAddressNormalizer::Formatter.normalize(city: "Kyiv", street: "Khreshchatyk", house: "1")
      expect(result).to eq("м. Київ, вул. Хрещатик, буд. 1")
    end

    it "розуміє англійські типи вулиць (st. -> вул.)" do
      result = UaAddressNormalizer::Formatter.normalize(city: "Lviv", street: "st. Bandery", house: "10")
      expect(result).to eq("м. Львів, вул. Бандери, буд. 10")
    end

    it "розуміє англійські проспекти (ave -> просп.)" do
      result = UaAddressNormalizer::Formatter.normalize(city: "Kharkiv", street: "ave. Nauky", house: "4")
      expect(result).to eq("м. Харків, просп. Науки, буд. 4")
    end

    it "викидає помилку на некоректний номер будинку" do
      expect {
        UaAddressNormalizer::Formatter.normalize(city: "Полтава", street: "Соборна", house: "нет")
      }.to raise_error(UaAddressNormalizer::Error, /починатися з цифри/)
    end

    # Старий тест
    it "працює зі звичайною кирилицею" do
      result = UaAddressNormalizer::Formatter.normalize(city: "одеса", street: "дерибасівська", house: "1")
      expect(result).to eq("м. Одеса, вул. Дерибасівська, буд. 1")
    end
  end
end