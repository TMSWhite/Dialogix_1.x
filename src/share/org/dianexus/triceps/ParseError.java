package org.dianexus.triceps;

import java.lang.*;
import java.util.*;
import java.io.*;


public final class ParseError implements VersionIF  {
	Node node = null;
	String dependenciesErrors = null;
	String actionErrors = null;
	String answerChoicesErrors = null;
	String readbackErrors = null;
	String nodeParseErrors = null;
	String nodeNamingErrors = null;

	public ParseError(Node node, String dependenciesErrors, String actionErrors, String answerChoicesErrors, String readbackErrors, String nodeParseErrors, String nodeNamingErrors) {
		this.node = node;
		this.dependenciesErrors = dependenciesErrors;
		this.actionErrors = actionErrors;
		this.answerChoicesErrors = answerChoicesErrors;
		this.readbackErrors = readbackErrors;
		this.nodeParseErrors = nodeParseErrors;
		this.nodeNamingErrors = nodeNamingErrors;

	}

	public String getDependenciesErrors() { return dependenciesErrors; }
	public String getQuestionOrEvalErrors() { return actionErrors; }
	public String getAnswerChoicesErrors() { return answerChoicesErrors; }
	public String getReadbackErrors() { return readbackErrors; }
	public String getNodeParseErrors() { return nodeParseErrors; }
	public String getNodeNamingErrors() { return nodeNamingErrors; }

	public Node getNode() { return node; }

	public boolean hasDependenciesErrors() { return (dependenciesErrors != null && dependenciesErrors.length() > 0); }
	public boolean hasQuestionOrEvalErrors() { return (actionErrors != null && actionErrors.length() > 0); }
	public boolean hasAnswerChoicesErrors() { return (answerChoicesErrors != null && answerChoicesErrors.length() > 0); }
	public boolean hasReadbackErrors() { return (readbackErrors != null && readbackErrors.length() > 0); }
	public boolean hasNodeParseErrors() { return (nodeParseErrors != null && nodeParseErrors.length() > 0); }
	public boolean hasNodeNamingErrors() { return (nodeNamingErrors != null && nodeNamingErrors.length() > 0); }

}
