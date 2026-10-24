package it.unipr.iotlab.iot2026.cf.server;

import org.eclipse.californium.core.CoapServer;

import it.unipr.iotlab.iot2026.cf.server.resources.AirConditioningController;
import it.unipr.iotlab.iot2026.cf.server.resources.HMI;
import it.unipr.iotlab.iot2026.cf.server.resources.TemperatureSensor;
import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;

//	Has the following resources:
//	TemperatureSensor, AirConditionController, HMI

public class Cockpit extends CoapServer{
	
	public Cockpit(int port) throws Exception {
		super(port);
		
		TemperatureSensor tempSensor = new TemperatureSensor(SmartAmbulanceSimulation.RESOURCE_TEMP_SENSOR);
		AirConditioningController acc = new AirConditioningController(SmartAmbulanceSimulation.RESOURCE_AC_CONTROLLER, tempSensor, port);
		HMI hmi = new HMI(SmartAmbulanceSimulation.RESOURCE_HMI, port);
		

		this.add(tempSensor)
		 	   .add(acc)
		 	   .add(hmi);
	}
	
}
