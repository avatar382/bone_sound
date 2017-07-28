require 'test_helper'

class ChargefilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account1 = Fabricate(:account)
    @account2 = Fabricate(:account)

    @charge1 = Fabricate(:charge, account: @account1)
    @charge2 = Fabricate(:charge, account: @account1)
    @charge3 = Fabricate(:charge, account: @account2)
    @charge4 = Fabricate(:charge, account: @account2)
  end

  test "should create chargefile from all unpaid UFID charges" do
    assert Charge.paid.count == 0
    assert Charge.unpaid.count == 4

    assert_difference('Chargefile.count') do
      post chargefiles_url
    end

    assert Charge.paid.count == 4
    assert Charge.unpaid.count == 0

    assert_redirected_to download_chargefile_path(assigns[:chargefile])
  end

  test "should show charges in a single chargefile" do
    post chargefiles_url
    chargefile = Chargefile.last

    get chargefile_url(chargefile)

    assert_response :success
    assert assigns[:chargefile].charges.length == 4
  end

  test "should download chargefile as text" do
    post chargefiles_url
    chargefile = Chargefile.last

    response = get download_chargefile_url(chargefile)

    assert_response :success
  end

  test "should list all chargefiles" do
    post chargefiles_url
    chargefile = Chargefile.last

    get chargefiles_url

    assert assigns[:chargefiles].include?(chargefile)
  end
end
