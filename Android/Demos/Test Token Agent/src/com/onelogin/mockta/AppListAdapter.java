package com.onelogin.mockta;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.onelogin.ta.App;

import java.util.ArrayList;

/**
 * Created by andreynazimov on 6/12/14.
 * <p/>
 * The list adapter that uses a fragment to display
 * the application.
 */
public class AppListAdapter extends BaseAdapter {

    private Activity activity;
    private ArrayList<App> apps;
    private static LayoutInflater inflater = null;

    public AppListAdapter(Activity activity, ArrayList<App> apps) {
        this.activity = activity;
        this.apps = apps;
        this.inflater = (LayoutInflater) this.activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public int getCount() {
        return this.apps.size();
    }

    public Object getItem(int position) {
        return position;
    }

    public long getItemId(int position) {
        return position;
    }



    public boolean onItemLongClick(AdapterView<?> parent, View view,
                                   int position, long id) {

        String res = Long.toString(id);
        Toast toast = Toast.makeText(activity, res, Toast.LENGTH_SHORT);
        toast.show();

        return true;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        View vi = convertView;
        if (convertView == null)
            vi = inflater.inflate(R.layout.check_list_item, null);
        TextView app_name = (TextView) vi.findViewById(R.id.text1);
        TextView app_url = (TextView) vi.findViewById(R.id.text2);
        Switch state = (Switch) vi.findViewById(R.id.switch_state);
        //App app = new HashMap<String, String>();
        final App app = apps.get(position);

        app_name.setText(app.getName());
        app_url.setText(app.getBackScheme());
        state.setChecked(app.getState());

        state.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                app.setState(b);
                if(activity instanceof Setup){
                    ((Setup) activity).dbHelper.updateApp(app);
                }
            }
        });
        return vi;
    }
}
