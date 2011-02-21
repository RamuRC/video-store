module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /login page/
      '/login'
    when /admin page/
      admin_path
    when /admin products page/
      admin_products_path
    when /^"(.*)" product page/
      "/products/#{$1.downcase}"
    when /shopping cart page/
      '/cart'
    when /checkout page/
      '/checkout'
    when /checkout payment page/
      '/checkout/payment'
    when /checkout confirm page/
      '/checkout/confirm'
    when /watch now "(.*)"/
      watch_now_product_path(Product.find_by_name($1).id)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
