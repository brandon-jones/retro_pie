require 'test_helper'

class ShippingsControllerTest < ActionController::TestCase
  setup do
    @shipping = shippings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shippings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shipping" do
    assert_difference('Shipping.count') do
      post :create, shipping: { apt_number: @shipping.apt_number, city: @shipping.city, order_id: @shipping.order_id, state: @shipping.state, street: @shipping.street, zip_code: @shipping.zip_code }
    end

    assert_redirected_to shipping_path(assigns(:shipping))
  end

  test "should show shipping" do
    get :show, id: @shipping
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shipping
    assert_response :success
  end

  test "should update shipping" do
    patch :update, id: @shipping, shipping: { apt_number: @shipping.apt_number, city: @shipping.city, order_id: @shipping.order_id, state: @shipping.state, street: @shipping.street, zip_code: @shipping.zip_code }
    assert_redirected_to shipping_path(assigns(:shipping))
  end

  test "should destroy shipping" do
    assert_difference('Shipping.count', -1) do
      delete :destroy, id: @shipping
    end

    assert_redirected_to shippings_path
  end
end
