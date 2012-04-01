class Cart
  attr_accessor :cart_items, :total_price, :total_quantity
    
  def initialize
    @cart_items = Array.new
    @total_price = 0
    @total_quantity = 0
  end
  
  def add_dish(name, price, id)
    current_item = find_by_name(name)
    if current_item
      current_item.quantity += 1
    else
      current_item = @cart_items << CartItem.new({ :name => name, :price => price, :quantity => 1, :dish_id => id })
    end
    @total_quantity += 1
    @total_price += price
  end
  
  def remove_dish(name)
    current_item = find_by_name(name)
    if current_item
      @total_quantity -= 1
      @total_price -= current_item.price
      if current_item.quantity > 1
        current_item.quantity -= 1
      else
        @cart_items.delete_at(@cart_items.index{|x|x.name == name})
      end
    end
  end
  
  private 
    def find_by_name(name)
      a = @cart_items.index{|x|x.name == name}
      a.nil? ?   nil : @cart_items[a]
    end
end