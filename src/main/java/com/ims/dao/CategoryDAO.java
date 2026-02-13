package com.ims.dao;

import org.hibernate.Session;
import org.hibernate.query.Query;
import com.ims.model.Category;
import com.ims.util.HibernateUtil;

public class CategoryDAO extends BaseDAO<Category> {
    
    public CategoryDAO() {
        super(Category.class);
    }
    
    public Category findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Category> query = session.createQuery("FROM Category WHERE name = :name", Category.class);
            query.setParameter("name", name);
            return query.uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error finding category by name", e);
        }
    }
    
    public boolean existsByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Category WHERE name = :name", Long.class);
            query.setParameter("name", name);
            return query.uniqueResult() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Error checking category name existence", e);
        }
    }
}