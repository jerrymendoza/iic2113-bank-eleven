# execute: bundle exec sidekiq -r ./app/worker/bank_inversion_worker.rb
# execute: redis-server
# execute console: bundle exec irb -r ./app/worker/bank_inversion_worker.rb
# BankInversionWorker.perform_async()

class BankInversionWorker
  include Sidekiq::Worker

  def perform
    puts "Ingreso a Perform"
    loop do
      accounts = Account.where(account_type: 1)
      puts accounts
      sleep 10
      puts "random value"
      random_value = rand(-0.03..0.03)
      puts random_value
      accounts.each do |account|
        puts "account saving"
        puts account.balance
        puts "Todo bien por aca"
        account.balance = account.balance + account.balance * random_value
        puts account.balance
        account.save
      end
    end
  end
end
