ProductsController.class_eval do
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
end
