package it.unipr.iotlab.iot2026.cf.server.resources;

import org.eclipse.californium.core.CoapResource;
import org.eclipse.californium.core.coap.CoAP.ResponseCode;
import org.eclipse.californium.core.coap.MediaTypeRegistry;
import org.eclipse.californium.core.server.resources.CoapExchange;

import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;
import it.unipr.iotlab.iot2026.cf.utils.SimulationUtils;

public class AirConditioningController extends CoapResource{
	private int targetTemperature;
	private final TemperatureSensor tempSensor;
	private final int port;

	public AirConditioningController(String name, TemperatureSensor tempSensor, int port) throws Exception {
		super(name);

		targetTemperature = 18;

		if(tempSensor == null)
			throw new Exception("TemperaureSensor object is null");

		this.tempSensor = tempSensor;
		this.port = port;
	}

	@Override
	public void handleGET(CoapExchange exchange) {

		String payload = String.format(
				"{\"%s\":%d}",
				SmartAmbulanceSimulation.EMERGENCY_LEVEL_STR, targetTemperature);

		exchange.respond(ResponseCode.CONTENT, payload, MediaTypeRegistry.APPLICATION_JSON);
	}

	@Override
	public void handlePUT(CoapExchange exchange) {
		System.out.println("--- " + this.getURI() + " --- ");

		String payload = exchange.getRequestText();

		String senderClient = SimulationUtils.extractJsonValue(payload, SimulationUtils.JSON_CLIENT_KEY);

		if (senderClient.equals(SimulationUtils.RELIEVER_CLIENT) && port == SmartAmbulanceSimulation.COCKPIT_PORT){

			exchange.respond(ResponseCode.FORBIDDEN);
			return;
		}

		System.out.println("Received a PUT request from: " + senderClient);
		System.out.println("Old Value: targetTemperature: " + targetTemperature);

		targetTemperature  = Integer.parseInt(SimulationUtils.extractJsonValue(payload, SmartAmbulanceSimulation.ACC_TEMP_TARGET));
		System.out.println("New Value: targetTemperature: " + targetTemperature);

		exchange.respond(ResponseCode.CHANGED);
		tempSensor.setTargetTemperature(targetTemperature);

		System.out.println("-------------- ACC Handle Put ---------------------------------");
	}
}
