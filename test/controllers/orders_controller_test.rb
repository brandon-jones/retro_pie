require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { delivery_type: @order.delivery_type, email: @order.email, item_count: @order.item_count, item_id: @order.item_id, item_price: @order.item_price, name: @order.name, order_id: @order.order_id, perferred_contact: @order.perferred_contact, shipping_info: @order.shipping_info, shipping_price: @order.shipping_price, special_instructions: @order.special_instructions, status: @order.status }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { delivery_type: @order.delivery_type, email: @order.email, item_count: @order.item_count, item_id: @order.item_id, item_price: @order.item_price, name: @order.name, order_id: @order.order_id, perferred_contact: @order.perferred_contact, shipping_info: @order.shipping_info, shipping_price: @order.shipping_price, special_instructions: @order.special_instructions, status: @order.status }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
