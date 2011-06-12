module Thrust::Datastore::AttributeMethods
  attr_reader :attributes

  def initialize(attributes = nil)
    @attributes = {}

    attributes.each { |(k, v)| write_attribute k, v } unless attributes.nil?
  end

  def attribute?(attr)
    @attributes.has_key? attr.to_sym
  end

  def read_attribute(attr)
    @attributes[attr.to_sym]
  end

  def write_attribute(attr, value)
    @attributes[attr.to_sym] = value
  end

  private

  def method_missing(name, *args)
    if name.to_s =~ /^(.+)(=)?$/ && attribute?($1)
      $2.nil? ? read_attribute($1) : write_attribute($1, args.first)
    else
      super
    end
  end
end
