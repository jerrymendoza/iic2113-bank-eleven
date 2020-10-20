class AccountSerializer < ActiveModel::Serializer
  attributes :id, :number, :balance, :savings
  has_one :user
end
