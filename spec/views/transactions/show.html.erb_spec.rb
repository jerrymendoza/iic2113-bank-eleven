require 'rails_helper'

RSpec.describe "transactions/show", type: :view do
  before do
    @transaction = assign(:transaction, Transaction.create!(
                                          amount: 2,
                                          transaction_type: 3,
                                          balance: 4,
                                          state: "",
                                          confirmation_code: 5,
                                          account: nil
                                        ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(//)
    expect(rendered).to match(/5/)
    expect(rendered).to match(//)
  end
end
