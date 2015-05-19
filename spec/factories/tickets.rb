FactoryGirl.define do

  factory :ticket do
    submitter nil
    project nil
    priority 1
    title "MyString"
    description "MyText"

    trait :high do
      priority 2
    end

    trait :low do
      priority 0
    end
  end

end
