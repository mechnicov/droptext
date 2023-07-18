require 'dry/system/container'
require 'dry/transaction/operation'

module Droptext
  class Container < Dry::System::Container
    extend Dry::Container::Mixin

    configure do |config|
      %w[contracts operations].each do |folder|
        config.component_dirs.add Rails.root.join('app', folder)
      end
    end
  end
end

Droptext::Container.finalize! unless Rails.env.test?
Droptext::Import = Dry::AutoInject(Droptext::Container)
