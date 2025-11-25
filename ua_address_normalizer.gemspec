# frozen_string_literal: true

require_relative "lib/ua_address_normalizer/version"

Gem::Specification.new do |spec|
  spec.name = "ua_address_normalizer"
  spec.version = UaAddressNormalizer::VERSION
  spec.authors = ["yehor pozc"]
  spec.email = ["yehor.mezentsev@student.karazin.ua"]

  spec.summary = "Гем для нормалізації адрес (Lab Work)."
  spec.description = "Лабораторна робота. Гем приводить адреси до формату Нової Пошти."

  # 2. Посилання (можна вказати посилання на свій GitHub або просто заглушку)
  spec.homepage = "https://github.com/yehor/ua_address_normalizer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # 3. Блок metadata
  # spec.metadata["allowed_push_host"] = "https://rubygems.org"
  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com/yehor/ua_address_normalizer"
  # spec.metadata["changelog_uri"] = "https://github.com/yehor/ua_address_normalizer/blob/main/CHANGELOG.md"

  # 4. Завантаження файлів
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.2"
end