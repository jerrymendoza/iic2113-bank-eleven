require 'rails_helper'

RSpec.describe "transactions/new", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new(
      amount: 1,
      transaction_type: 1,
      balance: 1,
      state: "",
      confirmation_code: 1,
      account: nil
    ))
  end

  it "renders new transaction form" do
    render

    assert_select "form[action=?][method=?]", transactions_path, "post" do

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[transaction_type]"

      assert_select "input[name=?]", "transaction[balance]"

      assert_select "input[name=?]", "transaction[state]"

      assert_select "input[name=?]", "transaction[confirmation_code]"

      assert_select "input[name=?]", "transaction[account_id]"
    end
  end
end
