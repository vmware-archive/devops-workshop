package io.pivotal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.builders.WebSecurity;

@EnableDiscoveryClient
@EnableFeignClients
@SpringBootApplication
public class CloudNativeSpringUiApplication {

	public static void main(String[] args) {
		SpringApplication.run(CloudNativeSpringUiApplication.class, args);
	}

	@Configuration
	static class ApplicationSecurityOverride extends WebSecurityConfigurerAdapter {

    	@Override
    	public void configure(WebSecurity web) throws Exception {
        	web
           		.ignoring()
               		.antMatchers("/**");
    	}
	}
}
