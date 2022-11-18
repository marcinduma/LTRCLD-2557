# Explore Backend App and Kubernetes Dashboard:

Your Hybrid Cloud App's backend compoents (MariaDB, MQTT DB Agent, and REST API agent) should be up and running. Now let's explore some low level details to understand the application containers and kubernetes better.

**Task 0:** Tasks in this section will be executed in Kubernetes on-premise. Change kubectl context to the correct one.

Execute command below on linux jumphost:
	
		kubectl config use-context admin@CLUS-IKS-1


**Task 1:** Find the size of the 'Persistent Volume Claim' used for MariaDB database?

To check 'CAPACITY' value of PVC execute this command on linux jumphost:
	
		kubectl get pvc mariadb-pv-claim


**Task 2:** Login to the MariaDB database and explore the data tables. 

1. Find the pod name for 'MariaDB' using the kubectl command 
		
		kubectl get pods
and locate the pod name starting with 'iot-backend-mariadb-'.

2. Login to the MariaDB container using the kubectl command

		kubectl exec -it <pod name> -- /bin/bash
	!!! tip
		(replace the **<pod name\>** in command above with correct value).

3. Inside the container execute
		
		ss -tulpn
and check the port MariaDB is listing to for incoming connections.

4. You can also check the version of MariaDB using the shell command:
		
		mysql --version

5. Now connect to the MariaDB from the container shell and check Databases and Tables.
Use 
		
		mysql -u root -pcisco123
command to login to MaraDB.

6. On mariaDB shell, use
		
		show databases;
command to list all the databases. Look for '**sensor\_db**' in the output (this is the database where we are storing the sensor data).

7. Switch to sensor_db using the command
		
		use sensor_db;
and list all the tables in this database using the command
		
		show tables;
You should see only one table with the name **'sensor\_data'**;

8. Try to list the data from this table using the SQL statement
		
		select * from sensor_data;

9. Now check the record count in this table using the sql statement:
		
		select count(*) from sensor_data;

10. Repeat the SQL from step 8 several times and check if the record count is increasing (each sensor would send the data after every 10 seconds). 
11. Use 
		
		exit
command at MariaDB prompt to exit the DB shell.

12. Use
		
		exit
command again to exit 'iot-backend-mariadb' container shell.


**Task 3:** Connect to the REST API Agent container and find the port it is listing on for incoming REST calls.

1. Find the pod name for 'REST API Agent' using the kubectl command
		
		kubectl get pods
and locate the pod name starting with 'iot-backend-rest-api-agent-' (you may see more than one pod for this service, pick any one).

2. login to the REST API Agent container using the kubectl command
		
		kubectl exec -it <pod name> -- /bin/ash
	!!! tip
		(replace the **<pod name\>** in command above with correct value).

3. Execute
		
		netstat -an
command on the container shell and check the output. This container listens on port '5050' for incoming REST connections and connects with MariaDB using port '3306' (Connection to DB will timeout in case there are no requests coming in).

4. Use
		
		exit
command to come out of the container shell.


**Task 4:** Check the logs messages from 'REST API Agent'.

1. Find the pod name for 'REST API Agent' using the kubectl command
		
		kubectl get pods
and locate the pod name starting with 'iot-backend-rest-api-agent-' (you may see more than one pod for this service, pick any one).

2. Check the logs using the kubectl command
		
		kubectl logs <pod name>
	!!! tip
		(replace the **<pod name\>** in command above with correct value).

**Task 5:** How the traffic would be distributed, if you have multiple Kubernetes Pods behind a Kubernetes NodePort Service?

1. Right click on top of your putty window and click on "Duplicate Session" (You should have two putty windows side by side logged into same linux jumphost).
2. In the first putty window (logged into linux jumphost) execute the command
		
		kubectl get nodes -o wide
and note down the Kubernetes master node's external IP address.

4. Open a web browser on your machine and access the following url
		
		http://<kubernetes node's external ip>:<port>/temperature

5. In the first putty window, run
		
		kubectl get pods
on the linux jumphost. In the output you should see 2 pods for 'iot-backend-rest-api-agent'.

6. In the first putty window, run the command
		
		watch kubectl logs <first pod name>
(Use the first 'iot-backend-rest-api-agent' pod out of 2 pods that you saw in the output of the command executed in step#5).

7. In the Second putty window, display the logs for second 'iot-backend-rest-api-agent' pod using the command
		
		watch kubectl logs <second pod name>

8. Refresh or reload the web page with the url you used in step 4. 

9. Repeat step 8 and check the requests hitting the kubernetes pods in the log messages.