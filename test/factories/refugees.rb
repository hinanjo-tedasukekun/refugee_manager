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
end
