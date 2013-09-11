module ClassStubbing
  def stub_class(superclass, const=nil, &block)
    Class.new(superclass).tap do |klass|
      klass.class_eval(&block)
      if const
        if superclass.const_defined?(const)
          superclass.send(:remove_const, const)
        end
        superclass.const_set(const, klass)
      end
    end
  end
end
