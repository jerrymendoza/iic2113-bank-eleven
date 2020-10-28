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
  # def show; end

  def new_transfer; end

  def new_saving; end

  # GET /transactions/1/confirm_transaction
  def confirm_transaction
    @origin_transaction = Transaction.find(params[:id])
    @target_transaction = Transaction.find(params[:format])
  end

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
    # Between other acounts
    if transaction_type.zero?
      origin_account = Account.find_by(id: params[:origin_account_id])
      target_account = Account.find_by(number: transaction_params[:target_account_number])
      if !target_account.nil?
        origin_transaction = make_transfer(origin_account, amount, date, 0,
                                           target_account.number, false)
        target_transaction = make_deposit(target_account, amount, date, 1,
                                          origin_account.number, false)
        UserMailer.code_confirmation(current_user,
                                     origin_transaction.confirmation_code).deliver_now
        # make_deposit(target_account, amount, date, 1, origin_account.number)
        redirect_to(confirm_transaction_path(origin_transaction.id, target_transaction.id))

        # redirect_to(user_account_transactions_path(current_user, origin_account),
        #            notice: 'Transaction was successfully created.')

      else
        redirect_back(fallback_location: { action: "index",
                                           notice: 'Error creating transaction.' })
      end

    # Between my acounts
    elsif transaction_type == 2
      origin_account = Account.find_by(id: params[:origin_account_id])
      target_account = Account.find_by(id: params[:target_account_id])
      make_transfer(origin_account, amount, date, 0, target_account.number, true)
      make_deposit(target_account, amount, date, 2, origin_account.number, true)
      redirect_to(user_account_transactions_path(current_user, origin_account),
                  notice: 'Transaction was successfully created.')

    else
      redirect_back(fallback_location: { action: "index",
                                         notice: 'Error creating transaction.' })
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

  def send_email
    # UserMailer.with(current_user: current_user).code_confirmation(current_user).deliver_now
    redirect_to(confirm_transaction_path)
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
    if origin_transaction.save && target_transaction.save
      origin_account = Account.find_by(id: origin_transaction.account_id)
      redirect_to(user_account_transactions_path(current_user,  origin_account),
                  notice: 'Transaction was successfully created.')
    else
      redirect_back(fallback_location: { action: "index",
                                         notice: 'Error creating transaction.' })
    end
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
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def set_new_transaction
    @transaction = Transaction.new
    @accounts = Account.where(user_id: current_user.id)
  end

  def make_transfer(origin_account, amount, date, transaction_type,
    another_account_number, transfer_state)
    origin_account.balance -= amount
    origin_account.save
    new_confirmation_code = rand(10000..100000)
    origin_transaction = Transaction.new(transaction_type: transaction_type,
                                         amount: amount, date: date,
                                         balance: origin_account.balance,
                                         account_id: origin_account.id,
                                         account_number: another_account_number,
                                         state: transfer_state,
                                         confirmation_code: new_confirmation_code)
    origin_transaction.save
    origin_transaction
  end

  def make_deposit(target_account, amount, date, transaction_type,
    another_account_number, transfer_state)
    target_account.balance += amount
    target_account.save
    target_transaction = Transaction.new(transaction_type: transaction_type,
                                         amount: amount, date: date,
                                         balance: target_account.balance,
                                         account_id: target_account.id,
                                         account_number: another_account_number,
                                         state: transfer_state)
    target_transaction.save
    target_transaction
  end

  def set_user_account
    @user = User.find(params[:user_id])
    @account = Account.find(params[:account_id])
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
