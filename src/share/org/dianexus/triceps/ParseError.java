import java.lang.*;
import java.util.*;
import java.io.*;


public class ParseError  {
	Node node;
	Vector dependenciesErrors;
	Vector actionErrors;

	public ParseError(Node n, Vector d, Vector a) {
		node = n;
		dependenciesErrors = d;
		actionErrors = a;
	}

	public String getDependencies() { return node.getDependencies(); }
	public Vector getDependenciesErrors() { return dependenciesErrors; }
	public String getAction() { return node.getAction(); }
	public Vector getActionErrors() { return actionErrors; }
	public Node getNode() { return node; }
}
