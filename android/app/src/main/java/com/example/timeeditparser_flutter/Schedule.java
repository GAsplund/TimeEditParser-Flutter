package com.example.timeeditparser_flutter;

import com.example.timeeditparser_flutter.NotificationEvent;
import com.example.timeeditparser_flutter.EventType;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Collections;
import java.util.Comparator;

public class Schedule {
    static ArrayList<NotificationEvent> events = new ArrayList<NotificationEvent>();
    public static NotificationEvent getCurrentEvent() {
        Boolean eventPassed = false;
        while(events.size() > 1) {
            if (events.get(0).eventTime.compareTo(Instant.now()) <= 0) {events.remove(0); eventPassed = true; continue;}
            else { 
                NotificationEvent event = events.get(0);
                event.eventPassed = eventPassed;
                return event;
            }
        }
        
        if (events.size() == 1) {
            NotificationEvent event = events.get(0);
            event.eventPassed = eventPassed;
            event.eventType = EventType.DAYEND;
            return event;
        } else {
            NotificationEvent event = new NotificationEvent();
            event.eventPassed = eventPassed;
            event.eventType = EventType.DAYEND;
            event.eventTime = Instant.now();
            return event; 
        }
        
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
        // Clear the events that have already passed
        getCurrentEvent();
    }

    static EventType intToEventType(Integer i){
        final EventType[] types = EventType.values();
        if(i > types.length) return types[0];
        return types[i];
    }
}
