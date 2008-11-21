require 'mocha/standalone'
require 'mocha/object'

module Micronaut
  module Mocking
    module WithMocha
      include Mocha::Standalone
    
      def setup_mocks
        mocha_setup
      end
    
      def verify_mocks
        mocha_verify
      end
    
      def teardown_mocks
        mocha_teardown
      end
      
    end
  end
end