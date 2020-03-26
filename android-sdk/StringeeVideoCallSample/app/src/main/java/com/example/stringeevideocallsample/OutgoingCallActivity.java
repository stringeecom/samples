package com.example.stringeevideocallsample;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.stringee.call.StringeeCall;

import org.json.JSONObject;

public class OutgoingCallActivity extends AppCompatActivity {
    private StringeeCall stringeeCall;
    private StringeeCall.SignalingState state;

    private FrameLayout vLocal;
    private FrameLayout vRemote;

    private Button btnCancel;

    private TextView tvStatus;

    private String from;
    private String to;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_outgoing_call);

        from = getIntent().getStringExtra("from");
        to = getIntent().getStringExtra("to");

        initView();

        //init callListener to make call
        makeCall();

    }

    private void makeCall() {
        // from: caller's id., to:  callee's id
        stringeeCall = new StringeeCall(OutgoingCallActivity.this, MainActivity.stringeeClient, from, to);

        // true if call is videoCall, false if call is not videoCall
        stringeeCall.setVideoCall(true);

        stringeeCall.setCallListener(new StringeeCall.StringeeCallListener() {
            @Override
            public void onSignalingStateChange(StringeeCall stringeeCall, StringeeCall.SignalingState signalingState, String s, int i, String s1) {
                //get signalingState: CALLING, RINGING, ANSWERED, BUSY, ENDED
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        tvStatus.setText(signalingState.toString());
                        state = signalingState;
                        tvStatus.setText(state.toString());
                        if (state == StringeeCall.SignalingState.ENDED) {
                            finish();
                        }
                    }
                });
            }

            @Override
            public void onError(StringeeCall stringeeCall, int i, String s) {
                //get message when make call error
            }

            @Override
            public void onHandledOnAnotherDevice(StringeeCall stringeeCall, StringeeCall.SignalingState signalingState, String s) {

            }

            @Override
            public void onMediaStateChange(StringeeCall stringeeCall, StringeeCall.MediaState mediaState) {
                //get mediaState: CONNECTED, DISCONNECTED
            }

            @Override
            public void onLocalStream(StringeeCall stringeeCall) {
                //get your localStream
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        vLocal.addView(stringeeCall.getLocalView());
                        stringeeCall.renderLocalView(true);
                    }
                });
            }

            @Override
            public void onRemoteStream(StringeeCall stringeeCall) {
                //get your remoteStream
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        vRemote.addView(stringeeCall.getRemoteView());
                        stringeeCall.renderRemoteView(false);
                    }
                });
            }

            @Override
            public void onCallInfo(StringeeCall stringeeCall, JSONObject jsonObject) {

            }
        });
        stringeeCall.makeCall();
    }

    private void initView() {
        vLocal = findViewById(R.id.v_local);
        vRemote = findViewById(R.id.v_remote);

        tvStatus = findViewById(R.id.tv_status);

        btnCancel = findViewById(R.id.btn_cancel);
        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (stringeeCall != null) {
                    stringeeCall.hangup();
                    finish();
                }
            }
        });
    }
}
