package com.onelogin.mockta;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.onelogin.ta.App;
import com.onelogin.ta.AppInfo;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

/**
 * Created by tdebenning on 5/13/14.
 * <p/>
 * This is the initial start up activity for the application.
 */
public class Setup extends Activity {
    private static String TAG = "Setup";
    //private Switch denybutton;
    private ListView appListView;
    private SDKTest app;
    private AppInfo apps;
    private ArrayList<App> app_list;
    private AppListAdapter adapter;
    public DbHelper dbHelper;
    private SharedPreferences settings;
    private int selectCodeIndex;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.setup);
        dbHelper = new DbHelper(getApplicationContext());
        settings = getSharedPreferences("com.onelogin.mock.ta", 0);
        selectCodeIndex = settings.getInt("select_index", -1);
        app = (SDKTest) this.getApplication();


        appListView = (ListView) this.findViewById(R.id.applist);


        appListView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {

            public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
                                           final int pos, long id) {
                final App _app = app_list.get(pos);
                AlertDialog.Builder ad = new AlertDialog.Builder(Setup.this);
                ad.setTitle(R.string.app_name);
                ad.setMessage(String.format("Remove the \"%s\"?", _app.getName()));
                ad.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int arg1) {
                        if (apps != null) {
                            apps.deleteApp(_app);
                            loadApps();
                        }
                    }
                });
                ad.setNegativeButton("No", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int arg1) {
                    }
                });
                ad.setCancelable(true);
                ad.show();

                return false;

            }
        });


        this.loadApps();

        // There is a TA request
        Intent intent = getIntent();
        Uri data = intent.getData();

        if (data != null) {
            String returnURI = data.getQueryParameter("returnRoute");
            String request = "";
            String appName = returnURI;
            appName = appName.replace("http://", "").replace(":", "").replace("/", "");

            App app = dbHelper.findApp(appName);

            if (selectCodeIndex > 0) {
                request = "?e=" + getCodeError(selectCodeIndex);

            } else if (app != null) {

                if (app.getState()) {
                    try {
                        request = String.format("?t=%s&e=%s", getToken(), 0);
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                        Log.e(TAG, "Failed generate Token");
                    }
                } else {
                    request = "?e=" + ErrorCode.NAPPSRequestingAppDoesNotHavePermission;
                }

            } else {
                request = "?e=" + ErrorCode.NAPPSRequestingAppDoesNotHavePermission;
            }

            Intent url_intent = new Intent(Intent.ACTION_VIEW, Uri.parse(returnURI + request));
            startActivity(url_intent);

        }
    }

    private int getCodeError(int index) {
        switch (index) {
            case 0:
                return ErrorCode.NAPPSNetworkNotAvailable;
            case 1:
                return ErrorCode.NAPPSIDPDidNotRespond;
            case 2:
                return ErrorCode.NAPPSRequestingAppDoesNotHavePermission;
            case 3:
                return ErrorCode.NAPPSSecondaryTokenRequestRejected;
            case 4:
                return ErrorCode.NAPPSAppInfoListRefreshFailed;
            case 5:
                return ErrorCode.NAPPSTokenAgentNotInstalled;
            case 6:
                return ErrorCode.NAPPSNoSessionActive;
            case 7:
                return ErrorCode.NAPPSDeviceCouldNotBeEnrolled;
            default:
                return ErrorCode.NAPPSNone;
        }
    }

    private void loadApps() {
        apps = app.getAppInfo();
        app_list = apps.getAppList();

        adapter = new AppListAdapter(Setup.this, app_list);
        appListView.setAdapter(adapter);
    }

    private String getToken() throws UnsupportedEncodingException {
        String text = md5(Integer.toString((int) (Math.random() * 7777)));
        byte[] data = text.getBytes("UTF-8");
        return Base64.encodeToString(data, Base64.DEFAULT);
    }

    @Override
    public void onResume() {
        super.onResume();
        this.loadApps();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle presses on the action bar items
        switch (item.getItemId()) {
            case R.id.action_add_app:
                Intent add_app_intent = new Intent(getApplicationContext(), AddApp.class);
                startActivity(add_app_intent);
                return true;
            case R.id.action_settings:
                Intent settings = new Intent(getApplicationContext(), Settings.class);
                startActivity(settings);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private static final String md5(final String s) {
        final String MD5 = "MD5";
        try {
            // Create MD5 Hash
            MessageDigest digest = java.security.MessageDigest
                    .getInstance(MD5);
            digest.update(s.getBytes());
            byte messageDigest[] = digest.digest();

            // Create Hex String
            StringBuilder hexString = new StringBuilder();
            for (byte aMessageDigest : messageDigest) {
                String h = Integer.toHexString(0xFF & aMessageDigest);
                while (h.length() < 2)
                    h = "0" + h;
                hexString.append(h);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }
}