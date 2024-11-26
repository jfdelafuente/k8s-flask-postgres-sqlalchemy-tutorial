#######################
# create VPC for target region
#######################################
gcloud compute networks create $GKE_NETWORK_NAME \
  --subnet-mode=custom \
  --mtu=1460 \
  --bgp-routing-mode=regional

#######################
# create subnet (spanning all availability zones w/i region)
#######################################
gcloud compute networks subnets create $GKE_SUBNET_NAME \
  --network=$GKE_NETWORK_NAME \
  --range=10.10.0.0/24 \
  --region=$GKE_REGION \
  --enable-private-ip-google-access

#######################
# add support for outbound traffic
#######################################
gcloud compute routers create $GKE_ROUTER_NAME \
  --network=$GKE_NETWORK_NAME \
  --region=$GKE_REGION

gcloud compute routers nats create $GKE_NAT_NAME \
  --router=$GKE_ROUTER_NAME \
  --region=$GKE_REGION \
  --nat-custom-subnet-ip-ranges=$GKE_SUBNET_NAME \
  --auto-allocate-nat-external-ips