package it.unipr.iotlab.iot2026.cf.server;

import org.eclipse.californium.core.CoapServer;

import it.unipr.iotlab.iot2026.cf.server.resources.HelloWorldResource;
import it.unipr.iotlab.iot2026.cf.server.resources.ObsResource;


public class TutorialServer extends CoapServer {

	public static void main(String[] args) {
		TutorialServer tutorialServer = new TutorialServer();
		
		HelloWorldResource helloResource = new HelloWorldResource("hello-world");
		
		ObsResource obsResource = new ObsResource("observable-resource");
		obsResource.setVisible(true);
		
		tutorialServer.add(helloResource);
		tutorialServer.add(obsResource);
		
		tutorialServer.start();

	}

}
