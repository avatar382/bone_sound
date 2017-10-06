class MaterialsController < ApplicationController
  before_action :set_material, only: [:edit, :update, :destroy]
  before_action :set_material_via_sku, only: [:show]

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all.filter(params[:q]).page(params[:page])
  end

  # GET /materials/new
  def new
    @material = Material.new
  end

  def show
    render :json => { :error => 'not found' }, :status => 404 if @material.nil?
  end

  # GET /materials/1/edit
  def edit
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(material_params)

    respond_to do |format|
      if @material.save
        flash[:notice] = "Inventory successfully added."
        format.html { redirect_to materials_url }

        format.json { render :show, status: :created, location: @material }
      else
        flash[:error] = "Unable to add inventory: #{@material.errors.full_messages.to_sentence}"
        format.html { render :new }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        flash[:notice] = "Inventory successfully updated."
        format.html { redirect_to materials_url }
        format.json { render :show, status: :ok, location: @material }
      else
        flash[:error] = "Unable to update inventory: #{@material.errors.full_messages.to_sentence}"
        format.html { render :edit }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    respond_to do |format|
      flash[:notice] = "Inventory successfully updated."
      format.html { redirect_to materials_url, notice: 'Material was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end

    def set_material_via_sku
      @material = Material.find_by_sku(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params
      params.fetch(:material, {}).permit(:sku, :description, :price, :count, :minimum_count)
    end
end
