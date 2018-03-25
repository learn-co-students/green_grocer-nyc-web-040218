def consolidate_cart(individual_items)
  consolidated_cart = {}

  individual_items.each do |item_hash|
    key = item_hash.keys.join(",")

    if consolidated_cart[key] == nil
      item_hash[key][:count] = 1
      consolidated_cart[key] = item_hash[key]
    else
      consolidated_cart[key][:count] += 1
    end
  end

  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    cart.each do |item, item_data_hash|
      if coupon_hash[:item] == item
        item_data_hash[:count] -= coupon_hash[:num]
        coupon_hash[:is_applied] = true
        coupon_hash[:clearance] = item_data_hash[:clearance]
      end
    end
  end

  add_coupons_to_cart(cart, coupons)
end

def add_coupons_to_cart(cart, coupons)
  coupons.each do |coupon_hash|
    if coupon_hash[:is_applied] && cart[coupon_hash[:item] + " W/COUPON"] == nil
      cart[coupon_hash[:item] + " W/COUPON"] = {
        :price => coupon_hash[:cost],
        :clearance => coupon_hash[:clearance],
        :count => 1
      }
    elsif cart[coupon_hash[:item]] != nil
      cart[coupon_hash[:item] + " W/COUPON"][:count] += 1
    end
  end

  cart
end

def apply_clearance(cart)
  cart.each do |item_name, item_data_hash|
    if item_data_hash[:clearance]
      item_data_hash[:price] = item_data_hash[:price] - item_data_hash[:price] * 0.2
    end
  end

  cart
end

def checkout(cart, coupons)
  total = 0

  consolidated_cart = consolidate_cart(cart)
  puts consolidated_cart
  cart = apply_clearance(apply_coupons(consolidated_cart, coupons))
  puts cart

  cart.each do |item, item_data_hash|
    quantity = item_data_hash[:count]
    if quantity > 0
      total += item_data_hash[:price] * quantity
    end
  end

  total > 100 ? total -= total * 0.1 : total
end
