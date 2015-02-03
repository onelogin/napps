package com.onelogin.mockta;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;



/**
 * Created by tdebenning on 5/23/14.
 * <p/>
 * This is a fragment that is used within a list activity
 * Not used in the initial version of the application.
 */
public class AppDetail extends Fragment {


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstance) {

        return inflater.inflate(R.layout.rowlayout, container, false);

    }


}
