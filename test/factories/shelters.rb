FactoryGirl.define do
  factory :shelter do
    id 1
    num 19
    name 'ポリテクカレッジ浜松'
    address '静岡県浜松市南区法枝町693'
    postal_code '4328053'

    initialize_with do
      Family.find_or_create_by(id: id)
    end
  end
end
