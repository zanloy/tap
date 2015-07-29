FactoryGirl.define do

  factory :user, aliases: [:reporter, :assignee] do
    provider 'google_oauth2'
    uid '12345'
    name { FFaker::Name.name }
    email { [FFaker::Internet.user_name, 'sparcedge.com'].join('@') }
    oauth_token 'abc123'
    oauth_expires_at { 1.day.from_now }

    trait :manager do
      role 1
    end

    trait :admin do
      role 2
    end

    trait :executive do
      executive true
    end
  end

end
