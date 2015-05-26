FactoryGirl.define do
  factory :membership do
    project
    user
    role 1
    admin false

    trait :moderator do
      role 2
    end

    trait :manager do
      role 3
    end

    trait :executive do
      role 4
    end

    trait :admin do
      admin true
    end
  end

end
