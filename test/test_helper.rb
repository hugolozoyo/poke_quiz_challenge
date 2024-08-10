# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'minitest/autorun'
require 'mocha/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def assert_model_validations_error(model, attributes:, error:)
      attributes = [attributes] unless attributes.is_a? Array

      attributes.each do |attribute|
        assert_model_validation_error model, attribute: attribute, error: error
      end
    end

    def assert_model_validation_error(model, attribute:, error:)
      assert_includes model.errors.attribute_names, attribute
      assert_equal error, model.errors.details[attribute].first[:error]
    end
  end
end
