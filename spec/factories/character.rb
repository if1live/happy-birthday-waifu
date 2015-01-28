FactoryGirl.define do
  factory :character, class: Character do
    slug 'kasugano-sora'
    name_en 'Kasugano Sora'
    name_ko '카스가노 소라'
    date '02/05'
  end

  factory :with_year_character, class: Character do
    slug 'kasugano-sora'
    name_en 'Kasugano Sora'
    name_ko '카스가노 소라'
    year 2008
    date '02/05'
  end

  factory :with_url_character, class: Character do
    slug 'kasugano-sora'
    name_en 'Kasugano Sora'
    name_ko '카스가노 소라'
    date '02/05'
    external_url = "http://en.wikipedia.org/wiki/Yosuga_no_Sora"
  end
end
