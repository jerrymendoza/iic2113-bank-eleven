class AccountSerializer < ActiveModel::Serializer
  attributes :id, :number, :balance, :account_type
  has_one :user
end
