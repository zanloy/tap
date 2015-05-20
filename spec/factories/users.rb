FactoryGirl.define do

  factory :user, aliases: [:owner, :reporter, :assignee] do
    provider "MyString"
    uid "MyString"
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    oauth_token "MyString"
    oauth_expires_at "2015-05-11 15:46:13"
  end

end
