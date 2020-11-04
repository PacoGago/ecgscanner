package com.gago.ECGScannerAPIRest.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.RejectedExecutionException;

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
		
		// Normalize file name
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
            
         // Matlab no acepta un fichero binario como tal para le paso de una funcion
            // Asi que convertimos el fichero binario a una matriz(3) con los cada uno de
            // los colores. Es decir, un pixel tedra tres valores (red, green, blue)
            int width = img.getWidth();
            int height = img.getHeight();
            int colors = 3;
            int matrix[][][] = new int[width][height][colors];
            
            
            for (int y = 0; y < height; y++){
               for (int x = 0; x < width; x++) {
             	  
                   int p = img.getRGB(x,y);
                   
                   matrix[x][y][0] = (p & 0x00ff0000) >> 16; //red
                   matrix[x][y][1] = (p & 0x0000ff00) >> 8;  //green
                   matrix[x][y][2] =  p & 0x000000ff; 	    //blue
               }
            }
            
            // Asi llamamos a la funcion que queremos ejecutar
            
            double test[] = eng.feval("main", f.getAbsolutePath());
            System.out.println(Arrays.toString(test));
            
            // Cerramos la conexion con el motor de MatLab
            eng.close();
            
         // ****************************** END SCRIPT MATLAB *******************************
            
            
        } catch (IOException ex) {
            throw new FileStorageException();
        }
        
		return null;
	}
}
