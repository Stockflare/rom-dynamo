FactoryGirl.define do
  factory :widget, class: Hash do
    email Faker::Internet.email

    usernames { Array.new(rand(10) + 2).map! { Faker::Internet.user_name } }

    password { Faker::Internet.password }

    domain { Faker::Internet.domain_name }

    logins { Hash.new }

    logins do
      Hash[[Array.new(rand(10)).map! do
        [Time.now.utc - Random.rand(1000) + 3000, Faker::Internet.ip_v4_address]
      end]]
    end

    created_at { Time.now.utc - Random.rand(1000) + 3000 }

    initialize_with { attributes }
  end
end
