FactoryBot.define do
  i = 0
  factory :user do
    email { "merchant#{i += 1}@example.com"}
    password { "strongpassword" }
    password_confirmation { "strongpassword" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    user_name { Faker::Ancient.titan }
  end
end
