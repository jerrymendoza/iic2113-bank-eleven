require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before do
    assign(:accounts, [
             Account.create!(
               number: "Number",
               balance: 2,
               account_type: 3,
               user: nil
             ),
             Account.create!(
               number: "Number",
               balance: 2,
               account_type: 3,
               user: nil
             )
           ])
  end

  it "renders a list of accounts" do
    render
    assert_select "tr>td", text: "Number".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
