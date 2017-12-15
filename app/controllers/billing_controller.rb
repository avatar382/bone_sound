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
    @print_charge = Charge.all.print
    @cnc_charge = Charge.all.cnc
    @waterjet_charge  = Charge.all.waterjet
    @membership_charge = Charge.all.membership
    @laser_charge = Charge.all.laser
    @design_charge = Charge.all.design
    @materials_charge = Charge.all.materials
  end

  def detail_report
    if params[:type] == "3dp"
      @charges = Charge.all.print
    elsif params[:type] == "cnc"
      @charges = Charge.all.cnc
    elsif params[:type] == "waterjet"
      @charges = Charge.all.waterjet
    elsif params[:type] == "membership"
      @charges = Charge.all.membership
    elsif params[:type] == "laser"
      @charges = Charge.all.laser
    elsif params[:type] == "design"
      @charges = Charge.all.design
    elsif params[:type] == "materials"
      @charges = Charge.all.materials
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
