FactoryBot.define do
  factory :account do
    number { "MyString" }
    balance { 1 }
    account_type { 1 }
    user { nil }
  end
end
