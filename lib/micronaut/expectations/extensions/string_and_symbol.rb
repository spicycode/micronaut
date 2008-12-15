module Micronaut
  module Expectations
    module StringHelpers

      def starts_with?(prefix)
        to_s[0..(prefix.to_s.length - 1)] == prefix.to_s
      end

    end
  end
end

class String
  include Micronaut::Expectations::StringHelpers
end

class Symbol
  include Micronaut::Expectations::StringHelpers
end
