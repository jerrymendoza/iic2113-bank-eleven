class ExchangesController < ApplicationController
    def get_coins
        response = HTTParty.get("http://api.exchangesix.com/api/v1/coins", 
            headers: { 
                "Accept" => "application/json" 
        })
        coins = response.to_a
    end
end
