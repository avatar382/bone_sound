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

    case params['affil']
    when 'dcp'
      charges = Charge.dcp
    when 'arts'
      charges = Charge.arts
    when 'uf'
      charges = Charge.uf
    when 'external'
      charges = Charge.external
    else
      charges = Charge.all
    end

    @print_charge = charges.created_after(date).created_before(end_date).not_comped.print
    @cnc_charge = charges.created_after(date).created_before(end_date).not_comped.cnc
    @waterjet_charge  = charges.created_after(date).created_before(end_date).not_comped.waterjet
    @membership_charge = charges.created_after(date).created_before(end_date).not_comped.membership
    @laser_charge = charges.created_after(date).created_before(end_date).not_comped.laser
    @design_charge = charges.created_after(date).created_before(end_date).not_comped.design
    @materials_charge = charges.created_after(date).created_before(end_date).all.not_comped.materials


    @print_charge_ufid = charges.created_after(date).created_before(end_date).not_comped.print.ufid
    @cnc_charge_ufid = charges.created_after(date).created_before(end_date).not_comped.cnc.ufid
    @waterjet_charge_ufid  = charges.created_after(date).created_before(end_date).not_comped.waterjet.ufid
    @membership_charge_ufid = charges.created_after(date).created_before(end_date).not_comped.membership.ufid
    @laser_charge_ufid = charges.created_after(date).created_before(end_date).not_comped.laser.ufid
    @design_charge_ufid = charges.created_after(date).created_before(end_date).not_comped.design.ufid
    @materials_charge_ufid = charges.created_after(date).created_before(end_date).all.not_comped.materials.ufid


    @print_charge_chartfield = charges.created_after(date).created_before(end_date).not_comped.print.chartfield
    @cnc_charge_chartfield = charges.created_after(date).created_before(end_date).not_comped.cnc.chartfield
    @waterjet_charge_chartfield  = charges.created_after(date).created_before(end_date).not_comped.waterjet.chartfield
    @membership_charge_chartfield = charges.created_after(date).created_before(end_date).not_comped.membership.chartfield
    @laser_charge_chartfield = charges.created_after(date).created_before(end_date).not_comped.laser.chartfield
    @design_charge_chartfield = charges.created_after(date).created_before(end_date).not_comped.design.chartfield
    @materials_charge_chartfield = charges.created_after(date).created_before(end_date).all.not_comped.materials.chartfield


    @print_charge_check = charges.created_after(date).created_before(end_date).not_comped.print.check
    @cnc_charge_check = charges.created_after(date).created_before(end_date).not_comped.cnc.check
    @waterjet_charge_check  = charges.created_after(date).created_before(end_date).not_comped.waterjet.check
    @membership_charge_check = charges.created_after(date).created_before(end_date).not_comped.membership.check
    @laser_charge_check = charges.created_after(date).created_before(end_date).not_comped.laser.check
    @design_charge_check = charges.created_after(date).created_before(end_date).not_comped.design.check
    @materials_charge_check = charges.created_after(date).created_before(end_date).all.not_comped.materials.check

  end

  def detail_report
    date, end_date = get_date_params

    case params['affil']
    when 'dcp'
      charges = Charge.dcp
    when 'arts'
      charges = Charge.arts
    when 'uf'
      charges = Charge.uf
    when 'external'
      charges = Charge.external
    else
      charges = Charge.all
    end

    if params[:type] == "3dp"
      @charges = charges.created_after(date).created_before(end_date).not_comped.print
    elsif params[:type] == "cnc"
      @charges = charges.created_after(date).created_before(end_date).not_comped.cnc
    elsif params[:type] == "waterjet"
      @charges = charges.created_after(date).created_before(end_date).not_comped.waterjet
    elsif params[:type] == "membership"
      @charges = charges.created_after(date).created_before(end_date).not_comped.membership
    elsif params[:type] == "laser"
      @charges = charges.created_after(date).created_before(end_date).not_comped.laser
    elsif params[:type] == "design"
      @charges = charges.created_after(date).created_before(end_date).not_comped.design
    elsif params[:type] == "materials"
      @charges = charges.created_after(date).created_before(end_date).not_comped.materials
    end

    generate_detail_report_data

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

    def generate_detail_report_data
      @headers = ['Date', 'Name', 'Gatorlink ID', 'UF College', 'Affiliation', 'Method of Payment', 'Charge Type', 'Description', 'Amount', 'Paid'] 

      @uf_charges = @charges.select {|c| c.account.affiliation == Account::UF_AFFILIATION} 
      @arch_charges = @charges.select {|c| c.account.affiliation == Account::ARCH_AFFILIATION} 
      @arts_charges = @charges.select {|c| c.account.affiliation == Account::ARTS_AFFILIATION} 
      @external_charges = @charges.select {|c| c.account.affiliation == nil} 

      # sort our hashes by account
      @uf_charges = @uf_charges.sort {|a, b| b.account_id <=> a.account_id } 
      @arch_charges = @arch_charges.sort {|a, b| b.account_id <=> a.account_id } 
      @arts_charges = @arts_charges.sort {|a, b| b.account_id <=> a.account_id } 
      @external_charges = @external_charges.sort {|a, b| b.account_id <=> a.account_id } 

      get_unique_count_data
    end

    def get_unique_count_data
      # Count number of unique charges for each "college" in UF charge hash #
      @uf_sec_summary = {} 
      accounts = {} 

      @uf_charges.each do |c| 
        next if accounts[c.account_id] 

        col = c.account.uf_college 
        if @uf_sec_summary[col] 
          @uf_sec_summary[col] += 1 
        else 
          @uf_sec_summary[col] = 1 
        end 

        accounts[c.account_id] = true 
      end 
    end


end
