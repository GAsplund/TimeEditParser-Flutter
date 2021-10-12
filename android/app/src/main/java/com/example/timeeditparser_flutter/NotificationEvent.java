package com.example.timeeditparser_flutter;

import com.example.timeeditparser_flutter.EventType;
import java.time.Instant;

public class NotificationEvent {
    public String eventName;
    public String eventLocation;
    public EventType eventType;
    public Instant eventTime;
    public Boolean eventPassed;
}