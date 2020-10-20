class Account < ApplicationRecord
  before_create :new_unique_number

  def new_unique_number
    last_account = Account.order('number DESC').first
    # Esto es asi, pq si no habia un numero, no encontraba un account
    last_number = if last_account
                    last_account.number
                  else
                    rand(1..100).to_s
                  end
    self.number = (last_number.to_i + rand(1..100)).to_s
  end
  belongs_to :user, dependent: :destroy
end

# == Schema Information
#
# Table name: accounts
#
#  id         :bigint(8)        not null, primary key
#  number     :string           not null
#  balance    :integer          not null
#  savings    :integer          not null
#  user_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
