import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * Schedule holds a collection of nodes.
 * TODO:
 *	know how to read from URL
 *	implemented as Object Pool
 *	delegate how to read from various file formats (CSV, XML, ...)
*/
public class Schedule implements Serializable {
	private Vector nodes;

	public Schedule() {
		nodes = new Vector();
	}

	public boolean load(File file) {
		if (file == null)
			return false;
		try {
			int count = 0;
			String fileLine;
			BufferedReader br = new BufferedReader(new FileReader(file));
			while ((fileLine = br.readLine()) != null) {
				if (fileLine.startsWith("COMMENT"))
					continue;

				Node node = new Node(count, fileLine);
				++count;
				nodes.addElement(node);
			}
			br.close();
			System.out.println("Read " + count + " nodes from " + file);
			return true;
		}
		catch(IOException e) {
			System.out.println("Error reading " + file);
			return false;
		}
	}

	public boolean load(URL url) {
		if (url == null)
			return false;

		boolean err = false;
		try {
			InputStream is = url.openStream();
			int count = 0;
			String fileLine;
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			while ((fileLine = br.readLine()) != null) {
				if (count == 0 &&
					(fileLine.indexOf("<h1>") != -1) ||
					(fileLine.indexOf("<html>") != -1)) {
					err = true;
					break;
				}
				if (fileLine.startsWith("COMMENT"))
					continue;

				Node node = new Node(count, fileLine);
				++count;
				nodes.addElement(node);
			}
			br.close();
			if (err) {
				System.out.println("Unable to access " + url.toExternalForm());
				return false;
			}
			System.out.println("Read " + count + " nodes from " + url);
			return true;
		}
		catch(IOException e) {
			System.out.println("Error reading " + url.toExternalForm());
			return false;
		}
	}

	public Node getNode(int index) {
		if (index < 0) {
			System.out.println("Node[" + index + "] does't exist");
			return null;
		}
		if (index > size()) {
			System.out.println("Node[" + index + "/" + size() + "] doesn't exist");
			return null;
		}
		return (Node)nodes.elementAt(index);
	}

	public int size() {
		return nodes.size();
	}
}
