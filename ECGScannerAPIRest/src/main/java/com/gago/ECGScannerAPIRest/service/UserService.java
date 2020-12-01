package com.gago.ECGScannerAPIRest.service;

import com.gago.ECGScannerAPIRest.dto.User;

public interface UserService {
	
	User autenticate(String username, String pwd);

}
