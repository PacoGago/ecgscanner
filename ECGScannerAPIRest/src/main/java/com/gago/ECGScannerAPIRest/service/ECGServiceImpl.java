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
		
		double[] res = null;
		
		Future<MatlabEngine> engine = MatlabEngine.startMatlabAsync();
        MatlabEngine eng = engine.get();
        
        // Directorio donde se almacenan las funciones de matLab
        eng.eval("cd " + functionsDir);
        
        // Procesamos la imagen
        res = eng.feval("main", f.getAbsolutePath());
        
        eng.close();
        
        int[] QRS = detect(res);
        System.out.println(Arrays.toString(QRS));
		
		return res;
	}
	
	private static int[] detect(double[] ecg) {
		
		// circular buffer for input ecg signal
		// we need to keep a history of M + 1 samples for HP filter
		double[] ecg_circ_buff = new double[M + 1];
		int ecg_circ_WR_idx = 0;
		int ecg_circ_RD_idx = 0;
	
		// circular buffer for input ecg signal
		// we need to keep a history of N+1 samples for LP filter
		double[] hp_circ_buff = new double[N+1];
		int hp_circ_WR_idx = 0;
		int hp_circ_RD_idx = 0;		
	
		// LP filter outputs a single point for every input point
		// This goes straight to adaptive filtering for eval
		double next_eval_pt = 0;
		
		// output 
		int[] QRS = new int[ecg.length];
		
		// running sums for HP and LP filters, values shifted in FILO
		double hp_sum = 0;
		double lp_sum = 0;
        
        // parameters for adaptive thresholding
		double treshold = 0;
		boolean triggered = false;
		int trig_time = 0;
		double win_max = 0;
		int win_idx = 0;
			
		for(int i = 0; i < ecg.length; i++){
			ecg_circ_buff[ecg_circ_WR_idx++] = ecg[i];
			ecg_circ_WR_idx %= (M+1);
			
			/* High pass filtering */
			if(i < M){
				// first fill buffer with enough points for HP filter
				hp_sum += ecg_circ_buff[ecg_circ_RD_idx];
				hp_circ_buff[hp_circ_WR_idx] = 0;
			}
			else{
				hp_sum += ecg_circ_buff[ecg_circ_RD_idx];
				
				int tmp = ecg_circ_RD_idx - M;
				if(tmp < 0){
					tmp += M + 1;
				}
				hp_sum -= ecg_circ_buff[tmp];
				
				double y1 = 0;
				double y2 = 0;

				tmp = (ecg_circ_RD_idx - ((M+1)/2));
				if(tmp < 0){
					tmp += M + 1;
				}
				y2 = ecg_circ_buff[tmp];

				y1 = HP_CONSTANT * hp_sum; 
				
				hp_circ_buff[hp_circ_WR_idx] = y2 - y1;
			}
			
			ecg_circ_RD_idx++;
			ecg_circ_RD_idx %= (M+1);
			
			hp_circ_WR_idx++;
			hp_circ_WR_idx %= (N+1);
				
			/* Low pass filtering */
			
			// shift in new sample from high pass filter
			lp_sum += hp_circ_buff[hp_circ_RD_idx] * hp_circ_buff[hp_circ_RD_idx];
			
			if(i < N){
				// first fill buffer with enough points for LP filter
				next_eval_pt = 0;
				
			}
			else{
				// shift out oldest data point
				int tmp = hp_circ_RD_idx - N;
				if(tmp < 0){
					tmp += N+1;
				}					
				lp_sum -= hp_circ_buff[tmp] * hp_circ_buff[tmp];
				
				next_eval_pt = lp_sum;
			}
			
			hp_circ_RD_idx++;
			hp_circ_RD_idx %= (N+1);
			
			/* Adapative thresholding beat detection */
			// set initial threshold				
			if(i < winSize) {
				if(next_eval_pt > treshold) {
					treshold = next_eval_pt;
				}
			}
        
			// check if detection hold off period has passed
			if(triggered){
				trig_time++;
			
				if(trig_time >= 100){
					triggered = false;
					trig_time = 0;
				}
			}

			// find if we have a new max
			if(next_eval_pt > win_max) win_max = next_eval_pt;

			// find if we are above adaptive threshold
            if(next_eval_pt > treshold && !triggered) {
				QRS[i] = 1;

				triggered = true;
            }
            else {
				QRS[i] = 0;
            }
            
			// adjust adaptive threshold using max of signal found 
			// in previous window            
	    	if(++win_idx > winSize){
				// weighting factor for determining the contribution of
				// the current peak value to the threshold adjustment
	        	double gamma = 0.175;
	        	
	        	// forgetting factor - 
	        	// rate at which we forget old observations
				double alpha = 0.01 + (Math.random() * ((0.1 - 0.01)));
				
				treshold = alpha * gamma * win_max + (1 - alpha) * treshold;
		
				// reset current window ind
				win_idx = 0;
				win_max = -10000000;
            }
		}

		return QRS;
	}

	@Override
	public File findImageById(Integer id) throws NoECGException {
		
		ECGDTO ecgdto = findById(id);
		
		File f = new File(uploadDir + ecgdto.getFile());
		
		return f;
	}
	
}
