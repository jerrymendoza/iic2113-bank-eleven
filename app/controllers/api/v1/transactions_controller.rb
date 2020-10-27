class Api::V1::TransactionsController < ApplicationController

    def index
        @transactions = Transaction.where(account_id: current_user.accounts[0].id).or(Transaction.where(account_id: current_user.accounts[1].id)) 
        respond_to do |format|
            format.json { render :json => @transactions.to_json, :status => :ok }
        end
    end

    def date
        @time_range = params[:from].to_time..params[:to].to_time
        @transactions = Transaction.where(account_id: current_user.accounts[0].id).or(Transaction.where(account_id: current_user.accounts[1].id)) 
        @transactions = @transactions.where(date: @time_range)

        respond_to do |format|
            format.json { render :json => @transactions.to_json, :status => :ok }
        end
    end
end
