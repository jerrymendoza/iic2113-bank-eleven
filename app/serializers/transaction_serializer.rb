class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :date, :transaction_type, :balance, :state, :confirmation_code
  has_one :account
end
