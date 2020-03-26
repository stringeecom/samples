package com.example.stringeevideocallsample;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.google.firebase.iid.FirebaseInstanceId;
import com.stringee.StringeeClient;
import com.stringee.call.StringeeCall;
import com.stringee.exception.StringeeError;
import com.stringee.listener.StatusListener;
import com.stringee.listener.StringeeConnectionListener;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    private String token = "YOUR_TOKEN";
    public static StringeeClient stringeeClient;

    public static Map<String, StringeeCall> callMap = new HashMap<>();

    private TextView tvUserId;
    private EditText etUserId;
    private Button btnVideoCall;

    private String firebaseToken;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initView();

        //init Stringee connectionListener and connect
        initStringee();

        requirePermission();
    }

    private void requirePermission() {
        ActivityCompat.requestPermissions(MainActivity.this, new String[]{
                Manifest.permission.CAMERA,
                Manifest.permission.RECORD_AUDIO
        }, 1);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == 1) {
            if (grantResults.length > 0
                    && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            } else {
                Toast.makeText(MainActivity.this, "Permission denied", Toast.LENGTH_SHORT).show();
            }
            return;
        }
    }

    private void initStringee() {
        stringeeClient = new StringeeClient(MainActivity.this);
        stringeeClient.setConnectionListener(new StringeeConnectionListener() {
            @Override
            public void onConnectionConnected(StringeeClient stringeeClient, boolean b) {
                // do something when connected to Stringee server
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        tvUserId.setText(stringeeClient.getUserId());

                        firebaseToken = FirebaseInstanceId.getInstance().getToken();
                        stringeeClient.registerPushToken(firebaseToken, new StatusListener() {
                            @Override
                            public void onSuccess() {
                                Toast.makeText(MainActivity.this, "Register success", Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onError(StringeeError stringeeError) {
                                Toast.makeText(MainActivity.this, "Register error: " + stringeeError.getMessage(), Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                });
            }

            @Override
            public void onConnectionDisconnected(StringeeClient stringeeClient, boolean b) {
            // do something when disconnected to Stringee server
            }

            @Override
            public void onIncomingCall(StringeeCall stringeeCall) {
                // do something when get incoming call
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        callMap.put(stringeeCall.getCallId(), stringeeCall);
                        Intent intent = new Intent(MainActivity.this, IncomingCallActivity.class);
                        intent.putExtra("call_id", stringeeCall.getCallId());
                        startActivity(intent);
                    }
                });
            }

            @Override
            public void onConnectionError(StringeeClient stringeeClient, StringeeError stringeeError) {
                // do something when connect to Stringee server in error
            }

            @Override
            public void onRequestNewToken(StringeeClient stringeeClient) {
                // do something when your token is out of date
            }

            @Override
            public void onCustomMessage(String s, JSONObject jsonObject) {

            }

            @Override
            public void onTopicMessage(String s, JSONObject jsonObject) {

            }
        });

        stringeeClient.connect(token);
    }

    private void initView() {
        tvUserId = findViewById(R.id.tv_user_id);
        etUserId = findViewById(R.id.et_user_id);
        btnVideoCall = findViewById(R.id.btn_video_call);

        btnVideoCall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivity.this, OutgoingCallActivity.class);
                intent.putExtra("from", stringeeClient.getUserId());
                intent.putExtra("to", etUserId.getText().toString());
                startActivity(intent);
            }
        });
    }
}
