class Interaction
  def initialize(url)
    @url = url
  end

  def noko
    @noko ||= Nokogiri::HTML(response_body)
  end

  private

  attr_reader :url

  def response
    @response ||= open(url)
  end

  def response_body
    @response_body ||=
      begin
        body = response.read
        response.rewind
        body
      end
  end
end
