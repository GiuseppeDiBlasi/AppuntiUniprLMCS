package it.unipr.iotlab.iot2026.cf.server.resources;

import org.eclipse.californium.core.CoapResource;
import org.eclipse.californium.core.coap.CoAP.ResponseCode;
import org.eclipse.californium.core.coap.MediaTypeRegistry;
import org.eclipse.californium.core.server.resources.CoapExchange;

public class HelloWorldResource extends CoapResource {
	
	// Constructor
	public HelloWorldResource(String name) {
		super(name);
		
	}

	@Override
	public void handleGET(CoapExchange exchange) {
		System.out.println("New GET request");
		
		exchange.respond(
				ResponseCode.CONTENT,
				"Hello World!",
				MediaTypeRegistry.TEXT_PLAIN);
	}
}
