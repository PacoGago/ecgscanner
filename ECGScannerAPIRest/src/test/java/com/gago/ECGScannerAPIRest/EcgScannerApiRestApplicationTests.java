package com.gago.ECGScannerAPIRest;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.service.ECGService;

@SpringBootTest
class EcgScannerApiRestApplicationTests {
	
	@MockBean
    private ECGService ecgservice;
	
	@Test
	void it_should_return_created_ecg() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setHeartRate(1.0);
		
		assertEquals(1.0,ecgdto.getHeartRate());
		
	}

}
