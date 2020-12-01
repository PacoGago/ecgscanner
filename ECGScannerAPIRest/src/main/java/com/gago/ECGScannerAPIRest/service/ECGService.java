package com.gago.ECGScannerAPIRest.service;

import java.io.File;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.RejectedExecutionException;

import org.springframework.web.multipart.MultipartFile;

import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.exception.FileStorageException;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.mathworks.engine.EngineException;

public interface ECGService {
	
	List<ECGDTO> findAll();
	ECGDTO transform(ECG ecg);
	ECG transform(ECGDTO ecg);
	ECGDTO create(ECGDTO book);
	void delete(ECGDTO eDTO) throws NoECGException;
	ECGDTO update(ECGDTO eDTO) throws NoECGException;
	void deleteById(Integer id) throws NoECGException;
	ECGDTO findById(Integer id) throws NoECGException;
	ECGDTO digitalizeImage(MultipartFile file) throws FileStorageException, EngineException, IllegalArgumentException, IllegalStateException, InterruptedException, RejectedExecutionException, ExecutionException;
	File findImageById(Integer id) throws NoECGException;

}
