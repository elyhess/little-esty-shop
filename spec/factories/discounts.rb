FactoryBot.define do
  factory :bulk_discount do
    name { Faker::Marketing.buzzwords + " discount" }
    percentage { [10, 20, 30].sample }
    quantity_threshold { [2, 3, 5].sample }
  end
end
