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
    password_protected false
    password nil
  end

  factory :protected_refugee, class: Refugee do
    id 3456
    family
    presence true
    name 'hoge piyo'
    furigana 'ほげ ぴよ'
    gender :female
    age 24
    password_protected true
    password '12345678'
    password_confirmation '12345678'
  end
end
