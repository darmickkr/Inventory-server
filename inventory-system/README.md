# DevOps Assignment: Load Balanced Java Web Application Cluster
**Team Member Name:** Darmick  
**Assigned Technology:** Spring MVC  
**Application Name:** Inventory Management System  
**Platform Configuration:** Windows 10/11 (Local Cluster Environment)

---

## 🏗️ 1. Architecture Overview
This project demonstrates a highly available, fault-tolerant DevOps web architecture. 
* **Load Balancing Layer:** Nginx (listening on Port `8000`) acts as a reverse proxy, accepting incoming traffic and distributing it.
* **Application Cluster Layer:** Three distinct Apache Tomcat 9 instances running on isolated loopback ports (`8091`, `8092`, and `8093`).
* **Application Layer:** A Spring MVC Java Web application packaged into a single Web Archive (`.war`) file.
* **Dynamic Validation:** The frontend UI contains a dynamic JSP script (`<%= request.getLocalPort() %>`) to render which backend server processed the individual network thread.

---

## 🚀 2. Build & Packaging Instructions
The application utilizes Apache Maven for dependency management and lifecycle packaging.

1. Open your terminal and navigate to the project directory:
   ```powershell
   cd .\inventory-system\
   ```
2. Compile and package the source code using the Maven goal:
   ```powershell
   mvn clean package
   ```
3. Upon a successful build, the deployment artifact will be generated here:
   ```text
   .\inventory-system\target\inventory-system.war
   ```

---

## 🎛️ 3. Cluster Deployment Steps

### Step 1: Configure Tomcat Ports
To avoid Windows port binding clashes, the `conf/server.xml` file of each isolated Tomcat instance was modified with these precise listener values:

* **Tomcat 1:** Shutdown Port = `8016` | HTTP Connector Port = `8091`
* **Tomcat 2:** Shutdown Port = `8017` | HTTP Connector Port = `8092`
* **Tomcat 3:** Shutdown Port = `8018` | HTTP Connector Port = `8093`

### Step 2: Deploy the WAR File
Run the following commands in your PowerShell terminal to distribute the compiled WAR package into the web applications context directory of all three cluster nodes:
```powershell
Copy-Item -Path "target\inventory-system.war" -Destination "C:\Users\darmick.kr\Desktop\Tomcat-Cluster\tomcat1\Tomcat 9.0\webapps\" -Force
Copy-Item -Path "target\inventory-system.war" -Destination "C:\Users\darmick.kr\Desktop\Tomcat-Cluster\tomcat2\Tomcat 9.0\webapps\" -Force
Copy-Item -Path "target\inventory-system.war" -Destination "C:\Users\darmick.kr\Desktop\Tomcat-Cluster\tomcat3\Tomcat 9.0\webapps\" -Force
```

### Step 3: Start the Tomcat Nodes
Open isolated command shell instances to spin up each server context while forcing the environment variable boundaries:

* **Node 1 Execution:**
  ```powershell
  \$env:CATALINA_HOME="C:\Users\darmick.kr\Desktop\Tomcat-Cluster\tomcat1\Tomcat 9.0"
  & "\$env:CATALINA_HOME\bin\startup.bat"
  ```
* **Node 2 Execution:**
  ```powershell
  \$env:CATALINA_HOME="C:\Users\darmick.kr\Desktop\Tomcat-Cluster\tomcat2\Tomcat 9.0"
  & "\$env:CATALINA_HOME\bin\startup.bat"
  ```
* **Node 3 Execution:**
  ```powershell
  \$env:CATALINA_HOME="C:\Users\darmick.kr\Desktop\Tomcat-Cluster\tomcat3\Tomcat 9.0"
  & "\$env:CATALINA_HOME\bin\startup.bat"
  ```

---

## 🔀 4. Nginx Load Balancer Configuration
The load balancer routing configuration file `C:\nginx-1.30.3\conf\nginx.conf` was rewritten to register the backend cluster addresses:

```nginx
events {
    worker_connections 1024;
}

http {
    upstream inventory_cluster {
        server 127.0.0.1:8091;
        server 127.0.0.1:8092;
        server 127.0.0.1:8093;
    }

    server {
        listen 8000;
        server_name localhost;

        location / {
            proxy_pass http://inventory_cluster;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
}
```

### Run Nginx
Navigate to your Nginx root directory and launch the proxy server:
```powershell
cd C:\nginx-1.30.3
.\nginx.exe
```

---

## 🧪 5. Testing & Verification

### 1. Load Balancing Verification (Round-Robin)
1. Open a fresh web browser instance in **Incognito Mode** (to bypass cache locks).
2. Enter the load balancer proxy address: `http://localhost:8000/inventory-system/`
3. Refresh the page several times.
4. **Result:** The green UI status badge dynamically updates its string label between `TOMCAT PORT 8091`, `TOMCAT PORT 8092`, and `TOMCAT PORT 8093`, proving the active distribution of web network requests.

### 2. High Availability & Fault Tolerance Verification (Failover)
1. Terminate the process window for **Tomcat 1 (Port 8091)**.
2. Refresh the primary proxy browser tab (`http://localhost:8000/inventory-system/`).
3. **Result:** The app continues to load seamlessly without showing an error screen. Nginx detects the unreachable node and routes traffic to the remaining healthy servers (`8092` and `8093`).

---

## 🛠️ 6. Troubleshooting Notes (Viva Guide)
* **Error 404:** Means Tomcat is alive but hasn't extracted the WAR folder yet. Verify your project structure or rebuild using `mvn package`.
* **502 Bad Gateway:** Nginx is active but all downstream Tomcat nodes are asleep or locked. Verify environment pathways and run `startup.bat`.
* **Port Bind Conflict:** If Nginx fails to start on Port 80, it means another default Windows process is blocking it. Moving Nginx to listen on Port `8000` bypasses this conflict cleanly.
