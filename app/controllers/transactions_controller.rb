class TransactionsController < ApplicationController
  # before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_new_transaction, only: %i[new_saving new_transfer]
  before_action :set_user_account, only: [:index]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    render json: @transaction
  end

  def new_transfer; end

  def new_saving; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  # def edit
  # end

  # POST /transactions
  # POST /transactions.json
  def create
    transaction_type = params[:transaction_type].to_i
    amount = transaction_params[:amount].to_i
    date = DateTime.now.strftime("%d/%m/%Y %H:%M")
    origin_account = Account.find_by(id: params[:origin_account_id])
    transaction_type_origin = 0 # transfer

    # Between other acounts
    if transaction_type.zero?
      target_account = Account.find_by(number: transaction_params[:target_account_number])
      transaction_type_target = 1 # deposit

    # Between my acounts
    elsif transaction_type == 2
      target_account = Account.find_by(id: params[:target_account_id])
      transaction_type_target = 2 # saving
    end

    if check_conditions(origin_account, target_account, amount)
      make_transfer(origin_account, amount, date, transaction_type_origin, target_account.number)
      make_deposit(target_account, amount, date, transaction_type_target, origin_account.number)
      redirect_to(user_account_transactions_path(current_user, origin_account),
                  notice: 'Transaction was successfully created.')

    else
      redirect_back(fallback_location: { action: "index",
                                         error: 'Error creating transaction.' })
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
  # def update
  #   respond_to do |format|
  #     if @transaction.update(transaction_params)
  #       format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @transaction }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @transaction.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /transactions/1
  # # DELETE /transactions/1.json
  # def destroy
  #   @transaction.destroy
  #   respond_to do |format|
  #     format.html { redirect_to transactions_url,
  #                   notice: 'Transaction was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_transaction
  #   @transaction = Transaction.find(params[:id])
  # end

  def set_new_transaction
    @transaction = Transaction.new
    @accounts = Account.where(user_id: current_user.id)
  end

  def set_user_account
    @user = User.find(params[:user_id])
    @account = Account.find(params[:account_id])
  end

  def check_conditions(origin_account, target_account, amount)
    condition1 = !origin_account.nil?
    condition2 = !target_account.nil?
    condition3 = amount >= 0
    condition4 = condition1 && origin_account.balance >= amount
    conditions = [condition1, condition2, condition3, condition4]
    conditions.all?
  end

  def make_transfer(origin_account, amount, date, transaction_type, another_account_number)
    origin_account.change_balance(-amount)
    new_confirmation_code = rand(10000..100000)
    origin_transaction = Transaction.new(transaction_type: transaction_type,
                                         amount: amount, date: date,
                                         balance: origin_account.balance,
                                         account_id: origin_account.id,
                                         account_number: another_account_number,
                                         state: false, confirmation_code: new_confirmation_code)
    origin_transaction.save
  end

  def make_deposit(target_account, amount, date, transaction_type, another_account_number)
    target_account.change_balance(amount)
    target_transaction = Transaction.new(transaction_type: transaction_type,
                                         amount: amount, date: date,
                                         balance: target_account.balance,
                                         account_id: target_account.id,
                                         account_number: another_account_number,
                                         state: true)
    target_transaction.save
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:amount, :date, :transaction_type, :balance,
                                        :state, :account_id, :confirmation_code,
                                        :target_account_number, :origin_account_number)
  end
end
