FactoryGirl.define do
  factory :refugee do
    family
    presence true
    name 'Foo Bar'
    furigana 'ふー ばー'
    gender :unspecified
    age 20
  end
end
