# frozen_string_literal: true

require 'field_serializer'
require 'nokogiri'

class String
  def tidy
    gsub(/[[:space:]]+/, ' ').strip
  end
end

class Page < ScrapedPage
end
