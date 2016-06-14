require "thread"
require "thread/inheritable_attributes/request_store"

class Thread
  INHERITABLE_ATTRIBUTES_MUTEX = Mutex.new
  alias_method :_initialize, :initialize

  def initialize(*args, &block)
    _inheritable_attributes = inheritable_attributes
    _initialize(*args) do |*block_args|
      RequestStore[:inheritable_attributes] = _inheritable_attributes
      block.call(block_args)
    end
  end

  def get_inheritable_attribute(key)
    INHERITABLE_ATTRIBUTES_MUTEX.synchronize do
      inheritable_attributes[key]
    end
  end

  def set_inheritable_attribute(key, value)
    INHERITABLE_ATTRIBUTES_MUTEX.synchronize do
      inheritable_attributes[key] = value
    end
  end

  protected

  def inheritable_attributes
    RequestStore[:inheritable_attributes] ||= {}
  end
end
