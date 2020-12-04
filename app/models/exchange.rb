class Exchange < ApplicationRecord
    has_many :percentages
    has_many :accounts, through: :percentages
end

# == Schema Information
#
# Table name: exchanges
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  monto      :integer
#  tipo       :string
#  valor_btf  :integer
#
