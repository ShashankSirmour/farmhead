package com.example.abcdz;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }



  public void triangle(View v){

       Intent i=new Intent(getApplicationContext(),Main2Activity.class);
        startActivity(i);

    }

   public void rectangle(View v){
        Intent i=new Intent(getApplicationContext(),Main3Activity.class);
        startActivity(i);

    }
}
