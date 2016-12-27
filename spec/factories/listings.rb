FactoryGirl.define do
  factory :listing do
    sku           { Faker::Code.isbn }
  end
end
