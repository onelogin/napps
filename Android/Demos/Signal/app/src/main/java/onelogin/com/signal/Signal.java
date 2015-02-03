package onelogin.com.signal;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.ProgressDialog;
import android.util.Log;
import android.widget.ListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.view.View;
import android.widget.Toast;
import android.content.Intent;
import android.net.Uri;

import com.onelogin.napps.sdk.OLError;
import com.onelogin.napps.sdk.OLException;
import com.onelogin.napps.sdk.OLNapps;
import com.onelogin.napps.sdk.OLToken;


public class Signal extends Activity {
    private SimpleAdapter adpt;
    List<Contact> result;
    private static final String TAG = "SIGNAL";
    private boolean isTAInstaled = false;
    //napps lib
    OLNapps OLNAPPS;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //---------------NAPPS------------
        //init lib

        try {
            OLNAPPS = OLNapps.SDK(this);
        } catch (OLException e) {
            e.printStackTrace();
        }

        Uri data = getIntent().getData();
        //get result
        if (data != null) {
            //get secondary token
            try{
                OLToken token = OLNAPPS.getToken(data);
                if (token.getError() == 0) {
                    Toast.makeText(this, "Token: " + token.getSecondaryToken(), Toast.LENGTH_LONG).show();
                    //continue work programm
                    initList();
                } else {
                    Toast.makeText(this, "Error: " + token.getError(), Toast.LENGTH_LONG).show();
                }
            }catch (OLException ex){
                Log.e(TAG, ex.getMessage());
            }

        } else {


            //test with Launcher NAPPS
            try {
                isTAInstaled = OLNAPPS.isTokenAgentInstalled();
            } catch (Exception ex) {
                ex.printStackTrace();
                Log.e(TAG, ex.getMessage());
            }
            //if TA is installed, start TA to get secondary token
            if (isTAInstaled) {
                //start TA
                try{
                    OLNAPPS.requestSecondaryToken("http://onelogin.com.signal.Signal://");
                }catch (OLException ex){
                    Log.e(TAG, ex.getMessage());
                }
            }else{

                //if Launcher NAPPS not install, set MOCK TA
                OLNAPPS.setTokenAgentPackageName("com.onelogin.mockta");
                OLNAPPS.setTokenAgentURLScheme("http://com.onelogin.mockta://");

                try {
                    isTAInstaled = OLNAPPS.isTokenAgentInstalled();
                } catch (Exception ex) {
                    ex.printStackTrace();
                    Log.e(TAG, ex.getMessage());
                }

                if (isTAInstaled) {
                    //start TA
                    try{
                        OLNAPPS.requestSecondaryToken("http://onelogin.com.signal.Signal://");
                    }catch (OLException ex){
                        Log.e(TAG, ex.getMessage());
                    }
                }else{
                    Toast.makeText(this, "Error: " + OLError.NAPPSTokenAgentNotInstalled, Toast.LENGTH_LONG).show();
                }

            }



        }

        //-------------------------------
    }

    private void initList() {
        adpt = new SimpleAdapter(new ArrayList<Contact>(), this);
        ListView lView = (ListView) findViewById(R.id.listview);

        lView.setAdapter(adpt);

        lView.setOnItemClickListener(new OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                Contact c = result.get(position);
                String tweetid = c.getTweet_id();
                Uri uri = Uri.parse("https://twitter.com/intent/tweet?in_reply_to=" + tweetid);
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                startActivity(intent);

            }
        });

        // Exec async load task
        (new AsyncListViewLoader()).execute("http://www.evilplancorp.com:5000/index");
    }

    private class AsyncListViewLoader extends AsyncTask<String, Void, List<Contact>> {
        private final ProgressDialog dialog = new ProgressDialog(Signal.this);

        @Override
        protected void onPostExecute(List<Contact> rresult) {
            super.onPostExecute(result);
            dialog.dismiss();
            adpt.setItemList(result);
            adpt.notifyDataSetChanged();
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            dialog.setMessage("Downloading tweets...");
            dialog.show();
        }


        @Override
        protected List<Contact> doInBackground(String... params) {
            result = new ArrayList<Contact>();


            try {
                URL u = new URL(params[0]);

                String JSONResp = getRawJSONString(u);


                if (JSONResp != null) {
                    try {

                        JSONArray arr = new JSONArray(JSONResp);

                        for (int j = 0; j < arr.length(); j++) {


                            JSONObject brr = arr.getJSONObject(j);
                            JSONArray newbrr = brr.getJSONArray("list");
                            String header = brr.getString("search_term");
                            result.add(new Contact("", "", "", header, "", 0));

                            for (int i = 0; i < newbrr.length(); i++) {
                                result.add(convertContact(newbrr.getJSONObject(i)));
                            }
                        }

                    } catch (JSONException e) {

                        String msg = e.getMessage();
                        System.out.println(msg);

                        e.printStackTrace();
                    }

                }
            } catch (MalformedURLException male) {

                male.printStackTrace();
            }


            return null;
        }


        private String getRawJSONString(URL url) {
            InputStream is = null;

            try {
                // defaultHttpClient
                DefaultHttpClient httpClient = new DefaultHttpClient();
                HttpGet httpGet = new HttpGet("http://www.evilplancorp.com:5000/index");
                //httpGet.setEntity(new UrlEncodedFormEntity(params));

                HttpResponse httpResponse = httpClient.execute(httpGet);
                HttpEntity httpEntity = httpResponse.getEntity();
                is = httpEntity.getContent();

            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (ClientProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

            String json = null;
            try {
                BufferedReader reader = new BufferedReader(new InputStreamReader(
                        is, "iso-8859-1"), 8);
                StringBuilder sb = new StringBuilder();
                String line = null;
                while ((line = reader.readLine()) != null) {
                    line = line.replaceAll("null", "\"\"");

                    sb.append(line + "\n");
                }
                is.close();
                json = sb.toString();


            } catch (Exception e) {
                Log.e("Buffer Error", "Error converting result " + e.toString());
            }

            return json;

        }
    }

    private Contact convertContact(JSONObject obj) throws JSONException {
        String date = obj.getString("date");
        String tweet_id = obj.getString("tweet_id");
        String picture_url = obj.getString("picture_url");
        String user_name = obj.getString("user_name");
        String text = obj.getString("text");

        return new Contact(date, tweet_id, picture_url, user_name, text, 1);
    }

}