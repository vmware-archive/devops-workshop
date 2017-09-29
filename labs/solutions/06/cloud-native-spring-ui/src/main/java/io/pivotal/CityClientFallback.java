package io.pivotal;

import java.util.Collections;
import org.springframework.stereotype.Component;
import org.springframework.hateoas.Resources;
import io.pivotal.domain.City;

@Component
public class CityClientFallback implements CityClient {
	@Override
	public Resources<City> getCities() {
		//We'll just return an empty response
		return new Resources<City>(Collections.emptyList());
	}
}