FactoryGirl.define do

  factory :ticket do
    reporter
    project
    priority 1
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }

    trait :high do
      priority 2
    end

    trait :low do
      priority 0
    end
  end

end
