FactoryGirl.define do
  factory :basic, class: Hash do
    id { rand(10000) + 100 }

    email Faker::Internet.email

    initialize_with { attributes }
  end
end
