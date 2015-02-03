package com.onelogin.mockta;

import android.app.Application;
import android.util.Log;

import com.onelogin.ta.App;
import com.onelogin.ta.AppInfo;

/**
 * Created by tdebenning on 5/14/14.
 * <p/>
 * The application object for the Mock Token Agent
 */
public class SDKTest extends Application {


    private static String TAG = "SDKTest";

    private boolean deny_mode = false;
    private AppInfo appInfo;

    public boolean isDeny_mode() {
        return deny_mode;
    }

    public void setDeny_mode(boolean deny_mode) {
        this.deny_mode = deny_mode;
    }


    public AppInfo getAppInfo() {
        return appInfo;
    }

    public void onCreate() {
        super.onCreate();

        Log.d(TAG, "onCreate for the application");
        appInfo = new AppInfo(this.getBaseContext());

    }


    /**
     * Validates a calling application against the known approved applications.
     *
     * @param package_name
     * @return
     */
    public boolean validCallingApp(String package_name) {

        boolean result = false;

        if (!isDeny_mode()) {


            result = this.appInfo.validateApp(package_name);


        }

        return result;

    }


    /**
     * Finds and app by name from the list of apps known to tha application
     *
     * @param name
     * @return
     */
    public App findApp(String name) {

        App result = null;

        if (name != null) {

            result = this.appInfo.findApp(name);
        }

        return result;


    }
}
