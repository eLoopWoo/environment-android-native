package com.zenysec.stack02;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ImageView;

public class SecretClass extends Activity  {

        static public Activity activity;
        static public TextView txt_welcome;
        static public ImageView imageview_pwn;

        static void secretMethod(){
                txt_welcome.setText("Welcome to stack02!\nSolved 1/1\nCongratulations - PWNED!");
                imageview_pwn.setVisibility(View.VISIBLE);
                Toast.makeText(activity, "Whaa! You successfuly pwned me :-)", 20000).show();
                Toast.makeText(activity, "Whaa! You successfuly pwned me :-)", 20000).show();
                Toast.makeText(activity, "Whaa! You successfuly pwned me :-)", 20000).show();
                Toast.makeText(activity, "Whaa! You successfuly pwned me :-)", 20000).show();
                return;
        }
}

