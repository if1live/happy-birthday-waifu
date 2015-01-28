FactoryGirl.define do
  name = "Kasugano Sora"
  month = 2
  day = 5

  factory :character do
    initialize_with { new(name, month, day) }
  end

  factory :with_year, class: Character do
    year 2008
    initialize_with { new(name, month, day, year) }
  end

  factory :with_url, class: Character do
    external_url = "http://en.wikipedia.org/wiki/Yosuga_no_Sora"
    initialize_with { new(name, month, day, nil, external_url) }
  end
end
