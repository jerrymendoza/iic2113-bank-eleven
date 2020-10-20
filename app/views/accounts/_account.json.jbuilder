json.extract! account, :id, :number, :balance, :savings, :user_id, :created_at, :updated_at
json.url account_url(account, format: :json)
