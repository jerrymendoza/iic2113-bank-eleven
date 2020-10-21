# == Schema Information
#
# Table name: accounts
#
#  id           :bigint(8)        not null, primary key
#  number       :string
#  balance      :integer
#  account_type :integer
#  user_id      :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
module AccountsHelper
end
