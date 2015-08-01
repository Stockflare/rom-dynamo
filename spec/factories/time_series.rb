FactoryGirl.define do
  factory :time_series, class: Hash do
    id { Time.now.strftime('%Y-%m-%d') }

    date { Time.now.iso8601 }

    initialize_with { attributes }
  end
end
