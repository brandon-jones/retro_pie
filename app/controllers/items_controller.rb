class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate
  skip_before_action :verify_authenticity_token, only: [:scrape_data]
  # GET /items
  # GET /items.json
  def index
    @title = "Listing Items"
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @title = @item.title
  end

  def scrape_data
    @item_values = Item.scrape_data(params)

    render json: @item_values and return unless @item_values == nil
    render json: { errors: "Unable to scrape data try again" }
  end

  # GET /items/new
  def new
    @title = 'New Item'
    @categories = Category.all
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @title = "Editing Items"
    @categories = Category.all
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        @categories = Category.all
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        @categories = Category.all
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :description, :amazon_url, :image_url, :cost, :base_item, :category_id, :markup, :title_locked, :description_locked, :image_url_locked, :title_css, :description_css, :image_url_css, :cost_css)
    end
end
