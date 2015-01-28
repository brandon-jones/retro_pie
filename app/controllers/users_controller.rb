class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index, :show, :destroy]
  before_action :session_auth, only: [:edit, :update, :show]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def receipt
    if @user = User.where(email: params["user_email"]).first
      EmailedReceiptMailer.emailed_receipt_send_mail(@user, params["user_order_id"]).deliver
    end
    redirect_to root_url, notice: "If email address mathing your is fond you will get an email with newest order information"
  end

  # GET /users/new
  def new
    @user = User.new
    @state_abreviations = ['AK','AL','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']
    @order = Order.find_by_order_id(params["order_id"] || session[:_bmp_order_id])
  end

  # GET /users/1/edit
  def edit        
    @state_abreviations = ['AK','AL','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']
    @order = Order.where(order_id: params["order_id"]).first
    @user = User.find_by_id(params["id"])
    @payment = Payment.find_by_id(params["payment_id"])
  end

  def verify
    @order = Order.where(order_id: params["id"]).first
    @user = User.find_by_id(params["user_id"])
    @payment = Payment.find_by_id(params["payment_id"])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.where(email: user_params["email"]).first || User.new(user_params)
    
    respond_to do |format|
      if @user.save
        @order = Order.find_by_order_id(params["order_id"])
        @order.delivery_type = params["delivery_type"]
        @order.shipping_price = $shipping unless @order.delivery_type == 'pickup'
        @order.user_id = @user.id
        @order.save
        session[:_bmp_user_id] = @user.id
        format.html { redirect_to verify_order_path(param("order_id"), user_id: @user.id)}
        format.json { render action: 'show', status: :created, location: @user }
      else
        @state_abreviations = ['AK','AL','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']
        @order = Order.find_by_order_id(params["order_id"])
        @payment = Payment.find_by_id(params["payment_id"])
        format.html { render action: 'new', params: params }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @order = Order.where(order_id: params["order_id"]).first
    @user = User.find_by_id(params["id"])
    @payment = Payment.find_by_id(params["payment_id"])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to verify_order_path(@order.order_id, user_id: param("user_id"), payment_id: param('payment_id') ) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :phone)
    end
end
