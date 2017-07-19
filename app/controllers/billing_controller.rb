class BillingController < ApplicationController
  def index
    if params[:type] == "ufid"
      @charges = Charge.all.unpaid.ufid
    elsif params[:type] == "check"
      @charges = Charge.all.unpaid.check
    elsif params[:type] == "chartfield"
      @charges = Charge.all.unpaid.chartfield
    elsif params[:type] == "comped"
      @charges = Charge.all.comped
    end
  end
end
