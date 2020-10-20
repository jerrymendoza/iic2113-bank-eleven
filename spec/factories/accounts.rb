FactoryBot.define do
  factory :account do
    number { "MyString" }
    balance { 1 }
    savings { 1 }
    user { nil }
  end
end
