FactoryGirl.define do

  factory :membership do
    project
    user

    trait :worker do
      role 1
    end
    
    trait :moderator do
      role 2
    end

    trait :manager do
      role 3
    end

    trait :admin do
      admin true
    end
  end

end
