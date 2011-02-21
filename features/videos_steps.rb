Given /^the product video$/ do |table|
  table.hashes.each do |video|
    Product.create! :name => video['name'], :url => video['url'], :master_price => video['price'], :available_on => "2011-02-06 00:00:00"
  end
end
