#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'require_all'
require 'scraped'
require 'scraperwiki'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

class AllMembersPage < Scraped::HTML
  field :members do
    member_nodes.drop(1).map do |mem|
      {
        name: mem.css('span').map(&:text).first.sub(/^Deputy/, '').tidy,
        url:  mem.css('a/@href').text,
      }
    end
  end

  private

  def member_nodes
    noko.xpath("id('subNavigation')//li[@id]")
  end
end

class MemberPage < Scraped::HTML
  field :name do
    noko.xpath("id('CenterContainer')/h1").text.tidy
  end

  field :area do
    noko.xpath("id('Breadcrumb')/li[last() - 1]").text.sub('Representatives', '').tidy
  end

  field :party do
    'Independent'
  end

  field :email do
    noko.xpath('//p/a[contains(@href, "mailto:")]/@href').text.gsub('mailto:', '').tidy
  end

  field :website do
    noko.xpath('//div[@id="contactDetails"]//span[.="Website:"]/following-sibling::a/@href').text.tidy
  end

  field :twitter do
    noko.xpath('//div[@id="contactDetails"]//span[@class="icon-tw"]/../@href').text.tidy
  end

  field :facebook do
    noko.xpath('//div[@id="contactDetails"]//span[@class="icon-fb"]/../@href').text.tidy
  end

  field :term do
    2016
  end

  field :source do
    url.to_s
  end
end

def scraper(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

url = 'https://gov.gg/article/153232/States-Members'
data = scraper(url => AllMembersPage).members.map { |mem| scraper(mem[:url] => MemberPage).to_h }
data.each { |mem| puts mem.reject { |_, v| v.to_s.empty? }.sort_by { |k, _| k }.to_h } if ENV['MORPH_DEBUG']

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite([:name], data)
