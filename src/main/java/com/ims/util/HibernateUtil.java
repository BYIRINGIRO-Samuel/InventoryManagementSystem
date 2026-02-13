package com.ims.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

import com.ims.model.*;

public class HibernateUtil {
    private static SessionFactory sessionFactory;
    
    static {
        try {
            Configuration configuration = new Configuration();
            
            // H2 Database connection properties (in-memory for demo)
            configuration.setProperty("hibernate.connection.driver_class", "org.h2.Driver");
            configuration.setProperty("hibernate.connection.url", "jdbc:h2:mem:stockio_db;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE");
            configuration.setProperty("hibernate.connection.username", "sa");
            configuration.setProperty("hibernate.connection.password", "");
            
            // Hibernate properties
            configuration.setProperty("hibernate.dialect", "org.hibernate.dialect.H2Dialect");
            configuration.setProperty("hibernate.hbm2ddl.auto", "create-drop");
            configuration.setProperty("hibernate.show_sql", "true");
            configuration.setProperty("hibernate.format_sql", "true");
            
            // Connection pool settings
            configuration.setProperty("hibernate.c3p0.min_size", "5");
            configuration.setProperty("hibernate.c3p0.max_size", "20");
            configuration.setProperty("hibernate.c3p0.timeout", "300");
            configuration.setProperty("hibernate.c3p0.max_statements", "50");
            configuration.setProperty("hibernate.c3p0.idle_test_period", "3000");
            
            // Add annotated classes
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Category.class);
            configuration.addAnnotatedClass(Supplier.class);
            configuration.addAnnotatedClass(Product.class);
            configuration.addAnnotatedClass(StockTransaction.class);
            configuration.addAnnotatedClass(SalesOrder.class);
            configuration.addAnnotatedClass(SalesOrderItem.class);
            
            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties()).build();
            
            sessionFactory = configuration.buildSessionFactory(serviceRegistry);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Initial SessionFactory creation failed: " + e);
        }
    }
    
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    
    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
