FactoryGirl.define do
  factory :refugee do
    id 1234
    family
    presence true
    name 'Foo Bar'
    furigana 'ふー ばー'
    gender :unspecified
    age 20
  end

  factory :refugee2, class: Refugee do
    id 2345
    family
    presence true
    name 'Baz Bar'
    furigana 'ばず ばー'
    gender :male
    age 22
  end
end
