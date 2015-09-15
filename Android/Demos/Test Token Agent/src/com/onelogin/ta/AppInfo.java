package com.onelogin.ta;

import android.content.Context;

import com.onelogin.mockta.DbHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by tdebenning on 5/13/14.
 */
public class AppInfo {


    private Context ctx = null;
    private static String TAG = "AppInfoDS";
    private ArrayList<App> app_list = null;
    private boolean dirty;
    private DbHelper dbHelper;


    public AppInfo(Context current) {

        if (current != null) {

            this.ctx = current;
            this.dirty = false;

            dbHelper = new DbHelper(this.ctx);
        } else {
            throw new NullPointerException("The Context passed in was null");

        }

    }


    /**
     * Reads and gets
     *
     * @return
     */
    public ArrayList<App> getAppList() {
        this.app_list = dbHelper.getApps();
        return this.app_list;
    }


    /**
     * Adds an app to the App List
     *
     * @param app
     * @return
     */
    public void addApp(App app) throws Exception {
        dbHelper.addApp(app);
    }

    /**
     * Deletes an app from the AppList
     *
     * @param the_app
     */
    public void deleteApp(App the_app) {
        if (the_app != null) {
           dbHelper.removeApp(the_app);
        }
    }


    /**
     * Validates if the app is in the app list
     * <p/>
     * returns true if the app is found in the list
     *
     * @param package_name
     * @return
     */
    public boolean validateApp(String package_name) {

        boolean result = false;

        if (package_name != null && package_name.length() > 0) {

            List<App> all_apps = getAppList();

            for (App current : all_apps) {

                if (current.getName().trim().compareTo(package_name.trim()) == 0) {
                    result = true;
                    break;

                }

            }

        }

        return result;

    }

    /**
     * Finds an app in the app list and returns the found App object;
     *
     * @param app_uri
     * @return
     */
    public App findApp(String app_uri) {
        App result = null;
        if (app_uri != null) {
            result = dbHelper.findApp(app_uri);
        }
        return result;
    }

    /**
     * Generates a list of application names
     *
     * @return
     */
    public List<String> getAppNames() {

        ArrayList<String> appnames = new ArrayList<String>();

        for (App current : app_list) {

            String a_app_name = current.getName();
            appnames.add(a_app_name);

        }

        return appnames;

    }


}