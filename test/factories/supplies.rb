FactoryGirl.define do
  factory :supply do
    id 1
    name 'ミルク'

    initialize_with do
      Supply.find_or_create_by(id: id)
    end
  end

  factory :supply2, class: Supply do
    id 2
    name 'おむつ'

    initialize_with do
      Supply.find_or_create_by(id: id)
    end
  end

  factory :supply3, class: Supply do
    id 3
    name 'お粥'

    initialize_with do
      Supply.find_or_create_by(id: id)
    end
  end
end
