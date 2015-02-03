package com.onelogin.mockta;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.onelogin.ta.App;

import java.util.List;

/**
 * Created by lineelik on 5/21/14.
 */
public class MyArrayAdapter extends ArrayAdapter {
    private List<App> apps;

    public MyArrayAdapter(Context context, List<App> items) {
        super(context, android.R.layout.simple_expandable_list_item_2, android.R.id.text1, items);
        this.apps = items;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = super.getView(position, convertView, parent);
        TextView name = (TextView) view.findViewById(android.R.id.text1);
        TextView domain = (TextView) view.findViewById(android.R.id.text2);
        name.setText(apps.get(position).getName());
        domain.setText(apps.get(position).getBackScheme());
        return view;
    }
}
