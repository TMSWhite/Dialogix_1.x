package beans.app;

// This is an item in an inventory or shopping cart (same thing)
// with four properties: sku, (stock keeping unit) name, price, 
// and amount. Items are nearly immutable to eliminate 
// multithreading concerns.

public class Item implements java.io.Serializable { 
   private final int sku; // stock keeping unit
   private final float price;
   private final String name; 

   private float amount;

   public Item(int sku, String name, float price, float amount) {
      this.sku    = sku;
      this.name   = name;
      this.amount = amount;
      this.price  = price;
   }
   public int    getSku()    { return sku;    }
   public String getName()   { return name;   }
   public float  getPrice()  { return price;  }

   public synchronized float getAmount() { 
      return amount; 
   }
   public synchronized void setAmount(float amount) {
      this.amount = amount;   
   }
}
