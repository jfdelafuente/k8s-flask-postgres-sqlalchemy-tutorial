# variable
export DEMO="$PROJECT_ID"

# variable global 
export GKE_PROJECT_ID="$DEMO"

# variables de red 
export GKE_NETWORK_NAME="$DEMO-base-main" 
export GKE_SUBNET_NAME="$DEMO-base-private" 
export GKE_ROUTER_NAME="$DEMO-base-router" 
export GKE_NAT_NAME="$DEMO-base-nat" 

# variables principales 
# export GKE_SA_NAME="$DEMO-gke-worker-nodes-sa" 
export GKE_SA_NAME="$DEMO-gke-sa" 
export GKE_SA_EMAIL="$GKE_SA_NAME@${GKE_PROJECT_ID}.iam.gserviceaccount.com" 

# variables gke 
export GKE_CLUSTER_NAME="$DEMO-base-gke" 
export GKE_REGION="$REGION" 
export GKE_MACHINE_TYPE="e2-standard-2" 

# variables de cliente kubectl 
export USE_GKE_GCLOUD_AUTH_PLUGIN="True" 
export KUBECONFIG=~/.kube/gcp/$GKE_REGION-$GKE_CLUSTER_NAME.yaml

export CLOUD_BILLING_ACCOUNT="0152B2-7E0055-F23A0D"



