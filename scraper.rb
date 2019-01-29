#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'require_all'
require 'scraperwiki'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

require_rel 'lib'

url = 'https://gov.gg/article/153232/States-Members'
member_list = AllMembersPage.new(response: Scraped::Request.new(url: url).response).members

warn "Found #{member_list.size} members"

data = member_list.map do |mem|
  MemberPage.new(response: Scraped::Request.new(url: mem[:url]).response).to_h
end
data.each { |mem| puts mem.reject { |_, v| v.to_s.empty? }.sort_by { |k, _| k }.to_h } if ENV['MORPH_DEBUG']

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite([:name], data)
