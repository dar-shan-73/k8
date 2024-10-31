What can be done better here ?
1) Most of the is WET 
2) Strucute is same, just values are changing. 
3) If you want to parameterize it, the only value that you can parameterize is IMAGE 

Using Kubernetes Package Manager, we can parameterize to 100% of the k8 manifest files. 

    Pupular of kubernetes package managers: Helm, Kustomize 

    HELM is a very popular package manager, using this we can achieve 100% dry in k8 manifests file and offers single shot deployments including dependencies. 


Just like how Ansible playbooks has their own patterns, like wise we HELM Charts will also have a structed that we need to follow.