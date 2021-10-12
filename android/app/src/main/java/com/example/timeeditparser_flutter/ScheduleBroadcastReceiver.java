package com.example.timeeditparser_flutter;

import com.example.timeeditparser_flutter.AppNotifications;
import com.example.timeeditparser_flutter.Schedule;
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
        filter.addAction("SCHEDULEBROADCAST_TERM");
        filter.addAction("SCHEDULEBROADCAST_DEST");
        context.registerReceiver(this, filter);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        switch(intent.getAction()) {
            case "SCHEDULEBROADCAST_FIRST":
            case Intent.ACTION_TIME_TICK:
                notif.send();
                break;
            case "SCHEDULEBROADCAST_TERM":
                context.unregisterReceiver(this);
                notif.sendLast();
                break;
            case "SCHEDULEBROADCAST_DEST":
                context.unregisterReceiver(this);
                notif.clear();
        }
        
    }

}