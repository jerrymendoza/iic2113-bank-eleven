require 'rails_helper'

RSpec.describe "accounts/edit", type: :view do
  before do
    @account = assign(:account, Account.create!(
                                  number: "MyString",
                                  balance: 1,
                                  account_type: 1,
                                  user: nil
                                ))
  end

  it "renders the edit account form" do
    render

    assert_select "form[action=?][method=?]", account_path(@account), "post" do
      assert_select "input[name=?]", "account[number]"

      assert_select "input[name=?]", "account[balance]"

      assert_select "input[name=?]", "account[account_type]"

      assert_select "input[name=?]", "account[user_id]"
    end
  end
end
