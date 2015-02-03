package com.onelogin.ta;

import android.util.Log;

/**
 * Created by tdebenning on 5/14/14.
 */
public class App {


    public static String TAG = "App";

    private String name;
    private String backScheme;
    private boolean state;

//    public App(String line) throws NullPointerException, MalFormedAppDataException {
//
//
//        if(line != null && line.length() > 0) {
//
//            String[] tokens = line.trim().split(" ");
//            if(tokens.length == 2) {
//
//                this.name = tokens[0];
//                this.backScheme = tokens[1];
//            } else {
//
//                Log.e(TAG, "The raw app data passed in was malformed");
//                throw new MalFormedAppDataException();
//
//            }
//        } else {
//            Log.e(TAG, "The line to be parsed in was null or of zero length");
//
//        }
//
//    }

    public App(String a_name, String backScheme, boolean state) throws NullPointerException {

        if (a_name != null && a_name.length() > 0) {

            if (backScheme != null && backScheme.length() > 0) {

                this.name = a_name;
                this.backScheme = backScheme;
                this.state = state;

            } else {

                Log.e(TAG, "The backScheme was null");
                throw new NullPointerException("That backScheme was null");
            }


        } else {

            Log.e(TAG, "The app name was null");
            throw new NullPointerException("The app name was null");
        }


    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBackScheme() {
        return backScheme;
    }

    public boolean getState() {
        return this.state;
    }

    public void setBackScheme(String backScheme) {
        this.backScheme = backScheme;
    }

    public void setState(boolean state) {
        this.state = state;
    }
}