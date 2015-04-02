class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index, :destroy]
  skip_before_action :verify_authenticity_token, only: [:update_status, :appreciation]
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
    binding.pry
  end

  # def update_status
  #   UpdatePaymentInfo.perform_async(params)
  #   render :text => ""
  # end

  def status
    @statuses = Status.all
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
    if order_id = cookies[:_bmp_order_id]
      if @order = Order.find_by_order_id(order_id)
        @order = nil unless @order.status.name == 'Unsubmitted'
      else
        @order = Order.new
        cookies[:_bmp_order_id] = @order.order_id
      end
    end

    unless @order
      @order = Order.new
      cookies[:_bmp_order_id] = @order.order_id
    end
    # @user = User.new
    # @state_abreviations = ['AK','AL','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']
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
    @categories["Service Charge"] = [Item.service_charge]
    # @delivery_types = [['Local Pickup','local_pickup'],['Delivery','delivery']]
  end

  def verify
    @order = Order.find_by_order_id(params["id"])
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

  def charge
    if order = Order.find_by_order_id(params["id"])
      
      order.update_attribute(:status_id, Status.find_by_name('Payment Processing'))
      begin
        charge = Stripe::Charge.create(
          :amount => order.total_cents, # amount in cents, again
          :currency => "usd",
          :source => params[:stripeToken],
          :description => "Bake My PIe"
        )
      rescue Stripe::CardError => e
        order.update_attribute(:status_id, Status.find_by_name('Payment Denied'))
        flash[:error] = e.message
        redirect_to verify_order_path(id: order.id) and return
      end

      success = false

      if charge.status == 'succeeded' && charge.source.cvc_check == 'pass' && charge.source.cvc_check == 'pass'
        payment = Payment.new(order_id: order.id, amount_cents: charge.amount, status: charge.status, method: 'card', meta: charge)
        if payment.save
          success = true
        end
      end

      if success
        cookies[:_bmp_order_id] = nil
        order.update_attribute(:status_id, Status.find_by_name('Payment Recieved'))
        redirect_to appreciation_orders_path and return
      else
        flash[:error] = e.message
        redirect_to verify_order_path(id: order.id) and return
      end

    end
    binding.pry
  end

  def appreciation

    # UpdatePaymentInfo.perform_async(params)
  end

  # def submit_order
  #   binding.pry
  #   @order = Order.where(order_id: params["id"]).first
  #   @user = User.find_by_id(params["OrderId"])
  #   @order = Order.where(order_id: params["order"]["order_id"]).first
  #   @order.status_id = Status.find_by_name('Ordered')
  #   @order.cost = @order.calculate_cost
  #   if @order.save
  #     redirect_to order_path(@order.order_id), { notice: 'Order status has been updated. You will be contacted shortly.' }
  #   else
  #     redirect_to verify_order_path(@order.order_id), {notice: 'Some error prevented updating the information.' }
  #   end
  # end

  # POST /orders
  # POST /orders.json
  def create
    if params["id"].present?
      if @order = Order.find_by_id(params["id"])
        @order.order_items.destroy_all
      end
    end
    @order = Order.new(order_params) unless @order

    respond_to do |format|
      if verify_recaptcha && @order.save
        @order.order_items_builder(params["order"]["items"])
        @order.refigure_totals
        cookies[:_bmp_order_id] = @order.order_id
        format.html { redirect_to new_user_path(order_id: @order.order_id) }
        format.json { render action: 'show', status: :created, location: @order }
      else
        @order.errors.add(:captcha, "Please fill out captcha") unless verify_recaptcha
        @categories = {}
        Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
          @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
        end
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
    if params["id"].present?
      if @order = Order.find_by_id(params["id"])
        @order.order_items.destroy_all
      end
    end
    @order = Order.new(order_params) unless @order

    respond_to do |format|
      if verify_recaptcha && @order.save
        @order.order_items_builder(params["order"]["items"])
        @order.refigure_totals
        cookies[:_bmp_order_id] = @order.order_id
        format.html { redirect_to new_user_path(order_id: @order.order_id) }
        format.json { render action: 'show', status: :created, location: @order }
      else
        @order.errors.add(:captcha, "Please fill out captcha") unless verify_recaptcha
        @categories = {}
        Category.all.collect{|cat| [ cat.id, cat.name] }.each do |cat|
          @categories[cat[1]] = Item.all.where(category_id: cat[0]).where(base_item: true) + Item.all.where(category_id: cat[0]).where(base_item: false)
        end
        format.html { render action: 'new' }
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
