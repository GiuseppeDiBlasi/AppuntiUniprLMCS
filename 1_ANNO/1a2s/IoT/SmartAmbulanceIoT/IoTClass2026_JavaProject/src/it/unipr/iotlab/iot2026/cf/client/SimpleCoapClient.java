package it.unipr.iotlab.iot2026.cf.client;

import org.eclipse.californium.core.CoapClient;
import org.eclipse.californium.core.CoapResponse;
import org.eclipse.californium.core.coap.CoAP.Code;
import org.eclipse.californium.core.coap.Request;
import org.eclipse.californium.core.Utils;

public class SimpleCoapClient {

	public static void main(String[] args) {
		System.out.println("Started SimpleCoapClient");
		
		CoapClient client = new CoapClient("coap://127.0.0.1:5683/observable-resource");
		
		Request request = new Request(Code.GET);
		
		CoapResponse coapResp = client.advanced(request);
		System.out.println(Utils.prettyPrint(coapResp));
	}

}
