package com.gago.ECGScannerAPIRest.exception;

public class FileStorageException extends Exception {

	private static final long serialVersionUID = -5248882382233819237L;
	
	private static final String msg = "Fichero no compatible.";
	
	public FileStorageException() {
		super(msg);
	}

}
