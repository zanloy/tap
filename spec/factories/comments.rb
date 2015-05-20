FactoryGirl.define do

  factory :comment do
    ticket
    user
    comment { FFaker::Lorem.paragraph }
  end

end
