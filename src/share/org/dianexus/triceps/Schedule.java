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
		BufferedReader br = null;
		if (file == null)
			return false;

		String filename = file.toString();
		try {
			int line = 1;
			int count=0;
			String fileLine;
			br = new BufferedReader(new FileReader(file));
			while ((fileLine = br.readLine()) != null) {
				++line;
				if (fileLine.startsWith("COMMENT"))
					continue;

				Node node = new Node(line, filename, fileLine);
				++count;
				nodes.addElement(node);
			}
			System.out.println("Read " + count + " nodes from " + filename);
			return true;
		}
		catch(IOException e) {
			System.out.println("Error reading " + filename);
			return false;
		}
		finally {
			if (br != null) {
				try { br.close(); } catch (Exception e) {}
			}
		}
	}

	public boolean load(URL url) {
		BufferedReader br = null;
		InputStream is = null;

		if (url == null)
			return false;

		boolean err = false;
		String 	filename = url.toExternalForm();

		try {
			is = url.openStream();
			int count = 0;
			int line = 1;
			String fileLine;
			br = new BufferedReader(new InputStreamReader(is));
			while ((fileLine = br.readLine()) != null) {
				if (count == 0 &&
					(fileLine.indexOf("<h1>") != -1) ||
					(fileLine.indexOf("<html>") != -1)) {
					err = true;
					break;
				}
				++line;
				if (fileLine.startsWith("COMMENT"))
					continue;

				Node node = new Node(line, filename, fileLine);
				++count;
				nodes.addElement(node);
			}
			if (err) {
				System.out.println("Unable to access " + filename);
				return false;
			}
			System.out.println("Read " + count + " nodes from " + url);
			return true;
		}
		catch(IOException e) {
			System.out.println("Error reading " + filename);
			return false;
		}
		finally {
			if (br != null) {
				try { br.close(); } catch (Exception e) {}
			}
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
