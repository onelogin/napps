package com.onelogin.mockta;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;


import com.onelogin.ta.App;
import com.onelogin.ta.AppInfo;

/**
 * Created by tdebenning on 5/14/14.
 * <p/>
 * <p/>
 * This activity presents the user the ability to add
 * a new application to the mock token agents appinfo list.
 */
public class AddApp extends Activity {


    private static String TAG = "AddApp";


    EditText appname = null;
    EditText backscheme = null;
    Button save_button = null;
    Button cancel_button = null;
    SDKTest app = null;

    AppInfo apps;


    /**
     * Your general construction and set up of the UI for the application.
     *
     * @param savedInstanceState
     */
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_app);

        app = (SDKTest) this.getApplication();

        apps = app.getAppInfo();

        appname = (EditText) findViewById(R.id.appname);
        backscheme = (EditText) findViewById(R.id.back);

        save_button = (Button) findViewById(R.id.btnSAve);
        cancel_button = (Button) findViewById(R.id.btnCancel);

        save_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                handleSave();
            }
        });


        cancel_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                handleCancel();
            }
        });

    }


    /**
     * Executed when the user clicks on the save button
     * Adds the new
     */
    private void handleSave() {

        String app_name = appname.getText().toString();
        String back = backscheme.getText().toString();

        if (app_name != null && app_name.length() > 0) {

            if (back != null && back.length() > 0) {
                App the_app = new App(app_name, back, false);
                SDKTest app = (SDKTest) getApplication();
                AppInfo apps = app.getAppInfo();
                if (apps != null) {
                    try {
                        apps.addApp(the_app);
                        goBackToAppListActivity();
                    } catch (Exception e) {
                        e.printStackTrace();
                        Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_SHORT).show();
                    }
                    //apps.writeList();


                } else {
                    Toast.makeText(getApplicationContext(), "Unknown error unable to save", Toast.LENGTH_SHORT).show();
                }
            } else {
                Toast.makeText(getApplicationContext(), "Enter the URI.", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(getApplicationContext(), "Enter the name.", Toast.LENGTH_SHORT).show();
        }


    }

    /**
     * Handles the click event when the user clicks on the
     * Cancel Button
     */
    private void handleCancel() {
        goBackToAppListActivity();
    }


    /**
     * Goes back to the App List Activity
     */
    private void goBackToAppListActivity() {
        // Intent back_to_app_list = new Intent(this, AddApp.class);
        // this.startActivity(back_to_app_list);
        finish();
    }
}