package com.gago.ECGScannerAPIRest.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.RejectedExecutionException;
import java.util.stream.Collectors;
import java.util.stream.DoubleStream;

import org.apache.commons.io.FilenameUtils;
import org.dozer.DozerBeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.gago.ECGScannerAPIRest.constants.ConstantsUtils;
import com.gago.ECGScannerAPIRest.dao.ECGDao;
import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.exception.FileStorageException;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.mathworks.engine.EngineException;
import com.mathworks.engine.MatlabEngine;
import com.mathworks.engine.MatlabExecutionException;
import com.mathworks.engine.MatlabSyntaxException;

@Service
public class ECGServiceImpl implements ECGService {
	
	public static final int M = 5;
    public static final int N = 30;
    public static final int winSize = 250;
    public static final float HP_CONSTANT = (float) 1/M;
	
	@Value("${file.upload-dir}")
	private String uploadDir;
	
	@Value("${matlab.functions-dir}")
	private String functionsDir;
	
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
		
		if (!file.isEmpty()) {
			
			// Usamos un nombre seguro
	        String fileName = getSecureName(file);
	       
	        try {
	        	
	            if(fileName.contains("..")) {
	                throw new FileStorageException();
	            }

	            // Copiamos el fichero en una carpeta (esta parte es innecesaria)
	            Path targetLocation = Paths.get(uploadDir + fileName);
	            
	            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
	            File f = new File(uploadDir + fileName);
	            
	            // Digitalizamos la imagen y nos quedamos con los valores de la funcion
	            double[] ecgdigi = digitalizacion(f);
	            
	            // Conversion
	            ArrayList<Double> values = DoubleStream.of(ecgdigi).boxed().collect(Collectors.toCollection(ArrayList::new));
	            ECGDTO ecgdto = new ECGDTO();
	            ecgdto.setValues(values);
	            ecgdto.setFile(fileName);
	            
	            return create(ecgdto);
	            
	        } catch (IOException ex) {
	            throw new FileStorageException();
	        }
			
		}else {
			throw new FileStorageException();
		}
		
	}
	
	private String getSecureName(MultipartFile file) {

		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());
		String extension = FilenameUtils.getExtension(fileName);
		
		fileName = FilenameUtils.getBaseName(fileName);
		
		fileName = fileName + ConstantsUtils.HYPHEN + timestamp.getTime() + ConstantsUtils.DOT + extension;
		
		return fileName;
	}
	
	private double[] digitalizacion(File f) throws MatlabExecutionException, MatlabSyntaxException, CancellationException, EngineException, InterruptedException, ExecutionException {
		
		Object[] res = null;
		
		Future<MatlabEngine> engine = MatlabEngine.startMatlabAsync();
        MatlabEngine eng = engine.get();
        
        // Directorio donde se almacenan las funciones de matLab
        eng.eval("cd " + functionsDir);
        
        // Procesamos la imagen
        // feval(numero de argumentos a recibir, nombre de la funciona a ejecutar, argumentos a pasar)
        double[] values = eng.feval("main", f.getAbsolutePath());
        //System.out.println("ECG: " + Arrays.toString(values));
        // Aqui deberiamos determinar si con la digitalizacion
        // que hemos conseguido podemos o no llamar al pantompkins
        // dado que si no posee la suficiente longitud no funciona
        
        
       // res = eng.feval(5, "pantompkins_qrs", eng.feval("main", f.getAbsolutePath()), 500);
                                    
        //double[] qrs_pos = (double[]) res[0];
//        double[] filt_dat = (double[]) res[2];
//        double[] int_dat = (double[]) res[3];
//        double[] thF1 = (double[]) res[4];
//        double[] thI1 = (double[]) res[5];
//        
        //System.out.println("qrs_pos: " + Arrays.toString(qrs_pos));
//        System.out.println("filt_dat: " + Arrays.toString(filt_dat));
//        System.out.println("int_dat: " + Arrays.toString(int_dat));
//        System.out.println("thF1: " + Arrays.toString(thF1));
//        System.out.println("thI1: " + Arrays.toString(thI1));
        
        eng.close();
		
		return values;
	}
	
	
	@Override
	public File findImageById(Integer id) throws NoECGException {
		
		ECGDTO ecgdto = findById(id);
		
		File f = new File(uploadDir + ecgdto.getFile());
		
		return f;
	}
	
}

