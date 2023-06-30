require 'dry/system/container'

module Droptext
  class Container < Dry::System::Container
    extend Dry::Container::Mixin

    configure do |config|
      config.component_dirs.add Rails.root.join('app', 'operations')
    end
  end
end

Droptext::Container.finalize!