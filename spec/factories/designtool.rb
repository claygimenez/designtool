FactoryGirl.define do
  sequence(:user_email) { |n| "name#{n}@example.com" }

  factory :project do
    title 'Super awesome design project'
    user
  end

  factory :note do
    text 'User seems to need our help! Summon the Batman'
    project
  end

  factory :user do
    email { generate(:user_email) }
    password 'Password'
  end
end
