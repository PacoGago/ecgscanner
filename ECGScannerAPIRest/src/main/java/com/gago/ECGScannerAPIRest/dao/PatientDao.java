package com.gago.ECGScannerAPIRest.dao;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.gago.ECGScannerAPIRest.model.Patient;

@Repository
public interface PatientDao extends CrudRepository<Patient, Integer> {
	
	@Query(value = "SELECT p FROM Patient p WHERE "
				 + "(p.hospital like %:hospital% OR :hospital is null)")
	List<Patient> find(@Param(value="hospital") String hospital, Pageable pages);
	
	
//	@Query(value = "SELECT p FROM Patient AS p WHERE "
//			 + "(p.hospital like %:hospital% OR :hospital is null) AND " 
//			 + "(p.age like %:age% OR :age is null) AND "
//			 + "(p.genre like %:genre% OR :genre is null) AND "
//			 + "(p.medication like %:medication% OR :medication is null) AND "
//			 + "(p.ecgmodel like %:ecgmodel% OR :ecgmodel is null) AND "
//			 + "(p.allergy like %:allergy% OR :allergy is null) AND "
//			 + "(p.hprovidence like %:hprovidence% OR :hprovidence is null) AND "
//			 + "(p.smoker like %:smoker% OR :smoker is null) AND "
//			 + "(p.weight like %:weight% OR :weight is null) AND "
//			 + "(p.height like %:height% OR :height is null)")
	
	
	
	
	

}
