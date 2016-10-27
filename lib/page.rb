# frozen_string_literal: true

require 'field_serializer'
require 'nokogiri'

class String
  def tidy
    gsub(/[[:space:]]+/, ' ').strip
  end
end

class Page
  include FieldSerializer

  def initialize(interaction)
    @url = interaction.url
    @noko = interaction.noko
  end

  private

  attr_reader :url, :noko

  def absolute_url(rel)
    return if rel.to_s.empty?
    URI.join(url, URI.encode(URI.decode(rel)))
  end
end
