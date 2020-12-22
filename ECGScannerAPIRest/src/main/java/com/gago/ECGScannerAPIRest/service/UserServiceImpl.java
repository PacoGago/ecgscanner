package com.gago.ECGScannerAPIRest.service;

import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.stream.Collectors;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Service;

import com.gago.ECGScannerAPIRest.controller.ECGController;
import com.gago.ECGScannerAPIRest.dto.User;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Service
public class UserServiceImpl implements UserService{
	
	private static final Logger log = LoggerFactory.getLogger(ECGController.class);
	
	@Override
	public User autenticate(String username, String pwd) {
		
		String token = getJWTToken(username);
		User user = new User();
		
		if(performAuthentication(username,pwd)) {
			user.setUser(username);
			user.setToken(token);
			user.setPwd("null");
		}else {
			user.setUser(username);
		}
		
		return user;
	}
	
	private String getJWTToken(String username) {
		
		String secretKey = "mySecretKey";
		List<GrantedAuthority> grantedAuthorities = AuthorityUtils
				.commaSeparatedStringToAuthorityList("ROLE_USER");
		
		String token = Jwts
				.builder()
				.setId("softtekJWT")
				.setSubject(username)
				.claim("authorities",
						grantedAuthorities.stream()
								.map(GrantedAuthority::getAuthority)
								.collect(Collectors.toList()))
				.setIssuedAt(new Date(System.currentTimeMillis()))
				.setExpiration(new Date(System.currentTimeMillis() + 600000))
				.signWith(SignatureAlgorithm.HS512,
						secretKey.getBytes()).compact();

		return "Bearer " + token;
	}
	
	private static boolean performAuthentication(String user, String pwd) {

	    // service user
	    String serviceUserDN = "cn=Francisco Gago,ou=Users,dc=example,dc=com";
	    String serviceUserPassword = "password";

	    // user to authenticate
	    String identifyingAttribute = "uid";
	    String identifier = user;
	    String password = pwd;
	    String base = "ou=Users,dc=example,dc=com";

	    // LDAP connection info
	    String ldap = "localhost";
	    int port = 10389;
	    String ldapUrl = "ldap://" + ldap + ":" + port;

	    // first create the service context
	    DirContext serviceCtx = null;
	    
	    try {
	    	
	        // servicio para la autenticacion
	        Properties serviceEnv = new Properties();
	        serviceEnv.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
	        serviceEnv.put(Context.PROVIDER_URL, ldapUrl);
	        serviceEnv.put(Context.SECURITY_AUTHENTICATION, "simple");
	        serviceEnv.put(Context.SECURITY_PRINCIPAL, serviceUserDN);
	        serviceEnv.put(Context.SECURITY_CREDENTIALS, serviceUserPassword);
	        serviceCtx = new InitialDirContext(serviceEnv);

	        // para la autenticacion solo usaremos los atributos necesarios
	        String[] attributeFilter = { identifyingAttribute };
	        SearchControls sc = new SearchControls();
	        sc.setReturningAttributes(attributeFilter);
	        sc.setSearchScope(SearchControls.SUBTREE_SCOPE);

	        // usamos un filtro de busqueda para encontrar solo el usuario que buscamos
	        String searchFilter = "(" + identifyingAttribute + "=" + identifier + ")";
	        NamingEnumeration<SearchResult> results = serviceCtx.search(base, searchFilter, sc);

	        if (results.hasMore()) {
	        	
	        	// obtenemos el DN (distinguishedName)  del usuario resultante
	            SearchResult result = results.next();
	            String distinguishedName = result.getNameInNamespace();

	            // intentamos autenticar al usuario
	            Properties authEnv = new Properties();
	            authEnv.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
	            authEnv.put(Context.PROVIDER_URL, ldapUrl);
	            authEnv.put(Context.SECURITY_PRINCIPAL, distinguishedName);
	            authEnv.put(Context.SECURITY_CREDENTIALS, password);
	            new InitialDirContext(authEnv);

	            log.info("Authentication user: " + identifier + " successful");
	            return true;
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        
	    } finally {
	        if (serviceCtx != null) {
	            try {
	                serviceCtx.close();
	            } catch (NamingException e) {
	                e.printStackTrace();
	            }
	        }
	    }
	    
	    log.info("Authentication user: " + identifier + " failed");
	    return false;
	}

}
