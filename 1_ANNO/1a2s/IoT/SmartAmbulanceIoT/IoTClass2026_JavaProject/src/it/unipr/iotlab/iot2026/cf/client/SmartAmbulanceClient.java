package it.unipr.iotlab.iot2026.cf.client;

import org.eclipse.californium.core.CoapClient;
import org.eclipse.californium.core.CoapHandler;
import org.eclipse.californium.core.CoapObserveRelation;
import org.eclipse.californium.core.CoapResponse;
import org.eclipse.californium.core.Utils;
import org.eclipse.californium.core.coap.MediaTypeRegistry;

import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;
import it.unipr.iotlab.iot2026.cf.utils.SimulationUtils;

public abstract class SmartAmbulanceClient {
	protected CoapClient client;
	protected int port;
	protected String clientString;
	
	protected CoapObserveRelation temperatureRelation;

	protected SmartAmbulanceClient(String c) {
		clientString = c;
	}
	
	public void changeServer(int port) {
		this.port = port;
	}
	
	
	public void observeTemperatureSensor() {
		System.out.println("--- " + clientString + " subscribing to Temp Sensor ---");

	    client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_TEMP_SENSOR);

	    temperatureRelation = client.observe(new CoapHandler() {

	        @Override
	        public void onLoad(CoapResponse response) {
	            System.out.println("--- " + clientString + " received temperature update ---");
	            System.out.println(Utils.prettyPrint(response));
	        }

	        @Override
	        public void onError() {
	            System.err.println("--- " + clientString + ": observe error on Temp Sensor ---");
	        }
	    });
	}

	public void stopObservingTemperature() {
	    if (temperatureRelation != null)
	        temperatureRelation.proactiveCancel();
	}
	
	public void GETRequestToHMI() {
		System.out.println("--- Driver sending a GET request to HMI ---");
		
		client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_HMI);
		CoapResponse coapResp = client.get();
		
		System.out.println(Utils.prettyPrint(coapResp));
	}
	
	
	public void PUTRequestToHMI() {
		System.out.println("---" + clientString +  " sending a PUT request to HMI ---");
		
		client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_HMI);
		
		int emergencyLevel = SimulationUtils.randomEmergencyLevel();
		int locationEvent = SimulationUtils.randomLocationEvent();
		
		String payload = String.format(
		        "{\"%s\": \"%s\",\"%s\":%d,\"%s\":%d }",
		        SimulationUtils.JSON_CLIENT_KEY, SimulationUtils.DRIVER_CLIENT,
		        SmartAmbulanceSimulation.EMERGENCY_LEVEL_STR, emergencyLevel,
		        SmartAmbulanceSimulation.LOCATION_STR, locationEvent);
				
		CoapResponse resp = client.put(payload, MediaTypeRegistry.APPLICATION_JSON);
	    System.out.println(Utils.prettyPrint(resp));
	    System.out.println("\n\n");
		
	}
	
	
	public void GETRequestToTempSensor() {
		System.out.println("--- " + clientString + " sending a GET request to Temp Sensor ---");
		
		client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_TEMP_SENSOR);
		CoapResponse coapResp = client.get();
		
		System.out.println(Utils.prettyPrint(coapResp));
	}
	
	
	public void GETRequestToACController() {
		System.out.println("--- " + clientString + " sending a GET request to AC Controller ---");
		
		client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_AC_CONTROLLER);
		CoapResponse coapResp = client.get();
		
		System.out.println(Utils.prettyPrint(coapResp));
	}
	
	
	public void PUTRequestToACController() {
		System.out.println("---" + clientString + " sending a PUT request to ACC ---");		
		
		
		client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_AC_CONTROLLER);
		
		int targetTemperature = SimulationUtils.randomTargetTemperature();
		
		String payload = String.format(
		        "{\"%s\": \"%s\",\"%s\":%d}",
		        SimulationUtils.JSON_CLIENT_KEY, clientString,
		        SmartAmbulanceSimulation.ACC_TEMP_TARGET, targetTemperature);
				
		CoapResponse resp = client.put(payload, MediaTypeRegistry.APPLICATION_JSON);
	    System.out.println(Utils.prettyPrint(resp));
	    System.out.println("\n\n");
	    		
	}
}
