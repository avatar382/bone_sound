require 'test_helper'

class MaterialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @material = Fabricate(:material)
  end

  test "should get index" do
    get materials_url
    assert_response :success
  end

  test "should search on sku" do
    search = rand(10000000000)
    waldo = Fabricate(:material, sku: search)

    get materials_url(q: "#{search}")
    
    assert assigns[:materials].length == 1
    assert assigns[:materials].include?(waldo)
  end

  test "should search on description" do
    search = rand(10000000000)
    waldo = Fabricate(:material, description: search)

    get materials_url(q: "#{search}")
    
    assert assigns[:materials].length == 1
    assert assigns[:materials].include?(waldo)
  end

  test "should search on price" do
    search = rand(100000)
    waldo = Fabricate(:material, price: search)

    get materials_url(q: "#{search}")
    
    assert assigns[:materials].length == 1
    assert assigns[:materials].include?(waldo)
  end

  test "should get new" do
    get new_material_url
    assert_response :success
  end

  test "should create material" do
    assert_difference('Material.count') do
      post materials_url, params: { material: Fabricate.attributes_for(:material) }
    end

    assert_redirected_to materials_url
  end

  test "should get edit" do
    get edit_material_url(@material)
    assert_response :success
  end

  test "should update material" do
    attrs = Fabricate.attributes_for(:material)
    patch material_url(@material), params: { material: attrs }
    assert_redirected_to materials_url
    @material.reload
    assert @material.sku.to_s == attrs["sku"].to_s
  end

  test "should destroy material" do
    assert_difference('Material.count', -1) do
      delete material_url(@material)
    end

    assert_redirected_to materials_url
  end
end
