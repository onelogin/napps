/*
 * Copyright (C) 2013 Surviving with Android (http://www.survivingwithandroid.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package onelogin.com.signal;

import java.util.ArrayList;
import java.util.List;


import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.SectionIndexer;
import android.widget.TextView;
import android.widget.ImageView;

public class SimpleAdapter extends ArrayAdapter<Contact> {
	
	private List<Contact> itemList;
	private Context context;
    public ImageLoader imageLoader;


    public SimpleAdapter(List<Contact> itemList, Context ctx) {
		super(ctx, android.R.layout.simple_list_item_1, itemList);
		this.itemList = itemList;
		this.context = ctx;

        imageLoader=new ImageLoader(ctx);
  }
	
	public int getCount() {
		if (itemList != null)
			return itemList.size();
		return 0;
	}

	public Contact getItem(int position) {
		if (itemList != null)
			return itemList.get(position);
		return null;
	}

	public long getItemId(int position) {
	//if (itemList != null)
	//		return itemList.get(position).hashCode();
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		View v = convertView;

        if (v == null) {
			LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			v = inflater.inflate(R.layout.list_item, null);
		}
		
		Contact c = itemList.get(position);
		TextView text = (TextView) v.findViewById(R.id.name);
		text.setText(c.getUser_name());

        TextView text1 = (TextView) v.findViewById(R.id.tweet);
        text1.setText(c.getText());

        ImageView thumb_image=(ImageView)v.findViewById(R.id.list_image); // thumb image


        // 0 - Section Header; 1 - Section Item
        if (c.getType().intValue() == 1)
        {
            thumb_image.setVisibility(View.VISIBLE);
            text1.setVisibility(View.VISIBLE);
        }

        else

        {
            thumb_image.setVisibility(View.GONE);
            text1.setVisibility(View.GONE);
        }


        imageLoader.DisplayImage(c.getPicture_url(), thumb_image);

		return v;
		
	}

	public List<Contact> getItemList() {

        return itemList;
	}

	public void setItemList(List<Contact> itemList) {
		this.itemList = itemList;
	}

	
}
