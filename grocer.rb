require "pry"
def consolidate_cart(cart)
  output = {}
  count = Hash.new 0

  cart.each do |item_hash|
    item_hash.each do |item, attributes|
      count[item] += 1
      attributes.each do |key, value|
        if output[item] == nil
          output[item] = {}
        end
        output[item][key] = value
        output[item][:count] = count[item]
      end
    end
  end
  return output
end

def apply_coupons(cart, coupons)
  output = {}
  if coupons == []
    return cart
  end

  cart.each do |item, attributes|
    times = 0
    if output[item] == nil
      output[item] = {}
      output[item] = attributes
    end
    coupons.each do |item_hash|
      if (item_hash[:item] == item && attributes[:count] >= item_hash[:num])
        times += 1
        count = attributes[:count] - item_hash[:num]
        output[item][:count] = count
        output["#{item} W/COUPON"] = {:price => item_hash[:cost], :clearance => attributes[:clearance], :count => times}
      end
    end
  end
  return output
end

def apply_clearance(cart)
  output = {}

  cart.each do |item, attributes|
    if output[item] == nil
      output[item] = {}
      output[item] = attributes
    end

    if attributes[:clearance] == true
      output[item][:price] = (attributes[:price] * 0.8).round(2)
    end
  end
  return output
end

def checkout(cart, coupons)
  total = 0.0
  final_cart = consolidate_cart(cart)
  final_cart = apply_coupons(final_cart, coupons)
  final_cart = apply_clearance(final_cart)

  final_cart.each do |item, attributes|
    total += final_cart[item][:price] * final_cart[item][:count]
  end

  if total > 100
    total = (total * 0.9).round(2)
  end
  return total
end
