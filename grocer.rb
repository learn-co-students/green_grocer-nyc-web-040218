require 'pry'

def consolidate_cart(cart)
  # code here
  cart.uniq.each_with_object({}) do |item, new_cart|
    name = item.keys.first
    contents = item.values.first
    contents[:count] = cart.count(item)
    new_cart[name] = contents
  end
end

# # clone the input cart
# for each coupon
# if the couponed item exists as a key in the cloned hash, extract it as a string(x) and add "W/ COUPON"(y)
# Turn the extracted string(y) into a key in the cloned hash cart[y] = Hash.new,
# now you have -- "AVOCADO W/ COUPON" => {}
# cart[y].merge!(:price => 0, :clearance => true, :count => 0) (now I have the coupon hash defaults)
# cart[y][:count] = cart[x][:count] % coupon[y][:num]
# cart[y][:price] = (cost/num) * (cart[x][:count] - cart[y][:count])

def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |key, value|
    value.each do |_k2, _v2|
      coupons.each do |coupon|
        x = "#{key} W/COUPON"
        if key == coupon[:item] && cart[key][:count] >= coupon[:num] && !new_cart.include?(x)
          cart[key][:count] -= coupon[:num]
          new_cart[x] = { price: coupon[:cost], clearance: cart[key][:clearance], count: 1 }
        elsif key == coupon[:item] && cart[key][:count] >= coupon[:num] && new_cart.include?(x)
          cart[key][:count] -= coupon[:num]
          new_cart[x][:count] += 1
        end
      end
    end
  end
  cart.merge(new_cart)
end

def apply_clearance(cart)
  cart.each_with_object(cart) do |item|
    clearance = item.last[:clearance]
    price = item.last[:price]
    item.last[:price] = price - (price * 0.20) if clearance
  end
  end

  def checkout(cart, coupons)
    consolidated = consolidate_cart(cart)
    coupons_applied = apply_coupons(consolidated, coupons)
    clearance_applied = apply_clearance(coupons_applied)
    total = 0
    clearance_applied.each do | k, v |
      sum = v[:price] * v[:count]
      total += sum
    end
    if total > 100
      total = total - (total * 0.10)
    end
    total
  end
