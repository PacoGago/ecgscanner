package com.gago.ECGScannerAPIRest.dao;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.gago.ECGScannerAPIRest.model.ECG;
import com.gago.ECGScannerAPIRest.model.User;

@Repository
public interface UserDao extends CrudRepository<User, Integer>{

}
