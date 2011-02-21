require 'spree_core'
require 'video_hooks'

module Video
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Spree::Config.set(:address_requires_state => false)

      Order.class_eval do
        # customize the checkout state machine
        Order.state_machines[:state] = StateMachine::Machine.new(Order, :initial => 'cart') do
          after_transition :to => 'complete', :do => :finalize!
        
          event :next do
            transition :from => 'cart', :to => 'address'
            transition :from => 'address', :to => 'payment'
            transition :from => 'payment', :to => 'confirm'
            transition :from => 'confirm', :to => 'complete'
          end
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end

# User.first.orders.first.line_items.first.product
