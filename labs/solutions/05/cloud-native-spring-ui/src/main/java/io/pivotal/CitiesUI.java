package io.pivotal;

import java.util.Collection;
import java.util.Collections;

import javax.annotation.PostConstruct;

import com.vaadin.flow.component.html.H2;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.server.PWA;
import com.vaadin.flow.theme.Theme;
import com.vaadin.flow.theme.material.Material;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.Resources;
import org.vaadin.crudui.crud.impl.GridCrud;

import io.pivotal.domain.City;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Route(value = "")
@Theme(Material.class)
@PWA(name = "Cities UI, Vaadin Flow with Spring", shortName = "Cities UI")
public class CitiesUI extends VerticalLayout {

    private static final long serialVersionUID = 1L;

    private final CityClient client;
    private final GridCrud<City> crud;

    @Autowired
    public CitiesUI(CityClient client) {
        this.client = client;
        this.crud = new GridCrud<>(City.class);
    }

    @PostConstruct
    protected void init() {
        H2 title = new H2("Cities");
        crud.getGrid().setColumns("id", "name", "county", "stateCode", "postalCode", "latitude", "longitude");
        crud.getCrudFormFactory().setVisibleProperties("name", "county", "stateCode", "postalCode", "latitude", "longitude");
        crud.getCrudFormFactory().setUseBeanValidation(true);
        crud.setFindAllOperation(this::getCities);
        crud.setAddOperation(this::addCity);
        crud.setUpdateOperation(this::updateCity);
        crud.setDeleteOperation(this::deleteCity);
        add(title, crud);
        setSizeFull();
    }

    private Collection<City> getCities() {
        Resources<City> resources = client.findAll(0, 500);
        Collection<City> cities = Collections.emptyList();
        if (resources != null) {
            log.trace(resources.toString());
            cities = resources.getContent();
            log.debug("Fetched {} cities.", cities.size());
            if (!cities.isEmpty()) {
                crud.getGrid().setHeightByRows(true);
            }
        }
        return cities;
    }

    private City addCity(City city) {
        log.trace("City to be added is {}", city.toString());
        return client.add(city);
    }

    private City updateCity(City city) {
        log.trace("City to be updated is {}", city.toString());
        return client.update(city.getId(), city);
    }

    private void deleteCity(City city) {
        log.trace("City to be deleted", city.toString());
        client.delete(city.getId());
    }
}