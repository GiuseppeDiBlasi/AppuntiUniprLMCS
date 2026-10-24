package it.unipr.iotlab.iot2026.cf.server;

import org.eclipse.californium.core.CoapServer;

import it.unipr.iotlab.iot2026.cf.server.resources.AirConditioningController;
import it.unipr.iotlab.iot2026.cf.server.resources.HMI;
import it.unipr.iotlab.iot2026.cf.server.resources.TemperatureSensor;
import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;

public class RearCabin extends CoapServer{

	
	public RearCabin(int port) throws Exception {
		//The rear cabin server will listen on port 5683
		super(port);
		
		TemperatureSensor tempSensor = new TemperatureSensor(SmartAmbulanceSimulation.RESOURCE_TEMP_SENSOR);
		AirConditioningController acc = new AirConditioningController(SmartAmbulanceSimulation.RESOURCE_AC_CONTROLLER, tempSensor, port);
		HMI hmi = new HMI(SmartAmbulanceSimulation.RESOURCE_HMI, port);
		
		// add resources
		this.add(tempSensor)
				 .add(acc)
				 .add(hmi);
	}
	
}
