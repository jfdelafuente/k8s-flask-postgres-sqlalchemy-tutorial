# Kubernetes + Docker + Flask + Postgres + Sqlalchemy + Gunicorn — Deploy your flask application on Kubernetes

## This project is based on an article on <a href="https://medium.com/@mudasiryounas/kubernetes-docker-flask-postgres-sqlalchemy-gunicorn-deploy-your-flask-application-on-57431c8cbd9f" target="_blank" />Medium</a>.

## Read the full article on <a href="https://medium.com/@mudasiryounas/kubernetes-docker-flask-postgres-sqlalchemy-gunicorn-deploy-your-flask-application-on-57431c8cbd9f" target="_blank" />here</a>.

## Creamos la imagen docke

Step 1) Build our flask image
Let’s start with building our docker image for our flask application.


docker build -t flask-image .

docker images

Step 2) Test flak image by running on localhost
Since our image is ready, we can now run our image to check if everything is working fine.

Run the following command

docker run -p 5001:5000 flask-image

Here -p 5001:5000 is mapping 5001 port from localhost to 5000 port inside flask container, since flask container is running at 5000 port as we mention in our entrypoint.sh file.

Here you can see our Gunicorn is running on port 5000 inside the container, and we are mapped 5001 port to 5000 inside the container, So if now we open any browser and navigate to 0.0.0.0:5001/test we will be able to see our application is working.

Step 3) Push flask image to container registry of Google Cloud Platform

Step 3.1) Push flask image to GCP de form manual

Step 3.2) Automatizar con Cloud Build