FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    gender { [:male, :female].sample }
  end
end