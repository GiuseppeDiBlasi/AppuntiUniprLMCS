package it.unipr.iotlab.iot2026.cf.sim;

import it.unipr.iotlab.iot2026.cf.client.Driver;
import it.unipr.iotlab.iot2026.cf.client.GPS;
import it.unipr.iotlab.iot2026.cf.client.Reliever;
import it.unipr.iotlab.iot2026.cf.server.Cockpit;
import it.unipr.iotlab.iot2026.cf.server.RearCabin;

public class SmartAmbulanceSimulation {
	public final static int REARCABIN_PORT = 5683;
	public final static int COCKPIT_PORT = 5684;
	
	private static final int PAUSE_MS = 3000;
	
	public static final String RESOURCE_TEMP_SENSOR = "temp-sensor";
	public static final String RESOURCE_AC_CONTROLLER = "ac-contr";
	public static final String RESOURCE_HMI = "hmi";
	
	public static final String EMERGENCY_LEVEL_STR = "emergency_lvl";
	public static final String LOCATION_STR = "location";
	public static final String LATITUDE_STR = "lat";
	public static final String LONGITUDE_STR = "lon";
	public static final String GPS_COORDINATES = "gps-coords";
	public static final String ACC_TEMP_TARGET = "temp_target";
	public static final String TEMPERATURE_SENSOR = "temp_sensor";
	
	private static RearCabin rearCabin;
	private static Cockpit cockpit;
	
	private static Driver driver;
	private static Reliever reliever;
	private static GPS gps;
	
	private static void init() throws Exception {
		
		rearCabin = new RearCabin(REARCABIN_PORT);
		cockpit = new Cockpit(COCKPIT_PORT);
		
		driver = new Driver(REARCABIN_PORT);
		reliever = new Reliever(REARCABIN_PORT);
		gps = new GPS(COCKPIT_PORT);
		
		// Servers starting
		rearCabin.start();
		cockpit.start();
	}
	
	public static void main(String[] args) {
		try {
			
			init();
			
	
			driver.PUTRequestToACController();
			Thread.sleep(PAUSE_MS);
			
//			Updating GPS Coordinates
			gps.PUTRequestToHMI();
			Thread.sleep(PAUSE_MS);
			
			// Driver putting information on HMI in RearCabin
			driver.PUTRequestToHMI();
			Thread.sleep(PAUSE_MS);
			
			// Reliever changing the target temperature in Rear Cabin
			reliever.PUTRequestToACController();
			Thread.sleep(PAUSE_MS);
			
			// Reliever changing to Cockpit server
			reliever.changeServer(COCKPIT_PORT);
			Thread.sleep(PAUSE_MS);
			
			// Reliever should get refused for a PUT Request on AC Controller in cockpit Port
			reliever.PUTRequestToACController();
			Thread.sleep(PAUSE_MS);
			
			// Reliever Put Request to HMI in Cockpit port
			reliever.PUTRequestToHMI();
			Thread.sleep(PAUSE_MS);
			
			gps.PUTRequestToHMI();
			Thread.sleep(PAUSE_MS);
			
			driver.GETRequestToHMI();
			Thread.sleep(PAUSE_MS);
			
			driver.changeServer(COCKPIT_PORT);
			
			driver.PUTRequestToACController();
			Thread.sleep(PAUSE_MS);
			
			driver.PUTRequestToHMI();
			Thread.sleep(PAUSE_MS);
			
			//Reliever starts observing the temperature sensor
			reliever.observeTemperatureSensor();		
			Thread.sleep(3500);		
			reliever.stopObservingTemperature();
			
			

			
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}
