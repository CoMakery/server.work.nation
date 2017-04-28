module Decentral
  def self.handle_error(error, params = {})
    Rails.logger.error 'in Decentral handle_error'.bold

    params.reverse_merge! level: 'info'
    Rails.logger.error error.message.to_s.red
    # Airbrake.notify error, params
    Raven.capture_exception error, params
  end

  class DecentralError < StandardError
  end

  # DecentralError:

  class NotFound < DecentralError
  end

  class InvalidFormat < DecentralError
  end

  class ReputonError < DecentralError
  end

  # ReputonError:

  class ReputonInvalid < ReputonError
  end

  class ReputonSignatureInvalid < ReputonError
  end
end

require_relative 'decentral/log'
require_relative 'decentral/uport'
require_relative 'decentral/claim'
