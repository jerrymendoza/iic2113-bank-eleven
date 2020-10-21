FactoryBot.define do
  factory :transaction do
    amount { 1 }
    date { "2020-10-20 23:35:58" }
    transaction_type { 1 }
    balance { 1 }
    state { "" }
    confirmation_code { 1 }
    account { nil }
  end
end
