# crear un nuevo proyecto
gcloud projects create $GKE_PROJECT_ID 

# configurar la facturación para el proyecto GKE
gcloud beta billing projects link  $GKE_PROJECT_ID --billing-account $ClOUD_BILLING_ACCOUNT 

# autorizar las API para el proyecto GKE
gcloud config set project $GKE_PROJECT_ID
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud config set compute/region $GKE_REGION