# frozen_string_literal: true

require_rel 'page'

class MemberPage < Page
  field :name do
    noko.xpath("id('CenterContainer')/h1").text.tidy
  end

  field :area do
    noko.xpath("id('Breadcrumb')/li[last() - 1]")
        .text
        .sub('Representatives', '')
        .tidy
  end

  field :party do
    "Independent"
  end

  field :address do
    noko.xpath('//p//span[.="Address:"]/following-sibling::text()')
        .map(&:text)
        .map(&:tidy)
        .join(', ')
  end

  field :email do
    noko.xpath('//p/a[contains(@href, "mailto:")]/@href').text
                                                         .gsub('mailto:','')
                                                         .tidy
  end

  field :website do
    noko.xpath('//div[@id="contactDetails"]//span[.="Website:"]/following-sibling::a/@href')
        .text
        .tidy
  end

  field :twitter do
    noko.xpath('//div[@id="contactDetails"]//span[@class="icon-tw"]/../@href')
        .text
        .tidy
  end

  field :facebook do
    noko.xpath('//div[@id="contactDetails"]//span[@class="icon-fb"]/../@href')
        .text
        .tidy
  end

  field :phone do
    noko.xpath('//div[@id="contactDetails"]//span[.="Telephone:"]/following-sibling::text()')
        .text
        .tidy
  end

  field :mobile do
    noko.xpath('//div[@id="contactDetails"]//span[.="Mobile:"]/following-sibling::text()')
        .text
        .tidy
  end

  field :term do
    2016
  end

  field :source do
    url.to_s
  end
end
