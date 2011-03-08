ProductsController.class_eval do
  before_filter :already_bought, :only => :show

  def get_xml
    @product = Product.find_by_id(params[:id])
    @xml = Builder::XmlMarkup.new
    render :layout => false
  end

  def watch_now
    @product = Product.find_by_id(params[:id])
    check_product
  end

  def already_bought
    if current_user.nil?
      redirect_to "/login"
    else
      orders = current_user.orders.find_all_by_state("complete")
      unless orders.empty?
        products = orders.map do |order|
          order.products
        end
        if products.include? [@product]
          render :watch_now
        end
      end
    end
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

Admin::ProductsController.class_eval do
  before_filter :upload_video, :only => :create

  def upload_video
    product = params[:product]
    if product[:url].empty?
      directory = "/home/bruna/projects/crtmpserver/builders/cmake/applications/flvplayback/mediaFolder"
      video_file_name = product[:video_file].split("/").last.split(".").first
      product[:url] = "rtmp://localhost/flvplayback/#{video_file_name}"
      path = File.join(directory, "#{video_file_name}.flv")
      File.open(path, 'wb') { |f| f.write(File.open(product[:video_file],'r').read)}
    end
  end
end
