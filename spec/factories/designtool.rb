FactoryGirl.define do
  sequence(:user_email) { |n| "name#{n}@example.com" }

  factory :project do
    title 'Yuppy design project'
    user
  end

  factory :user do
    email { generate(:user_email) }
    password 'Password'
  end
end
