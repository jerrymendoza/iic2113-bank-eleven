require 'rails_helper'

RSpec.describe "transactions/index", type: :view do
  before do
    assign(:transactions, [
             Transaction.create!(
               amount: 2,
               transaction_type: 3,
               balance: 4,
               state: "",
               confirmation_code: 5,
               account: nil
             ),
             Transaction.create!(
               amount: 2,
               transaction_type: 3,
               balance: 4,
               state: "",
               confirmation_code: 5,
               account: nil
             )
           ])
  end

  it "renders a list of transactions" do
    render
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: 5.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
