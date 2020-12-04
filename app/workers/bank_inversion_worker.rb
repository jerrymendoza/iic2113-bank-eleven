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
    end
    valor_actual = @@bank_exchange.get_coins["coins"][0]["precio_venta"]

    return (pozo/valor_actual.to_f).ceil, pozo
  end

  def get_payout
    last_exchange = Exchange.all.last
    pozo_nuevo = @@bank_exchange.get_coins["coins"][0]["precio_venta"]*last_exchange.monto
    pozo_viejo = last_exchange.valor_btf * last_exchange.monto
    return pozo_nuevo - pozo_viejo
  end

  def payout_investments(accounts) #actualizamos las cuentas en base al porcentaje
    payout = get_payout()
    accounts.each do |account|
      percent = Percentage.where(account_id: account.id)
      
      if !percent.last.nil?
        porcentaje = percent.last.porcentaje
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
    if Exchange.count == 0
      tipo = "COMPRA"
    elsif cantidad_btf < Exchange.all.last.valor_btf
      tipo = "COMPRA"
    else
      tipo = "VENTA"
    end
    @@bank_exchange.exchange_btf(cantidad_btf, tipo)
    Exchange.create(monto: pozo, tipo: tipo, valor_btf: @@bank_exchange.get_coins["coins"][0]["precio_venta"])

  end

  def perform
    loop do
      accounts = Account.where(account_type: 1)
      sleep 3600
      if Exchange.count != 0
        payout_investments(accounts)
      end
      cantidad_btf, pozo = get_total_money(accounts)
      invest(cantidad_btf, pozo)
      set_percentages(pozo, accounts)
    end
  end
end
