class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, except: [:new, :create, :status]

  # GET /orders
  # GET /orders.json
  def index
    @title = "All Orders"
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @title = @order.order_id
  end

  def status
    if params["order_id"]
      temp_order = Order.where(order_id: params["order_id"]).first
      if temp_order
        @order_status = "Order id: #{temp_order.order_id}"
        @order_status +=  "<br>Order Status: #{temp_order.status}"
        @order_status += "<br>Last Updated: #{temp_order.updated_at}"
      else
        @order_status = "An order with the id #{params["order_id"]} was not found"
      end
    end
    @title = "Check order status"
  end

  # GET /orders/new
  def new
    @title = "New Order"
    @order = Order.new
    @categories = {}
    Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
      @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
    end
    @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
  end

  # GET /orders/1/edit
  def edit
    @title = "Edit Order #{@order.order_id}"
    @categories = {}
    Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
      @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
    end
    @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
  end

  def verify
    @order = Order.where(order_id: params["id"]).first
    @title = "#{@order.order_id}"
  end

  def verify_order
    @order = Order.where(order_id: params["order"]["order_id"]).first
    @order.status_id = Status.where(name: 'Ordered').first.id
    if @order.save
      redirect_to @order, { notice: 'Order status has been updated. You will be contacted shortly.' }
    else
      redirect_to verify_order_path(@order.order_id), {notice: 'Some error prevented updating the information.' }
    end
  end

  # POST /orders
  # POST /orders.json
  def create
    if @order = Order.where(order_id: params["order"]["order_id"]).first
      @order.total = params["order"]["total"].to_f
      @order.name = params["order"]["name"]
      @order.email = params["order"]["email"]
      @order.perferred_contact = params["order"]["perferred_contact"]
      @order.delivery_type = params["order"]["delivery_type"]
      @order.shipping_info = params["order"]["shipping_info"]
      @order.special_instructions = params["order"]["special_instructions"]
    end
    @order = Order.new(order_params) unless @order
    respond_to do |format|
      if @order.save
        @order.order_items.destroy_all
        @order.order_items_builder(params["order"]["items"])
        format.html { redirect_to verify_order_path(@order.order_id), notice: 'Please Verify the order and submit.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        @categories = {}
        Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
          @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
        end
        @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    binding.pry
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      puts '-'*80
      puts params
      puts '='*80
      params.require(:order).permit(:total, :item_id, :item_price, :item_count, :status_id, :name, :email, :perferred_contact, :shipping_info, :delivery_type, :shipping_price, :order_id, :special_instructions, :items)
    end
end
