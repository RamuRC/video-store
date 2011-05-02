module VideoHelper
  def video_already_bought?(video)
    unless current_user.nil?
      orders = current_user.orders.find_all_by_state("complete")
      unless orders.empty?
        videos = orders.map do |order|
          order.products
        end
        if (videos.include? [video]) || (videos.first.include? video)
          return true
        end
      end
    end
    false
  end

  def already_on_cart?(video)
    if current_order
      if current_order.products.include? video
        return true
      end
      false
    end
  end
end
