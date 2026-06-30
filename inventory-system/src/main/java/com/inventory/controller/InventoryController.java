package com.inventory.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.ArrayList;
import java.util.List;

@Controller
public class InventoryController {

    @GetMapping("/")
    public String showDashboard(Model model) {
        // Sample static data for your Inventory Management demo
        List<String> items = new ArrayList<>();
        items.add("Laptop - 15 Units Available");
        items.add("Wireless Mouse - 45 Units Available");
        items.add("Mechanical Keyboard - 20 Units Available");
        items.add("Monitor 24\" - 12 Units Available");

        model.addAttribute("inventoryItems", items);
        model.addAttribute("appName", "Inventory Management System");
        
        return "dashboard";
    }
}
