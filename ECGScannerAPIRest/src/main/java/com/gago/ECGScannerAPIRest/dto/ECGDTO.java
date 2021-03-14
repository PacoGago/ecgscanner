package com.gago.ECGScannerAPIRest.dto;

import java.io.Serializable;
import java.util.ArrayList;

public class ECGDTO implements Serializable {

	private static final long serialVersionUID = 4990322289672892141L;
	
	private Integer id;
	
	private ArrayList<Double> values;
	
	private String file;
	
	private Double heartRate;
	private Double rMSSD;
	private Double SDNN;
	private Double mRR;
	
	public ECGDTO() {
		super();
	}
	
	public ECGDTO(Integer id, ArrayList<Double> values) {
		super();
		this.id = id;
		this.values = values;
	}
	
	public Double getHeartRate() {
		return heartRate;
	}

	public void setHeartRate(Double heartRate) {
		this.heartRate = heartRate;
	}

	public Double getrMSSD() {
		return rMSSD;
	}

	public void setrMSSD(Double rMSSD) {
		this.rMSSD = rMSSD;
	}

	public Double getSDNN() {
		return SDNN;
	}

	public void setSDNN(Double sDNN) {
		SDNN = sDNN;
	}

	public Double getmRR() {
		return mRR;
	}

	public void setmRR(Double mRR) {
		this.mRR = mRR;
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
