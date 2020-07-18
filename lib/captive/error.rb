# frozen_string_literal: true

module Captive
  # Base error class.
  class CaptiveError < StandardError
  end

  # Error denoting a malformed string during subtitle parsing.
  class MalformedString < CaptiveError
  end

  # Error denoting a malformed subtitle input format.
  class InvalidSubtitle < CaptiveError
  end

  # Error denoting incorrect input to a method.
  class InvalidInput < CaptiveError
  end

  class InvalidJsonInput < CaptiveError
  end
end
