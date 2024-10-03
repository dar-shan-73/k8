# learn-kubernetes

How to learn kubernetes ?
    1) We need to have a kubernetes cluster provisioned 

How to provision a kubernetes cluster ?

    1) Managing your cluster by using EC2 / On-Prem Instances 
        a) Create instances 
        b) Install Run time     ( PodMan/Docker )
        c) Install Kubernetes  
        d) Enroll the nodes 
    
    2) Using Managed Services From Cloud 

        a) AWS   ( EKS )  [ Preferred ]
        b) GCP   ( GKE )
        c) Azure ( AKS ) 
    
    3) Learning Environment : Minikube   ( We will start with this for the next 2 days )

        a) Create an EC2 Instance 
        b) Install Minukube On It

Most of the information can be availed from `kubernetes.io`

How to connect to kubernets cluster ?

    a) First we need to have `kubectl` installed on your computer or on the server from where you're trying to connect 

What is `kubectl` ?
    
    kubectl is a kubernetes client to connect to the kubernetes cluster ( which is a CLI based tool )