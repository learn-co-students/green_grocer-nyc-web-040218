require 'pry'

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do | item |
    item.each do | item_name, item_hash |
      if !cart_hash.include?(item_name)
        cart_hash[item_name] = item_hash.merge :count => 1
      elsif cart_hash.include?(item_name)
        cart_hash[item_name][:count] += 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  coupon_item_hash = {}
  cart.each do | item_name, info_hash |
    info_hash.each do | label, value |
      coupons.each do | coupon |
        coupon_item_key = "#{item_name} W/COUPON"
        if item_name == coupon[:item] && cart[item_name][:count] >= coupon[:num] && !coupon_item_hash.include?(coupon_item_key)
          cart[item_name][:count] -= coupon[:num]
          coupon_item_hash[coupon_item_key] = {:price => coupon[:cost], :clearance => cart[item_name][:clearance], :count => 1}
        elsif item_name == coupon[:item] && cart[item_name][:count] >= coupon[:num] && coupon_item_hash.include?(coupon_item_key)
          cart[item_name][:count] -= coupon[:num]
          coupon_item_hash[coupon_item_key][:count] += 1
        end
      end
    end
  end
  return cart.merge(coupon_item_hash)
end

def apply_clearance(cart)
  cart.each do | item_name, info_hash |
    if info_hash[:clearance] == true 
      info_hash[:price] = (info_hash[:price] * 0.8).round(2)
    end 
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  applied_coupons_cart = apply_coupons(consolidated_cart, coupons)
  applied_clearance_cart = apply_clearance(applied_coupons_cart)
  total = 0
  applied_clearance_cart.each do | item_name, info_hash |
    item_total = info_hash[:price] * info_hash[:count]
    total += item_total
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end

