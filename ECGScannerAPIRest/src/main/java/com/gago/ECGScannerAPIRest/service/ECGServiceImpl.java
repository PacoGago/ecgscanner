package com.gago.ECGScannerAPIRest.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.util.ArrayList;
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
import com.gago.ECGScannerAPIRest.dao.PatientDao;
import com.gago.ECGScannerAPIRest.dto.ECGDTO;
import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.exception.FileStorageException;
import com.gago.ECGScannerAPIRest.exception.NoECGException;
import com.gago.ECGScannerAPIRest.model.ECG;
import com.gago.ECGScannerAPIRest.model.Patient;
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
	private PatientDao patientDao;
	
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
	public PatientDTO transform(Patient p) {
		return dozer.map(p, PatientDTO.class);
	}
	
	@Override
	public Patient transform(PatientDTO p) {
		return dozer.map(p, Patient.class);
	}
	
	@Override
	public ECGDTO create(ECGDTO ecg){
		
		final ECG e = transform(ecg);
		
		final ECGDTO eDTO = transform(ecgDao.save(e));
		
		return eDTO;
	}
	
	public PatientDTO create(Patient p) {
		
		return transform(patientDao.save(p));
		
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
	public ECGDTO digitalizeImage(MultipartFile file, String genre, Integer age, Double weight, Double height, 
			Double bmi, Boolean smoker, String allergy, String chronic, String medication, String hospital, 
			String hospitalProvidence, String origin, String ecgModel, Double bodypresssystolic, 
			Double bodypressdiastolic, Double bodytemp, Double glucose, String reason, String ecgType, 
			Double heartRate) throws FileStorageException, IllegalArgumentException, 
			IllegalStateException, InterruptedException, RejectedExecutionException, ExecutionException {
		
		if (!file.isEmpty()) {
			
			// Usamos un nombre seguro
	        String fileName = getSecureName(file);
	       
	        try {
	        	Patient p = new Patient();
	        	ECGDTO ecgdto = new ECGDTO();
	        	
	            if(fileName.contains("..")) {
	                throw new FileStorageException();
	            }

	            // Copiamos el fichero en una carpeta (esta parte es innecesaria)
	            Path targetLocation = Paths.get(uploadDir + fileName);
	            
	            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
	            File f = new File(uploadDir + fileName);
	            
	            // Digitalizamos la imagen y nos quedamos con los valores de la funcion
	            double[] ecgdigi = digitalizacion(f,ecgdto);
	            
	            // Conversion
	            ArrayList<Double> values = DoubleStream.of(ecgdigi).boxed().collect(Collectors.toCollection(ArrayList::new));
	            
	            if (!StringUtils.isEmpty(genre)){p.setGenre(genre);}
	            if (age != null){p.setAge(age);}
	            if (weight != null){p.setWeight(weight);}
	            if (height != null){p.setHeight(height);}
	            if (bmi != null){p.setBmi(bmi);}
	            if (smoker != null){p.setSmoker(smoker);}
	            if (!StringUtils.isEmpty(allergy)){p.setAllergy(allergy);}
	            if (!StringUtils.isEmpty(chronic)){p.setChronic(chronic);}
	            if (!StringUtils.isEmpty(medication)){p.setMedication(medication);}
	            if (!StringUtils.isEmpty(hospital)){p.setHospital(hospital);}
	            if (!StringUtils.isEmpty(hospitalProvidence)){p.setHospitalProvidence(hospitalProvidence);}
	            if (!StringUtils.isEmpty(origin)){p.setOrigin(origin);}
	            if (!StringUtils.isEmpty(ecgModel)){p.setEcgModel(ecgModel);}
	            if (bodypresssystolic != null){p.setBodypresssystolic(bodypresssystolic);}
	            if (bodypressdiastolic != null){p.setBodypressdiastolic(bodypressdiastolic);}
	            if (bodytemp != null){p.setBodytemp(bodytemp);}
	            if (glucose != null){p.setGlucose(glucose);}
	            if (!StringUtils.isEmpty(reason)){p.setReason(reason);}
	            if (!StringUtils.isEmpty(ecgType)){p.setEcgType(ecgType);}
	            if (heartRate != null){p.setHeartRate(heartRate);}
	            
	            ecgdto.setValues(values);
	            ecgdto.setFile(fileName);
	            p.setEcg(transform(ecgdto));
	            
	            ECGDTO e = create(ecgdto);
	            create(p);
	            
	            return e;
	            
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
	
	private double[] digitalizacion(File f, ECGDTO ecg) throws MatlabExecutionException, MatlabSyntaxException, CancellationException, EngineException, InterruptedException, ExecutionException {
		
		Object[] res = null;
		double[] values;
		
		Future<MatlabEngine> engine = MatlabEngine.startMatlabAsync();
        MatlabEngine eng = engine.get();
        
        
        // Directorio donde se almacenan las funciones de matLab
        eng.eval("cd " + functionsDir);
        
        // Procesamos la imagen
        // feval(numero de argumentos a recibir, nombre de la funciona a ejecutar, argumentos a pasar)
        //double[] values = eng.feval("main", f.getAbsolutePath());
        
        
        //System.out.println("ECG: " + Arrays.toString(values));
        // Aqui deberiamos determinar si con la digitalizacion
        // que hemos conseguido podemos o no llamar al pantompkins
        // dado que si no posee la suficiente longitud no funciona
        
        
        res = eng.feval(2,"main", f.getAbsolutePath());
        values = (double[]) res[0];
        String[] R = (String[]) res[1];
        Double heartRate = Double.parseDouble(R[0]);
        Double rMSSD = Double.parseDouble(R[1]);
        Double SDNN = Double.parseDouble(R[2]);
        Double mRR = Double.parseDouble(R[3]);
        
        ecg.setHeartRate(heartRate);
        ecg.setrMSSD(rMSSD);
        ecg.setSDNN(SDNN);
        ecg.setmRR(mRR);
       
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

