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

RSpec::Matchers.define :have_format do |format|
  validator = Fog::Schema::DataValidator.new

  match do |data|
    options = { :allow_extra_keys => false, :allow_optional_rules => true }
    validator.validate(data, format, options)
  end

  # Optional failure messages
  failure_message do |actual|
    "expected #{actual.inspect} to have format #{format.inspect}"
  end

  # Optional method description
  description do
    "checks data gainst given format"
  end
end
