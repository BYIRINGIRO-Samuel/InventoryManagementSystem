package com.ims.dao;

import org.hibernate.Session;
import org.hibernate.query.Query;
import com.ims.model.StockTransaction;
import com.ims.util.HibernateUtil;

import java.time.LocalDateTime;
import java.util.List;

public class StockTransactionDAO extends BaseDAO<StockTransaction> {
    
    public StockTransactionDAO() {
        super(StockTransaction.class);
    }
    
    public List<StockTransaction> findByProduct(Long productId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<StockTransaction> query = session.createQuery(
                "FROM StockTransaction WHERE product.id = :productId ORDER BY createdAt DESC", 
                StockTransaction.class
            );
            query.setParameter("productId", productId);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding transactions by product", e);
        }
    }
    
    public List<StockTransaction> findByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<StockTransaction> query = session.createQuery(
                "FROM StockTransaction WHERE createdAt BETWEEN :startDate AND :endDate ORDER BY createdAt DESC", 
                StockTransaction.class
            );
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding transactions by date range", e);
        }
    }
    
    public List<StockTransaction> findRecentTransactions(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<StockTransaction> query = session.createQuery(
                "FROM StockTransaction ORDER BY createdAt DESC", 
                StockTransaction.class
            );
            query.setMaxResults(limit);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding recent transactions", e);
        }
    }
}