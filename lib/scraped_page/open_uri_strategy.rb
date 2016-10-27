class ScrapedPage
  class OpenURIStrategy < Strategy
    def body
      @body ||=
        begin
          body = response.read
          response.rewind
          body
        end
    end

    private

    def response
      @response ||= open(url)
    end
  end
end
