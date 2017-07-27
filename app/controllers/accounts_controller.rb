class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :access_form]

  layout "invoice", only: [:access_form]

  # GET /accounts
  # GET /accounts.json
  def index
    if params[:filter] == "recent_laser"
      @accounts = Account.recent_laser.active_laser
    elsif params[:filter] == "uncharged_laser"
      @accounts = Account.uncharged_laser
    elsif params[:filter] == "active_laser"
      @accounts = Account.active_laser
    elsif params[:filter] == "expired_laser"
      @accounts = Account.expired_laser
    else
      @accounts = Account.all
    end

    @accounts = @accounts.filter(params[:q]).page(params[:page])
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @service_charge = Charge.new
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  def batch_new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        flash[:notice] = "Account was successfully created"
        format.html { redirect_to @account }
        format.json { render :show, status: :created, location: @account }
      else
        flash[:error] = "Unable to save account: #{@account.errors.full_messages.to_sentence}"
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def batch_create
    @account = Account.new(account_params)
    @account.auto_charge = true

    respond_to do |format|
      if @account.save
        flash[:notice] = "Account was successfully created"
        format.html { redirect_to batch_new_accounts_path }
      else
        flash[:error] = "Unable to save account: #{@account.errors.full_messages.to_sentence}"
        format.html { redirect_to batch_new_accounts_path }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        flash[:notice] = "Account was successfully updated."
        format.html { redirect_to @account }
        format.json { render :show, status: :ok, location: @account }
      else
        flash[:error] = "Unable to update account: #{@account.errors.full_messages.to_sentence}"
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      flash[:notice] = "Account was successfully removed."
      format.html { redirect_to accounts_url(filter: "all") }
      format.json { head :no_content }
    end
  end

  def access_form
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.fetch(:account, {}).permit(:email, :first_name, :last_name, :business_name, :phone, :gatorlink_id, :ufid, :chartfield, :affiliation, :account_type, :expires_at, :uf_college)
    end
end
