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
    date, end_date = get_date_params

    @print_charge = Charge.all.created_after(date).created_before(end_date).not_comped.print
    @cnc_charge = Charge.all.created_after(date).created_before(end_date).not_comped.cnc
    @waterjet_charge  = Charge.all.created_after(date).created_before(end_date).not_comped.waterjet
    @membership_charge = Charge.all.created_after(date).created_before(end_date).not_comped.membership
    @laser_charge = Charge.all.created_after(date).created_before(end_date).not_comped.laser
    @design_charge = Charge.all.created_after(date).created_before(end_date).not_comped.design
    @materials_charge = Charge.created_after(date).created_before(end_date).all.not_comped.materials


    @print_charge_ufid = Charge.all.created_after(date).created_before(end_date).not_comped.print.ufid
    @cnc_charge_ufid = Charge.all.created_after(date).created_before(end_date).not_comped.cnc.ufid
    @waterjet_charge_ufid  = Charge.all.created_after(date).created_before(end_date).not_comped.waterjet.ufid
    @membership_charge_ufid = Charge.all.created_after(date).created_before(end_date).not_comped.membership.ufid
    @laser_charge_ufid = Charge.all.created_after(date).created_before(end_date).not_comped.laser.ufid
    @design_charge_ufid = Charge.all.created_after(date).created_before(end_date).not_comped.design.ufid
    @materials_charge_ufid = Charge.created_after(date).created_before(end_date).all.not_comped.materials.ufid


    @print_charge_chartfield = Charge.all.created_after(date).created_before(end_date).not_comped.print.chartfield
    @cnc_charge_chartfield = Charge.all.created_after(date).created_before(end_date).not_comped.cnc.chartfield
    @waterjet_charge_chartfield  = Charge.all.created_after(date).created_before(end_date).not_comped.waterjet.chartfield
    @membership_charge_chartfield = Charge.all.created_after(date).created_before(end_date).not_comped.membership.chartfield
    @laser_charge_chartfield = Charge.all.created_after(date).created_before(end_date).not_comped.laser.chartfield
    @design_charge_chartfield = Charge.all.created_after(date).created_before(end_date).not_comped.design.chartfield
    @materials_charge_chartfield = Charge.created_after(date).created_before(end_date).all.not_comped.materials.chartfield


    @print_charge_check = Charge.all.created_after(date).created_before(end_date).not_comped.print.check
    @cnc_charge_check = Charge.all.created_after(date).created_before(end_date).not_comped.cnc.check
    @waterjet_charge_check  = Charge.all.created_after(date).created_before(end_date).not_comped.waterjet.check
    @membership_charge_check = Charge.all.created_after(date).created_before(end_date).not_comped.membership.check
    @laser_charge_check = Charge.all.created_after(date).created_before(end_date).not_comped.laser.check
    @design_charge_check = Charge.all.created_after(date).created_before(end_date).not_comped.design.check
    @materials_charge_check = Charge.created_after(date).created_before(end_date).all.not_comped.materials.check

  end

  def detail_report
    date, end_date = get_date_params

    if params[:type] == "3dp"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.print
    elsif params[:type] == "cnc"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.cnc
    elsif params[:type] == "waterjet"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.waterjet
    elsif params[:type] == "membership"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.membership
    elsif params[:type] == "laser"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.laser
    elsif params[:type] == "design"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.design
    elsif params[:type] == "materials"
      @charges = Charge.all.created_after(date).created_before(end_date).not_comped.materials
    end

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"fab_lab_detail_report_#{Time.now.strftime("%m%d%Y")}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  private

    def get_date_params
      if params[:date]
        date = params[:date]
      else
        date = "2017-05-01"
      end

      if params[:end_date]
        end_date = params[:end_date]
      else
        end_date = (Time.now + 1.day).strftime("%Y-%m-%d")
      end

      [date, end_date]
    end


end
