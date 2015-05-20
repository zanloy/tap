FactoryGirl.define do

  factory :project do
    name { FFaker::Name.name }
    icon "MyString"
    description { FFaker::Lorem.paragraph }
    private false
  end

end
