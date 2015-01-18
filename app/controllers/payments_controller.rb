class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @user = User.find_by_id(param('user_id'))
    @order = Order.find_by_order_id(param('order_id'))
  end

  # GET /payments/1/edit
  def edit
    @order = Order.find_by_order_id(params["order_id"])
    @user = User.find_by_id(params["user_id"])
    @payment = Payment.find_by_id(params["id"])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    respond_to do |format|
      if @payment.save
        session[:_bmp_payment_id] = @payment.id
        binding.pry
        format.html { redirect_to verify_order_path(params["payment"]["order_order_id"], user_id: params["payment"]["user_id"], payment_id: @payment.id), notice: 'Payment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @payment }
      else
        format.html { render action: 'new' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    binding.pry
    @order = Order.find_by_order_id(params["payment"]["order_id"])

    @order = Order.find_by_order_id(params["payment"]["order_order_id"]) unless @order
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to verify_order_path(@order.order_id, user_id: param("user_id"), payment_id: @payment.id ) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:order_id, :amount)
    end
end
