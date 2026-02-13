package com.ims.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ims.dao.ProductDAO;
import com.ims.dao.CategoryDAO;
import com.ims.dao.SupplierDAO;
import com.ims.dao.StockTransactionDAO;
import com.ims.model.Product;
import com.ims.model.Category;
import com.ims.model.Supplier;
import com.ims.model.StockTransaction;
import com.ims.model.User;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private SupplierDAO supplierDAO;
    private StockTransactionDAO transactionDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        supplierDAO = new SupplierDAO();
        transactionDAO = new StockTransactionDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    listProducts(request, response);
                    break;
                case "view":
                    viewProduct(request, response);
                    break;
                case "edit":
                    editProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "search":
                    searchProducts(request, response);
                    break;
                case "lowstock":
                    lowStockProducts(request, response);
                    break;
                case "new":
                    showAddForm(request, response);
                    break;
                default:
                    listProducts(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products.jsp?error=Operation failed");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "add":
                    addProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "updateStock":
                    updateStock(request, response);
                    break;
                default:
                    response.sendRedirect("products.jsp?error=Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products.jsp?error=Operation failed");
        }
    }
    
    private void listProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> products = productDAO.findActiveProducts();
        List<Category> categories = categoryDAO.findAll();
        List<Supplier> suppliers = supplierDAO.findAll();
        java.math.BigDecimal totalValue = java.math.BigDecimal.ZERO;
        int lowStockCount = 0;
        for (Product p : products) {
            java.math.BigDecimal price = p.getPrice() != null ? p.getPrice() : java.math.BigDecimal.ZERO;
            int qty = p.getQuantityInStock() != null ? p.getQuantityInStock() : 0;
            totalValue = totalValue.add(price.multiply(java.math.BigDecimal.valueOf(qty)));
            Integer q = p.getQuantityInStock();
            Integer r = p.getReorderLevel();
            if (q != null && r != null && q <= r) {
                lowStockCount++;
            }
        }
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("totalInventoryValue", totalValue);
        request.setAttribute("lowStockCount", lowStockCount);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAll();
        List<Supplier> suppliers = supplierDAO.findAll();
        
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("product-form.jsp").forward(request, response);
    }
    
    private void viewProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long productId = Long.parseLong(request.getParameter("id"));
        Product product = productDAO.findById(productId);
        List<StockTransaction> transactions = transactionDAO.findByProduct(productId);
        
        request.setAttribute("product", product);
        request.setAttribute("transactions", transactions);
        request.getRequestDispatcher("product-details.jsp").forward(request, response);
    }
    
    private void editProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long productId = Long.parseLong(request.getParameter("id"));
        Product product = productDAO.findById(productId);
        List<Category> categories = categoryDAO.findAll();
        List<Supplier> suppliers = supplierDAO.findAll();
        
        request.setAttribute("product", product);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("product-form.jsp").forward(request, response);
    }
    
    private void addProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String sku = request.getParameter("sku");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String costPriceStr = request.getParameter("costPrice");
        String quantityStr = request.getParameter("quantity");
        String reorderLevelStr = request.getParameter("reorderLevel");
        String categoryIdStr = request.getParameter("categoryId");
        String supplierIdStr = request.getParameter("supplierId");
        
        // Validation
        if (sku == null || name == null || sku.trim().isEmpty() || name.trim().isEmpty()) {
            response.sendRedirect("product-form.jsp?error=SKU and Name are required");
            return;
        }
        
        if (productDAO.existsBySku(sku.trim())) {
            response.sendRedirect("product-form.jsp?error=SKU already exists");
            return;
        }
        
        Product product = new Product();
        product.setSku(sku.trim());
        product.setName(name.trim());
        product.setDescription(description != null ? description.trim() : "");
        
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            product.setPrice(new BigDecimal(priceStr));
        }
        
        if (costPriceStr != null && !costPriceStr.trim().isEmpty()) {
            product.setCostPrice(new BigDecimal(costPriceStr));
        }
        
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            product.setQuantityInStock(Integer.parseInt(quantityStr));
        }
        
        if (reorderLevelStr != null && !reorderLevelStr.trim().isEmpty()) {
            product.setReorderLevel(Integer.parseInt(reorderLevelStr));
        }
        
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            Category category = categoryDAO.findById(Long.parseLong(categoryIdStr));
            product.setCategory(category);
        }
        
        if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
            Supplier supplier = supplierDAO.findById(Long.parseLong(supplierIdStr));
            product.setSupplier(supplier);
        }
        
        productDAO.save(product);
        
        // Create initial stock transaction if quantity > 0
        if (product.getQuantityInStock() > 0) {
            User user = (User) request.getSession().getAttribute("user");
            StockTransaction transaction = new StockTransaction(
                product, 
                StockTransaction.TransactionType.IN, 
                product.getQuantityInStock(), 
                "Initial stock", 
                user
            );
            transactionDAO.save(transaction);
        }
        
        response.sendRedirect("product?action=list&message=Product added successfully");
    }
    
    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long productId = Long.parseLong(request.getParameter("id"));
        Product product = productDAO.findById(productId);
        
        if (product == null) {
            response.sendRedirect("product?action=list&error=Product not found");
            return;
        }
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String costPriceStr = request.getParameter("costPrice");
        String reorderLevelStr = request.getParameter("reorderLevel");
        String categoryIdStr = request.getParameter("categoryId");
        String supplierIdStr = request.getParameter("supplierId");
        
        product.setName(name.trim());
        product.setDescription(description != null ? description.trim() : "");
        product.setUpdatedAt(LocalDateTime.now());
        
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            product.setPrice(new BigDecimal(priceStr));
        }
        
        if (costPriceStr != null && !costPriceStr.trim().isEmpty()) {
            product.setCostPrice(new BigDecimal(costPriceStr));
        }
        
        if (reorderLevelStr != null && !reorderLevelStr.trim().isEmpty()) {
            product.setReorderLevel(Integer.parseInt(reorderLevelStr));
        }
        
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            Category category = categoryDAO.findById(Long.parseLong(categoryIdStr));
            product.setCategory(category);
        }
        
        if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
            Supplier supplier = supplierDAO.findById(Long.parseLong(supplierIdStr));
            product.setSupplier(supplier);
        }
        
        productDAO.update(product);
        response.sendRedirect("product?action=list&message=Product updated successfully");
    }
    
    private void updateStock(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long productId = Long.parseLong(request.getParameter("productId"));
        String typeStr = request.getParameter("type");
        String quantityStr = request.getParameter("quantity");
        String reason = request.getParameter("reason");
        
        Product product = productDAO.findById(productId);
        if (product == null) {
            response.sendRedirect("product?action=list&error=Product not found");
            return;
        }
        
        int quantity = Integer.parseInt(quantityStr);
        StockTransaction.TransactionType type = StockTransaction.TransactionType.valueOf(typeStr);
        User user = (User) request.getSession().getAttribute("user");
        
        // Update product stock
        int currentStock = product.getQuantityInStock();
        switch (type) {
            case IN:
                product.setQuantityInStock(currentStock + quantity);
                break;
            case OUT:
                if (currentStock < quantity) {
                    response.sendRedirect("product?action=view&id=" + productId + "&error=Insufficient stock");
                    return;
                }
                product.setQuantityInStock(currentStock - quantity);
                break;
            case ADJUSTMENT:
                product.setQuantityInStock(quantity);
                quantity = quantity - currentStock; // Store the difference
                break;
        }
        
        product.setUpdatedAt(LocalDateTime.now());
        productDAO.update(product);
        
        // Create transaction record
        StockTransaction transaction = new StockTransaction(product, type, Math.abs(quantity), reason, user);
        transactionDAO.save(transaction);
        
        response.sendRedirect("product?action=view&id=" + productId + "&message=Stock updated successfully");
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long productId = Long.parseLong(request.getParameter("id"));
        Product product = productDAO.findById(productId);
        
        if (product != null) {
            product.setActive(false);
            productDAO.update(product);
        }
        
        response.sendRedirect("product?action=list&message=Product deleted successfully");
    }
    
    private void searchProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<Product> products = productDAO.searchProducts(searchTerm);
        List<Category> categories = categoryDAO.findAll();
        List<Supplier> suppliers = supplierDAO.findAll();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
    
    private void lowStockProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> products = productDAO.findLowStockProducts();
        request.setAttribute("products", products);
        request.setAttribute("lowStockView", true);
        request.getRequestDispatcher("low-stock.jsp").forward(request, response);
    }
}
