require "fog/schema/data_validator"

module Fog
  module Boolean; end
  module Nullable
    module Boolean; end
    module Integer; end
    module String; end
    module Time; end
    module Float; end
    module Hash; end
    module Array; end
  end
end
[FalseClass, TrueClass].each { |klass| klass.send(:include, Fog::Boolean) }
[FalseClass, TrueClass, NilClass, Fog::Boolean].each { |klass| klass.send(:include, Fog::Nullable::Boolean) }
[NilClass, String].each { |klass| klass.send(:include, Fog::Nullable::String) }
[NilClass, Time].each { |klass| klass.send(:include, Fog::Nullable::Time) }
[Integer, NilClass].each { |klass| klass.send(:include, Fog::Nullable::Integer) }
[Float, NilClass].each { |klass| klass.send(:include, Fog::Nullable::Float) }
[Hash, NilClass].each { |klass| klass.send(:include, Fog::Nullable::Hash) }
[Array, NilClass].each { |klass| klass.send(:include, Fog::Nullable::Array) }

# Copied from fog-core and modified to provide more
# detailed errors messages
class DataValidator
  attr_reader :errors

  def initialize
    @errors = []
  end

  def validate(data, schema, options = {})
    validate_value(schema, data, options)
  end

  private

  def validate_value(validator, value, options)
    case validator
    when Array
      return false if value.is_a?(Hash)
      value.respond_to?(:all?) && value.all? { |x| validate_value(validator[0], x, options) }
    when Symbol
      value.respond_to? validator
    when Hash
      if value.is_a?(Array)
        add_error("expected '#{value}' to be Hash")
        return false
      end

      # When being strict values not specified in the schema are fails
      # Validator is empty but values are not
      return false if !options[:allow_extra_keys] &&
                      value.respond_to?(:empty?) &&
                      !value.empty? &&
                      validator.empty?

      # Validator has rules left but no more values
      return false if !options[:allow_optional_rules] &&
                      value.respond_to?(:empty?) &&
                      value.empty? &&
                      !validator.empty?

      validator.all? do |key, sub_validator|
        result = validate_value(sub_validator, value[key], options)
        unless result
          add_error("'#{key}' has wrong format: expected #{sub_validator}, got #{value[key].inspect}")
        end
        result
      end
    else
      result = validator == value
      result = validator === value unless result
      # Repeat unless we have a Boolean already
      unless result.is_a?(TrueClass) || result.is_a?(FalseClass)
        result = validate_value(result, value, options)
      end
      result
    end
  end

  private

  def add_error(error)
    errors << error
  end
end

RSpec::Matchers.define :have_format do |format|
  validator = DataValidator.new

  match do |data|
    options = { :allow_extra_keys => false, :allow_optional_rules => true }
    validator.validate(data, format, options)
  end

  # Optional failure messages
  failure_message do |actual|
    message = <<-ERROR
expected
#{prettyfy(actual)}
to have format
#{prettyfy(format)}
    ERROR

    if validator.errors.any?
      message += "\nErrors:\n" + validator.errors.join("\n")
    end
  end

  # Optional method description
  description do
    "checks data gainst given format"
  end

  def prettyfy(hash)
    longest_key_length = hash.inject(0) do |memo, (key, value)|
      memo = key.length if key.length > memo
      memo
    end

    sorted_hash = hash.sort { |(keyA, valA), (keyB, valB)| keyA <=> keyB }

    "{\n" +
    sorted_hash.map do |key, value|
      key_with_padding = sprintf("%-#{longest_key_length}s", key)
      "\t#{key_with_padding} => #{value.inspect}"
    end.join(",\n") +
    "\n}"
  end
end
