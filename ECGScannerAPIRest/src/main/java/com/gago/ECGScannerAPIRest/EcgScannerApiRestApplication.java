package com.gago.ECGScannerAPIRest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.gago.ECGScannerAPIRest.security.JWTAuthorizationFilter;

import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableScheduling
@EnableAutoConfiguration
@EnableSwagger2
public class EcgScannerApiRestApplication {

	public static void main(String[] args) {
		SpringApplication.run(EcgScannerApiRestApplication.class, args);
	}
	
	@EnableWebSecurity
	@Configuration
	class WebSecurityConfig extends WebSecurityConfigurerAdapter {
		
		@Override
		protected void configure(HttpSecurity http) throws Exception {
			http.csrf().disable()
				.addFilterAfter(new JWTAuthorizationFilter(), UsernamePasswordAuthenticationFilter.class)
				.authorizeRequests()
				//.antMatchers(HttpMethod.POST, "/user").permitAll()
				.antMatchers("/user","/v2/api-docs", 
		        		"/swagger-resources/configuration/ui", 
		        		"/swagger-resources", 
		        		"/swagger-resources/configuration/security", 
		        		"/swagger-ui/**", 
		        		"/webjars/**").permitAll()
				.anyRequest().authenticated();
			
		}
	}

}
