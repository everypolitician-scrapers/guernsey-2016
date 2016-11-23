# frozen_string_literal: true
require 'scraped'

class AllMembersPage < Scraped
  field :members do
    member_nodes.drop(1).map do |mem|
      {
        name:    mem.text.tidy,
        url:     mem.xpath('a/@href').text,
      }
    end
  end

  private

  def member_nodes
    noko.xpath("id('subNavigation')/li[4]/ul//li")
  end
end
