<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inventory Management System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
            text-align: center;
        }
        .container {
            max-width: 600px;
            background: white;
            margin: 50px auto;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .subtitle {
            color: #27ae60;
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 25px;
            background-color: #e8f8f5;
            padding: 10px;
            border-radius: 5px;
            display: inline-block;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            background: #ecf0f1;
            margin: 10px 0;
            padding: 15px;
            border-radius: 5px;
            text-align: left;
            font-weight: 600;
            color: #34495e;
            border-left: 5px solid #3498db;
        }
        .footer {
            margin-top: 30px;
            font-size: 12px;
            color: #95a5a6;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1><%= request.getAttribute("appName") %></h1>
        
        <!-- Replace your hardcoded badge line with this -->
        <div class="badge">CLUSTER NODE: TOMCAT PORT <%= request.getLocalPort() %></div>

        
        <hr>
        
        <h3>Current Stock Levels:</h3>
        <ul>
            <% 
                List<String> items = (List<String>) request.getAttribute("inventoryItems");
                if (items != null) {
                    for (String item : items) {
            %>
                        <li><%= item %></li>
            <% 
                    }
                }
            %>
        </ul>

        <div class="footer">
            <p>Deployed on Apache Tomcat Cluster</p>
        </div>
    </div>

</body>
</html>
