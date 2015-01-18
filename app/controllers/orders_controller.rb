class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index]
  before_action :session_auth, only: [:edit, :update, :show]
  # GET /orders
  # GET /orders.json
  def index
    sort_order = params["sort_order"] || 'DESC'
    @sort_order = sort_order == 'ASC' ? 'DESC' : 'ASC'

    # @sort_by = params["sort_by"] || 'name'
    
    @statuses = Status.all.pluck(:name, :id)
    # @orders = Order.order("#{@sort_by} #{@sort_order}")
    @orders = Order.all
    if params["table_only"] && params["table_only"] == "true"
      render partial: 'index_table' and return
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    
  end

  def status
    # if params["order_id"]
    #   order = params["order_id"]
    # elsif session[:my_pie_order]
    #   order = session[:my_pie_order]
    # end
    # if order
    #   @order = Order.where(order_id: order).first
    # end
    # @order = "An order with the id #{order} was not found<br>If an order was not verified I will delete it after a few days." unless @order
    # @title = "Check order status"
  end

  # GET /orders/new
  def new
    @order = Order.new
    @categories = {}
    Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
      @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
    end
    @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
  end

  # GET /orders/1/edit
  def edit
    @order = Order.where(order_id: params["id"]).first
    @user = User.find_by_id(params["user_id"])
    @payment = Payment.find_by_id(params["payment_id"])
    @categories = {}
    Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
      @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
    end
    # @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
  end

  def verify
    @order = Order.where(order_id: params["id"]).first
    @user = User.find_by_id(params["user_id"])
    @payment = Payment.where(id: params["payment_id"]).first
    if params["commit"]
      @order.status_id = Status.find_by_name('Ordered')
      if @order.save
        EmailedReceiptMailer.emailed_receipt_send_mail(@user).deliver
        redirect_to appreciation_orders_path, { notice: 'Order status has been updated. You will be contacted shortly.' }
      else
        redirect_to verify_order_path(params["id"], user_id: params["user_id"], payment_id: params["payment_id"]), {notice: 'Some error prevented updating the information.' }
      end
    end
  end

  def submit_order
    binding.prty
    @order = Order.where(order_id: params["id"]).first
    @user = User.find_by_id(params["OrderId"])
    @order = Order.where(order_id: params["order"]["order_id"]).first
    @order.status_id = Status.find_by_name('Ordered')
    @order.cost = @order.calculate_cost
    if @order.save
      redirect_to order_path(@order.order_id), { notice: 'Order status has been updated. You will be contacted shortly.' }
    else
      redirect_to verify_order_path(@order.order_id), {notice: 'Some error prevented updating the information.' }
    end
  end

  # POST /orders
  # POST /orders.json
  def create

    if params["order"]["order_id"].present?
      #   @title =  params["order"]["order_id"]
      # else
      #   @title = "New Order"
      # end
      if @order = Order.where(order_id: params["order"]["order_id"]).first
        @order.total = params["order"]["total"].to_f
        @order.order_items.destroy_all
      end
    end
    @order = Order.new(order_params) unless @order
    respond_to do |format|
      if @order.save
        @order.order_items_builder(params["order"]["items"])
        @order.cost = @order.calculate_cost
        @order.save
        session[:_bmp_order_id] = @order.order_id
        format.html { redirect_to new_user_path(order_id: @order.order_id) }
        format.json { render action: 'show', status: :created, location: @order }
      else
        @categories = {}
        Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
          @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
        end
        # @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def stats
    # @orders = Order.all
    # return_hash = {}
    # @orders.each do |order|
    #   order["items"] = order.calculate_cost
      
    # end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    @order = Order.find_by_order_id(params["order"]["order_id"])
    respond_to do |format|
      if @order.update(order_params)
        @order.order_items_builder(params["order"]["items"])
        @order.cost = @order.calculate_cost
        @order.save
        format.html { redirect_to verify_order_path(@order.order_id, user_id: param("user_id"), payment_id: param('payment_id') ) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_orders
    params["changed_orders"].split(',').each_slice(2) do |id,status_id|
      if order = Order.where(order_id: id).first
        order.status_id = status_id
        order.save
      end
    end

    render nothing: true
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
      @order = Order.where(order_id: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      puts '-'*80
      puts params
      puts '='*80
      params.require(:order).permit(:status_id, :shipping_price, :order_id, :special_instructions, :total, :delivery_type, :cost)
    end
end
