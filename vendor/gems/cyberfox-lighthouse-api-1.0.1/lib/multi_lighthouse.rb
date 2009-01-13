class MultiLighthouse
  def method_missing(meth, *args, &block)
    begin
      const = Lighthouse.const_get(meth)
      Lighthouse.account = @account
      Lighthouse.token = @token
      return const
    rescue NameError => ne
      Lighthouse.send(meth, args, block)
    end
  end

  def initialize(account, token)
    @account = account
    @token = token
  end
end
