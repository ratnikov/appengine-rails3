require 'jopenssl'

class OpenSSL::X509::Store
  def set_default_paths
    super
  rescue
    # it's okay if default path setting fails for whatever reason
    nil
  end
end

