# frozen_string_literal: true
require 'nokogiri'
require 'uri'
require 'field_serializer'

require_rel 'scraped_page'

# Abstract class which scrapers can extend to implement their functionality.
class ScrapedPage
  include FieldSerializer

  class Response
    attr_reader :status, :headers, :body

    def initialize(body:, status: 200, headers: {})
      @status = status
      @headers = headers
      @body = body
    end
  end

  module Strategy
    class LiveRequest
      def get(url)
        warn url
        response = open(url)
        Response.new(
          status:  response.status.first.to_i,
          headers: response.meta,
          body:    response.read
        )
      end
    end
  end

  def initialize(url:, strategy: Strategy::LiveRequest.new)
    @url = url
    @strategy = strategy
  end

  private

  attr_reader :url, :strategy

  def noko
    @noko ||= Nokogiri::HTML(response.body)
  end

  def response
    @response ||= strategy.get(url)
  end
end
