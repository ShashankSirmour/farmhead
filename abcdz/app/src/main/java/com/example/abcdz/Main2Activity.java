package com.example.abcdz;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class Main2Activity extends AppCompatActivity {


    EditText e1;
    EditText e2;
    EditText e3;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);
        e1=findViewById(R.id.side1);
        e2=findViewById(R.id.side2);
        e3=findViewById(R.id.side3);
    }

   public void calculate(View v){
       float s1= Integer.parseInt(e1.getText().toString());
       float s2= Integer.parseInt(e2.getText().toString());
       float s3= Integer.parseInt(e3.getText().toString());

       float p=(s1+s2+s3)/2;
        float a=p*(p-s1)*(p-s2)*(p-s3);
        double area = Math.sqrt(a);
        Toast.makeText(getApplicationContext(),"Area is "+area,Toast.LENGTH_LONG).show();
    }
}
