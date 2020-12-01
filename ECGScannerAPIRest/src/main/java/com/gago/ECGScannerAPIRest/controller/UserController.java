package com.gago.ECGScannerAPIRest.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gago.ECGScannerAPIRest.dto.User;
import com.gago.ECGScannerAPIRest.service.UserService;

@RestController
public class UserController {
	
	@Autowired
	private UserService userservice;

	@PostMapping("user")
	public User login(@RequestParam("user") String username, @RequestParam("password") String pwd) {
		
		return userservice.autenticate(username, pwd);
		
	}
	
}
