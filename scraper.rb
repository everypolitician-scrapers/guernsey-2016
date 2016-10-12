#!/bin/env ruby
# encoding: utf-8
require 'require_all'
# require 'open-uri/cached'
require 'scraped_page_archive/open-uri'
# OpenURI::Cache.cache_path = '.cache'
require 'scraperwiki'

require_rel 'lib'


url = 'https://gov.gg/contactus'
member_list = AllMembersPage.new(url).to_h

warn "Found #{member_list[:members].count} members"

member_list[:members].shuffle.each do |mem|
  member = MemberPage.new(mem[:url]).to_h
  ScraperWiki.save_sqlite([:name], member)
end
