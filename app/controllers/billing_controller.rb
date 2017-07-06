class BillingController < ApplicationController
  def index
    if params[:type] == "ufid"
      @charges = Charge.all.unpaid.ufid
    else
      @charges = Charge.all.unpaid - Charge.unpaid.ufid
    end

  end
end
