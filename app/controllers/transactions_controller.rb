class TransactionsController < ApplicationController
  before_action :set_new_transaction, only: %i[new_saving new_transfer]
  before_action :set_user_account, only: [:index]

  # GET /transactions
  def index
    @transactions = Transaction.all
  end

  def new_transfer; end

  def new_saving; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # POST /transactions
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
  end

  private

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
