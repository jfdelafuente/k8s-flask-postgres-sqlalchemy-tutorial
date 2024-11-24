# Kubernetes + Docker + Flask + Postgres + Sqlalchemy + Gunicorn — Deploy your flask application on Kubernetes

##### This project is based on an article on <a href="https://medium.com/@mudasiryounas/kubernetes-docker-flask-postgres-sqlalchemy-gunicorn-deploy-your-flask-application-on-57431c8cbd9f" target="_blank" />Medium</a>

## Step 0) Requisitos previos

Crea un proyecto nuevo para asegurarte de tener los permisos que necesitas o selecciona un proyecto existente en el que tengas los permisos relevantes.

```bash
    source setup.sh
```

## Step 1) Creamos la imagen docker

### Step 1.1) Build our flask image

  Let’s start with building our docker image for our flask application.

  ```bash
  docker build -t flask-image .
  ```

  ```bash
  docker images
  ```

### Step 1.2) Test flak image by running on localhost

  Since our image is ready, we can now run our image to check if everything is working fine.

  Run the following command

  ```bash
  docker run -p 5001:5000 flask-image
  ```

  Here -p 5001:5000 is mapping 5001 port from localhost to 5000 port inside flask container, since flask container is running at 5000 port as we mention in our entrypoint.sh file.

  Here you can see our Gunicorn is running on port 5000 inside the container, and we are mapped 5001 port to 5000 inside the container, So if now we open any browser and navigate to 0.0.0.0:5001/test we will be able to see our application is working.

## Step 2) Push flask image to container registry of Google Cloud Platform

### Step 2.1) Crea un repositorio de Docker en Artifact Registry

  Crear un repositorio en Google Artifact Registry para almacenar las imagenes de los contenedores

  ```bash
  # Habilitamos las APIs obligatorias
  gcloud services enable artifactregistry.googleapis.com

  # Creamos el repositorio
  gcloud artifacts repositories create my-repository \
    --repository-format=docker \
    --location=$REGION

  # Verificamos que se ha creado el repositorio
  gcloud artifacts repositories list
  ```

### Step 2.2) Push flask image to GCP

Existen varias alternativas:

1. **Push flask image to GCP de form manual**

    Compila y etiqueta la imagen de Docker para hello-app:

    ```bash
    docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-app:v1 .
    ```

    Asegúrate de que la API de Artifact Registry esté habilitada para el proyecto de Google Cloud en el que estás trabajando:

    ```bash
    gcloud services enable artifactregistry.googleapis.com
    ```

    Configura la herramienta de línea de comandos de Docker para que se autentique en Artifact Registry:

    ```bash
    gcloud auth configure-docker ${REGION}-docker.pkg.dev
    ```

    Envía la imagen de Docker que acabas de compilar al repositorio:

    ```bash
    docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-app:v1
    ```

    Ahora que la imagen de Docker está almacenada en Artifact Registry. Ejecuta la imagen de Docker que compilaste antes:

    ```bash
    docker run ${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-app:v1
    ```

2. **Cloud Build - Compila una imagen con un Dockerfile**

    Cloud Build te permite compilar una imagen de Docker mediante un Dockerfile. No se necesita un archivo de configuración de Cloud Build diferente.

    ```bash
    COMMIT_ID="$(git rev-parse --short=7 HEAD)"
    gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-cloudbuild:${COMMIT_ID}" .
    ```

    Acabas de compilar una imagen de Docker llamada hello-cloudbuild mediante un Dockerfile y enviaste la imagen a Artifact Registry.

3. **Cloud Build - Compila una imagen mediante un archivo de configuración de compilación**

    En esta sección, usarás un archivo de configuración de Cloud Build para compilar la misma imagen de Docker que la anterior. El archivo de configuración de compilación indica a Cloud Build que realice tareas según tus especificaciones.

    En el mismo directorio que contiene quickstart.sh y Dockerfile, crea un archivo llamado cloudbuild.yaml con el siguiente contenido. Este archivo es tu archivo de configuración de compilación. A la hora de la compilación, Cloud Build reemplaza de forma automática $PROJECT_ID por tu ID del proyecto.

    ```bash
    steps:
    - name: 'gcr.io/cloud-builders/docker'
      script: |
        docker build -t us-central1-docker.pkg.dev/$PROJECT_ID/my-repository/hello-image:$SHORT_SHA .
      automapSubstitutions: true
    images:
    - 'us-central1-docker.pkg.dev/$PROJECT_ID/my-repository/hello-image:$SHORT_SHA'
    ```

    Comienza la compilación mediante la ejecución del siguiente comando:

    ```bash
    gcloud builds submit --region=$REGION --config cloudbuild.yaml
    ```

    Acabas de compilar *hello-image* mediante un archivo de configuración de compilación y enviaste la imagen a Artifact Registry.

##### Aprovisionar recurso en GCP

 Google Kubernetes Engine ( GKE ) es fácil de configurar y poner en marcha. Con solo un comando o unos pocos clics del mouse, puede tener un clúster completo listo para usar.

 El aprovisionamiento de GKE se realizará en el siguiente orden:

- Crear la cuenta de servicio de Google

    Debemos crear una cuenta de servicio más segura que tenga los privilegios mínimos necesarios para ejecutar un clúster de GKE.

    ```bash
    source privilegios.sh
    ```

- Crear la subred privada

    Al aprovisionar GKE , se utilizarán la VPC y la subred predeterminadas, lo que puede aumentar la superficie de ataque del clúster de GKE . Todo lo que se ejecute en la subred y posiblemente fuera de Internet público podrá acceder al clúster de GKE .

    El primer paso para cambiar este comportamiento sería crear una nueva VPC y subred con enrutamiento saliente a Internet, de modo que el clúster pueda extraer imágenes de un registro de contenedores externo como Docker Hub o Quay.

    📓 NOTA : A continuación, se creará una infraestructura de red regional local adecuada para esta demostración. Para las organizaciones que puedan necesitar aprovisionar clústeres de GKE en varias regiones, deberá configurar una red VPC compartida . Los casos de uso de varios clústeres no se abordarán en este artículo.

    Lo siguiente creará una subred privada con un enrutador y NAT para el tráfico saliente, que es necesario para extraer una imagen de contenedor de Internet.

    ```bash
    source infraestructura.sh
    ```

- Cree el clúster de GKE utilizando la cuenta de servicio y la subred privada

    Podemos crear un clúster de GKE que use una subred privada y Google Service Account(GSA) con el mínimo privilegio con el siguiente comando.

    ```bash
    source cluster.sh
    ```

    📓NOTA : Las configuraciones anteriores crearán worker nodes que estarán en una subred privada, pero los master nodes administrados por Google seguirán teniendo acceso público a Internet, que es necesario para la herramiente kubectl y se protegerá mediante credenciales de Google Cloud. Para proteger completamente también los master nodes, consulte Creación de un clúster privado, pero tenga en cuenta que esto también requerirá configurar el acceso a los master nodes configurando Cloud VPN , Identity Aware Proxy o usando un acceso basado en identidad como Boundary o una solución alternativa con VPN o una solución de host bastión. Este tema no se tratará en este artículo.

- Configurar el acceso del cliente de Kubernetes al clúster de GKE

    Durante la creación del clúster GKE, con KUBECONFIGla configuración de la variable de entorno, la configuración debe configurarse automáticamente.

    Si surge un motivo por el cual necesita configurarlo o actualizarlo, puede ejecutar el siguiente comando:

    ```bash
    gcloud container clusters  get-credentials $GKE_CLUSTER_NAME \
        --project $GKE_PROJECT_ID \
        --region $GKE_REGION
    ```

    Puede probar la funcionalidad con los siguientes comandos:

    ```bash
    kubectl get nodes
    kubectl get all --all-namespaces
    ```
