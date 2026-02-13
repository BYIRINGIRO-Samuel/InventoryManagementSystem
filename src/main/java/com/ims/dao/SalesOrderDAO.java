package com.ims.dao;

import org.hibernate.Session;
import org.hibernate.query.Query;
import com.ims.model.SalesOrder;
import com.ims.util.HibernateUtil;

import java.util.List;

public class SalesOrderDAO extends BaseDAO<SalesOrder> {

    public SalesOrderDAO() {
        super(SalesOrder.class);
    }

    public List<SalesOrder> findAllOrders() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<SalesOrder> query = session.createQuery("FROM SalesOrder ORDER BY createdAt DESC", SalesOrder.class);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding sales orders", e);
        }
    }

    public SalesOrder findByOrderNumber(String orderNumber) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<SalesOrder> query = session.createQuery("FROM SalesOrder WHERE orderNumber = :orderNumber", SalesOrder.class);
            query.setParameter("orderNumber", orderNumber);
            return query.uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error finding sales order by number", e);
        }
    }

    public List<SalesOrder> findRecentOrders(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<SalesOrder> query = session.createQuery("FROM SalesOrder ORDER BY createdAt DESC", SalesOrder.class);
            query.setMaxResults(limit);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error finding recent sales orders", e);
        }
    }

    public java.math.BigDecimal findTotalSalesAmount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            java.math.BigDecimal sum = (java.math.BigDecimal) session.createQuery("SELECT COALESCE(SUM(totalAmount), 0) FROM SalesOrder").uniqueResult();
            return sum != null ? sum : java.math.BigDecimal.ZERO;
        } catch (Exception e) {
            throw new RuntimeException("Error summing total sales amount", e);
        }
    }
}
