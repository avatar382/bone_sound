class ChargefilesController < ApplicationController
  before_action :set_chargefile, only: [:show, :download]

  def create
    @chargefile = Chargefile.new
    @chargefile.charges << Charge.all.unpaid.ufid

    respond_to do |format|
      if @chargefile.save
        flash[:notice] = "Charge File successfully created"
        format.html { redirect_to download_chargefile_path(@chargefile)}
      else
        flash[:error] = "Unable to create charge file: #{@chargefile.errors.full_messages.to_sentence}"
        format.html { redirect_to billing_path(type: "ufid") }
      end
    end    
  end

  def index
    @chargefiles = Chargefile.all
  end

  def show
  end

  def download
    file_content = @chargefile.generate_text_content
    send_data file_content, filename: "DCPSFAR.#{Time.now.strftime("%Y%m%d")}.txt"
  end

  private

    def set_chargefile
      @chargefile = Chargefile.find(params[:id])
    end
end
