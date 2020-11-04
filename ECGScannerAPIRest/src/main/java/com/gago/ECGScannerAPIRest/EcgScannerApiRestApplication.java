package com.gago.ECGScannerAPIRest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableScheduling
@EnableAutoConfiguration
@EnableSwagger2
public class EcgScannerApiRestApplication {

	public static void main(String[] args) {
		SpringApplication.run(EcgScannerApiRestApplication.class, args);
	}

}
