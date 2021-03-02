package com.gago.ECGScannerAPIRest.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.gago.ECGScannerAPIRest.model.Patient;

public interface PatientRepository extends JpaRepository<Patient, Long>{
	
	@Query(value = "SELECT p FROM Patient p WHERE "
			 + "(p.hospital like %:hospital% OR :hospital is null) AND"
			 + "(p.weight = :weight OR :weight is null) AND"
			 + "(p.height = :height OR :height is null) AND"
			 + "(p.bodypresssystolic = :bodypresssystolic OR :bodypresssystolic is null) AND"
			 + "(p.bodypressdiastolic = :bodypressdiastolic OR :bodypressdiastolic is null) AND"
			 + "(p.bodytemp = :bodytemp OR :bodytemp is null) AND"
			 + "(p.glucose = :glucose OR :glucose is null) AND"
			 + "(p.heartRate = :heartRate OR :heartRate is null) AND"
			 + "(p.bmi = :bmi OR :bmi is null) AND"
			 + "(p.smoker = :smoker OR :smoker is null) AND"
			 + "(p.genre like %:genre% OR :genre is null) AND"
			 + "(p.allergy like %:allergy% OR :allergy is null) AND"
			 + "(p.chronic like %:chronic% OR :chronic is null) AND"
			 + "(p.medication like %:medication% OR :medication is null) AND"
			 + "(p.hospitalProvidence like %:hospitalProvidence% OR :hospitalProvidence is null) AND"
			 + "(p.origin like %:origin% OR :origin is null) AND"
			 + "(p.ecgModel like %:ecgModel% OR :ecgModel is null) AND"
			 + "(p.reason like %:reason% OR :reason is null) AND"
			 + "(p.ecgType like %:ecgType% OR :ecgType is null) AND"
			 + "(p.age = :age OR :age is null)")
	Page<Patient> find(@Param(value="hospital") String hospital,
				   	   @Param(value="age") Integer age,
				   	   @Param(value="weight") Double weight,
				   	   @Param(value="height") Double height, 
				   	   @Param(value="genre") String genre,  
				   	   @Param(value="bmi") Double bmi,  
				   	   @Param(value="smoker") Boolean smoker,  
				   	   @Param(value="allergy") String allergy,  
				   	   @Param(value="chronic") String chronic,  
				   	   @Param(value="medication") String medication,  
				   	   @Param(value="hospitalProvidence") String hospitalProvidence,  
				   	   @Param(value="origin") String origin,  
				   	   @Param(value="ecgModel") String ecgModel,  
				   	   @Param(value="bodypresssystolic") Double bodypresssystolic,  
				   	   @Param(value="bodypressdiastolic") Double bodypressdiastolic,  
				   	   @Param(value="bodytemp") Double bodytemp,  
				   	   @Param(value="glucose") Double glucose,  
				   	   @Param(value="reason") String reason,  
				   	   @Param(value="ecgType") String ecgType,  
				   	   @Param(value="heartRate") Double heartRate,
				   	   Pageable pages);
	

}
