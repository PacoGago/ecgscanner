package com.gago.ECGScannerAPIRest.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gago.ECGScannerAPIRest.dao.PatientDao;
import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.exception.NoPatientException;
import com.gago.ECGScannerAPIRest.model.Patient;
import com.gago.ECGScannerAPIRest.repository.PatientRepository;
import com.gago.ECGScannerAPIRest.service.PatientService;

@RestController
@RequestMapping(value = "/patient")
public class PatientController {
	
	@Autowired
	private PatientRepository patientrepository;

	@Autowired
	private PatientService patientservice;
	
	private static final Logger log = LoggerFactory.getLogger(PatientController.class);
	
	/**
	 * 
	 * Metodo para obtener todos los Pacientes almacenados en el repositorio
	 * 
	 * @return lista de ECGDTO
	 */
	@RequestMapping(value = "all", method = { RequestMethod.GET })
	public List<PatientDTO> getAll() {
		
		log.debug(String.format("Mostramos todos los Pacientes almacenados."));
		
		return patientservice.findAll();
	}
	
	/**
	 * 
	 * Metodo para obtener un paciente
	 * 
	 * @return lista de ECGDTO
	 * @throws NoPatientException 
	 */
	@RequestMapping(value = "/{id}", method = {RequestMethod.GET})
	public PatientDTO findOne(@PathVariable("id") Integer id) throws NoECGException, NoPatientException {
		
		log.debug(String.format("Recuperamos un Paciente por id: %s", id));
		
		return patientservice.findById(id);
	}
	
	/**
	 * 
	 * Metodo para obtener un ECG de un paciente
	 * 
	 * @return lista de ECGDTO
	 * @throws NoPatientException 
	 */
	@RequestMapping(value = "/ecg/{id}", method = {RequestMethod.GET})
	public ECGDTO findEcg(@PathVariable("id") Integer id) throws NoECGException, NoPatientException {
		
		log.debug(String.format("Recuperamos un ECG por id de paciente: %s", id));
		
		return patientservice.findEcgById(id);
	}
	
	/**
	 * 
	 * Metodo para obtener los pacientes almacenados con los siguientes filtros:
	 * 
	 * @param hospital
	 * @param age
	 * @param weight
	 * @param page
	 * @param size
	 * @return Listado de pacientes
	 * @throws NoPatientException
	 */
	@RequestMapping(method={RequestMethod.GET})
	public ResponseEntity<Map<String, Object>> get(@RequestParam(value="hospital",required=false) String hospital,
								@RequestParam(value="age",required=false) Integer age,
								@RequestParam(value="weight",required=false) Double weight,
								@RequestParam(value = "page", required = false, defaultValue = "0") Integer page,
								@RequestParam(value = "size", required = false, defaultValue = "10") Integer size) throws NoPatientException{
		
		List<Patient> patients = new ArrayList<Patient>();
		
		Page<Patient> pagePatientDTO = patientrepository.find(hospital, age, weight, PageRequest.of(page, size));
		patients = pagePatientDTO.getContent();
		
		Map<String, Object> response = new HashMap<>();
		
		response.put("pacientes", patients);
		response.put("currentPage", pagePatientDTO.getNumber());
		response.put("totalItems", pagePatientDTO.getTotalElements());
		response.put("totalPages", pagePatientDTO.getTotalPages());
				
		return new ResponseEntity<>(response, HttpStatus.OK);
		
	}
	
}
