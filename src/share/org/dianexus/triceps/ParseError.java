import java.lang.*;
import java.util.*;
import java.io.*;


public class ParseError  {
	Node node;
	String dependenciesErrors;
	String actionErrors;
	Vector nodeErrors;

	public ParseError(Node node, String d, String a, Vector n) {
		this.node = node;
		dependenciesErrors = d;
		actionErrors = a;
		nodeErrors = n;
	}

	public String getDependencies() { return node.getDependencies(); }
	public String getDependenciesErrors() { return dependenciesErrors; }
	public String getQuestionOrEval() { return node.getQuestionOrEval(); }
	public String getQuestionOrEvalErrors() { return actionErrors; }
	public Vector getNodeErrors() { return nodeErrors; }
	public Node getNode() { return node; }
}
