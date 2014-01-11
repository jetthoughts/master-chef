
# Warning there are some magic here to get knife config without even requiring a bit of chef

class Object

  @@_knife = {}

  def method_missing(meth, *args, &block)
    knife[meth.to_sym] = args[0]
  end

  def knife
    @@_knife
  end
end

