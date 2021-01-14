FactoryBot.define do
  factory :discount do
    name { Faker::Marketing.buzzwords + " discount" }
    percentage { [10, 20, 50].sample }
    quantity_threshold { [5, 10, 15].sample }
  end
end
