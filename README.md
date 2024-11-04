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

    $ bash create.sh 

### How to connect to EKS Cluster ?

    ```
        aws eks update-kubeconfig --name clusterName 
    ```

### RBAC : Role Based Acccess Control ( This helps in achieving least privilege principle )

Role-Based Access Control (RBAC) is a method of controlling access to Kubernetes resources based on the roles assigned to users or groups. 

RBAC involves creating roles and binding them to users or groups to control access to Kubernetes resources. Roles are defined as a set of rules that determine what actions can be performed on specific resources. 

By assigning roles to users or groups, access to Kubernetes resources can be restricted or granted based on the permissions defined in the role. 

RBAC helps ensure the security and integrity of Kubernetes clusters by limiting access to authorized users and groups
 

### How to get the Metrics or Saturation Info of the nodes and pods on ELS.

To gain metrics level information on EKS, we need to have Metrics Server Installed and I would like to do it as a part of the cluster provisioning


> What's next ? RBAC: role, role binding, service account, cluster-role, cluster-role-binding
```
    serviceaccount/metrics-server created
    clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
    clusterrole.rbac.authorization.k8s.io/system:metrics-server created
    rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
    clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
    clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
    service/metrics-server created
    deployment.apps/metrics-server created
    apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
```


> IAM Role ---> Attaching Permissions ----> Attaching the role to the instance ---> Then instance will get all the needed permissions.


### Role Based Access Control Good Practices ( RBAC )
Principles and practices for good RBAC design for cluster operators.
```
    Kubernetes RBAC is a key security control to ensure that cluster users and workloads have only the access to resources required to execute their roles. It is important to ensure that, when designing permissions for cluster users, the cluster administrator understands the areas where privilege escalation could occur, to reduce the risk of excessive access leading to security incidents.

```

RBAC ensure you get roles that are needed on the cluster and for this ROLES are available in the cluster. 

### What are the default roles that are available in the cluster ?

Points to be notes :

    1) Just like on linux how you create users and delegate permissions to them either directly or by groups, we can also do the same thing on kubermetes using k8 users and groups. 

    2) You cal create your roles, perform binding ( adding user to the role ) 


Kubernetes uses authorization , not authentication ( userName & password )

    1) If we create a user, he don't present himself with userName and password, instead a token

A service account in Kubernetes is a non-human identity that allows applications to run workloads in a Kubernetes cluster



Service Account:
    Just like how we use IAM Role to gain access to a non-human resource on AWS, similarly we use Service Account on K8's to let needed roles aligned to the k8 workloads.

    Each and every sa will have token, if that's not available we can generate a token and associated

    ```
        $ kubectl create token sample   ( creates token for the service account sample )
    ```

    Using the above token, we will connecto the cluster ( Let's create a user account on your linux machine )

    We are using a token generated on the system and using this we are attempting to connect to the cluster

```
    $ kc get nodes

        Error from server (Forbidden): nodes is forbidden: User "system:serviceaccount:default:sample" cannot list resource "nodes" in API group "" at the cluster scope

```

Roles in kubernetes are of 2 types :

    1) Roles : scope is namespace: that you means you create at namespace and that's limited only to the namespace like pod, configmap, deployment 
    2) Cluster Role: scope is entire cluster: you can give access to create cluster roles, change cluster policies.


### Where logs of the kubernetes cluster ar shipped ?

    1) api-server, scheduler, controller logs cannbe shipped to a service in AWS Called as Cloud Watch 
    2) By default you don't see them enabled, you need explicitly enable it. 
    3) Once you enable it, you can view then Cloud Watch.

Backlog:  Role binding is not happening  ( Cluster Role )
The RoleBinding "nsreadonly-binding" is invalid: subjects[0].apiGroup: Unsupported value: "rbac.authorization.k8s.io": supported values: ""


### VPA ( Vertical Pod AutoScaling )

    1) This helps in adding respoures to the pod by taking down the pod that experiencing resource stress with a new pod with more resources
    2) VPA always involves downtime 

    Both HPA and VPA cannot be used for the same deployment.

VPC Operates in 2 modes:
    *   Manual Mode         ( Pods will be upsized and downsized automatically : but involves downtime )
    *   Automatic Mode      ( When you enable in autoMode, you just get suggestions )

!!! You cannot work or run VPA's by default, you need to enable few options on the cluster, then only VPA will work.

    Ref: https://www.kubecost.com/kubernetes-autoscaling/kubernetes-vpa/ 

    VPA to work, we need to enable the Admission Controller for the VPA ( Above documentation instructs the same )

### How EKS Cluster AutoScaling Works ?

    1) Just like how pods HPA works, likewise with in the min & max values of the EKS Cluster Nodepool, the number of nodes would upsized and downsize automatically. 
    2) What will happen if the pod that you're trying to scale is a big pod and current pod cannot accomodate ? ( Pod goes to pending state and that creates an event to add one more node in the cluster node pool )

    > Whenever pods go for unschedule state, autoScaler should create another node 
    > We need to deploy auto-scaler and for this auto-scaler we need to attach the IAM Roles ( OIDC )


### Scheduling 
    > Scheduling would be done by scheduler on the control plane of kubernetes
    > Scheduler by default schedules the pods on the nodes as per the availability.

    > What if you don't want pods to be scheduled on a specfic or specific set of nodes. 
    > What if I want my pods of deployment x and y should be deployed on the same node.
    > What if my pods of deployment x and y should never ever be deployed on the same node.
    > What if I want my pods should be deployed on the nodes at a balancer aspect per zone to keep the hig-availability.
    > What if you've pods of important applications vs pods of low priority applications and would like to make sure, pods of high-priority should be taken in to consideration first.
    > What if low-priority pods are already running and if you schedule high-priority jobs and if resources are not available to accomodate high-priority pods, low priority pods should be evicted from the node ? Pod Priority & Preemption comes up.

Concepts: ( All the below topics are to make sure how and where scheduling should be done by the scheduler )

    ```
        1) Taints
        2) Tolerations
        3) Node Selectors
        4) Pod affinity
        5) Pod Antifnity 
        6) Topology Constraints 
        7) Pod Priority 
        8) Preemptions 
    ```

    Use cases:

        1) You've 3 types of nodes on the cluster that has SSD Disks, HDD Disks, Flash Drives

    

    How to see the labels of the nodes ?

        ```
            $ kc get nodes -o wide --show-labels
        ```
    
    # How to label the nodes ?

        ```
            $ kubectl label nodes ip-172-31-39-2.ec2.internal  disktype=flashdriv
        ```

Using nodeSelector, we can define the where to schedule the pods ?

How can we make sure that pods should not be scheduled on the nodes of our choice ?

Taints:
    Taint is a feature that allows scheduler not to schedule pods on the node that has taints.
    Only the pods that has tolerations to that taint can be allowed to be scheduled on the tained node 

Taints can be operated in 3 modes:
    1) NoExecute         : Pods that do not tolerate the taint are evicted immediately
    2) NoSchedule        : No new Pods will be scheduled on the tainted node unless they have a matching toleration. Pods currently running on the node are not evicted. 
    3) PreferNoSchedule : PreferNoSchedule is a "preference" or "soft" version of NoSchedule. The control plane will try to avoid placing a Pod that does not tolerate the taint on the node, but it is not guaranteed.

How to taint a node ?

    ```
        $ kubectl taint nodes ip-172-31-31-19.ec2.internal app=expense:NoSchedule

        Workloads going forward cannot be scheduled on the top of this node.
    ``` 

Whenever we are taking maintenance of the cluster ( Updating from one version to other verison.)

    1.29.3 ( Majorverison.minorVersion.servicePack)

    We can only upgrade from one minor version to other minor version ( 1.29.3 to 1.30.1 to 1.31.0 ) 
    But we can move from one service pack to other service packge without any dependency 

    In the maintenance window, typically first master will be upgraded and then worked nodes will be upgraded. 


In the unmanaged/on-prem kubernetes cluster, if you wish to do maintenance on the node, then we first mark that node in maintenance using an option called as "cordon". Once you cordon the node, new workloads won't be scheduled on it and that turns to NotReady State.

```
$ kc get nodes -o wide
NAME                           STATUS   ROLES    AGE     VERSION             INTERNAL-IP    EXTERNAL-IP       OS-IMAGE              KERNEL-VERSION                    
ip-172-31-31-19.ec2.internal   Ready    <none>   58m   v1.31.0-eks-a737599   172.31.31.19   54.227.47.239   Amazon Linux    6.1.112-122.189.amzn2023.x86_64   
ip-172-31-39-2.ec2.internal    Ready    <none>   58m   v1.31.0-eks-a737599   172.31.39.2    54.82.22.139    Amazon Linux    6.1.112-122.189.amzn2023.x86_64  

$ kc cordon ip-172-31-39-2.ec2.internal
NAME                           STATUS                     ROLES    AGE   VERSION               INTERNAL-IP    EXTERNAL-IP             OS-IMAGE                       
ip-172-31-31-19.ec2.internal   Ready                      <none>   60m   v1.31.0-eks-a737599   172.31.31.19   54.227.47.239   Amazon Linux 2023.6.20241010   6.1.112-122.189.
ip-172-31-39-2.ec2.internal    Ready,SchedulingDisabled   <none>   60m   v1.31.0-eks-a737599   172.31.39.2    54.82.22.139    Amazon Linux 2023.6.20241010   6.1.112-122.189.
```

1) First we cordon the nodes ( this disabled the scheduled , existing workloads will run as it )
    $ kc cordon ip-172-31-39-2.ec2.internal
2) Next is to drain the node ( existing workloads as per the graceful internal, they will run and will evicted and will be scheduled as per the expections on the other nodes )
    $ kc drain ip-172-31-39-2.ec2.internal --grace-period=30
3) Once maintenance is completed, we would uncordon the node 
    $ kc uncordon ip-172-31-39-2.ec2.internal

4) How to remove the taint on a node?   
    $  kubectl taint nodes ip-172-31-31-19.ec2.internal app-  ( taint keyName- )


### Topology Constraint :

```
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    region: us-east
spec:
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  topologySpreadConstraints:
  - maxSkew: 1 
    topologyKey: topology.kubernetes.io/zone 
    whenUnsatisfiable: DoNotSchedule 
    labelSelector: 
      matchLabels:
        region: us-east 
    matchLabelKeys:
      - my-pod-label 
  containers:
  - image: "docker.io/ocpqe/hello-pod"
    name: hello-pod
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: [ALL]
```

> Key Points: 

```
    1) The maximum difference in number of pods between any two topology domains. The default is 1, and you cannot specify a value of 0.
    2) The key of a node label. Nodes with this key and identical value are considered to be in the same topology.
    3) How to handle a pod if it does not satisfy the spread constraint. The default is DoNotSchedule, which tells the scheduler not to schedule the pod. Set to ScheduleAnyway to still schedule the pod, but the scheduler prioritizes honoring the skew to not make the cluster more imbalanced.
    4) Pods that match this label selector are counted and recognized as a group when spreading to satisfy the constraint. Be sure to specify a label selector, otherwise no pods can be matched.
    5) Be sure that this Pod spec also sets its labels to match this label selector if you want it to be counted properly in the future.
    6) A list of pod label keys to select which pods to calculate spreading over.
```

### Pod Priority 

Pods can have priority. Priority indicates the importance of a Pod relative to other Pods. If a Pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority Pods to make scheduling of the pending Pod possible.


### We can also define the kubelet configuration, to define when to evict the pods. 

Sample Kubelte config to evict the pods from the nodes if it's left with 500Mb memory

```
    apiVersion: kubelet.config.k8s.io/v1beta1
    kind: KubeletConfiguration
    evictionHard:
    memory.available: "500Mi"
    evictionMinimumReclaim:
    memory.available: "0Mi"

```

### Cluster Autoscaler:

    1) Cluster Autoscaler listens to the node stress events and would be autoscaline the nodes in the node pool as per the max cap values
    2) Cluster Autoscaler is a deployment that has to go to kube-system.
    3) Pods of the Cluster AutoScaler Deployment should have the needed IAM Roles attached to launch the new nodes in the cluster.
    4) We will also learn a concept in IAM called OIDC Provider 


Goal: 
    1) To launch k8 work load with with sevice account 
    2) Create OIDC Provider on cluster 
    3) Create IAM Role that has permissions to launch nodes in eks cluster nodepool 
    4) Binding of IAM Role with K8-SA can be achieled by using the OIDC 
    5) Then that k8 workload will get the needed roles to launch the nodes in the cluster.

Tomorrow OIDC Integration.

### Deploy Expense App On Kubernetes
1) Expense app on k8s


Helm Charts :
1) Helm offers parameterizing the entire manifest
2) Keep the code dry by eliminating the common patterns
3) Also helps in dealing multiple environments with a single definition. 


This is how a helm-chart looks like and name of the folder should be as defined.
```
    mychart/
        Chart.yaml
        values.yaml
        charts/
        templates/
```

chart.yaml : holds the metadata of the chart, like chartName, apiVersion, version of the chart,
values.yaml: this is where you supply all the needed values and name of the values.yaml can you any file like dev.yaml, test.yaml, prod.yaml.
charts/ : This folder holds sub charts or dependent charts or charts in charts 
templates/ :This folder holds the deployment, service, configmap template structure


### Helm Commands :
    $ helm create chart-name  ( Creates chart )
    $ helm install chartName ./chartLocation -f values.yaml   ( values.yaml )
      you cannot run the install command multiple times with the same name and if there are any change in the values, you to go by "helm update" 
    
    $ helm upgrade --install ./chartLocation -f values.yaml 
    helm upgrade --install frontend  ./helm-charts/  -f helm-charts/frontend.yam 

What's next ?
1) We will see some more advanced options in heml and will try to optimzie the charts using those options.
2) Let's target deployments of helm using UI [ ArgoCD: Deployment Tools For K8's]

ArgoCD: 
    1) This is a CD Tool designed for kubernetes
    2) It has reconissance
    3) Reconsilation