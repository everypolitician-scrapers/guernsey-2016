class ArchivedResponse
  def initialize(response)
    @response = response
  end

  def store
    warn "Storing #{response.base_uri}"
  end

  private

  attr_reader :response
end
