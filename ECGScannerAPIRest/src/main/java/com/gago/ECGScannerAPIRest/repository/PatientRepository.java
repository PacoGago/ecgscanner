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
			 + "(p.age = :age OR :age is null)")
	Page<Patient> find(@Param(value="hospital") String hospital,
				   @Param(value="age") Integer age,
				   @Param(value="weight") Double weight, Pageable pages);

}
