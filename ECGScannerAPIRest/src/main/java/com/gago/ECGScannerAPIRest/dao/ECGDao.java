package com.gago.ECGScannerAPIRest.dao;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.gago.ECGScannerAPIRest.model.ECG;

@Repository
public interface ECGDao extends CrudRepository<ECG, Integer>{

}
