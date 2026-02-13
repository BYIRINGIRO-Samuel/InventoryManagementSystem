package com.ims.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.ims.dao.ProductDAO;
import com.ims.dao.CategoryDAO;
import com.ims.dao.SupplierDAO;
import com.ims.dao.SalesOrderDAO;
import com.ims.model.Product;
import com.ims.model.SalesOrder;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private SupplierDAO supplierDAO;
    private SalesOrderDAO salesOrderDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        supplierDAO = new SupplierDAO();
        salesOrderDAO = new SalesOrderDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.findActiveProducts();
        int productsCount = products.size();
        int categoriesCount = categoryDAO.findAll().size();
        int suppliersCount = supplierDAO.findAll().size();
        int lowStockCount = 0;
        BigDecimal totalInventoryValue = BigDecimal.ZERO;
        for (Product p : products) {
            BigDecimal price = p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO;
            int qty = p.getQuantityInStock() != null ? p.getQuantityInStock() : 0;
            totalInventoryValue = totalInventoryValue.add(price.multiply(BigDecimal.valueOf(qty)));
            Integer q = p.getQuantityInStock();
            Integer r = p.getReorderLevel();
            if (q != null && r != null && q <= r) {
                lowStockCount++;
            }
        }

        BigDecimal totalSalesAmount = salesOrderDAO.findTotalSalesAmount();
        int ordersCount = salesOrderDAO.findAllOrders().size();
        List<SalesOrder> recentOrders = salesOrderDAO.findRecentOrders(10);

        request.setAttribute("productsCount", productsCount);
        request.setAttribute("categoriesCount", categoriesCount);
        request.setAttribute("suppliersCount", suppliersCount);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("totalInventoryValue", totalInventoryValue);
        request.setAttribute("totalSalesAmount", totalSalesAmount);
        request.setAttribute("ordersCount", ordersCount);
        request.setAttribute("recentOrders", recentOrders);
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
