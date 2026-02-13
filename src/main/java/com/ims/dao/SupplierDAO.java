package com.ims.dao;

import org.hibernate.Session;
import org.hibernate.query.Query;
import com.ims.model.Supplier;
import com.ims.util.HibernateUtil;

import java.util.List;

public class SupplierDAO extends BaseDAO<Supplier> {
    
    public SupplierDAO() {
        super(Supplier.class);
    }
    
    public Supplier findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Supplier> query = session.createQuery("FROM Supplier WHERE name = :name", Supplier.class);
            query.setParameter("name", name);
            return query.uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error finding supplier by name", e);
        }
    }
    
    public List<Supplier> searchSuppliers(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Supplier> query = session.createQuery(
                "FROM Supplier WHERE name LIKE :searchTerm OR contactPerson LIKE :searchTerm OR email LIKE :searchTerm", 
                Supplier.class
            );
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error searching suppliers", e);
        }
    }
    
    public boolean existsByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Supplier WHERE name = :name", Long.class);
            query.setParameter("name", name);
            return query.uniqueResult() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Error checking supplier name existence", e);
        }
    }
}