FactoryGirl.define do
  factory :product, class: Hash do
    id { rand(10000) + 100 }

    title "20-Bicycle 205"

    description "205 description"

    bicycle_type "Hybrid"

    brand "Brand-Company C"

    price 500

    gender "B"

    orders_placed 5

    number_in_stock 20

    launch_date { { m: 12, d: 4, y: 1996 } }

    features { { rover: true, pedals: false, wheels: true } }

    color { Set.new(["Red", "Black"]) }

    product_category "Bike"

    in_stock true

    quantity_on_hand nil

    number_sold BigDecimal.new("1E4")

    related_items { [341, 472, 649] }

    pictures {
      {
        front_view: "http://example.com/products/205_front.jpg",
        rear_view: "http://example.com/products/205_rear.jpg",
        side_view: "http://example.com/products/205_left_side.jpg",
      }
    }

    product_reviews {
      {
        five_star: [
          "Excellent! Can't recommend it highly enough!  Buy it!"
        ],
        one_star: [
          "Terrible product!  Do not buy this."
        ]
      }
    }

    tags { Set.new(["#Mars", "#MarsCuriosity", "#StillRoving"]) }

    initialize_with { attributes }
  end
end
