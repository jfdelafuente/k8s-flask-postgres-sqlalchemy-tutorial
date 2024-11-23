# variable
export DEMO="demo"

# variable global 
export GKE_PROJECT_ID= "$DEMO -base-gke" 

# variables de red 
export GKE_NETWORK_NAME= "base-main" 
export GKE_SUBNET_NAME= "base-private" 
export GKE_ROUTER_NAME= "base-router" 
export GKE_NAT_NAME= "base-nat" 

# variables principales 
export GKE_SA_NAME= "gke-worker-nodes-sa" 
export GKE_SA_EMAIL= " $GKE_SA_NAME @ ${GKE_PROJECT_ID} .iam.gserviceaccount.com" 

# variables gke 
export GKE_CLUSTER_NAME= "base-gke" 
export GKE_REGION= "us-central1" 
export GKE_MACHINE_TYPE= "e2-standard-2" 

# variables de cliente kubectl 
export USE_GKE_GCLOUD_AUTH_PLUGIN= "True" 
export KUBECONFIG=~/.kube/gcp/ $GKE_REGION - $GKE_CLUSTER_NAME .yaml

export CLOUD_BILLING_ACCOUNT="<mi-cuenta-de-facturacion-en-la-nube>"

