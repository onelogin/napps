package com.onelogin.mockta;

import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.onelogin.ta.App;

import java.util.ArrayList;

public class DbHelper extends SQLiteOpenHelper {
    private static String TAG = "DbHelper";
    ProgressDialog progressDialog;
    Context _context;

    public DbHelper(Context context/*, String name,
           CursorFactory factory, int version*/) {
        //super(context, name, factory, version);
        super(context, "ta.db", null, 1);
        this._context = context;
    }


    @Override
    public void onCreate(SQLiteDatabase db) {
        String CREATE_DB = "CREATE TABLE apps (" +
                "id integer(1,0) NOT NULL DEFAULT 1," +
                "name TEXT NOT NULL DEFAULT 0," +
                "url TEXT NOT NULL DEFAULT 0," +
                "active integer(1,0) NOT NULL DEFAULT 0);";

        db.execSQL(CREATE_DB);
    }


    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public void addApp(App app) throws Exception {
        if (this.findApp(app.getBackScheme()) != null) {
            Log.e(TAG, "App already exist");
            throw new Exception("App already exist");
        } else {
            ContentValues value = new ContentValues();
            SQLiteDatabase db = getWritableDatabase();
            value.put("name", app.getName());
            value.put("url", app.getBackScheme());
            db.insert("apps", null, value);
            db.close();
        }
    }

    public void removeApp(App app) {
        ContentValues value = new ContentValues();
        SQLiteDatabase db = getWritableDatabase();
        value.put("url", app.getBackScheme());
        db.delete("apps", "url = '" + app.getBackScheme() + "'", null);
        db.close();
    }

    public App findApp(String url) {
        SQLiteDatabase db = getWritableDatabase();
        App app = null;

        Cursor c = db.rawQuery("SELECT * FROM apps WHERE url = '" + url + "'", null);
        if (c.moveToFirst()) {
            int i_name = c.getColumnIndex("name");
            int i_url = c.getColumnIndex("url");
            int i_state = c.getColumnIndex("active");
            do {
                String name = c.getString(i_name);
                String app_url = c.getString(i_url);
                boolean state = c.getInt(i_state) == 0 ? false : true;
                app = new App(name, app_url, state);
            } while (c.moveToNext());
        } else
            c.close();
        db.close();
        return app;
    }

    public ArrayList<App> getApps() {
        ArrayList<App> app_list = new ArrayList<App>();
        SQLiteDatabase db = getWritableDatabase();
        Cursor c = db.rawQuery("SELECT * FROM apps", null);
        if (c.moveToFirst()) {
            int i_name = c.getColumnIndex("name");
            int i_url = c.getColumnIndex("url");
            int i_state = c.getColumnIndex("active");
            do {
                String name = c.getString(i_name);
                String app_url = c.getString(i_url);
                boolean state = c.getInt(i_state) == 0 ? false : true;
                App app = new App(name, app_url, state);
                app_list.add(app);
            } while (c.moveToNext());
        } else
            c.close();
        db.close();
        return app_list;
    }

    public void updateApp(App app) {
        ContentValues value = new ContentValues();
        SQLiteDatabase db = getWritableDatabase();
        value.put("active", app.getState());
        db.update("apps", value, "url = '" + app.getBackScheme() + "'", null);
        db.close();
    }

}