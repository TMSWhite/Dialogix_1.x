package org.dianexus.triceps;

import java.lang.String;

/*public*/ interface VersionIF {
    /*public*/ final static boolean DEBUG = true;
    /*public*/ final static boolean AUTHORABLE = true;
    /*public*/ final static boolean DEPLOYABLE = true;
    /*public*/ final static boolean DEMOABLE = (!AUTHORABLE && !DEPLOYABLE);
    /*public*/ final static boolean DEVELOPERABLE = (AUTHORABLE && DEPLOYABLE);
    /*public*/ final static String VERSION_MAJOR = "2.6";
    /*public*/ final static String VERSION_MINOR = "0";
    /*public*/ final static String VERSION_TYPE = ((DEVELOPERABLE) ? "Development System" : ((AUTHORABLE) ? "Authoring System" : ((DEPLOYABLE) ? "Interviewing System" : "Demo")));
    /*public*/ final static String VERSION_NAME = "Triceps " + VERSION_TYPE + " version " + VERSION_MAJOR + "." + VERSION_MINOR;
}
