FactoryGirl.define do

  factory :project do
    name { FFaker::Name.name }
    owner nil
    icon "MyString"
    description "MyString"
    private false
    auto_assignee nil
  end

end
