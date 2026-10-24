package it.unipr.iotlab.iot2026.cf.client;

import org.eclipse.californium.core.CoapClient;

import it.unipr.iotlab.iot2026.cf.utils.SimulationUtils;

public class Driver extends SmartAmbulanceClient{
		
	public Driver(int port) {
		super(SimulationUtils.DRIVER_CLIENT);
		
		client = new CoapClient();
		this.port = port;
		
	}
	

}
