# deploy application
kubectl create namespace httpd-svc
kubectl create deployment httpd \
  --image=httpd \
  --replicas=3 \
  --port=80 \
  --namespace=httpd-svc

# provision external load balancer
cat <<EOF | kubectl apply --namespace httpd-svc -f -
apiVersion: v1
kind: Service
metadata:
  name: httpd
spec:
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  type: LoadBalancer
  selector:
    app: httpd
EOF