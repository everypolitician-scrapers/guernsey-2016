#!/bin/env ruby
# encoding: utf-8
require 'require_all'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraperwiki'
require 'pry'

require_rel 'lib'

class String
  def tidy
    gsub(/[[:space:]]+/, ' ').strip
  end
end

url = 'https://gov.gg/contactus'
member_list = AllMembersPage.new(response: ScrapedPage::Request.new(url: url).response).to_h

warn "Found #{member_list[:members].count} members"

member_list[:members].shuffle.each do |mem|
  member = MemberPage.new(response: ScrapedPage::Request.new(url: mem[:url]).response).to_h
  ScraperWiki.save_sqlite([:name], member)
end
