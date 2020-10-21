require 'rails_helper'

RSpec.describe "transactions/edit", type: :view do
  before(:each) do
    @transaction = assign(:transaction, Transaction.create!(
      amount: 1,
      transaction_type: 1,
      balance: 1,
      state: "",
      confirmation_code: 1,
      account: nil
    ))
  end

  it "renders the edit transaction form" do
    render

    assert_select "form[action=?][method=?]", transaction_path(@transaction), "post" do

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[transaction_type]"

      assert_select "input[name=?]", "transaction[balance]"

      assert_select "input[name=?]", "transaction[state]"

      assert_select "input[name=?]", "transaction[confirmation_code]"

      assert_select "input[name=?]", "transaction[account_id]"
    end
  end
end
