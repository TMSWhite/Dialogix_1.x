import java.lang.*;
import java.util.*;
import java.io.*;


public class ParseError  {
	Node node;
	Vector dependenciesErrors;
	Vector actionErrors;
	Vector nodeErrors;

	public ParseError(Node node, Vector d, Vector a, Vector n) {
		this.node = node;
		dependenciesErrors = d;
		actionErrors = a;
		nodeErrors = n;
	}

	public String getDependencies() { return node.getDependencies(); }
	public Vector getDependenciesErrors() { return dependenciesErrors; }
	public String getAction() { return node.getAction(); }
	public Vector getActionErrors() { return actionErrors; }
	public Vector getNodeErrors() { return nodeErrors; }
	public Node getNode() { return node; }
}
