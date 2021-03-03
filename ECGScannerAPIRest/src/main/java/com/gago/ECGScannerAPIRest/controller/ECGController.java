package com.gago.ECGScannerAPIRest.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.RejectedExecutionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.MediaType;

import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.exception.FileStorageException;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.model.Patient;
import com.gago.ECGScannerAPIRest.service.ECGService;
import com.mathworks.engine.EngineException;

@RestController
@RequestMapping(value = "/ecg")
public class ECGController {
	
	@Autowired
	private ECGService ecgservice;
	
	private static final Logger log = LoggerFactory.getLogger(ECGController.class);
	
	/**
	 * 
	 * Metodo para crear un ECG
	 * 
	 * @param ecg ECGDTO que contiene los datos del ECG a crear
	 * @return
	 */
	@RequestMapping(method = { RequestMethod.POST })
	public ECGDTO create(@RequestBody ECGDTO ecg){
		
		log.debug(String.format("Se crea el siguiente ECG: %s", ecg));
		
		return ecgservice.create(ecg);
	}
	
	/**
	 * 
	 * Metodo para obtener todos los ECG almacenados en el repositorio
	 * 
	 * @return lista de ECGDTO
	 */
	@RequestMapping(value = "all", method = { RequestMethod.GET })
	public List<ECGDTO> getAll() {
		
		log.debug(String.format("Mostramos todos los ECGs almacenadas."));
		
		return ecgservice.findAll();
	}
	
	@RequestMapping(value = "/{id}", method = {RequestMethod.GET})
	public ECGDTO findOne(@PathVariable("id") Integer id) throws NoECGException {
		
		log.debug(String.format("Recuperamos un ECG por id: %s", id));
		
		return ecgservice.findById(id);
	}
	
	/**
	 * 
	 * Metodo para borrar un ECG en concreto
	 * 
	 * @param eDTO ECGDTO ECG a borrar
	 * @throws NoECGException excepcion a mostrar en caso de no existir
	 * 
	 */
	@RequestMapping(method = {RequestMethod.DELETE})
	public void delete(@RequestBody ECGDTO eDTO) throws NoECGException{
		
		log.debug(String.format("Eliminamos un ECG con id: %s.", eDTO.getId()));
		
		ecgservice.delete(eDTO);
	}
	
	@RequestMapping(value = "/{id}", method = {RequestMethod.DELETE})
	public void delete(@PathVariable("id") Integer id) throws NoECGException{
		
		log.debug(String.format("Eliminamos un ECG por su id: %s", id));
		
		ecgservice.deleteById(id);
	}
	
	@RequestMapping(method = {RequestMethod.PUT})
	public ECGDTO update(@RequestBody ECGDTO eDTO) throws NoECGException{
		
		log.debug(String.format("Modificamo el ECG con id: %s.", eDTO.getId()));
		
		return ecgservice.update(eDTO);
	}
	
	@RequestMapping(value = "/upload", method = { RequestMethod.POST })
	public ECGDTO handleFileUpload(@RequestParam("file") MultipartFile file, 
			RedirectAttributes redirectAttributes,
			@RequestParam(name = "genre", required = false) String genre,
			@RequestParam(name = "age", required = false) Integer age,
			@RequestParam(name = "weight", required = false) Double weight,
			@RequestParam(name = "height", required = false) Double height,
			@RequestParam(name = "bmi", required = false) Double bmi,
			@RequestParam(name = "smoker", required = false) Boolean smoker,
			@RequestParam(name = "allergy", required = false) String allergy,
			@RequestParam(name = "chronic", required = false) String chronic,
			@RequestParam(name = "medication", required = false) String medication,
			@RequestParam(name = "hospital", required = false) String hospital,
			@RequestParam(name = "hospitalProvidence", required = false) String hospitalProvidence,
			@RequestParam(name = "origin", required = false) String origin,
			@RequestParam(name = "ecgModel", required = false) String ecgModel,
			@RequestParam(name = "bodypresssystolic", required = false) Double bodypresssystolic,
			@RequestParam(name = "bodypressdiastolic", required = false) Double bodypressdiastolic,
			@RequestParam(name = "bodytemp", required = false) Double bodytemp,
			@RequestParam(name = "glucose", required = false) Double glucose,
			@RequestParam(name = "reason", required = false) String reason,
			@RequestParam(name = "ecgType", required = false) String ecgType,
			@RequestParam(name = "heartRate", required = false) Double heartRate) throws FileStorageException, EngineException, IllegalArgumentException, IllegalStateException, RejectedExecutionException, InterruptedException, ExecutionException {
			
		return ecgservice.digitalizeImage(file, genre, age, weight, height, bmi, smoker, 
				allergy, chronic, medication, hospital, hospitalProvidence, origin, ecgModel, 
				bodypresssystolic, bodypressdiastolic, bodytemp, glucose, reason, ecgType, heartRate);
	}
	
	
	@RequestMapping(value = "/image/{id}", method = RequestMethod.GET,
            produces = MediaType.IMAGE_JPEG_VALUE)
    public ResponseEntity<byte[]> getImage(@PathVariable("id") Integer id) throws IOException, NoECGException {
        
		File imgFile = ecgservice.findImageById(id);
		
		byte[] bytes = Files.readAllBytes(imgFile.toPath());
        
		return ResponseEntity
                .ok()
                .contentType(MediaType.IMAGE_JPEG)
                .body(bytes);
    }

}
