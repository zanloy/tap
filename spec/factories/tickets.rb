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

    factory :ticket_with_purchases do
      transient do
        purchases_count 5
      end

      after(:create) do |ticket, evaluator|
        create_list(:purchase, evaluator.purchases_count, ticket: ticket)
      end

      trait :manager_approved do
        approving_manager { create(:user) }
      end

      trait :executive_approved do
        approving_manager { create(:user) }
        approving_executive { create(:user) }
      end
    end
  end

end
