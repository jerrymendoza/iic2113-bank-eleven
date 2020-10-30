# execute: bundle exec sidekiq -r ./app/worker/bank_inversion_worker.rb
# execute: redis-server
# execute console: bundle exec irb -r ./app/worker/bank_inversion_worker.rb
# BankInversionWorker.perform_async()

class BankInversionWorker
  include Sidekiq::Worker

  def perform
    loop do
      accounts = Account.where(account_type: 1)
      sleep 3600
      random_value = rand(-0.03..0.03)
      accounts.each do |account|
        account.balance = account.balance + account.balance * random_value
        account.save
      end
    end
  end
end
