# execute: bundle exec sidekiq -r ./app/worker/bank_inversion_worker.rb
# execute: redis-server
# execute console: bundle exec irb -r ./app/worker/bank_inversion_worker.rb
# BankInversionWorker.perform_async()

class BankInversionWorker
  include Sidekiq::Worker
  @@bank_exchange = ExchangesController.new
  @@compra_venta = {"VENTA": "precio_venta", "COMPRA": "precio_compra"}


  def get_total_money(accounts)
    pozo = 0
    accounts.each do |account| #aqui calculamos cuanta plata hay
      pozo += account.balance
      puts "pozo: #{pozo}"
    end
    valor_actual = @@bank_exchange.get_coins["coins"][0]["precio_venta"]
    puts "valor_actual: #{valor_actual}"

    return (pozo/valor_actual.to_f).ceil, pozo
  end

  def get_payout
    last_exchange = Exchange.last
    pozo_nuevo = @@bank_exchange.get_coins["coins"][0]["precio_venta"]*last_exchange.monto
    puts "1"
    puts @@bank_exchange.get_coins["coins"][0]["precio_venta"]
    pozo_viejo = last_exchange.valor_btf*last_exchange.monto
    return pozo_nuevo - pozo_viejo
  end

  def payout_investments(accounts) #actualizamos las cuentas en base al porcentaje
    payout = get_payout()
    accounts.each do |account|
      if !Percentage.where(account_id: account.id).nil?
        porcentaje = Percentage.where(account_id: account.id).last.porcentaje
        account.balance += porcentaje * payout
        account.save

      end
    end
  end

  def set_percentages(pozo, accounts)
    # guardar porcentajes de nueva transaccion
    exchange_id = Exchange.last.id
    accounts.each do |account|
      porcentaje = account.balance/pozo
      Percentage.create(porcentaje: porcentaje, exchange_id: exchange_id, account_id: account.id)
    end
  end

  def invest(cantidad_btf, pozo)
    puts "11"
    if Exchange.count == 0
      puts "12"
      tipo = "COMPRA"
    elsif cantidad_btf < Exchange.all.last.valor_btf
      puts "13"
      tipo = "COMPRA"
    else
      puts "14"
      tipo = "VENTA"
    end
    @@bank_exchange.exchange_btf(cantidad_btf, tipo)
    puts "2"
    Exchange.create(monto: pozo, tipo: tipo, valor_btf: @@bank_exchange.get_coins["coins"][0][@@compra_venta["tipo"]])
    puts "3"

  end

  def perform
    loop do
      accounts = Account.where(account_type: 1)
      sleep 10
      puts "4"
      if Exchange.count != 0
        puts "exchange any"
        payout_investments(accounts)
      end
      puts "5"
      cantidad_btf, pozo = get_total_money(accounts)
      puts "6"
      invest(cantidad_btf, pozo)
      puts "7"
      set_percentages(pozo, accounts)
      puts "8"
    end
  end
end
