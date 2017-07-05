class BillingController < ApplicationController
  def index
    @charges = Charge.all.unpaid.ufid
  end
end
