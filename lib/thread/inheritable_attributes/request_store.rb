require "thread/inheritable_attributes/can_be_loaded"

class Thread
  if CanBeLoaded.call("request_store") && defined? ::RequestStore
    request_store_version = Gem::Version.new(::RequestStore::VERSION)
    if request_store_version >= Gem::Version.new("1.0") && request_store_version < Gem::Version.new("2.0")
      RequestStore = ::RequestStore
    else
      raise "RequestStore version: #{::RequestStore::Version} unsupported"
    end
  else
    RequestStore = Thread.current
  end
end
