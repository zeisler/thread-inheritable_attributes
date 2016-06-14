module CanBeLoaded
  def self.call(file)
    loaded = false
    begin
      require file
      loaded = true
    rescue LoadError => e
      raise e unless /^cannot load such file -- #{file}$/ =~ e.message
      false
    end
    loaded
  end
end
