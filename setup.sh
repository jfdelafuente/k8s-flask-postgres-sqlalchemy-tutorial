export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
export REGION=europe-southwest1
export ZONE=europe-southwest1-a
gcloud config set compute/region $REGION



# autorizar las API para el proyecto GKE
gcloud config set project $PROJECT_ID
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud config set compute/region $REGION