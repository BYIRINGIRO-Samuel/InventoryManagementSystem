package com.ims.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

import com.ims.model.*;

public class H2HibernateUtil {
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
    
    public static void initializeSampleData() {
        if (sessionFactory == null) {
            return; // Should be initialized by static block or caller
        }
        
        org.hibernate.Session session = sessionFactory.openSession();
        org.hibernate.Transaction transaction = null;
        try {
            transaction = session.beginTransaction();
            
            // 1. Create Default Admin User
            Long userCount = (Long) session.createQuery("select count(u) from User u where u.username = 'admin'").uniqueResult();
            if (userCount == 0) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setFullName("Administrator");
                admin.setEmail("admin@stockio.com");
                admin.setPassword(PasswordUtil.hashPassword("admin123"));
                admin.setRole(User.Role.ADMIN);
                session.save(admin);
            }
            
            // 2. Create Categories
            Category electronics = (Category) session.createQuery("from Category where name = 'Electronics'").uniqueResult();
            if (electronics == null) {
                electronics = new Category();
                electronics.setName("Electronics");
                electronics.setDescription("Electronic devices and accessories");
                session.save(electronics);
            }
            
            Category furniture = (Category) session.createQuery("from Category where name = 'Furniture'").uniqueResult();
            if (furniture == null) {
                furniture = new Category();
                furniture.setName("Furniture");
                furniture.setDescription("Office and home furniture");
                session.save(furniture);
            }
            
            // 3. Create Suppliers
            Supplier techSupply = (Supplier) session.createQuery("from Supplier where name = 'TechSupply Co.'").uniqueResult();
            if (techSupply == null) {
                techSupply = new Supplier();
                techSupply.setName("TechSupply Co.");
                techSupply.setContactPerson("John Doe");
                techSupply.setEmail("contact@techsupply.com");
                techSupply.setPhone("123-456-7890");
                session.save(techSupply);
            }
            
            // 4. Create Sample Products
            Product laptop = (Product) session.createQuery("from Product where sku = 'LAP-001'").uniqueResult();
            if (laptop == null) {
                laptop = new Product();
                laptop.setSku("LAP-001");
                laptop.setName("Laptop Pro");
                laptop.setDescription("High-performance laptop for professionals");
                laptop.setPrice(new java.math.BigDecimal("1200.00"));
                laptop.setQuantityInStock(25);
                laptop.setCategory(electronics);
                laptop.setSupplier(techSupply);
                session.save(laptop);
            }
            
            Product desk = (Product) session.createQuery("from Product where sku = 'DSK-001'").uniqueResult();
            if (desk == null) {
                desk = new Product();
                desk.setSku("DSK-001");
                desk.setName("Office Desk");
                desk.setDescription("Ergonomic wooden desk");
                desk.setPrice(new java.math.BigDecimal("350.00"));
                desk.setQuantityInStock(10);
                desk.setCategory(furniture);
                desk.setSupplier(techSupply);
                session.save(desk);
            }
            
            transaction.commit();
            System.out.println("H2 Database initialization checked/completed (Admin: admin / admin123)");
            
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}