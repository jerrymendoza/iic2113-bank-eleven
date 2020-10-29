#execute: bundle exec sidekiq -r ./app/worker/bank_inversion_worker.rb
#execute: redis-server
#execute console: bundle exec irb -r ./app/worker/bank_inversion_worker.rb
# BankInversionWorker.perform_async()

class BankInversionWorker
  include Sidekiq::Worker

  def perform()
    puts "Ingreso a Perform"
    while true 
      accounts = Account.where(account_type: 1)
      sleep 10
      random_value = rand(-0.03..0.03)
      accounts.each do |account|
          account.balance = account.balance + account.balance*random_value
          account.save
      end 
    end
  end
end

