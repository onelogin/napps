package com.onelogin.mockta;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckedTextView;
import android.widget.ListView;


/**
 * Created by lineelik on 6/13/14.
 */
public class Settings extends Activity {

    private SharedPreferences settings;
    private SharedPreferences.Editor settings_editor;
    private int selectIndex;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settings);
        settings = getSharedPreferences("com.onelogin.mock.ta", 0);
        settings_editor = settings.edit();
        selectIndex = settings.getInt("select_index", 0);

        String data[] = new String[]{
                "Network not available (1000)",
                "IDP did not respond (1100)",
                "Requesting App does not have permission (1201)",
                "Secondary token request rejected (1202)",
                "App Info List refresh failed (1203)",
                "Token Agent not installed (1300)",
                "No Session Active (1500)",
                "Device could not be enrolled (1600)"};

        final ListView listSettings = (ListView) findViewById(R.id.listView);
        listSettings.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);


        ArrayAdapter<String> adapter = new ArrayAdapter<String>(Settings.this,
                android.R.layout.simple_list_item_multiple_choice, data);
        listSettings.setAdapter(adapter);

        listSettings.setItemChecked(selectIndex, true);

        listSettings.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                for (int i = 0; i < listSettings.getAdapter().getCount(); i++) {
                    if (i != position)
                        listSettings.setItemChecked(i, false);
                }

                if (listSettings.isItemChecked(position))
                    selectIndex = position;
                else
                    selectIndex = -1;

                settings_editor.putInt("select_index", selectIndex);
                settings_editor.commit();
            }
        });
    }
}

