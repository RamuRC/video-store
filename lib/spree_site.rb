require 'video_store_hooks'

module SpreeSite
  class Engine < Rails::Engine
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_extended*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

    if Spree::Config.instance
      Spree::Config.set(:site_name => 'Video Store')
      Spree::Config.set(:address_requires_state => true)
      Spree::Config.set(:logo => '/images/logo.png')
      Spree::Config.set(:admin_interface_logo => '/images/logo.png')
      Spree::Config.set(:allow_checkout_on_gateway_error => false)
    end

      Order.class_eval do
        # customize the checkout state machine
        Order.state_machines[:state] = StateMachine::Machine.new(Order, :initial => 'cart') do

    event :next do
      transition :from => 'cart', :to => 'address'
      transition :from => 'address', :to => 'payment'
      transition :from => 'payment', :to => 'confirm'
      transition :from => 'confirm', :to => 'complete'
    end
    #TODO - add conditional confirmation step (only when gateway supports it, etc.)

    event :cancel do
      transition :to => 'canceled', :if => :allow_cancel?
    end
    event :return do
      transition :to => 'returned', :from => 'awaiting_return'
    end
    event :resume do
      transition :to => 'resumed', :from => 'canceled', :if => :allow_resume?
    end
    event :authorize_return do
      transition :to => 'awaiting_return'
    end

    before_transition :to => 'complete' do |order|
      begin
        order.process_payments!
      rescue Spree::GatewayError
        if Spree::Config[:allow_checkout_on_gateway_error]
          true
        else
          false
        end
      end
    end

    after_transition :to => 'complete', :do => :finalize!
    after_transition :to => 'delivery', :do => :create_tax_charge!
    after_transition :to => 'canceled', :do => :after_cancel

  end
        end
    end
    config.to_prepare &method(:activate).to_proc
  end
end
