# Persistent Volumes
kubectl get pvc --all-namespaces

# Kubernetes Cluster
gcloud container clusters delete $GKE_CLUSTER_NAME

# you may want to clean up any configuration files on your system:
rm -f $KUBECONFIG

# Network Infrastructure
gcloud compute routers nats delete $GKE_NAT_NAME --router $GKE_ROUTER_NAME
gcloud compute routers delete $GKE_ROUTER_NAME
gcloud compute networks subnets delete $GKE_SUBNET_NAME
gcloud compute networks delete $GKE_NETWORK_NAME


# Delete the Service Account and Role Assignments

#######################
# list of roles configured earlier
#######################################
ROLES=(
  roles/logging.logWriter
  roles/monitoring.metricWriter
  roles/monitoring.viewer
  roles/stackdriver.resourceMetadata.writer
)


#######################
# remove service account from roles
#######################################
for ROLE in ${ROLES[*]}; do
  gcloud projects remove-iam-policy-binding $GKE_PROJECT_ID \
    --member "serviceAccount:$GKE_SA_EMAIL" \
    --role $ROLE
done


# After removing access from the project, delete the unused service account:
gcloud iam service-accounts delete $GKE_SA_EMAIL --project $GKE_PROJECT_ID