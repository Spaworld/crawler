FactoryGirl.define do
  factory :node, class: OpenStruct do
    skip_create
    sku { Faker::Number.number(10) }
    id  { Faker::Number.number(10) }
  end
end
