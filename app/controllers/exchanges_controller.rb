class ExchangesController < ApplicationController
    def get_coins
        puts "9"
        @exchanges = Exchange.all
        response = HTTParty.get("http://api.exchangesix.com/api/v1/coins", 
            headers: { 
                "Accept" => "application/json" ,
                'Content-Type' => 'application/json'
        })
        puts response
        return response
    end

    def exchange_btf(ammount=1, tipo="COMPRA")
        puts "10"
        options = { 
            headers: { 
                'Content-Type': 'application/json',
                "Authorization": "Bearer #{ENV["TOKEN_EXCHANGE"]}"
            },
            body: {
                "coin_id": 1,
                "cantidad": ammount,
                "tipo": tipo
            }.to_json
        }
        response = HTTParty.post("http://api.exchangesix.com/api/v1/transactions", options)
        puts response
    end
end
