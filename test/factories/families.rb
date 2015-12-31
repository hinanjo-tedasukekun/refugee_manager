FactoryGirl.define do
  factory :family do
    id 99
    num_of_members 3
    at_home :unspecified
    address '静岡県浜松市南区法枝町693'
    postal_code '4328053'

    initialize_with do
      Family.find_or_create_by(id: id)
    end
  end
end
