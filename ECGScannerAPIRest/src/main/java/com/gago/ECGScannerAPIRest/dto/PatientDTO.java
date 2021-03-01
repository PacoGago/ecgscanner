package com.gago.ECGScannerAPIRest.dto;

import java.io.Serializable;

import com.gago.ECGScannerAPIRest.model.ECG;

public class PatientDTO implements Serializable {

	private static final long serialVersionUID = -5894888479258449787L;
	
	private Integer id;
	private String genre;
	private Integer age;
	private Double weight;
	private Double height;
	private Double bmi;
	private Boolean smoker;
	private String allergy;
	private String chronic;
	private String medication;
	private String hospital;
	private String hospitalProvidence;
	private String origin;
	private String ecgModel;
	private Double bodypresssystolic;
	private Double bodypressdiastolic;
	private Double bodytemp;
	private Double glucose;
	private String reason;
	private String ecgType;
	private Double heartRate;
	private ECG ecg;
	
	
	public PatientDTO() {
		super();
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public Double getWeight() {
		return weight;
	}

	public void setWeight(Double weight) {
		this.weight = weight;
	}

	public Double getHeight() {
		return height;
	}

	public void setHeight(Double height) {
		this.height = height;
	}

	public Double getBmi() {
		return bmi;
	}

	public void setBmi(Double bmi) {
		this.bmi = bmi;
	}

	public Boolean getSmoker() {
		return smoker;
	}

	public void setSmoker(Boolean smoker) {
		this.smoker = smoker;
	}

	public String getAllergy() {
		return allergy;
	}

	public void setAllergy(String allergy) {
		this.allergy = allergy;
	}

	public String getChronic() {
		return chronic;
	}

	public void setChronic(String chronic) {
		this.chronic = chronic;
	}

	public String getMedication() {
		return medication;
	}

	public void setMedication(String medication) {
		this.medication = medication;
	}

	public String getHospital() {
		return hospital;
	}

	public void setHospital(String hospital) {
		this.hospital = hospital;
	}

	public String getHospitalProvidence() {
		return hospitalProvidence;
	}

	public void setHospitalProvidence(String hospitalProvidence) {
		this.hospitalProvidence = hospitalProvidence;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getEcgModel() {
		return ecgModel;
	}

	public void setEcgModel(String ecgModel) {
		this.ecgModel = ecgModel;
	}

	public Double getBodypresssystolic() {
		return bodypresssystolic;
	}

	public void setBodypresssystolic(Double bodypresssystolic) {
		this.bodypresssystolic = bodypresssystolic;
	}

	public Double getBodypressdiastolic() {
		return bodypressdiastolic;
	}

	public void setBodypressdiastolic(Double bodypressdiastolic) {
		this.bodypressdiastolic = bodypressdiastolic;
	}

	public Double getBodytemp() {
		return bodytemp;
	}

	public void setBodytemp(Double bodytemp) {
		this.bodytemp = bodytemp;
	}

	public Double getGlucose() {
		return glucose;
	}

	public void setGlucose(Double glucose) {
		this.glucose = glucose;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getEcgType() {
		return ecgType;
	}

	public void setEcgType(String ecgType) {
		this.ecgType = ecgType;
	}

	public Double getHeartRate() {
		return heartRate;
	}

	public void setHeartRate(Double heartRate) {
		this.heartRate = heartRate;
	}

	public ECG getEcg() {
		return ecg;
	}

	public void setEcg(ECG ecg) {
		this.ecg = ecg;
	}

}
