#######################
# list of minimal required roles
#######################################
ROLES=(
  roles/logging.logWriter
  roles/monitoring.metricWriter
  roles/monitoring.viewer
  roles/stackdriver.resourceMetadata.writer
)

#######################
# create google service account principal
#######################################
gcloud iam service-accounts create $GKE_SA_NAME \
  --display-name $GKE_SA_NAME --project $GKE_PROJECT_ID

#######################
# assign google service account to roles in GKE project
#######################################
for ROLE in ${ROLES[*]}; do
  gcloud projects add-iam-policy-binding $GKE_PROJECT_ID \
    --member "serviceAccount:$GKE_SA_EMAIL" \
    --role $ROLE
done