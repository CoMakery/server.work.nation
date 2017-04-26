module Decentral
  class DecentralError < StandardError
  end

  class NotFound < DecentralError
  end

  class ReputonError < DecentralError
  end

  class ReputonInvalid < ReputonError
  end

  class ReputonSignatureInvalid < ReputonError
  end
end
