package com.gago.ECGScannerAPIRest.exception;

public class NoPatientException extends Exception {

	private static final long serialVersionUID = -1239881588119833256L;
	
	private static final String msg = "Paciente no encontrado.";
	
	public NoPatientException() {
		super(msg);
	}

}
