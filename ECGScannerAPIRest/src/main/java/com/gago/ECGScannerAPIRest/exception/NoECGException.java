package com.gago.ECGScannerAPIRest.exception;

public class NoECGException extends Exception {

	private static final long serialVersionUID = -4253296020454822073L;
	
	private static final String msg = "ECG no encontrado.";
	
	public NoECGException() {
		super(msg);
	}
}
