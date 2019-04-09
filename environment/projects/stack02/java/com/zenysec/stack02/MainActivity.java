package com.zenysec.stack02;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.zenysec.stack02.SecretClass;

public class MainActivity extends Activity {

    static {
        System.loadLibrary("native-lib");
    }

    public native String getString();
    public native void vulnFunc();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

	TextView txt_welcome = (TextView)findViewById(R.id.txt_welcome);
        txt_welcome.setText("Welcome to stack02!\nSolved 0/1...");

        ImageView imageview_pwn =(ImageView) findViewById(R.id.img_pwned);

        SecretClass.activity = this;
        SecretClass.txt_welcome = txt_welcome;
        SecretClass.imageview_pwn = imageview_pwn;

        Button bt_getstring = (Button)findViewById(R.id.bt_getstring);
        bt_getstring.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                TextView txt_getstring = (TextView)findViewById(R.id.txt_getstring);
                Toast.makeText(getApplicationContext(), "Calling GetString Function...", Toast.LENGTH_SHORT).show();
                txt_getstring.setText(getString());
            }
        });

        Button bt_vuln = (Button)findViewById(R.id.bt_vuln);
        bt_vuln.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getApplicationContext(), "Calling Vulnerable Function...", Toast.LENGTH_SHORT).show();
                vulnFunc();
            }
        });
    }

}

