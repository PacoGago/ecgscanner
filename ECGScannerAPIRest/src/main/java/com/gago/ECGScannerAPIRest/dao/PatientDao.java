package com.gago.ECGScannerAPIRest.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.gago.ECGScannerAPIRest.dto.PatientDTO;
import com.gago.ECGScannerAPIRest.model.Patient;

@Repository
public interface PatientDao extends CrudRepository<Patient, Integer> {
	
	@Query(value = "SELECT p FROM Patient p WHERE "
				 + "(p.hospital like %:hospital% OR :hospital is null) AND"
				 + "(p.weight = :weight OR :weight is null) AND"
				 + "(p.age = :age OR :age is null)")
	Page<PatientDTO> find(@Param(value="hospital") String hospital,
					   @Param(value="age") Integer age,
					   @Param(value="weight") Double weight, Pageable pages);

}
