FactoryGirl.define do
  factory :purchase do
    ticket
    name { FFaker::Product.product_name }
    quantity { (1..10).sample }
    cost { Random.rand(50.0).round(2) }
    url { FFaker::Internet.http_url }
    status { %w[waiting approved rejected].sample }
  end

end
