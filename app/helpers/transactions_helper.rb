# == Schema Information
#
# Table name: transactions
#
#  id                :bigint(8)        not null, primary key
#  amount            :integer
#  date              :datetime
#  transaction_type  :integer
#  balance           :integer
#  state             :boolean
#  confirmation_code :integer
#  account_id        :bigint(8)        not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_transactions_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
module TransactionsHelper
end
