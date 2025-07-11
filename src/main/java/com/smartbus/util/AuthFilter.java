package com.smartbus.util;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);

        boolean loggedIn = session != null && session.getAttribute("username") != null;
        boolean isPublic = uri.endsWith("index.jsp") || 
                uri.endsWith("login.jsp") || 
                uri.endsWith("register.jsp") || 
                uri.contains("css") || 
                uri.contains("js") || 
                uri.endsWith("/login") || 
                uri.endsWith("/register");


        if (loggedIn || isPublic) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect("login.jsp?error=session_expired");
        }
    }
}
