package com.gago.ECGScannerAPIRest.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.RejectedExecutionException;
import java.util.stream.Collectors;
import java.util.stream.DoubleStream;

import javax.imageio.ImageIO;

import org.dozer.DozerBeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.gago.ECGScannerAPIRest.dao.ECGDao;
import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.exception.FileStorageException;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.mathworks.engine.MatlabEngine;

@Service
public class ECGServiceImpl implements ECGService {
	
	@Autowired
	private ECGDao ecgDao;
	
	@Autowired
	private DozerBeanMapper dozer;
	
	@Override
	public List<ECGDTO> findAll(){
		
		final Iterable<ECG> findAll = ecgDao.findAll();
		final Iterator<ECG> iterator = findAll.iterator();
		final List<ECGDTO> res = new ArrayList<>();
		while (iterator.hasNext()) {
			final ECG e = iterator.next();
			final ECGDTO eDTO = transform(e);
			res.add(eDTO);
		}
		
		return res;
		
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
	public ECGDTO create(ECGDTO ecg){
		
		final ECG e = transform(ecg);
		
		final ECGDTO eDTO = transform(ecgDao.save(e));
		
		return eDTO;
	}
	
	@Override
	public ECGDTO findById(Integer id) throws NoECGException {
		
		final Optional<ECG> e = ecgDao.findById(id);
		
		if (e == null){
			throw new NoECGException();
		}else{
			return transform(e.get());
		}	
	}
	
	@Override
	public void delete(ECGDTO eDTO) throws NoECGException {
		
		Optional<ECG> e = ecgDao.findById(eDTO.getId());
		
		if (e == null){
			throw new NoECGException();	
		}else{
			ecgDao.deleteById(eDTO.getId());
		}
	}
	
	@Override
	public void deleteById(Integer id) throws NoECGException {
		ecgDao.deleteById(id);	
	}
	
	@Override
	public ECGDTO update(ECGDTO eDTO) throws NoECGException{
		
		Optional<ECG> e = ecgDao.findById(eDTO.getId());
		
		if (e == null){
			throw new NoECGException();
		}else{
			ecgDao.save(transform(eDTO));
			return eDTO;
		}
	}
	
	@Override
	public ECGDTO digitalizeImage(MultipartFile file) throws FileStorageException, IllegalArgumentException, IllegalStateException, InterruptedException, RejectedExecutionException, ExecutionException {
		
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());

        try {
        	
            if(fileName.contains("..")) {
                throw new FileStorageException();
            }

            // Copiamos el fichero en una carpeta (esta parte es innecesaria)
            Path targetLocation = Paths.get("/Users/gago/Dropbox/Proyecto/Dev/testupload/" + fileName);
            
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
                      
            // ******************************* SCRIPT MATLAB *******************************
            
            Future<MatlabEngine> engine = MatlabEngine.startMatlabAsync();
            MatlabEngine eng = engine.get();
            
	            // Directorio donde se almacenan las funciones de matLab
	            eng.eval("cd /Users/gago/Dropbox/Proyecto/Dev/repo/ecgscanner/ECGScannerAPIRest/src/main/resources/external/");
	            
	            File f = new File("/Users/gago/Dropbox/Proyecto/Dev/testupload/" + fileName);
	            BufferedImage img = ImageIO.read(f);
	            
	            // Asi llamamos a la funcion que queremos ejecutar
	            double res[] = eng.feval("main", f.getAbsolutePath());
            
            eng.close();
            
            // ******************************* END SCRIPT MATLAB ****************************
            
            ECGDTO ecgdto = new ECGDTO();
            ArrayList<Double> values = DoubleStream.of(res).boxed().collect(Collectors.toCollection(ArrayList::new));
            ecgdto.setValues(values);
            
            return create(ecgdto);
            
        } catch (IOException ex) {
            throw new FileStorageException();
        }
        
	}
}
