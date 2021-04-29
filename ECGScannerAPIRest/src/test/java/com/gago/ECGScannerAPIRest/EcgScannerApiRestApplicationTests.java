package com.gago.ECGScannerAPIRest;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.gago.ECGScannerAPIRest.model.Healthcheck;
import com.gago.ECGScannerAPIRest.model.Patient;
import com.gago.ECGScannerAPIRest.service.ECGService;

@SpringBootTest
class EcgScannerApiRestApplicationTests {
	
	@MockBean
    private ECGService ecgservice;
	
	@Test
	void heartRateDTO() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setHeartRate(1.0);
		assertEquals(1.0,ecgdto.getHeartRate());
	}
	
	@Test
	void mRRDTO() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setmRR(1.0);
		assertEquals(1.0,ecgdto.getmRR());
	}
	
	@Test
	void rMSSDDTO() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setrMSSD(1.0);
		assertEquals(1.0,ecgdto.getrMSSD());
	}
	
	@Test
	void SDNNDTO() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setSDNN(1.0);
		assertEquals(1.0,ecgdto.getSDNN());
	}
	
	@Test
	void valuesDTO() {
		
		ECGDTO ecgdto = new ECGDTO();
		ArrayList<Double> values = new ArrayList<>();
		values.add(1.0);
		ecgdto.setValues(values);
		
		assertEquals(1.0,ecgdto.getValues().get(0));
	}
	
	@Test
	void fileDTO() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setFile("file");
		
		assertEquals("file",ecgdto.getFile());
	}
	
	@Test
	void heartRate() {
		
		ECGDTO ecgdto = new ECGDTO();
		ecgdto.setHeartRate(1.0);
		assertEquals(1.0,ecgdto.getHeartRate());
	}
	
	@Test
	void mRR() {
		
		ECG ecg = new ECG();
		ecg.setmRR(1.0);
		assertEquals(1.0,ecg.getmRR());
	}
	
	@Test
	void rMSSD() {
		
		ECG ecg = new ECG();
		ecg.setrMSSD(1.0);
		assertEquals(1.0,ecg.getrMSSD());
	}
	
	@Test
	void SDNN() {
		
		ECG ecg = new ECG();
		ecg.setSDNN(1.0);
		assertEquals(1.0,ecg.getSDNN());
	}
	
	@Test
	void values() {
		
		ECG ecg = new ECG();
		ArrayList<Double> values = new ArrayList<>();
		values.add(1.0);
		ecg.setValues(values);
		
		assertEquals(1.0,ecg.getValues().get(0));
	}
	
	@Test
	void file() {
		
		ECG ecg = new ECG();
		ecg.setFile("file");
		
		assertEquals("file",ecg.getFile());
	}
	
	@Test
	void status() {
		
		Healthcheck healthcheck = new Healthcheck();
		healthcheck.setStatus("up");
		
		assertEquals("up",healthcheck.getStatus());
	}
	
	@Test
	void patientEcg() {
		
		ECG ecg = new ECG();
		ecg.setFile("file");
		ecg.setHeartRate(1.0);
		ecg.setmRR(2.0);
		ecg.setrMSSD(3.0);
		ecg.setSDNN(4.0);
		ArrayList<Double> values = new ArrayList<>();
		values.add(5.0);
		ecg.setValues(values);
		
		Patient patient = new Patient();
		patient.setEcg(ecg);
		
		assertEquals("file",patient.getEcg().getFile());
		assertEquals(1.0,patient.getEcg().getHeartRate());
		assertEquals(2.0,patient.getEcg().getmRR());
		assertEquals(3.0,patient.getEcg().getrMSSD());
		assertEquals(4.0,patient.getEcg().getSDNN());
		assertEquals(5.0,patient.getEcg().getValues().get(0));
	}
	
	@Test
	void genre() {
		
		Patient patient = new Patient();
		patient.setGenre("genre");
		
		assertEquals("genre",patient.getGenre());
	}
	
	@Test
	void age() {
		
		Patient patient = new Patient();
		patient.setAge(30);
		
		assertEquals(30,patient.getAge());
	}
	
	@Test
	void weight() {
		
		Patient patient = new Patient();
		patient.setWeight(1.0);
		
		assertEquals(1.0,patient.getWeight());
	}
	
	@Test
	void height() {
		
		Patient patient = new Patient();
		patient.setHeight(1.0);
		
		assertEquals(1.0,patient.getHeight());
	}
	
	@Test
	void bmi() {
		
		Patient patient = new Patient();
		patient.setBmi(1.0);
		
		assertEquals(1.0,patient.getBmi());
	}
	
	@Test
	void smoker() {
		
		Patient patient = new Patient();
		patient.setSmoker(false);
		
		assertEquals(false,patient.getSmoker());
	}
	
	@Test
	void allergy() {
		
		Patient patient = new Patient();
		patient.setAllergy("allergy");
		
		assertEquals("allergy",patient.getAllergy());
	}
	
	@Test
	void chronic() {
		
		Patient patient = new Patient();
		patient.setChronic("chronic");
		
		assertEquals("chronic",patient.getChronic());
	}
	
	@Test
	void medication() {
		
		Patient patient = new Patient();
		patient.setMedication("medication");
		
		assertEquals("medication",patient.getMedication());
	}
	
	@Test
	void hospital() {
		
		Patient patient = new Patient();
		patient.setHospital("hospital");
		
		assertEquals("hospital",patient.getHospital());
	}
	
	@Test
	void hospitalProvidence() {
		
		Patient patient = new Patient();
		patient.setHospitalProvidence("hospitalProvidence");
		
		assertEquals("hospitalProvidence",patient.getHospitalProvidence());
	}
	
	@Test
	void origin() {
		
		Patient patient = new Patient();
		patient.setOrigin("origin");
		
		assertEquals("origin",patient.getOrigin());
	}
	
	@Test
	void ecgModel() {
		
		Patient patient = new Patient();
		patient.setEcgModel("ecgModel");
		
		assertEquals("ecgModel",patient.getEcgModel());
	}
	
	@Test
	void bodypresssystolic() {
		
		Patient patient = new Patient();
		patient.setBodypresssystolic(1.0);
		
		assertEquals(1.0,patient.getBodypresssystolic());
	}
	
	@Test
	void bodypressdiastolic() {
		
		Patient patient = new Patient();
		patient.setBodypressdiastolic(1.0);
		
		assertEquals(1.0,patient.getBodypressdiastolic());
	}
	
	@Test
	void bodytemp() {
		
		Patient patient = new Patient();
		patient.setBodytemp(1.0);
		
		assertEquals(1.0,patient.getBodytemp());
	}
	
	@Test
	void glucose() {
		
		Patient patient = new Patient();
		patient.setGlucose(1.0);
		
		assertEquals(1.0,patient.getGlucose());
	}
	
	@Test
	void reason() {
		
		Patient patient = new Patient();
		patient.setReason("reason");
		
		assertEquals("reason",patient.getReason());
	}
	
	@Test
	void ecgType() {
		
		Patient patient = new Patient();
		patient.setEcgType("ecgType");
		
		assertEquals("ecgType",patient.getEcgType());
	}
	

}
