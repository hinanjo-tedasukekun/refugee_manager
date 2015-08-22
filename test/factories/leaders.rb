FactoryGirl.define do
  factory :leader do
    refugee
    family { refugee.family }
  end
end
