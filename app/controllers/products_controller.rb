class ProductsController < Spree::BaseController
  HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+\/)$/

  #prepend_before_filter :reject_unknown_object, :only => [:show]
  before_filter :load_data, :only => :show

  resource_controller
  helper :taxons
  actions :show, :index

  def get_xml
    @product = Product.find_by_id(params[:id])
    @xml = Builder::XmlMarkup.new
    render :layout => false
  end

  def watch_now
    @product = Product.find_by_id(params[:id])
    check_product
  end

  private

  def check_product
    if current_user.nil?
      redirect_to "/login"
    else
      orders = current_user.orders.find_all_by_state("complete")
      unless orders.empty?
        products = orders.map do |order|
          order.products
        end
        if products.include? [@product]
          return
        end
      end
      redirect_to product_path(@product.name.downcase)
    end
  end

  def load_data
    load_object

    @variants = Variant.active.find_all_by_product_id(@product.id,
                :include => [:option_values, :images])
    @product_properties = ProductProperty.find_all_by_product_id(@product.id,
                          :include => [:property])
    @selected_variant = @variants.detect { |v| v.available? }

    referer = request.env['HTTP_REFERER']

    if referer  && referer.match(HTTP_REFERER_REGEXP)
      @taxon = Taxon.find_by_permalink($1)
    end
  end

  def collection
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
  end

  def accurate_title
    @product ? @product.name : nil
  end
end
