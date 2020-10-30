class TransactionsController < ApplicationController
  before_action :set_new_transaction, only: %i[new_saving new_transfer]
  before_action :set_user_account, only: [:index]

  # GET /transactions
  def index
    @transactions = Transaction.where(state: true)
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
      origin_transaction = make_transfer(origin_account, amount, date, transaction_type_origin,
                                         target_account.number, false)
      target_transaction = make_deposit(target_account, amount, date, transaction_type_target,
                                        origin_account.number, false)
      UserMailer.code_confirmation(current_user, origin_transaction.confirmation_code).deliver_now
      redirect_to(confirm_transaction_path(origin_transaction.id, target_transaction.id))
    else
      redirect_back(fallback_location: { action: "index",
                                         error: 'Error creating transaction.' })
    end
  end

  # GET /transactions/1/confirm_transaction
  def confirm_transaction
    @origin_transaction = Transaction.find(params[:id])
    @target_transaction = Transaction.find(params[:format])
  end

  def create_deposit
    @origin_transaction = Transaction.find(params[:origin_transaction_id])
    @target_transaction = Transaction.find(params[:target_transaction_id])
    confirmation_code_user = params.require(:post).permit(:confirmation_code_user)
    confirmation_code_user = confirmation_code_user[:confirmation_code_user]
    if verify_code(@origin_transaction.confirmation_code, confirmation_code_user)
      changestate(@origin_transaction, @target_transaction)

    else
      redirect_back(fallback_location: { action: "index",
                                         notice: 'Error creating transaction.' })
    end
  end

  def changestate(origin_transaction, target_transaction)
    origin_transaction.state = true
    target_transaction.state = true
    origin_account = Account.find_by(id: origin_transaction.account_id)
    origin_account.change_balance(-origin_transaction.amount)
    origin_transaction.balance = origin_account.balance
    target_account = Account.find_by(id: target_transaction.account_id)
    target_account.change_balance(target_transaction.amount)
    target_transaction.balance = target_account.balance
    if origin_transaction.save && target_transaction.save
      redirect_to(user_account_transactions_path(current_user,  origin_account),
                  notice: 'Transaction was successfully created.')
    else
      redirect_back(fallback_location: { action: "index",
                                         notice: 'Error creating transaction.' })
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

  def make_transfer(origin_account, amount, date, transaction_type, another_account_number,
    transfer_state)
    new_confirmation_code = rand(10000..100000)
    origin_transaction = Transaction.new(transaction_type: transaction_type,
                                         amount: amount, date: date,
                                         account_id: origin_account.id,
                                         account_number: another_account_number,
                                         state: transfer_state,
                                         confirmation_code: new_confirmation_code)
    origin_transaction.save
    origin_transaction
  end

  def make_deposit(target_account, amount, date, transaction_type, another_account_number,
    transfer_state)
    target_transaction = Transaction.new(transaction_type: transaction_type,
                                         amount: amount, date: date,
                                         account_id: target_account.id,
                                         account_number: another_account_number,
                                         state: transfer_state)
    target_transaction.save
    target_transaction
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:amount, :date, :transaction_type, :balance,
                                        :state, :account_id, :confirmation_code,
                                        :target_account_number, :origin_account_number)
  end

  def verify_code(original_code, user_code)
    if original_code.to_i == user_code.to_i
      return true
    end

    false
  end
end
