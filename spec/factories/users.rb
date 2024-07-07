# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    campaigns_list { [{ campaign_name: Faker::Lorem.word, campaign_id: Faker::Number.number(digits: 4) }] }
  end
end
