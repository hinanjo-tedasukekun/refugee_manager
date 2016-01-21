FactoryGirl.define do
  factory :notice do
    id 1
    title '避難所が開設されました'
    content '避難所が開設されました。'

    initialize_with do
      Notice.find_or_create_by(id: id)
    end
  end
end
