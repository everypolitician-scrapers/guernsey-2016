#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true
require 'require_all'
# require 'open-uri/cached'
require 'scraped_page_archive/open-uri'
# OpenURI::Cache.cache_path = '.cache'
require 'scraperwiki'

require_rel 'lib'

url = 'https://gov.gg/contactus'
member_list = AllMembersPage.new(response: Scraped::Request.new(url: url).response).members

warn "Found #{member_list.size} members"

member_list.shuffle.each do |mem|
  response = Scraped::Request.new(url: mem[:url]).response
  if response.status != 200
    warn "Got response status #{response.status} from #{response.url}. Skipping"
    next
  end
  member = MemberPage.new(response: response)
  ScraperWiki.save_sqlite([:name], member.to_h)
end
