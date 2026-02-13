package com.ims.dao;

import org.hibernate.Session;
import org.hibernate.query.Query;
import com.ims.model.Product;
import com.ims.util.HibernateUtil;

import java.util.List;

public class ProductDAO extends BaseDAO<Product> {
    
    public ProductDAO() {
        super(Product.class);
    }
    
    public Product findBySku(String sku) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Product> query = session.createQuery("FROM Product WHERE sku = :sku", Product.class);
            query.setParameter("sku", sku);
            return query.uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error finding product by SKU", e);
        }
    }
    
    public List<Product> findByCategory(Long categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Product> query = session.createQuery("FROM Product WHERE category.id = :categoryId AND active = true", Product.class);
            query.setParameter("categoryId", categoryId);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding products by category", e);
        }
    }
    
    public List<Product> findBySupplier(Long supplierId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Product> query = session.createQuery("FROM Product WHERE supplier.id = :supplierId AND active = true", Product.class);
            query.setParameter("supplierId", supplierId);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding products by supplier", e);
        }
    }
    
    public List<Product> findLowStockProducts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Product> query = session.createQuery("FROM Product WHERE quantityInStock <= reorderLevel AND active = true", Product.class);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding low stock products", e);
        }
    }
    
    public List<Product> searchProducts(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Product> query = session.createQuery(
                "FROM Product WHERE (name LIKE :searchTerm OR sku LIKE :searchTerm OR description LIKE :searchTerm) AND active = true", 
                Product.class
            );
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error searching products", e);
        }
    }
    
    public List<Product> findActiveProducts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Product> query = session.createQuery("FROM Product WHERE active = true ORDER BY name", Product.class);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding active products", e);
        }
    }
    
    public boolean existsBySku(String sku) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Product WHERE sku = :sku", Long.class);
            query.setParameter("sku", sku);
            return query.uniqueResult() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Error checking SKU existence", e);
        }
    }
}