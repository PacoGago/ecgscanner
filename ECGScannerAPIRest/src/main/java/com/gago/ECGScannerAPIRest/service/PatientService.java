package com.gago.ECGScannerAPIRest.service;

import java.util.List;

import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.exception.NoPatientException;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.gago.ECGScannerAPIRest.model.Patient;

public interface PatientService {
	
	List<PatientDTO> findAll();
	PatientDTO transform(Patient p);
	Patient transform(PatientDTO pDTO);
	ECGDTO transform(ECG ecg);
	ECG transform(ECGDTO ecg);
	List<PatientDTO> transform(List<Patient> patients);
	PatientDTO findById(Integer id)  throws NoPatientException;
	ECGDTO findEcgById(Integer id) throws NoPatientException, NoECGException;

}
