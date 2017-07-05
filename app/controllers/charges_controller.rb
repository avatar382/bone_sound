class ChargesController < ApplicationController
  before_action :set_charge, only: [:show, :edit, :update, :destroy]
  before_action :set_account, only: [:index, :create, :update, :destroy]

  # GET /charges
  # GET /charges.json
  def index
    @charges = @account.charges.all.page(params[:page])
  end

  # POST /charges
  # POST /charges.json
  def create
    @charge = Charge.new(charge_params)
    fill_params_via_membership_id(@charge, params[:membership_id]) if params[:membership_id].present?

    @charge.account = @account

    respond_to do |format|
      if @charge.save
        flash[:notice] = "Charge successfully created"
        format.html { redirect_to account_path(@account) }
        format.json { render :show, status: :created, location: @account }
      else
        flash[:error] = "Unable to save charge to account: #{@charge.errors.full_messages.to_sentence}"
        format.html { redirect_to account_path(@account) }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charges/1
  # PATCH/PUT /charges/1.json
  def update
    respond_to do |format|
      if @charge.pay!
        format.html { redirect_to account_charges_url(@account), notice: 'Charge was successfully marked paid.' }
        format.json { render :show, status: :ok, location: @charge }
      else
        format.html { render :edit }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge.destroy
    respond_to do |format|
      format.html { redirect_to account_charges_url(@account), notice: 'Charge was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_charge
      @charge = Charge.find(params[:id])
    end

    def set_account
      @account = Account.find(params[:account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def charge_params
      params.fetch(:charge, {}).permit(:account_id, :charge_type, :description, :amount, :payment_method)
    end

    def fill_params_via_membership_id(charge, membership_id)
      membership = Membership.find(membership_id)

      charge.amount = membership.price 
      charge.description = membership.name
      charge.charge_type = Charge::MEMBERSHIP_CHARGE
    end
end
