class BaseTransaction
  include Dry::Transaction(container: Droptext::Container)

  def self.call(*args, &block)
    new.call(*args, &block)
  end
end
