package com.example.timeeditparser_flutter.appnotifications;

import com.example.timeeditparser_flutter.schedule.Schedule;
import com.example.timeeditparser_flutter.eventtype.EventType;
import com.example.timeeditparser_flutter.notificationevent.NotificationEvent;

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

public class AppNotifications {
    NotificationCompat.Builder builder;
    NotificationManager notificationManager;
    NotificationChannel importantChannel;
    NotificationChannel unimportantChannel;
    Boolean notify = false;

    public AppNotifications(Context context) {
        builder = new NotificationCompat.Builder(context).setSmallIcon(R.drawable.btn_plus);
        notificationManager = context.getSystemService(NotificationManager.class);
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

    public void send(Context context) {
        NotificationEvent event = Schedule.getCurrentEvent();
        switch(event.eventType) {
            case START:
                builder.setContentTitle("No ongoing lesson")
                    .setContentText("Next up: " + event.eventName + " in " + timeBetweenInstants(Instant.now(), event.eventTime).toString() + "m (" + timeStamp(event.eventTime) + ") at " + event.eventLocation);
                break;
            case END:
                builder.setContentTitle("Current lesson: " + event.eventName +" at " + event.eventLocation)
                    .setContentText("Lesson ends in" + timeBetweenInstants(Instant.now(), event.eventTime).toString() + "m (" + timeStamp(event.eventTime) + ")");
                break;
            case DAYEND:
                builder.setContentTitle("School day ended")
                    .setContentText("Day ended " + timeBetweenInstants(event.eventTime, Instant.now()).toString() + " minutes ago");
                break;
        }
        
        builder.setOngoing(true);
        updateNotificationSettings();
        Notification notification = builder.build();

        // Publish the notification:
        final int notificationId = 0;
        notificationManager.notify(notificationId, notification);
    }

    private void updateNotificationSettings() {
        if (notify)
        {
            builder.setChannelId("1");
            builder.setVibrate(new long[] { 200L });
            builder.setSound(Settings.System.DEFAULT_NOTIFICATION_URI);
        }
        else
        {
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
