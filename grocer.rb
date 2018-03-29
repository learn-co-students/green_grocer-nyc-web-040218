def consolidate_cart(cart)
  result = {}
  cart.each do |cart_item|
    cart_item.each do |item_name, item_des|
      if !result.has_key?(item_name)
        result[item_name] = item_des
        result[item_name][:count] = 1
      else
        result[item_name][:count] += 1
      end
    end
  end
  return result
end

def apply_coupons(cart, coupons)
  coupons.each do |coup|
    # exists?
    if cart.has_key?(coup[:item])
      #has enough for one coup?
      if cart[coup[:item]][:count] >= coup[:num]
        new_name = "#{coup[:item]} W/COUPON"
        #if coup already exists
        if !cart.has_key?(new_name)
          cart[new_name] = Hash[:price, coup[:cost],
                                  :clearance, cart[coup[:item]][:clearance], 
                                  :count, 1 ]
        else
          cart[new_name][:count] += 1
        end
        
        cart[coup[:item]][:count] -= coup[:num]
        
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item_name, item_atts|
    if item_atts[:clearance]
      item_atts[:price] = (0.8 * item_atts[:price]).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  result = 0
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  cart3 = apply_clearance(cart2)
  cart3.each do |key, val|
    result += (val[:price] * val[:count])
  end
  if result > 100
    result = (result* 0.9).round(2)
  end
  return result
end
