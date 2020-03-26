package com.example.stringeevideocallsample;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.stringee.exception.StringeeError;
import com.stringee.listener.StatusListener;

import org.json.JSONException;
import org.json.JSONObject;

public class MyFirebaseMessagingService extends FirebaseMessagingService {

    private static final String CHANNEL_ID = "com.example.stringeevideocallsample.notification";
    private static final String CHANNEL_NAME = "Stringee VideoCall Notification";
    private static final String CHANNEL_DESC = "Channel for Notification";

    @Override
    public void onNewToken(@NonNull String s) {
        MainActivity.stringeeClient.registerPushToken(s, new StatusListener() {
            @Override
            public void onSuccess() {
                Toast.makeText(MyFirebaseMessagingService.this, "Register success", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onError(StringeeError stringeeError) {
                Toast.makeText(MyFirebaseMessagingService.this, "Register error: " + stringeeError.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        if (remoteMessage.getData().size() > 0) {
            Log.d("Stringee Notification", "Message data payload: " + remoteMessage.getData());
            String pushFromStringee = remoteMessage.getData().get("stringeePushNotification");

//             Stringee Notification:
//            {stringeePushNotification=1.0, data={"callId":"callId","serial":1,"callStatus":"started"}, type=CALL_EVENT}
            if (pushFromStringee != null) {
                String data = remoteMessage.getData().get("data");
                try {
                    JSONObject jsonObject = new JSONObject(data);

                    //callStatus : started, ringing, answered, ended
                    String callStatus = jsonObject.getString("callStatus");
                    if (callStatus != null && callStatus.equals("started")) {
                        showNotification();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void showNotification() {
        NotificationManager notificationManager;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT);
            notificationChannel.setDescription(CHANNEL_DESC);
            notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(notificationChannel);
        } else {
            notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        }

        Intent intent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher_round)
                .setContentTitle("IncomingCall")
                .setContentIntent(pendingIntent);

        Notification notification = builder.build();

        notificationManager.notify(1, notification);
    }
}
