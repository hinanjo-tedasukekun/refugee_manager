FactoryGirl.define do
  factory :skill do
    id 1
    name '医療'

    initialize_with do
      Skill.find_or_create_by(id: id)
    end
  end

  factory :skill2, class: Skill do
    id 2
    name '看護'

    initialize_with do
      Skill.find_or_create_by(id: id)
    end
  end
end
