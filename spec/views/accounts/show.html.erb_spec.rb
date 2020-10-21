require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before do
    @account = assign(:account, Account.create!(
                                  number: "Number",
                                  balance: 2,
                                  account_type: 3,
                                  user: nil
                                ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
  end
end
