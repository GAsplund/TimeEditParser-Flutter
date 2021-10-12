package com.example.timeeditparser_flutter;

import com.example.timeeditparser_flutter.Schedule;
import com.example.timeeditparser_flutter.EventType;
import com.example.timeeditparser_flutter.NotificationEvent;

import androidx.core.app.NotificationCompat;
import android.content.Context;
import java.time.Instant;
import java.time.Duration;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;
import android.provider.Settings;
import android.content.Intent;
import android.app.Notification;
import android.R;
import android.app.PendingIntent;

public class AppNotifications {
    NotificationCompat.Builder builder;
    NotificationManager notificationManager;
    NotificationChannel importantChannel;
    NotificationChannel unimportantChannel;
    Boolean notify = false;

    Intent stopIntent = new Intent().setAction("SCHEDULEBROADCAST_DEST");
    PendingIntent stopPendingIntent;

    public AppNotifications(Context context) {
        builder = new NotificationCompat.Builder(context).setSmallIcon(R.drawable.btn_plus);
        notificationManager = context.getSystemService(NotificationManager.class);
        stopPendingIntent = PendingIntent.getBroadcast(context, 0, stopIntent, 0);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String importantChannelName = "Schedule notifications";
            String importantChannelDescription = "Notification for the schedule";
            importantChannel = new NotificationChannel("1", importantChannelName, NotificationManager.IMPORTANCE_DEFAULT);
            importantChannel.setDescription(importantChannelDescription);

            String unimportantChannelName = "Ongoing schedule updates";
            String unimportantChannelDescription = "Notification for the schedule";
            unimportantChannel = new NotificationChannel("0", unimportantChannelName, NotificationManager.IMPORTANCE_LOW);
            unimportantChannel.setDescription(unimportantChannelDescription);

            notificationManager.createNotificationChannel(unimportantChannel);
            notificationManager.createNotificationChannel(importantChannel);
        }
    }

    private Notification getNotifOngoing() {
        NotificationEvent event = Schedule.getCurrentEvent();
        switch(event.eventType) {
            case START:
                builder.setContentTitle("No ongoing booking")
                    .setContentText("Next up: " + event.eventName + " in " + ((Long)(timeBetweenInstants(Instant.now(), event.eventTime) + 1)).toString() + "m (" + timeStamp(event.eventTime) + ") at " + event.eventLocation);
                break;
            case END:
                builder.setContentTitle("Ongoing: " + event.eventName +" at " + event.eventLocation)
                    .setContentText("Ending in " + ((Long)(timeBetweenInstants(Instant.now(), event.eventTime) + 1)).toString() + "m (" + timeStamp(event.eventTime) + ")");
                break;
            case DAYEND:
                if(event.eventTime.isBefore(Instant.now())) builder.setContentTitle("Day has ended")
                    .setContentText("Ended " + timeBetweenInstants(event.eventTime, Instant.now()).toString() + " minutes ago");
                else builder.setContentTitle("Ongoing: " + event.eventName +" at " + event.eventLocation)
                .setContentText("Day ends in " + ((Long)(timeBetweenInstants(Instant.now(), event.eventTime) + 1)).toString() + "m (" + timeStamp(event.eventTime) + ")");
                break;
        }

        switch(event.eventType) {
            case START:
            case END:
                builder.mActions.clear();
                builder.addAction(R.drawable.ic_delete, "Stop",
                stopPendingIntent);
                builder.setOngoing(true);
                break;
            case DAYEND:
            default:
                builder.mActions.clear();
                builder.setDeleteIntent(stopPendingIntent);
                builder.setOngoing(false);
                break;
        }

        notify = event.eventPassed;
        updateNotificationSettings();
        return builder.build();
    }

    public void send() {
        Notification notification = getNotifOngoing();

        // Publish the notification:
        final int notificationId = 0;
        notificationManager.notify(notificationId, notification);
    }

    // Prevent notification from not being able to dismiss after termination
    public void sendLast() {
        // Get latest info before making it ongoing
        getNotifOngoing();

        // Probably a jank solution
        builder.setOngoing(false);
        Notification notification = builder.build();

        // Publish the notification:
        final int notificationId = 0;
        notificationManager.notify(notificationId, notification);
    }

    // 
    public void clear() {
        // Might want to do this in another way when/before adding non-ongoing notifications.
        notificationManager.cancel(0);
    }

    private void updateNotificationSettings() {
        if (notify) {
            builder.setChannelId("1");
            builder.setVibrate(new long[] { 200L });
            builder.setSound(Settings.System.DEFAULT_NOTIFICATION_URI);
        } else {
            builder.setChannelId("0");
            builder.setVibrate(new long[] { 0L });
            builder.setSound(null);
        }
    }

    private Long timeBetweenInstants(Instant time1, Instant time2) {
        return Duration.between(time1, time2).toMinutes();
    }

    private String timeStamp(Instant time) {
        DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm")
            .withZone(ZoneId.systemDefault());

        return DATE_TIME_FORMATTER.format(time);
    }

}
