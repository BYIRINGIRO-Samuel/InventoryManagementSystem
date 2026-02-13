package com.ims.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ims.dao.SupplierDAO;
import com.ims.model.Supplier;

@WebServlet("/supplier")
public class SupplierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO supplierDAO;
    
    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    listSuppliers(request, response);
                    break;
                case "view":
                    viewSupplier(request, response);
                    break;
                case "edit":
                    editSupplier(request, response);
                    break;
                case "delete":
                    deleteSupplier(request, response);
                    break;
                case "search":
                    searchSuppliers(request, response);
                    break;
                default:
                    listSuppliers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("suppliers.jsp?error=Operation failed");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "add":
                    addSupplier(request, response);
                    break;
                case "update":
                    updateSupplier(request, response);
                    break;
                default:
                    response.sendRedirect("suppliers.jsp?error=Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("suppliers.jsp?error=Operation failed");
        }
    }
    
    private void listSuppliers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.findAll();
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("suppliers.jsp").forward(request, response);
    }
    
    private void viewSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long supplierId = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierDAO.findById(supplierId);
        
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("supplier-details.jsp").forward(request, response);
    }
    
    private void editSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long supplierId = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierDAO.findById(supplierId);
        
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("supplier-form.jsp").forward(request, response);
    }
    
    private void addSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String contactPerson = request.getParameter("contactPerson");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("supplier-form.jsp?error=Supplier name is required");
            return;
        }
        
        if (supplierDAO.existsByName(name.trim())) {
            response.sendRedirect("supplier-form.jsp?error=Supplier name already exists");
            return;
        }
        
        Supplier supplier = new Supplier();
        supplier.setName(name.trim());
        supplier.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
        supplier.setEmail(email != null ? email.trim() : "");
        supplier.setPhone(phone != null ? phone.trim() : "");
        supplier.setAddress(address != null ? address.trim() : "");
        
        supplierDAO.save(supplier);
        response.sendRedirect("supplier?action=list&message=Supplier added successfully");
    }
    
    private void updateSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long supplierId = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierDAO.findById(supplierId);
        
        if (supplier == null) {
            response.sendRedirect("supplier?action=list&error=Supplier not found");
            return;
        }
        
        String name = request.getParameter("name");
        String contactPerson = request.getParameter("contactPerson");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("supplier-form.jsp?error=Supplier name is required");
            return;
        }
        
        // Check if name exists for other suppliers
        Supplier existingSupplier = supplierDAO.findByName(name.trim());
        if (existingSupplier != null && !existingSupplier.getId().equals(supplierId)) {
            response.sendRedirect("supplier-form.jsp?error=Supplier name already exists");
            return;
        }
        
        supplier.setName(name.trim());
        supplier.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
        supplier.setEmail(email != null ? email.trim() : "");
        supplier.setPhone(phone != null ? phone.trim() : "");
        supplier.setAddress(address != null ? address.trim() : "");
        
        supplierDAO.update(supplier);
        response.sendRedirect("supplier?action=list&message=Supplier updated successfully");
    }
    
    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long supplierId = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierDAO.findById(supplierId);
        
        if (supplier != null) {
            supplierDAO.delete(supplier);
        }
        
        response.sendRedirect("supplier?action=list&message=Supplier deleted successfully");
    }
    
    private void searchSuppliers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<Supplier> suppliers = supplierDAO.searchSuppliers(searchTerm);
        
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("suppliers.jsp").forward(request, response);
    }
}