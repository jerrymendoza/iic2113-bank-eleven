class Percentage < ApplicationRecord
    belongs_to :account
    belongs_to :exchange
end

# == Schema Information
#
# Table name: percentages
#
#  id          :bigint(8)        not null, primary key
#  porcentaje  :float
#  exchange_id :bigint(8)
#  account_id  :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_percentages_on_account_id   (account_id)
#  index_percentages_on_exchange_id  (exchange_id)
#
