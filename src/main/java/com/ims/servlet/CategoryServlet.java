package com.ims.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ims.dao.CategoryDAO;
import com.ims.model.Category;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    listCategories(request, response);
                    break;
                case "edit":
                    editCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    listCategories(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("categories.jsp?error=Operation failed");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "add":
                    addCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                default:
                    response.sendRedirect("categories.jsp?error=Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("categories.jsp?error=Operation failed");
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("categories.jsp").forward(request, response);
    }
    
    private void editCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long categoryId = Long.parseLong(request.getParameter("id"));
        Category category = categoryDAO.findById(categoryId);
        List<Category> categories = categoryDAO.findAll();
        
        request.setAttribute("category", category);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("category-form.jsp").forward(request, response);
    }
    
    private void addCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("category-form.jsp?error=Category name is required");
            return;
        }
        
        if (categoryDAO.existsByName(name.trim())) {
            response.sendRedirect("category-form.jsp?error=Category name already exists");
            return;
        }
        
        Category category = new Category();
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");
        
        categoryDAO.save(category);
        response.sendRedirect("category?action=list&message=Category added successfully");
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long categoryId = Long.parseLong(request.getParameter("id"));
        Category category = categoryDAO.findById(categoryId);
        
        if (category == null) {
            response.sendRedirect("category?action=list&error=Category not found");
            return;
        }
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("category-form.jsp?error=Category name is required");
            return;
        }
        
        // Check if name exists for other categories
        Category existingCategory = categoryDAO.findByName(name.trim());
        if (existingCategory != null && !existingCategory.getId().equals(categoryId)) {
            response.sendRedirect("category-form.jsp?error=Category name already exists");
            return;
        }
        
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");
        
        categoryDAO.update(category);
        response.sendRedirect("category?action=list&message=Category updated successfully");
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long categoryId = Long.parseLong(request.getParameter("id"));
        Category category = categoryDAO.findById(categoryId);
        
        if (category != null) {
            categoryDAO.delete(category);
        }
        
        response.sendRedirect("category?action=list&message=Category deleted successfully");
    }
}