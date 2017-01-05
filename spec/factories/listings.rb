FactoryGirl.define do
  factory :listing do
    sku           { Faker::Code.isbn }
    trait :with_menards_attrs do
      vendors { {
        menards: {
          vendor_url:   Faker::Internet.url,
          vendor_id:    Faker::Number.number(10),
          vendor_sku:   Faker::Code.isbn,
          vendor_title: Faker::Commerce.product_name,
          vendor_price: Faker::Commerce.price
        },
        hd: {}
      } }
    end
    trait :with_menards_url do
      menards_url Faker::Internet.url
    end
  end
end
