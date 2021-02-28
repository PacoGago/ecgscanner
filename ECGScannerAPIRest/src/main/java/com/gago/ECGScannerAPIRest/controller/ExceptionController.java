package com.gago.ECGScannerAPIRest.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.gago.ECGScannerAPIRest.dto.ExceptionDTO;
import com.gago.ECGScannerAPIRest.exception.FileStorageException;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.exception.NoPatientException;

@ControllerAdvice(basePackages= {"com.gago.ECGScannerAPIRest.controller"})
public class  ExceptionController {

	@ResponseBody
	@ExceptionHandler(FileStorageException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public ExceptionDTO error(FileStorageException e){
		return new ExceptionDTO(404,e.getMessage());
	}
	
	@ResponseBody
	@ExceptionHandler(NoECGException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public ExceptionDTO error(NoECGException e){
		return new ExceptionDTO(404,e.getMessage());
	}
	
	@ResponseBody
	@ExceptionHandler(NoPatientException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public ExceptionDTO error(NoPatientException e){
		return new ExceptionDTO(404,e.getMessage());
	}
	
}
