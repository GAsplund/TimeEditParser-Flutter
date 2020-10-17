package com.example.timeeditparser_flutter.schedule;

import com.example.timeeditparser_flutter.notificationevent.NotificationEvent;
import com.example.timeeditparser_flutter.eventtype.EventType;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Collections;
import java.util.Comparator;

public class Schedule {
    static ArrayList<NotificationEvent> events = new ArrayList<NotificationEvent>();
    public static NotificationEvent getCurrentEvent() {
        while(events.size() > 0) {
            if (events.get(0).eventTime.compareTo(Instant.now()) <= 0) {events.remove(0); continue;}
            else return events.get(0);
        }
        NotificationEvent dayEnded = new NotificationEvent();
        dayEnded.eventType = EventType.DAYEND;
        dayEnded.eventTime = Instant.now();
        return dayEnded;
    }

    public static void setCurrentSchedule(List<Map<String, Object>> schedule) {
        events.clear();
        for(Map<String, Object> event : schedule) {
            NotificationEvent parsedEvent = new NotificationEvent();
            Long eventTime = (Long) event.get("TIME");
            Integer eventType = (Integer) event.get("TYPE");
            parsedEvent.eventTime = Instant.ofEpochMilli(eventTime);
            parsedEvent.eventType = intToEventType(eventType);
            parsedEvent.eventName = (String) event.get("NAME");
            parsedEvent.eventLocation = (String) event.get("LOCATION");
            events.add(parsedEvent);
        }
        Collections.sort(events, Comparator.comparing((NotificationEvent e) -> e.eventTime.getEpochSecond()));
    }

    static EventType intToEventType(Integer i){
        final EventType[] types = EventType.values();
        if(i > types.length) return types[0];
        return types[i];
    }
}
