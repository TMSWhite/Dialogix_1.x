package beans.jdbc;

import java.util.Iterator;
import java.util.Vector;

public abstract class ConnectionPool implements Runnable {
   protected final Vector availableConnections = new Vector();
   protected final Vector inUseConnections = new Vector();
   private   final int maxConnections;
   private   final boolean waitIfMaxedOut;

   private ConnectionException error = null; // set by run()

   // Extensions must implement these three methods:
   public abstract Object  createConnection()
                                       throws ConnectionException;
   public abstract boolean isConnectionValid(Object connection);
   public abstract void    disconnect(Object connection);

   public ConnectionPool() {
      this(10,     // by default, a maximum of 10 connections
           false); // don't wait for connection if maxed out
   }
   public ConnectionPool(int max, boolean waitIfMaxedOut) {
      this.maxConnections = max;
      this.waitIfMaxedOut = waitIfMaxedOut;
   }
   public Object getConnection() throws ConnectionException {
      return getConnection(0);
   }
   public synchronized Object getConnection(long timeout) 
                                    throws ConnectionException {
      Object connection = getFirstAvailableConnection();

      if(connection == null) { // no available connections
         if(countConnections() < maxConnections) {
            waitForAvailableConnection();
            return getConnection();
         }
         else { // maximum connection limit reached
            if(waitIfMaxedOut) { 
               try {
                  wait(timeout);
               }
               catch(InterruptedException ex) {}
               return getConnection();
            }
            throw new ConnectionException("Maximum number " +
                  "of connections reached. Try again later.");
         }
      }
      inUseConnections.addElement(connection);
      return connection;
   }
   public synchronized void recycleConnection(Object connection) {
      inUseConnections.removeElement(connection);
      availableConnections.addElement(connection);
      notifyAll(); // notify waiting threads of available con
   }
   public void shutdown() {
      closeConnections(availableConnections);
      closeConnections(inUseConnections);

      availableConnections.clear();
      inUseConnections.clear();
   }
   public synchronized void run() { // can't throw an exception!
      Object connection;
      error = null;
      try {
         connection = createConnection(); // subclasses create
      }
      catch(ConnectionException ex) {
         error = ex;  // store the exception
         notifyAll(); // waiting thread will throw an exception
         return;
      }
      availableConnections.addElement(connection);
      notifyAll(); // notify waiting threads
   }
   private Object getFirstAvailableConnection() {
      Object connection = null;

      if(availableConnections.size() > 0) {
         connection = availableConnections.firstElement();
         availableConnections.removeElementAt(0);
      }
      if(connection != null && !isConnectionValid(connection))
         connection = getFirstAvailableConnection(); // try again

      return connection;
   }
   private void waitForAvailableConnection() 
                                    throws ConnectionException {
      Thread thread = new Thread(this); 
      thread.start(); // thread creates a connection: see run()

      try {
         wait(); // wait for new connection to be created
      }          // or for a connection to be recycled
      catch(InterruptedException ex) { }
               
      if(error != null) // exception caught in run()
         throw error;   // rethrow exception caught in run()
   }
   private void closeConnections(Vector connections) {
      Iterator it = connections.iterator();
      while(it.hasNext())
         disconnect(it.next());
   }
   private int countConnections() {
      return availableConnections.size()+inUseConnections.size();
   }
}
