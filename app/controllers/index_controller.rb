class IndexController < ApplicationController
  before_action :add_inversion

  def welcome; end

  private 

  def add_inversion 
    yes ||= BankInversionWorker.perform_async()
  end
end
