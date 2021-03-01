package com.gago.ECGScannerAPIRest.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.gago.ECGScannerAPIRest.model.Healthcheck;

@RestController
@RequestMapping(value = "/")
public class HealthcheckController {
	
	private static final Logger log = LoggerFactory.getLogger(HealthcheckController.class);
	
	@GetMapping("/healthcheck")
	public Healthcheck getHealthcheck() {
		
		log.debug(String.format("Healthcheck"));
		
		Healthcheck healthcheck = new Healthcheck();
		healthcheck.setStatus("up");
		
		return healthcheck;
	}
	
}
