FactoryBot.define do
  factory :user do
    email_address Faker::Internet.email
    name Faker::Name.name
    password Faker::Color.color_name
    token Faker::Crypto.sha1
  end
end
