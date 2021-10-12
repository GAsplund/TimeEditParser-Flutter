package com.example.timeeditparser_flutter;

import com.example.timeeditparser_flutter.Schedule;
import com.example.timeeditparser_flutter.ScheduleBroadcastReceiver;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.Intent;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "scheduleNotification";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            switch(call.method) {
              case "setNotifSchedule":
                if (((List<Map<String, Object>>)call.arguments).size() < 1) break;
                Schedule.setCurrentSchedule((List<Map<String, Object>>)call.arguments);
                if(ScheduleBroadcastReceiver.currentInstance == null) {
                  ScheduleBroadcastReceiver.currentInstance = new ScheduleBroadcastReceiver(this);
                  this.sendBroadcast(new Intent().setAction("SCHEDULEBROADCAST_FIRST"));
                }
              break;
              default:
                result.notImplemented();
                break;
            }
          }
        );
  }

  @Override
  protected void onDestroy() {
       super.onDestroy();
       this.sendBroadcast(new Intent().setAction("SCHEDULEBROADCAST_DEST"));
  }
}
