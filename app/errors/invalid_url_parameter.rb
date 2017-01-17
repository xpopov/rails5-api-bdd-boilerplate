class InvalidURLParameter < StandardError

  def http_status
      :unprocessable_entity
  end

  def code
      'invalid_parameter'
  end

  def message
      "URL is invalid"
  end

  def to_hash
      {
      message: message,
      code: code
      }
  end
end
