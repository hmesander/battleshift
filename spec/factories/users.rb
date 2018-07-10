FactoryBot.define do
  factory :user do
    email_address Faker::Internet.email
    name Faker::Name.name
    password Faker::Color.color_name

  end
end
