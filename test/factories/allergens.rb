FactoryGirl.define do
  factory :allergen do
    id 1
    name 'えび'

    initialize_with do
      Allergen.find_or_create_by(id: id)
    end
  end

  factory :allergen2, class: Allergen do
    id 2
    name 'かに'

    initialize_with do
      Allergen.find_or_create_by(id: id)
    end
  end
end
