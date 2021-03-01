package com.gago.ECGScannerAPIRest.dto;

import java.io.Serializable;
import java.util.ArrayList;

public class ECGDTO implements Serializable {

	private static final long serialVersionUID = 4990322289672892141L;
	
	private Integer id;
	
	private ArrayList<Double> values;
	
	private String file;
	
	public ECGDTO() {
		super();
	}
	
	public ECGDTO(Integer id, ArrayList<Double> values) {
		super();
		this.id = id;
		this.values = values;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public ArrayList<Double> getValues() {
		return values;
	}

	public void setValues(ArrayList<Double> values) {
		this.values = values;
	}

	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}
	
}
