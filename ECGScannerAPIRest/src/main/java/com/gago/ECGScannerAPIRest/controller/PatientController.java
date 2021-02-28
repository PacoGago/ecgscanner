package com.gago.ECGScannerAPIRest.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.exception.NoPatientException;
import com.gago.ECGScannerAPIRest.service.PatientService;

@RestController
@RequestMapping(value = "/patient")
public class PatientController {

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
	
	@RequestMapping(method={RequestMethod.GET})
	public List<PatientDTO> get(@RequestParam(value="hospital",required=false) String hospital,
							@RequestParam(value = "page", required = false, defaultValue = "0") Integer page,
							@RequestParam(value = "size", required = false, defaultValue = "10") Integer size) throws NoPatientException{
		
		return patientservice.find(hospital, PageRequest.of(page, size));
		
	}
						
	
	
}
