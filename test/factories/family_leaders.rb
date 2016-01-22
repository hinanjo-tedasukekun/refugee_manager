FactoryGirl.define do
  factory :family_leader do
    refugee
    family { refugee.family }
  end
end
