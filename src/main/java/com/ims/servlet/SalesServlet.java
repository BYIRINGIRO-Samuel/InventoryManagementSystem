package com.ims.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.ims.dao.ProductDAO;
import com.ims.dao.SalesOrderDAO;
import com.ims.dao.StockTransactionDAO;
import com.ims.model.Product;
import com.ims.model.SalesOrder;
import com.ims.model.SalesOrderItem;
import com.ims.model.StockTransaction;
import com.ims.model.User;

@WebServlet("/sales")
public class SalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private SalesOrderDAO salesOrderDAO;
    private StockTransactionDAO transactionDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        salesOrderDAO = new SalesOrderDAO();
        transactionDAO = new StockTransactionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action != null ? action : "list") {
                case "list":
                    listOrders(request, response);
                    break;
                case "new":
                    showCreateForm(request, response);
                    break;
                case "view":
                    viewOrder(request, response);
                    break;
                default:
                    listOrders(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sales.jsp?error=Operation failed");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action != null ? action : "") {
                case "create":
                    createOrder(request, response);
                    break;
                default:
                    response.sendRedirect("sales.jsp?error=Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sales.jsp?error=Operation failed");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SalesOrder> orders = salesOrderDAO.findAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("sales.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.findActiveProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("sales-form.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        SalesOrder order = salesOrderDAO.findById(id);
        request.setAttribute("order", order);
        request.getRequestDispatcher("sales.jsp").forward(request, response);
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerName = request.getParameter("customerName");

        String[] productIds = request.getParameterValues("itemProductId");
        String[] quantities = request.getParameterValues("itemQuantity");
        String[] prices = request.getParameterValues("itemPrice");

        if (productIds == null || quantities == null || productIds.length == 0) {
            response.sendRedirect("sales-form.jsp?error=Please add at least one item");
            return;
        }

        SalesOrder order = new SalesOrder();
        order.setOrderNumber("SO-" + System.currentTimeMillis());
        order.setCustomerName(customerName != null ? customerName.trim() : "");

        List<SalesOrderItem> items = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;
        User user = (User) request.getSession().getAttribute("user");

        for (int i = 0; i < productIds.length; i++) {
            Long pid = Long.parseLong(productIds[i]);
            int qty = Integer.parseInt(quantities[i]);
            Product product = productDAO.findById(pid);

            if (product == null || qty <= 0) {
                continue;
            }

            int currentStock = product.getQuantityInStock() != null ? product.getQuantityInStock() : 0;
            if (currentStock < qty) {
                response.sendRedirect("sales?action=new&error=Insufficient stock for " + product.getName());
                return;
            }

            BigDecimal price = (prices != null && prices.length > i && prices[i] != null && !prices[i].trim().isEmpty())
                    ? new BigDecimal(prices[i]) : (product.getPrice() != null ? product.getPrice() : BigDecimal.ZERO);
            BigDecimal lineTotal = price.multiply(BigDecimal.valueOf(qty));

            SalesOrderItem item = new SalesOrderItem();
            item.setOrder(order);
            item.setProduct(product);
            item.setQuantity(qty);
            item.setPrice(price);
            item.setTotal(lineTotal);
            items.add(item);

            total = total.add(lineTotal);

            product.setQuantityInStock(currentStock - qty);
            productDAO.update(product);

            StockTransaction tx = new StockTransaction(product, StockTransaction.TransactionType.OUT, qty, "Sale " + order.getOrderNumber(), user);
            transactionDAO.save(tx);
        }

        order.setItems(items);
        order.setTotalAmount(total);
        order.setStatus(SalesOrder.Status.COMPLETED);

        salesOrderDAO.save(order);

        response.sendRedirect("sales?action=list&message=Order " + order.getOrderNumber() + " created");
    }
}
