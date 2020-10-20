require 'rails_helper'

RSpec.describe "accounts/new", type: :view do
  before do
    assign(:account, Account.new(
                       number: "MyString",
                       balance: 1,
                       savings: 1,
                       user: nil
                     ))
  end

  it "renders new account form" do
    render

    assert_select "form[action=?][method=?]", accounts_path, "post" do
      assert_select "input[name=?]", "account[number]"

      assert_select "input[name=?]", "account[balance]"

      assert_select "input[name=?]", "account[savings]"

      assert_select "input[name=?]", "account[user_id]"
    end
  end
end
