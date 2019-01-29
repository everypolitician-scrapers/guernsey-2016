#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'require_all'
require 'scraperwiki'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

require_rel 'lib'

def scraper(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

url = 'https://gov.gg/article/153232/States-Members'
data = scraper(url => AllMembersPage).members.map { |mem| scraper(mem[:url] => MemberPage).to_h }
data.each { |mem| puts mem.reject { |_, v| v.to_s.empty? }.sort_by { |k, _| k }.to_h } if ENV['MORPH_DEBUG']

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite([:name], data)
