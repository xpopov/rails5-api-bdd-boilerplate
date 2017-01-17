require 'test_helper'
require 'ostruct'
require 'json'
require 'yaml'

# ActionDispatch::IntegrationTest supersedes ActionController::TestCase which is deprecated
class StorePagesTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = true

  setup do
    # Disable network, allow only stubs
    WebMock.disable_net_connect!
    @microsoft = OpenStruct.new(url: 'http://www.microsoft.com')
    @dummy = pages(:dummy)
  end

  test "it should grab and return a page" do
    stub_get = stub_microsoft_load

    # page count should increase by +1 after submitting API request
    assert_difference -> { Page.count }, +1, 'New Page should be created' do
      post "/api/pages/store", params: { url: @microsoft.url }
    end

    assert_requested stub_get
    assert_response :created
    assert_equal Mime[:json], response.content_type

    # page should have the correct attributes
    fixtures_page_data = YAML.load_file(Rails.root + 'test/data/microsoft_page_data.yml')
    page_from_response = JSON.parse(response.body)
    page_from_response.except! 'id', 'created_at', 'updated_at'

    # File.open(Rails.root + 'test/data/microsoft_page_data_from_response', 'w') { |file| file.write(page_from_response.to_yaml) }
    assert_equal fixtures_page_data, page_from_response
  end

  test "it should fail when URL not provided" do
    assert_no_difference -> { Page.count }, 'New Page should not be created' do
      post "/api/pages/store"
    end

    assert_response :unprocessable_entity
    assert_equal Mime[:json], response.content_type
  end


  test "it should not create new record when URL is already in database" do
    stub_dummy_load
    post "/api/pages/store", params: { url: @dummy.url }
    assert_no_difference -> { Page.count }, 'New Page should not be created' do
      post "/api/pages/store", params: { url: @dummy.url }
    end
    
    assert_response :created
    assert_equal Mime[:json], response.content_type

    # page should have the correct attributes
    fixtures_page_data = @dummy.as_json
    page_from_response = JSON.parse(response.body)
    fixtures_page_data.except! 'id', 'created_at', 'updated_at'
    page_from_response.except! 'id', 'created_at', 'updated_at'

    # File.open(Rails.root + 'test/data/microsoft_page_data_from_response', 'w') { |file| file.write(page_from_response.to_yaml) }
    assert_equal fixtures_page_data, page_from_response
  end


  test "it should fail when URL gives network error on retrieval, such as 404, etc" do
    WebMock.allow_net_connect!
    assert_no_difference -> { Page.count }, 'New Page should not be created' do
      post "/api/pages/store", params: { url: "https://www.this-should-not-exist-sfjsjsgkdg858.com" }
    end

    assert_response :unprocessable_entity
    assert_equal Mime[:json], response.content_type
  end


  test "it should fail when URL is malformed" do
    assert_no_difference -> { Page.count }, 'New Page should not be created' do
      post "/api/pages/store", params: { url: "file:///some_stuff" }
    end
    assert_response :not_found
    assert_equal Mime[:json], response.content_type
  end

  test "it should fail when URL is local" do
    assert_no_difference -> { Page.count }, 'New Page should not be created' do
      post "/api/pages/store", params: { url: "http://localhost:6379/redis_stuff" }
    end
    assert_response :not_found
    assert_equal Mime[:json], response.content_type

    assert_no_difference -> { Page.count }, 'New Page should not be created' do
      post "/api/pages/store", params: { url: "http://127.0.0.1:6379/redis_stuff" }
    end
    assert_response :not_found
    assert_equal Mime[:json], response.content_type
  end

end
