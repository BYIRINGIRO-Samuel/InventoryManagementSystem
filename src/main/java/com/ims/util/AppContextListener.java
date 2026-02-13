package com.ims.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Web application starting up...");
        try {
            // Trigger Hibernate initialization
            HibernateUtil.getSessionFactory();
            
            // Populate sample data
            H2HibernateUtil.initializeSampleData();
            
            System.out.println("Hibernate SessionFactory initialized and sample data populated.");
        } catch (Exception e) {
            System.err.println("CRITICAL: Hibernate initialization failed!");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Web application shutting down...");
        HibernateUtil.shutdown();
    }
}
