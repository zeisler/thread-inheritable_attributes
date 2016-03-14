require "thread"

class Thread
  INHERITABLE_ATTRIBUTES_MUTEX = Mutex.new
  alias_method :_initialize, :initialize

  def initialize(*args, &block)
    inheritable_attributes = Thread.current.inheritable_attributes
    _initialize(*args) do |*block_args|
      Thread.current[:inheritable_attributes] = inheritable_attributes
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
    self[:inheritable_attributes] ||= {}
  end

end
