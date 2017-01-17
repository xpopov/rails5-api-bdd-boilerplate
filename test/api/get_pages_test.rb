require 'test_helper'
require 'ostruct'

# ActionDispatch::IntegrationTest supersedes ActionController::TestCase which is deprecated
class GetPagesTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = true

  setup do
    @microsoft = OpenStruct.new(url: 'http://www.microsoft.com')
    @dummy = pages(:dummy)
  end


  test "it should return previously grabbed page" do
    get "/api/pages/get", params: { url: @dummy.url }

    assert_response :success
    assert_equal Mime[:json], response.content_type

    # page should have the correct attributes
    fixtures_page_data = @dummy.as_json
    page_from_response = JSON.parse(response.body)
    fixtures_page_data.except! 'id', 'created_at', 'updated_at'
    page_from_response.except! 'id', 'created_at', 'updated_at'

    # File.open(Rails.root + 'test/data/microsoft_page_data_from_response', 'w') { |file| file.write(page_from_response.to_yaml) }
    assert_equal fixtures_page_data, page_from_response
  end


  test "it should fail if data is not in the database" do
    get "/api/pages/get", params: { url: @microsoft.url }

    assert_response :not_found
  end

end
