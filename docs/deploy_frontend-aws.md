# Deploy the Frontend Application Components on AWS

In this section you would deploy the frontend components of the IoT Application on the Amazon Cloud. Following diagram shows the high-level architecture of these frontend application containers

![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/frontend_app_architecture.png)


## Login to Kubernetes Master CLI Shell:

SSH into Linux Jumphost using Putty "ubuntu-terminal" (198.18.133.11) - use your credentials. Switch to context 'arn:aws:eks:us-east-1:782256189490:cluster/CLUS-EKS-X'.

	kubectl config get-contexts
	kubectl config use-context <AWS context-name from previous command output>
	kubectl config get-contexts

## 1. Deploy frontend-iot:

Frontend is nginx web server connected to frontend-server which connect to REST-API Agent over already created Site-2-Site connection. In this section you will configure:

1. Kubernetes ConfigMap
2. Kubernetes frontend-iot Deployment
3. Kubernetes frontend-iot Load-Balancer AWS Service

You will create kubernetes deployment for frontend app and expose it to the internet using Kubernetes Load Balancer Service as shown in the following diagram

![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/deploy_frontend_srvr.png)

### 1.1 Create ConfigMap

Create now configmap which will be used by your FrontEnd deployment. Replace '**BACKEND\_HOST**' and '**BACKEND\_PORT**' in the configmap command (below) with value noted down in section 2.3 in chapter *Deploy REST API Agent on Kubernetes*.
Following screenshot highlights the Port and Node IPs in the command outputs in on-prem cluster.

!!! warning
	External IP addresses of your on-prem workers can vary from one visible on figure below.
	

![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/restapi-service-ip.png)

!!! Important
	Note down the Node External IP Address of **one of on-prem WORKER** and NodePort Service Port Number.

ConfigMap create command - Copy it to notepad FIRST, edit and paste to Terminal:

	kubectl create configmap iot-frontend-config --from-literal=BACKEND_HOST=<NODE_IP> --from-literal=BACKEND_PORT=<PORT>

### 1.2 Create new deployment: iot-frontend

Now is time to deploy our web frontend. Deployment contain two containers in one POD. The frontend server uses existing Site-2-Site connection to on-prem to access data which will be presented in GUI.
Monifest file is represented below:

```yaml
---
apiVersion: "extensions/v1beta1"
kind: "Deployment"
metadata:
  name: "iot-frontend"
  namespace: "default"
  labels:
    app: "iot-frontend"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: "iot-frontend"
  template:
    metadata:
      labels:
        app: "iot-frontend"
    spec:
      containers:
      - name: "frontend-server"
        image: "eu.gcr.io/fwardz001-poc-ci1s/frontend_server:vegas2022-v5"
        env:
        - name: "BACKEND_HOST"
          valueFrom:
            configMapKeyRef:
              key: "BACKEND_HOST"
              name: "iot-frontend-config"
        - name: "BACKEND_PORT"
          valueFrom:
            configMapKeyRef:
              key: "BACKEND_PORT"
              name: "iot-frontend-config"
      - name: "nginx-srvr"
        image: "eu.gcr.io/fwardz001-poc-ci1s/nginx_srvr:latest"
---
```

Create deployment of frontend using command below:

	kubectl create -f https://raw.githubusercontent.com/marcinduma/WILCLD-2611/main/Kubernetes/Frontend/frontend_and_nginx_deployment.yaml

Check deployment status and associated PODs:

	kubectl get pods,deployment | egrep "NAME|iot-front"

![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/deploy_aws_front-deployment.png)

## 2. Expose the Application by Creating Kubernetes Service:

Next step of our deployment is exposure of frontend web to the Internet. By using following manifest file, you will be able to create Service type LoadBalancer in AWS Kubernetes cluster.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-iot-service
  labels:
    app: iot-frontend
spec:
  ports:
    - protocol: TCP
	  port: 80
      targetPort: 80
  selector:
    app: iot-frontend
  type: "LoadBalancer"
```

using the following command -

	kubectl create -f https://raw.githubusercontent.com/marcinduma/WILCLD-2611/main/Kubernetes/Frontend/frontend-iot-service.yml

you get service created and exposed in TCP port 80.

### 2.1 Check status of newly created service

Once service was created, run following command
	
	kubectl get svc

	
![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/deploy_aws_frontend.png)
	
Copy service name from your output as marked by green frame on the screenshot above.

!!! tip
	Place the DNS name of service copied to your web browser. It may not work imediately. Please wait few minutes if frontend is not visible yet.
	

### 3. Open the Application Dashboard:


* **3.1:** Use “http” to open the Dashboard for URL captured in step 2.1. You should see the following webpage in the new tab of your browser. Click on the "Open Dashboard" button to open the application dashboard as shown in the following screenshot

	![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/deploy_aws_workload.png)
	
* **3.2:** If you see the following web-page with charts filled with data, your application is working :-) Congratulations!!!

	![Rapi](https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/deploy_aws_workload_2.png)


