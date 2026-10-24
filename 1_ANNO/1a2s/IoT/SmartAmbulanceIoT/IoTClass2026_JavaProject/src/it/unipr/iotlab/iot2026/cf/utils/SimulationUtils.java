package it.unipr.iotlab.iot2026.cf.utils;

import java.util.Random;

public class SimulationUtils {
	public static final String JSON_CLIENT_KEY = "Client";
	public static final String LOCALHOST = "coap://127.0.0.1";
	
	public static final String DRIVER_CLIENT = "DRIVER";
	public static final String RELIEVER_CLIENT = "RELIEVER";
	public static final String GPS_CLIENT = "GPS";
	
	public static final String HMI_UPDATE_REQUEST = "HMI_UP";
	
	private static final int MIN_EMERGENCY_LEVEL = 1;
	private static final int MAX_EMERGENCY_LEVEL = 3;
	
	private static final int MIN_LOCATION_EVENT = 1;
	private static final int MAX_LOCATION_EVENT = 4;
	
	private static final int MAX_TARGET_TEMP = 30;
	private static final int MIN_TARGET_TEMP = 8;
	
	public static int randomEmergencyLevel() {
	    return (int) ((Math.random() * (MAX_EMERGENCY_LEVEL - MIN_EMERGENCY_LEVEL)) + MIN_EMERGENCY_LEVEL);
	}
	
	public static int randomLocationEvent() {
	    return (int) ((Math.random() * (MAX_LOCATION_EVENT - MIN_LOCATION_EVENT)) + MIN_LOCATION_EVENT);
	}
	
	public static int randomTargetTemperature() {
		return (int) ((Math.random() * (MAX_TARGET_TEMP - MIN_TARGET_TEMP)) + MIN_TARGET_TEMP);
	}
	
	public static String extractJsonValue(String json, String key) {
	        String search = "\"" + key + "\":";
	        int start = json.indexOf(search) + search.length();
	        int end   = json.indexOf(",", start);
	        if (end == -1) end = json.indexOf("}", start);
	        return json.substring(start, end).replaceAll("\"", "").trim();
	}
	
	public static double[] randomGPSCoordinates() {
		Random rand = new Random();

		double lat = -90  + rand.nextDouble() * 180;  
		double lon = -180 + rand.nextDouble() * 360; 
		
		return new double[]{lat, lon};
	}
}
