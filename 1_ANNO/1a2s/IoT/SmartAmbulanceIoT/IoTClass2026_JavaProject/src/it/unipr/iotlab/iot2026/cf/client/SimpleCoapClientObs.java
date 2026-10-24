package it.unipr.iotlab.iot2026.cf.client;

import org.eclipse.californium.core.CoapClient;
import org.eclipse.californium.core.CoapHandler;
import org.eclipse.californium.core.CoapResponse;

public class SimpleCoapClientObs {

	public static void main(String[] args) {
		CoapClient client = new CoapClient("coap://127.0.0.1:5683/observable-resource");

		client.observe(new CoapHandler() {
			@Override
			public void onLoad(CoapResponse response) {
				System.out.println(response.getResponseText());

			}

			@Override
			public void onError() {
				// TODO Auto-generated method stub

			}
		});
		
		try {
			Thread.sleep(3000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
