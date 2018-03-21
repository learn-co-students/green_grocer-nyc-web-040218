def consolidate_cart(cart)
  new_cart = {}
  duplcate_array = []
  cart.each do |array|
    array.each do |product, info|
      new_cart[product] = {}
      duplcate_array << product
      info.each do |detail, value|
        new_cart[product][detail] = value
      end
      new_cart[product][:count] = duplcate_array.count(product)
    end
  end
  return new_cart
end

def apply_coupons(cart, coupons)
  add_more = false
  slip_array = []

  coupons.each do |c_hash|
    cart.each do |food, details|
      if c_hash[:item] == food
        add_more = true

        if details[:count] - c_hash[:num] < 0
          slip_array << ["#{food} W/COUPON" => {:price => c_hash[:cost], :clearance => details[:clearance], :count => 1, :applied => 1}]
        else
          slip_array << ["#{food} W/COUPON" => {:price => c_hash[:cost], :clearance => details[:clearance], :count => 1, :applied => 1 }]
          puts "we deviding: #{(details[:count] / c_hash[:num]).floor}"
          details[:count] = details[:count] - c_hash[:num]
        end

      end
    end
  end

  if add_more
    hash_count = []
    slip_array.each do |array|
      array.each do |array2|
        array2.each do |key, value|
          hash_count << key.to_s
        end
      end
    end

    slip_array.each do |array|
      array.each do |array2|
        array2.each do |key, value|
          if hash_count.count(key.to_s) > 1
            value[:count] = hash_count.count(key.to_s)
          end
        end
        cart.merge!(array2)
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |product, info|
    if info[:clearance] == true
      info[:price] = info[:price]-(info[:price] * 0.2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  puts "Incoming: Cart #{cart}. Coupons #{coupons}"
  new_cart = consolidate_cart(cart)
  puts "New Cart 1: #{new_cart}"
  new_cart = apply_coupons(new_cart, coupons)
  puts "New Cart 2: #{new_cart}"
  new_cart = apply_clearance(new_cart)
  puts "New Cart3: #{new_cart}"

  total = 0
  new_cart.each do |item, item_info|
    if item.to_s.include?("W/COUPON")
      total = total + (item_info[:price] * item_info[:applied])
    else
      total = total + (item_info[:price] * item_info[:count])
    end
  end

  puts "My Total: #{total}"

  if total > 100
    total = total - (total * 0.1)
    return total
  else
    return total
  end
end
