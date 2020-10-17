package com.example.timeeditparser_flutter.schedulebroadcastreceiver;

import com.example.timeeditparser_flutter.appnotifications.AppNotifications;
import com.example.timeeditparser_flutter.schedule.Schedule;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

public class ScheduleBroadcastReceiver extends BroadcastReceiver {
    private AppNotifications notif;
    public static ScheduleBroadcastReceiver currentInstance;

    public ScheduleBroadcastReceiver(Context context) {
        notif = new AppNotifications(context);
        IntentFilter filter = new IntentFilter();
        filter.addAction(Intent.ACTION_TIME_TICK);
        filter.addAction("SCHEDULEBROADCAST_FIRST");
        context.registerReceiver(this, filter);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        notif.send(context);
    }

}