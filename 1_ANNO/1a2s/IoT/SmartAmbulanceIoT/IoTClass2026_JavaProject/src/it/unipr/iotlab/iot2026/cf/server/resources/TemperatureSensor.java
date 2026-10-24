package it.unipr.iotlab.iot2026.cf.server.resources;

import java.util.Timer;
import java.util.TimerTask;

import org.eclipse.californium.core.CoapResource;
import org.eclipse.californium.core.coap.CoAP.ResponseCode;
import org.eclipse.californium.core.coap.MediaTypeRegistry;
import org.eclipse.californium.core.server.resources.CoapExchange;

import it.unipr.iotlab.iot2026.cf.sim.SmartAmbulanceSimulation;

// Make the temperature sensor update with time when the ACC controller receives a PUT
// Use timerTask
public class TemperatureSensor extends CoapResource{
	private int currentTemperature;
	private int targetTemp;
	
	private Timer timer;
	
	public TemperatureSensor(String name) {
		super(name);
		timer =  new Timer();
		
		setObservable(true);                        
        setObserveType(org.eclipse.californium.core.coap.CoAP.Type.CON);
	}
	
	@Override
	public void handleGET(CoapExchange exchange) {
		String payload = String.format(
		        "{\"%s\":%d}",
		        SmartAmbulanceSimulation.TEMPERATURE_SENSOR, currentTemperature);
		
		exchange.respond(ResponseCode.CONTENT, payload, MediaTypeRegistry.APPLICATION_JSON);
	}
	
	public void setTargetTemperature(int targetTemp) {
		this.targetTemp = targetTemp;
		updateTemperature();
	}
	
	private void updateTemperature() {
		timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
            	//System.out.println(currentTemperature);
            	if (currentTemperature == targetTemp)
            		this.cancel();
            	
                if (currentTemperature > targetTemp)
                	--currentTemperature;
                else 
                	++currentTemperature;
                
                changed();
            }
        }, 0, 1500);
	}
}
