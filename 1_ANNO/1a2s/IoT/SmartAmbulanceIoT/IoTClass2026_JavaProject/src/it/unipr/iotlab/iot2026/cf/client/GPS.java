package it.unipr.iotlab.iot2026.cf.client;

import org.eclipse.californium.core.CoapClient;
import org.eclipse.californium.core.CoapResponse;
import org.eclipse.californium.core.Utils;
import org.eclipse.californium.core.coap.MediaTypeRegistry;

import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;
import it.unipr.iotlab.iot2026.cf.utils.SimulationUtils;

public class GPS {
	private CoapClient client;

	
	private int port;
	
	public GPS(int port) {
		client = new CoapClient();
		this.port = port;
	}
	
	public void PUTRequestToHMI() {
		System.out.println("--- GPS sending a PUT request to HMI ---");
		
		client.setURI(SimulationUtils.LOCALHOST + ":" + port + "/" + SmartAmbulanceSimulation.RESOURCE_HMI);
		
		double[] gpsCoord = SimulationUtils.randomGPSCoordinates();
		
		String payload = String.format(
		        "{\"%s\": \"%s\",\"%s\":%f,\"%s\":%f }",
		        SimulationUtils.JSON_CLIENT_KEY, SimulationUtils.GPS_CLIENT,
		        SmartAmbulanceSimulation.LATITUDE_STR, gpsCoord[0],
		        SmartAmbulanceSimulation.LONGITUDE_STR, gpsCoord[1]);
				
		CoapResponse resp = client.put(payload, MediaTypeRegistry.APPLICATION_JSON);
	    System.out.println(Utils.prettyPrint(resp));
		
	}
}
