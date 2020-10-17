package com.example.timeeditparser_flutter.notificationevent;

import com.example.timeeditparser_flutter.eventtype.EventType;
import java.time.Instant;

public class NotificationEvent {
    public String eventName;
    public String eventLocation;
    public EventType eventType;
    public Instant eventTime;
}