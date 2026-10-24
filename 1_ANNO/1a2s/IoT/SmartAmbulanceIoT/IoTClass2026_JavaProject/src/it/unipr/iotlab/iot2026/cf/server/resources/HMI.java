package it.unipr.iotlab.iot2026.cf.server.resources;

import org.eclipse.californium.core.CoapClient;
import org.eclipse.californium.core.CoapResource;
import org.eclipse.californium.core.CoapResponse;
import org.eclipse.californium.core.coap.CoAP.ResponseCode;
import org.eclipse.californium.core.coap.MediaTypeRegistry;
import org.eclipse.californium.core.server.resources.CoapExchange;

import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;
import it.unipr.iotlab.iot2026.cf.utils.SimulationUtils;


public class HMI extends  CoapResource{
	// These can be updated only by the Driver and Reliever

	private final int port;
	
	// could also be represented as enum
	private int emergencyLevel;
	private int locationEvent;

	// These can be updated only by the GPS client
	// 0 is latitude
	// 1 is longitude
	private double coordinates[];

	public HMI(String name, int port) {
		super(name);

		coordinates = new double[2];
		coordinates[0] = 1.005;
		coordinates[1] = 1.010;

		emergencyLevel = 1;
		locationEvent = 2;
		this.port = port;
	}

	@Override
	public void handleGET(CoapExchange exchange) {		
		String gpsLatLon = "[" + coordinates[0] + "," + coordinates[1] + "]";

		String payload = String.format(
				"{\"%s\":%d,\"%s\":%d,\"%s\":\"%s\"}",
				SmartAmbulanceSimulation.EMERGENCY_LEVEL_STR,
				emergencyLevel,
				SmartAmbulanceSimulation.LOCATION_STR,
				locationEvent,
				SmartAmbulanceSimulation.GPS_COORDINATES,
				gpsLatLon);

		exchange.respond(ResponseCode.CONTENT, payload, MediaTypeRegistry.APPLICATION_JSON);	
	}

	@Override
	public void handlePUT(CoapExchange exchange) {
		System.out.println("--- " + this.getURI() + " --- ");

		String payload = exchange.getRequestText();

		String senderClient = SimulationUtils.extractJsonValue(payload, SimulationUtils.JSON_CLIENT_KEY);

		System.out.println("Received a PUT request from: " + senderClient);

		if (senderClient.equals(SimulationUtils.DRIVER_CLIENT) || senderClient.equals(SimulationUtils.RELIEVER_CLIENT))
			handleRequestFromDriverOrReliever(payload);

		else if(senderClient.equals(SimulationUtils.GPS_CLIENT))
			handleRequestFromGPS(payload);
		else
			handleRequestFromOtherHMI(payload);


		exchange.respond(ResponseCode.CHANGED);

		System.out.println("-------------- HMI Handle Put ---------------------------------");
	}

	private void handleRequestFromDriverOrReliever(String payload) {

		System.out.println("Old Values: emergency level: " + emergencyLevel + "; location event: " + locationEvent);

		emergencyLevel = Integer.parseInt(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.EMERGENCY_LEVEL_STR));
		locationEvent  = Integer.parseInt(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.LOCATION_STR));

		System.out.println("New Values: emergency level: " + emergencyLevel + "; location event: " + locationEvent);

		updateOtherHMI(payload);
	}

	private void handleRequestFromGPS(String payload) {


		System.out.println("\nUpdating GPS coordinates from other HMI");
		System.out.println("Old Values: LAT: " + coordinates[0] + "; LON: " + coordinates[1]);
		
		double lat = Double.parseDouble(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.LATITUDE_STR));
		double lon = Double.parseDouble(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.LONGITUDE_STR));
				
	    coordinates[0] = lat;
		coordinates[1] = lon;

		System.out.println("New Values: LAT: " + coordinates[0] + "; LON: " + coordinates[1]);

	}

	private void handleRequestFromOtherHMI(String payload) {

		System.out.println("\nReceiving values from other HMI");
		System.out.println("Old Values: emergency level: " + emergencyLevel + "; location event: " + locationEvent);

		emergencyLevel = Integer.parseInt(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.EMERGENCY_LEVEL_STR));
		locationEvent  = Integer.parseInt(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.LOCATION_STR));

		System.out.println("New Values: emergency level: " + emergencyLevel + "; location event: " + locationEvent);

	}

	private void updateOtherHMI(String payload) {
		System.out.println("Updating the other HMI");


		int destinationPort;

		if(port == SmartAmbulanceSimulation.COCKPIT_PORT)
			destinationPort = SmartAmbulanceSimulation.REARCABIN_PORT;
		else
			destinationPort = SmartAmbulanceSimulation.COCKPIT_PORT;

		String updatePayload = String.format(
				"{\"%s\": \"%s\",\"%s\":%d,\"%s\":%d }",
				SimulationUtils.JSON_CLIENT_KEY, SimulationUtils.HMI_UPDATE_REQUEST,
				SmartAmbulanceSimulation.EMERGENCY_LEVEL_STR, emergencyLevel,
				SmartAmbulanceSimulation.LOCATION_STR, locationEvent);

		CoapClient coapClient = new CoapClient(SimulationUtils.LOCALHOST + ":" + destinationPort + "/" + SmartAmbulanceSimulation.RESOURCE_HMI);

		CoapResponse response = coapClient.put(updatePayload, MediaTypeRegistry.APPLICATION_JSON);

		if(response == null) {
			System.out.println("Error in updating the other HMI...");

		}
		else
		{
			System.out.println("The other HMI was updated successfully");
		}
	}
}
