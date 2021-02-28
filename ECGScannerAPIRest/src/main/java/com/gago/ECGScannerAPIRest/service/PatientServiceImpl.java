package com.gago.ECGScannerAPIRest.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

import org.dozer.DozerBeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.gago.ECGScannerAPIRest.dao.PatientDao;
import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.exception.NoPatientException;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.gago.ECGScannerAPIRest.model.Patient;

@Service
public class PatientServiceImpl implements PatientService{
	
	@Autowired
	private PatientDao patientDao;
	
	@Autowired
	private DozerBeanMapper dozer;
	
	@Override
	public List<PatientDTO> findAll(){
		
		final Iterable<Patient> findAll = patientDao.findAll();
		final Iterator<Patient> iterator = findAll.iterator();
		final List<PatientDTO> res = new ArrayList<>();
		while (iterator.hasNext()) {
			final Patient p = iterator.next();
			final PatientDTO pDTO = transform(p);
			res.add(pDTO);
		}
		
		return res;
		
	}

	@Override
	public PatientDTO transform(Patient p) {
		return dozer.map(p, PatientDTO.class);
	}

	@Override
	public Patient transform(PatientDTO pDTO) {
		return dozer.map(pDTO, Patient.class);
	}
	
	@Override
	public ECGDTO transform(ECG ecg) {
		return dozer.map(ecg, ECGDTO.class);
	}
	
	@Override
	public ECG transform(ECGDTO ecg) {
		return dozer.map(ecg, ECG.class);
	}
	
	@Override
	public List<PatientDTO> transform(List<Patient> patients) {
		
		final Iterator<Patient> it = patients.iterator();
		final List<PatientDTO> patientsDTO = new ArrayList<>();
		
		while (it.hasNext()) {
			final Patient p = it.next();
			final PatientDTO pDTO = transform(p);
			patientsDTO.add(pDTO);
		}
		
		return patientsDTO;
	}

	@Override
	public PatientDTO findById(Integer id) throws NoPatientException{

		final Optional<Patient> p = patientDao.findById(id);
		
		if (p == null) {
			throw new NoPatientException();
		}else {
			return transform(p.get());
		}
	}

	@Override
	public ECGDTO findEcgById(Integer id) throws NoPatientException, NoECGException {
		
		final Optional<ECG> e = Optional.of(findById(id).getEcg());
		
		if (e == null) {
			throw new NoECGException();
		}else {
			return transform(e.get());
		}
		
	}

	@Override
	public List<PatientDTO> find(String hospital, Pageable pages) throws NoPatientException {
		
		List<PatientDTO> patients;
		
		if (pages.getPageSize()>10) {
			patients = transform(patientDao.find(hospital, PageRequest.of(pages.getPageNumber(),10)));
		}else {
			patients = transform(patientDao.find(hospital, pages));
		}
		
		
		if (patients.isEmpty()) {
			throw new NoPatientException();
		}else {
			return patients;
		}
		
	}

}
