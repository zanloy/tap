FactoryGirl.define do

  factory :purchase do
    ticket
    name { FFaker::Product.product_name }
    url { FFaker::Internet.http_url }
    quantity { Random.rand(10) }
    cost { Random.rand(50.0).round(2) }
  end

end
