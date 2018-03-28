require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each_with_index do |item, index|
    cart[index][item.keys[0]][:count] = cart.count(item)
    new_hash[item.keys[0]] = item[item.keys[0]]
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |item, item_properties|
    coupons.each do |discounted_item|
      if discounted_item[:item].to_s == item
        new_cart[item +" W/COUPON"] =
        {price: discounted_item[:cost],
          clearance: item_properties[:clearance],
          count: item_properties[:count] / discounted_item[:num]}
        if item_properties[:count] >= discounted_item[:num]
          new_cart[item] = {price: item_properties[:price],
             clearence: item_properties[:clearance],
             count: item_properties[:count] - (discounted_item[:num]*(item_properties[:count] / discounted_item[:num]))}
        end
      end
    end
  end
  cart.each do |item, item_properties|
    if !new_cart.include?(item)
      new_cart[item] = cart[item]
    end
  end
  # if new_cart.size == 0
  #   new_cart = cart
  # end
  new_cart
end

def apply_clearance(cart)
  new_cart = cart
  cart.each do |item, item_properties|
    if item_properties[:clearance] == true
      new_cart[item][:price] = ((item_properties[:price] * 0.80).round(2))
    end
  end
  new_cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0.0
  cart.each do |key, value|
    total += value[:price].to_f * value[:count].to_f
  end
  if total > 100
    total = total * 0.90
  end
  total
end
