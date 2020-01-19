package com.example.abcdz;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class Main3Activity extends AppCompatActivity {

    EditText e1;
    EditText e2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main3);
        e1=findViewById(R.id.side1);
        e2=findViewById(R.id.side2);

    }

  public   void calculate(View v){
        float s1= Integer.parseInt(e1.getText().toString());
        float s2= Integer.parseInt(e2.getText().toString());
        Toast.makeText(getApplicationContext(),"Area is "+(s1*s2),Toast.LENGTH_LONG).show();
    }
}
