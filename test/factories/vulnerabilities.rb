FactoryGirl.define do
  factory :vulnerability do
    id 1
    name '身体が不自由'

    initialize_with do
      Vulnerability.find_or_create_by(id: id)
    end
  end

  factory :vulnerability2, class: Vulnerability do
    id 2
    name '妊婦'

    initialize_with do
      Vulnerability.find_or_create_by(id: id)
    end
  end
end
