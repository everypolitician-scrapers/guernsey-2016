# frozen_string_literal: true
require 'scraped'

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
