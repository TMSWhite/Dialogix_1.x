package beans.app;

import java.util.Iterator;
import java.util.Vector;

public class Inventory implements java.io.Serializable { 
   final protected Vector items;

   public Inventory() { 
      items = new Vector();
   }
   public void addItem(Item item) {
      items.add(item);
   }
   public void removeItem(Item item) {
      items.remove(item);
   }
   public Vector getItems() {
      return items;   
   }
}
