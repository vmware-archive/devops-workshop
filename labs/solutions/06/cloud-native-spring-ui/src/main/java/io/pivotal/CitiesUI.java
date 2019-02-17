package io.pivotal;

import java.util.ArrayList;
import java.util.Collection;

import javax.annotation.PostConstruct;

import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.server.PWA;
import com.vaadin.flow.theme.Theme;
import com.vaadin.flow.theme.material.Material;

import org.springframework.beans.factory.annotation.Autowired;

import io.pivotal.domain.City;

@Route("cities-ui")
@Theme(Material.class)
@PWA(name = "Cities UI, Vaadin Flow with Spring", shortName = "Cities UI")
public class CitiesUI extends VerticalLayout {

    private static final long serialVersionUID = 1L;

    private final CityClient client;

    @Autowired
    public CitiesUI(CityClient client) {
        this.client = client;
    }

    @PostConstruct
    protected void init() {
        Grid<City> grid = new Grid<>(City.class);
        Collection<City> cities = new ArrayList<>();
        // fetch cities from back-end service
        client.getCities().forEach(cities::add);
        grid.setItems(cities);
        // influence order of column headers for display
        grid.setColumns("id", "name", "county", "stateCode", "postalCode", "latitude", "longitude");
        add(grid);
    }
}