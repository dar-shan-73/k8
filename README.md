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