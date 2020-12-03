class ExchangesController < ApplicationController
    def get_coins
        @exchanges = Exchange.all
        response = HTTParty.get("http://api.exchangesix.com/api/v1/coins", 
            headers: { 
                "Accept" => "application/json" 
        })
        puts response
        puts response["precio_venta"]
    end

    def buy_btf(ammount=1)
        options = { 
            headers: { 
                'Content-Type': 'application/json',
                "Authorization": "Bearer #{ENV["TOKEN_EXCHANGE"]}"
            },
            body: {
                "coin_id": 1,
                "cantidad": ammount,
                "tipo": "COMPRA"
            }.to_json
        }
        response = HTTParty.post("http://api.exchangesix.com/api/v1/transactions", options)
        puts response
    end

    def sell_btf(ammount=1)
        options = { 
            headers: { 
                'Content-Type': 'application/json',
                "Authorization": "Bearer #{ENV["TOKEN_EXCHANGE"]}"
            },
            body: {
                "coin_id": 1,
                "cantidad": ammount,
                "tipo": "VENTA"
            }.to_json
        }
        response = HTTParty.post("http://api.exchangesix.com/api/v1/transactions", options)
        puts response
    end
end
