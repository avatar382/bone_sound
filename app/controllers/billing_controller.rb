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

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"fab_lab_chartfield_charges_#{Time.now.strftime("%m%d%Y")}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def report
    @print_charge = Charge.all.not_comped.print
    @cnc_charge = Charge.all.not_comped.cnc
    @waterjet_charge  = Charge.all.not_comped.waterjet
    @membership_charge = Charge.all.not_comped.membership
    @laser_charge = Charge.all.not_comped.laser
    @design_charge = Charge.all.not_comped.design
    @materials_charge = Charge.all.not_comped.materials
  end

  def detail_report
    if params[:type] == "3dp"
      @charges = Charge.all.not_comped.print
    elsif params[:type] == "cnc"
      @charges = Charge.all.not_comped.cnc
    elsif params[:type] == "waterjet"
      @charges = Charge.all.not_comped.waterjet
    elsif params[:type] == "membership"
      @charges = Charge.all.not_comped.membership
    elsif params[:type] == "laser"
      @charges = Charge.all.not_comped.laser
    elsif params[:type] == "design"
      @charges = Charge.all.not_comped.design
    elsif params[:type] == "materials"
      @charges = Charge.all.not_comped.materials
    end

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"fab_lab_detail_report_#{Time.now.strftime("%m%d%Y")}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
