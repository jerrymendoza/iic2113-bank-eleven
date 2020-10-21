class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_new_transaction, only: %i[new_saving new_transfer]


  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  def new_transfer
  end

  def new_saving
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    transaction_type = params[:transaction_type].to_i
    amount = transaction_params[:amount].to_i
    date = DateTime.now.strftime("%d/%m/%Y %H:%M")

    # Between other acounts
    if transaction_type == 0
      origin_account = Account.find_by(id: params[:origin_account_id])
      target_account = Account.find_by_number(transaction_params[:target_account_number])
      if !target_account.nil?
          make_transfer(origin_account, amount, date, 0)
          make_deposit(target_account, amount, date, 1)
          redirect_to(action: 'index', notice: 'Transaction was successfully created.')  
      else
        redirect_back(fallback_location: { action: "index", notice: 'Error creating transaction.' })
      end
        
    # Between my acounts
    elsif transaction_type == 2
      origin_account = Account.find_by(id: params[:origin_account_id])
      target_account = Account.find_by(id: params[:target_account_id])
      make_transfer(origin_account, amount, date, 0)
      make_deposit(target_account, amount, date, 2)
      redirect_to(action: 'index', notice: 'Transaction was successfully created.')    

    else
      redirect_back(fallback_location: { action: "index", notice: 'Error creating transaction.' })
    end




    # respond_to do |format|
    #   if @transaction.save
    #     format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
    #     format.json { render :show, status: :created, location: @transaction }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @transaction.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def set_new_transaction
      @transaction = Transaction.new
      @accounts = Account.where(user_id: current_user.id)
    end

    def make_transfer(origin_account, amount, date, transaction_type)
      origin_account.balance -= amount
      origin_account.save
      origin_transaction = Transaction.new(transaction_type: 0,
       amount: amount, date: date, balance: origin_account.balance, account_id: origin_account.id)
      origin_transaction.save
    end 

    def make_deposit(target_account, amount, date, transaction_type)
      target_account.balance += amount
      target_account.save
      target_transaction = Transaction.new(transaction_type: transaction_type,
       amount: amount, date: date, balance: target_account.balance, account_id: target_account.id)
      target_transaction.save
    end 


    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:amount, :date, :transaction_type, :balance, :state, :account_id,
      :confirmation_code, :target_account_number, :origin_account_number)
    end
end
