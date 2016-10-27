# frozen_string_literal: true
require 'nokogiri'
require 'uri'
require 'field_serializer'

class ScrapedPage
  include FieldSerializer

  class Strategy
    MissingMethodError = Class.new(StandardError)

    def initialize(url)
      @url = url
    end

    def body
      raise MissingMethodError, "Strategy must provide '#body' method to return response body"
    end

    private

    attr_reader :url
  end

  class OpenURIStrategy < Strategy
    def body
      @body ||=
        begin
          body = response.read
          response.rewind
          body
        end
    end

    private

    def response
      @response ||= open(url)
    end
  end

  class OpenURIArchiveStrategy < OpenURIStrategy
    private

    def response
      super.tap do |response|
        # Archiver.new(response).store
      end
    end
  end

  def initialize(url:, strategy: ScrapedPage::OpenURIStrategy)
    @url = url
    @strategy = strategy.new(url)
  end

  def noko
    @noko ||= Nokogiri::HTML(strategy.body)
  end

  private

  attr_reader :url, :strategy

  def absolute_url(rel)
    return if rel.to_s.empty?
    URI.join(url, URI.encode(URI.decode(rel)))
  end
end
