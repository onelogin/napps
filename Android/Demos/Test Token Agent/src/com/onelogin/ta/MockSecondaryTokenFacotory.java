package com.onelogin.ta;

import android.util.Log;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by tdebenning on 5/19/14.
 */
public class MockSecondaryTokenFacotory {



    private static String TAG = "MockSecondaryTokenFacotory";


    /**
     *
     * This function generates a mock secondary token pass back to the invoking application.
     *
     *
     * @return
     */
    public static  JSONObject genMockSecondaryToken() {


        JSONObject result = new JSONObject();

        try {
            result.put("token", "This is a mock token not to be used");
        } catch (JSONException je) {
            Log.e(TAG, "There was a json exception when attempting to construct the mock secondary token");

        }

        return result;


    }
}
