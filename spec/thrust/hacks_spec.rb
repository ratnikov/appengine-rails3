require 'spec_helper'

describe "Thrust hacks" do
  it "should be okay with default certificates directory load failing" do
    manager = Class.new(java.lang.SecurityManager) do
      def checkRead(file)
        raise 'read failed'
      end
    end.new

    with_security_manager(manager) do
      OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE.set_default_paths
    end
  end

  private

  def with_security_manager(manager)
    java_import 'java.lang.System'

    before = System.security_manager

    begin
      System.security_manager = manager

      yield
    ensure
      System.security_manager = before
    end
  end
end
