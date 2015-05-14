FactoryGirl.define do
  factory :ticket do
    submitter nil
    project nil
    priority { rand(0..4) }
    title "MyString"
    description "MyText"
  end

end
