# learn-kubernetes

How to learn kubernetes ?
    1) We need to have a kubernetes cluster provisioned 

How to provision a kubernetes cluster ?

    1) Managing your cluster by using EC2 / On-Prem Instances 
    
        a) Create instances     ( t3.small or medium with 30gb )
        b) Install Run time     ( PodMan/Docker )
        c) Install Kubernetes  
        d) Enroll the nodes  
        e) kubectl              ( a k8 client to connect to the cluster )
    
    2) Using Managed Services From Cloud 

        a) AWS   ( EKS )  [ Preferred ]
        b) GCP   ( GKE )
        c) Azure ( AKS ) 
    
    3) Learning Environment : Minikube   ( We will start with this for the next 2 days )

        a) Create an EC2 Instance        ( t3.small or medium with 30gb and expand the /var and /root-vol directories )
        b) Install Minukube On It 

        `https://raw.githubusercontent.com/CodingManoj/rhel9-tools/refs/heads/main/Minikube/init.sh`
        `https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download`

Most of the information can be availed from `kubernetes.io`

How to connect to kubernets cluster ?

    a) First we need to have `kubectl` installed on your computer or on the server from where you're trying to connect 

What is `kubectl` ?
    
    kubectl is a kubernetes client to connect to the kubernetes cluster ( which is a CLI based tool )

### In kubernetes, we have lot of resources and amound all Pod is the smallest computing resource!!!

## What is a Pod in kubernetes ?
```
    Pods are the smallest deployable units of computing that you can create and manage in Kubernetes. A Pod (as in a pod of whales or pea pod) is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers.
```
### Kubernetes is all about API's 

Each and every resource would be under a specific api.

### What is the purpose of pod ?

```
    POD is used to run a container, it's just a wrapper to containers.
    
    A pod can have more than one container.

    But all the containers in the pod will have the sameNetwork & same storage.
```


All the commands in kubernetes starts with `kubectl`

    Syntax: 

        $ kubectl  verb  resources
        $ kubectl  get pods 
        $ kubectl  describe  resource 
        $ kubectl cluster-info


### Kubernetes Components 

    Master / Control Plane Components: 

        1) Kube-api server         ( 6643 )
        2) Scheduler
        3) Controller Manager 
        4) etcd database 
    
    Worker / Data Plane Components: 

        1) Kubelet                ( Run's on each and every node ) 
        2) Container Runtime      ( Docker/PodMan )


### What is kube contenxt file ?

    1) This is a file that resides on your server under profile after you authenticate to the cluster ~/.kube/config 
    2) This has the token / auth info to connect to the cluster 
    3) This also has the option to tell on which cluster your commands are supposed to be executed ( current cluster )

### How to create kubernetes resources ?

    1) Either using imperative approach ( directly running the resource commands and it's not recommended as you cannot version control it )
     ```
        $ kubectl run NAME --image=image
     ```
    2) Declarative approach : Writing manifest files using YAML and then applying this, this is the most recommended way as we can version control it. 

    ```
        $ kubectl create -f fileName.yml   ( This just creates and cannot be used with resources if they are in place : not recommended )
        $ kubectl apply -f fileName.yml    ( This creates the resources mentioned in the manifest file if they are not in place, if they are already place, it updates the resources with the latest values that are mentioned in the yaml file. )  
    ```


## How to list the suppored resources in kubernetes 

    $ kubectl api-resources  

##  How to list the suppored api versions in kubernetes 

    $ kubectl api-versions

## How to see the clusetr info 

    $ kubectl cluster-info 

## How to start minikune 

    $ minikube --force-start

## How to see the manifest of a deployed kubernetes resource 

    $ kc get resourceType resourceName -o yaml 

### How to validate manifest file without deploying to cluster 

    $ kubectl apply -f manifest.yml  --dry-run=server   ( This tells whether resource is valid and can be deployed or not without really deploying) 

    or 
   
    $ kubectl apply -f manifest.yml  --dry-run=client  ( This will only be validated by the client not by the api-server )

### What is a namespace in kubernetes and what are it's default namespace, where our resources are going to be created by default ?

    Namespaces in Kubernetes are a way to divide and manage resources in a cluster by creating isolated environments for different users or project.

    Using, we can isolate the resources belongs to different and this is to make sure one team cannot access other team's resources.
    We can also ensure, that one namespace can use only x cpu and y memory and can define these limits.

### Kubernetes comes with three default namespaces: 
    default: The default namespace for objects that don't have a specified namespace. This is the namespace that's referenced by default for every Kubernetes command. 

    kube-system: Used for Kubernetes components, such as kube-dns, api-server, controller-managers, scheduler
    kube-public: Used for public resources, such as information needed to communicate with the Kubernetes API. 

### How to see all the resources of a specific namespace ?

    $ kubectl get all -n nameSpaceName

    $ kc get all -n kube-system
        NAME                                   READY   STATUS    RESTARTS      AGE
        pod/coredns-6f6b679f8f-w5cjz           1/1     Running   0             46m
        pod/etcd-minikube                      1/1     Running   0             46m
        pod/kube-apiserver-minikube            1/1     Running   0             46m
        pod/kube-controller-manager-minikube   1/1     Running   0             46m
        pod/kube-proxy-b4l7n                   1/1     Running   0             46m
        pod/kube-scheduler-minikube            1/1     Running   0             46m
        pod/storage-provisioner                1/1     Running   1 (45m ago)   46m

### Kubernetes resources scope can either be nameSpace or cluster based  

        # pods are namespace  
        # node are cluster resources 

### How to we know whether a resource scope is cluster or nameSpace ?

        $ kubectl api-resources 

```
    NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
    bindings                                         v1                                true         Binding
    componentstatuses                   cs           v1                                false        ComponentStatus
    configmaps                          cm           v1                                true         ConfigMap
    endpoints                           ep           v1                                true         Endpoints
    events                              ev           v1                                true         Event
    limitranges                         limits       v1                                true         LimitRange
    namespaces                          ns           v1                                false        Namespace
    nodes                               no           v1                                false        Node
    persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
    persistentvolumes                   pv           v1                                false        PersistentVolume
    pods                                po           v1                                true         Pod
    podtemplates                                     v1                                true         PodTemplate
```

### We don't create pods in kubernetes directlty ? Then how ? 
    
    We use SETS :

    There are 4 types of sets and these sets will create the PODS in kubernetes ? Becuase of the advantages to maintain the replica count of the pods 

        1) REPLICA SET          ( controller )
        2) DEPLOYMENT SET       ( controller )
        3) DAEMON SET           ( controller )
        4) STATEFUL SET         ( controller )

### Replica Set :
    1) This will ensure the mentioned number of pods are running all the time 
    2) Even if we / system deletes the pod, immediately the mentioned numbers of will  automatically be created. 
    3) Using replica-set, we cannot update the pods from x to y version, replica-set will be configured but it's not going to impact the pods.  But the new pods that are going to be provisioned by this replica-set will have the image that's update.
    4) We only use replica-set set just to make sure the comminted number of pods are running all the time or not.
    5) If you want to support the version updating to the pods, then we need to use another type of SET called as deployment

    !!! If you're dealing replica-set, you cannot let the version update of the image from one version to another verison.
    If that's the case, we end-up using Deployment Sets.

Labesl and selectors are very important, let's talk about that tomorrow.
How bodning is happening between pods and replica-sets

### How to scale a replicaset manually? 

    ```
        $ kubectl scale rs rsName --replicas=x 
    
    ```
### Deployment Set 

    Deployment Set is a wrapper to Replicaset 

        1) This ensure the mentioned number of replias are running all the time
        2) Deployment set helps in moving the pods from one version to another versions ( Old version pods will be deleted and new pods will be coming very fast )
        3) Deployment set again create a replica-set in the backend ( Behind the hoods )

    By default, deployment updates goes by deployment type of ROLLING UPDATE, which take down the old version by create new pods with the new version, we can also define the Rolling Update Percentage as well  ( zero to none downtime )

    If you're not interested, we can also with Recreate Strategy In Deployment. Whenever a new version comes up, all the old versions will be deleted at a time and new one will be created  ( There would be some down time )

### Statementful 

    Stateful Set ensure all the created pods will be having a disk attached to it and at the same time this is mostly used to host the DB or storage based workloads. 

    Pods created by ths stateful set will have a number associated with it. 

    pod-0, pod-1, pod-2, pod-3

    They will be created in the order and at the time , new pod of the set will only be coming up after the creation of the pod successfully.

    Even if you scale down a stateful set with 5 pods, the first pod to be deleted is pod-4 

    Very less number of times, we would scale down ( 99% of the times, we would never scale down ) 

### What is Cloud Native ?

    A product that is designed to work on cloud but is also capable to run on-prem but this yeilds all the promised features with ease when they are cloud. 

    Ex: If you want to use stateful set: 

        1) If you're on-prem, then we are responsible for provisioning the underlying storage disk for the statefulset
        2) Using Persistent Volument and Persistent Volume Claim ( PV or PVC )
    
        3) If you're CLOUD, cloud provider offers STORAGE CLASS, this automatically provisions the underlying disk for the pods of the stateful set.

### ConfigMap in kuberntes 

        1) ConfigMap is a wrapper to hold a bunch fo environment varaibles that can be supplied like a packed entity to the pod.

### How to connect to these workloads ?

    1) Do pods have IP ?  Yes
    2) Do containers with in the pods have IP Address ? No 
    3) How to connect to them ? 

### Services In Kubernetes, Metrics Server 

    1) This is an abstract that helps in connecting to pods and this load balances the requests

### Types of Services In Kubernetes 

    1) Cluster IP            ( This type of service is only accessible with in the cluster )
    2) Load Balancer         ( This is to expose something to the internet, typically any service that needs to be exposed to the internet )
    3) Node Port             ( This is also something to allow access from the internet, but using the nodes pods)
    4) External Name ( Alias for CNAME )

If you don't mention the service type while creating the service, it default to clusterip ( which is a good option )


Imp :
    1) When we are tyring to connect to any service from any namespace, by default the k8 will look for the service the namespace from where we are making the call 

        Ex: nginx-svc is in default nameSpace ,  exp-pod is in expense namespace .

            Now if you want to make a call from expense-namespace to serfvice in other namespace, you need to call the service by using FQDN 


            FQDN of svc:  svcName.nameSpace.svc.cluster.local
                          
                          nginx-svc.default.svc.cluster.local


Response To a service in the same cluster but in other nameSpace:

```
root@exp-pod:/# curl nginx-svc
    curl: (6) Could not resolve host: nginx-svc

root@exp-pod:/# curl nginx-svc.default.svc.cluster.local
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>

```

### External Name: 
    This is to create an alias name for a biggerNames.

        Ex: My service name is nginx-svc  in default nameSpace and if this has to be called from other namespaces, here is the FQDN to use
            "nginx-svc.default.svc.cluster.local" 
        
        If you create an external name in other namespace, then you call call the above svc with just the short name

```
apiVersion: v1
kind: Service
metadata:
  name: ngx-svc
  namespace: expense
spec:
  type: ExternalName
  externalName: nginx-svc.default.svc.cluster.local
```

Output Example: 

```
# kc exec -it exp-pod -n expense -- bash

    root@exp-pod:/# curl exp-pod
    
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to nginx!</title>
        <style>
        html { color-scheme: light dark; }
        body { width: 35em; margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif; }
        </style>
        </head>
        <body>
        <h1>Welcome to nginx!</h1>
        <p>If you see this page, the nginx web server is successfully installed and
        working. Further configuration is required.</p>

        <p>For online documentation and support please refer to
        <a href="http://nginx.org/">nginx.org</a>.<br/>
        Commercial support is available at
        <a href="http://nginx.com/">nginx.com</a>.</p>

        <p><em>Thank you for using nginx.</em></p>
        </body>
        </html>

```

### Headless Service In Kubernetes 
    > This is majorly used when a cluster of DB's are in place.

A headless Service allows a client to connect to whichever Pod it prefers, directly. Services that are headless don't configure routes and packet forwarding using virtual IP addresses and proxies; instead, headless Services report the endpoint IP addresses of the individual pods via internal DNS records, served through the cluster's DNS service.

### How do we control what can be maximum resources ( CPU & Memory ) that can consumed by the containers with in the pod ?

    How to define, what are te minimum CPU and Memory needed for the container in the pods to start ?
        * If the minimum needed resourced mentioned in the pod are not available on the node, then that POD won't be schedule; Pending State 
    
    How to define, what are te maxium CPU and Memory needed for the container that it can use ?
        * If we define the limits for the resources, whenever container reaches the limits in the pod, POD goes for a restart.

### Resource Management 

    Requests:

    Limits:

    Limits and Requests are at container level of the pod, if we have 3 containers in a pod, then we need to mention limits and reqeusts for both the containers.

    IMP: Only REQUESTS are guaranteed, LIMITS are not guaranteed. 

    
How to check the rource utilization of pods ?
    
How to check the rource utilization of nodes ? 

For this, you need to install METRICS_SERVER!!! Then it collects the metrics and shows you.


### Quotas in kubernetes!!!!

    1) Deining limits saying that my namespace can have a maximum of 100 pods
    2) Namespace-x can have a maximum of 16gb memory utilization 
    3) A maximum of 100 secrets can be created in a namespace

Quotas majorly comes up in a efficent and a shared cluster where namespaces are extensively used.

When several users or teams share a cluster with a fixed number of nodes, there is a concern that one team could use more than its fair share of resources.

Resource quotas are a tool for administrators to address this concern.

If creating or updating a resource violates a quota constraint, the request will fail with HTTP status code 403 FORBIDDEN with a message explaining the constraint that would have been violated.

* When quotas are defined, pods/deployments should have limits & requests defined if not, it will not be deployed.

    Ex: Error from server (Forbidden): error when creating "017-quota.yml": pods "debug-003" is forbidden: exceeded quota: quota-demo-cpu-mem-count, requested: pods=1, used: pods=2, limited: pods=2


## Probes ( Health Check In Kubernetes )

    * Horizontal scaling means that the response to increased load is to deploy more Pods. This is different from vertical scaling, which for Kubernetes would mean assigning more resources (for example: memory or CPU) to the Pods that are already running for the workload.

    * Horizontal pod autoscaling does not apply to objects that can't be scaled (for example: a DaemonSet.)

    * We can scale the pods of the deployment either by CPU or MEMORY or by custom metric

### Managed Services For K8s on AWS :

    * EKS: Elastic Kubernetes Service ( Very robust and heavy lifting service )

    Advantage of using EKS:
        1) AWS is responsible for managing the nodes 
        2) You don't linux patching, you're not responsible for container run-time
        3) You don't have to employ storage solution and you get out of the box HA storage solution
        4) Very nice features can be installed as optional and we call them plug-ins. 

# What will happen if your master node is gone/down in a kubernetes cluster ?

    1) In managed environment, we won't be having access to MASTER NODE ( it's in AWS control )
    2) If master node is down, you cannot schedule new work-loads and you cannot connect to the cluster ( Kube-api server, etcd , scheduler and controller manager are on master ) 
    3) Existing workloads run as it (  but any of the pods of the deployment were killed then new pods of that controller won't come up )
    4) You can have n number of node-groups to a single cluster.
    5) You can have multi-master kuberntes cluster to achive ha in case of Master Node Failure.

### How create Kubernetes Cluster ?

    1) First create the cluster by selecting the version of our choice 
    2) Create the node-pools / node-groups with the instance type of your choice and these nodes can be SPOT or RRSERVED or ON-DEMAND

### In AWS, EKS offers 3 types of clusters wrt to conenctivity 

    1) Public Cluster   [The cluster endpoint is accessible from outside of your VPC. Worker node traffic will leave your VPC to connect to the endpoint. ]
    2) Public & Private [The cluster endpoint is accessible from outside of your VPC. Worker node traffic to the endpoint will stay within your VPC. ]
    3) Private Cluster  [ The cluster endpoint is only accessible through your VPC. Worker node traffic to the endpoint will stay within your VPC. ]

What is the networking solution offered on AWS ?
    1) Amazon VPC CNI : is the networking solution that can be enabled to get pod and service level restrictions.

What are other networking solutions that are supported by Kubernetes ?

    1) Calico CNI 
    2) Weavenet CNI 

Let's try to create EKS using Terraform :


