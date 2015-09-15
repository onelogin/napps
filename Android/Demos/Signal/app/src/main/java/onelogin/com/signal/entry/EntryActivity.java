package onelogin.com.signal.entry;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.onelogin.napps.sdk.OLException;
import com.onelogin.napps.sdk.OLNapps;

import onelogin.com.signal.R;


public class EntryActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_entry);

        TextView titleTextView = (TextView) findViewById(R.id.titleTextView);
        titleTextView.setText("Test Token Agent");

        TextView taglineTextView = (TextView) findViewById(R.id.taglineTextView);
        taglineTextView.setText("Let's make sure you have the token agent.");

        setupActionButton();

    }

    /* NAPPS Tutorial:
     This is where you configure the app to either run against a Mock token agent
     (for testing purposes) or against the OneLogin launcher app.

     Note: Make sure you have this pointing to the real token agent before you ship your
      application!
     */

    private void setTestMode() {
        try {
            OLNapps.SDK(this).setTokenAgentPackageName("com.onelogin.mockta");
            OLNapps.SDK(this).setTokenAgentURLScheme("olta://com.onelogin.mockta://");
        } catch(OLException ex) {
            ex.printStackTrace();
        }
    }

    /* NAPPS Tutorial:
       Setup the action button to either request the secondary token or
       to allow the user to look again for a relevant token agent.
       Ideally here's where you would decide if your application should automatically use the
       token agent or alternatively give the user the option of logging in via OneLogin
     */
    private void setupActionButton() {

        Button actionButton = (Button) findViewById(R.id.actionButton);
        TextView tokenAgentMessageTextView = (TextView) findViewById(R.id.tokenAgentMessageTextView);

        try {
            if (OLNapps.SDK(this).isTokenAgentInstalled()) {
                /* If there is a relevant token agent,
                    allow token agent request when
                   the action button is clicked. */

                tokenAgentMessageTextView.setText("AGENT FOUND");
                actionButton.setText("Continue");
                actionButton.setOnClickListener(new View.OnClickListener() {

                    @Override
                    public void onClick(View arg0) {
                        acquireNappsToken();
                    }
                });
            } else {
                tokenAgentMessageTextView.setText("AGENT NOT FOUND");
                actionButton.setText("Refresh");
                actionButton.setOnClickListener(new View.OnClickListener() {

                    @Override
                    public void onClick(View arg0) {
                        setupActionButton();
                    }
                });
            }

        } catch(OLException ex) {
        }
    }

  /* NAPPS Tutorial:
       Call that actually makes the request to get the secondary token from the token agent.
       Not that the URI passed into the call should be what you've defined as a scheme in your
       manifest file (otherwise your app won't get the secondary token back from the Token Agent!)
     */

    private void acquireNappsToken() {
        try {
            OLNapps.SDK(this).requestSecondaryToken("SIGNAL://onelogin.com.signal.Signal://");
        } catch (OLException ex) {
            Log.e("SIGNAL", ex.getMessage());
        }
    }
}
