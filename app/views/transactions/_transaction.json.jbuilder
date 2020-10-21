json.extract! transaction, :id, :amount, :date, :transaction_type, :balance, :state,
              :confirmation_code, :account_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
