package it.unipr.iotlab.iot2026.cf.client;

import org.eclipse.californium.core.CoapClient;

import it.unipr.iotlab.iot2026.cf.utils.SimulationUtils;

public class Reliever extends SmartAmbulanceClient{

	
	public Reliever( int port) {
		super(SimulationUtils.RELIEVER_CLIENT);
		
		client = new CoapClient();
		this.port = port;
		
	}
		
}
