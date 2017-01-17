require 'rest-client'
# require 'app/errors/invalid_parameter'

class PagesController < ApplicationController
  
  # before_action :set_store_page, only: [:show, :update, :destroy

  # GET /pages/get/:url
  def get
    url = store_page_params[:url]
    page = Page.find_by! url: url
    render json: page, status: :created
  end


  # POST /pages/store/:url
  def store
    # Query using given URL
    url = store_page_params[:url]
    html_page = Nokogiri::HTML(RestClient.get(url))
    
    title = html_page.css("title").text
    h1 = html_page.css("h1").map(&:text)
    h2 = html_page.css("h2").map(&:text)
    h3 = html_page.css("h3").map(&:text)
    links = html_page.css("a").map{ |a| a['href'] }
    page_attrs = { url: url, title: title, h1: h1, h2: h2, h3: h3, links: links }

    # page = Page.new
    page = Page.upsert(page_attrs)

    # Use PostgreSQL 9.5+ UPSERT feature
    # Page.import([page], on_duplicate_key_update: { conflict_target: [:url], columns: [:title, :h1, :h2, :h3, :links] })

    if page
      render json: page, status: :created
    else
      render json: page.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_store_page
    #   @page = Page.find(params[:id])
    # end

    # Only allow a trusted parameter "white list" through.
    def store_page_params
      params.require(:url)
      params.permit(:url)

      begin
        uri = URI.parse(params[:url])
        raise InvalidURLParameter if !uri.is_a?(URI::HTTP) || uri.host.nil? || 
          'localhost' == uri.host.downcase || '127.0.0.1' == uri.host.downcase
        params.permit(:url)
      rescue URI::InvalidURIError
        false
      end
    end
end
