# ZeroDPD Deployment Guide

## Local Development Setup

### Quick Start with Docker Compose

```bash
# Clone repository
git clone https://github.com/Dorabb/ZeroDPD.git
cd ZeroDPD

# Checkout development branch
git checkout loan-recovery-platform

# Start all services
docker-compose up -d

# Verify services are running
docker-compose ps

# View logs
docker-compose logs -f api-gateway
```

**Local Service URLs:**
- API Gateway: `http://localhost:8080`
- Agent Workbench: `http://localhost:3000`
- Kafka UI: `http://localhost:9000`
- PostgreSQL: `localhost:5432`
- MongoDB: `localhost:27017`
- Redis: `localhost:6379`

## Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (1.20+)
- kubectl configured
- Helm 3.0+

### Step 1: Create Namespace

```bash
kubectl create namespace zerodpd
```

### Step 2: Create Secrets

```bash
# PostgreSQL secret
kubectl create secret generic postgres-secret \
  --from-literal=password=secure_password \
  -n zerodpd

# OAuth2 secret
kubectl create secret generic oauth2-secret \
  --from-literal=client-id=zerodpd-client \
  --from-literal=client-secret=client_secret \
  -n zerodpd
```

### Step 3: Deploy Infrastructure

```bash
# Deploy PostgreSQL
helm install postgres bitnami/postgresql \
  --values infrastructure/helm-charts/postgres-values.yaml \
  -n zerodpd

# Deploy MongoDB
helm install mongodb bitnami/mongodb \
  --values infrastructure/helm-charts/mongodb-values.yaml \
  -n zerodpd

# Deploy Redis
helm install redis bitnami/redis \
  --values infrastructure/helm-charts/redis-values.yaml \
  -n zerodpd

# Deploy Kafka
helm install kafka confluentinc/cp-helm-charts \
  --values infrastructure/helm-charts/kafka-values.yaml \
  -n zerodpd
```

### Step 4: Deploy ZeroDPD Services

```bash
helm install zerodpd ./infrastructure/helm-charts/zerodpd \
  --values infrastructure/helm-charts/zerodpd-values.yaml \
  -n zerodpd
```

### Step 5: Verify Deployment

```bash
# Check pods
kubectl get pods -n zerodpd

# Check services
kubectl get svc -n zerodpd

# View logs
kubectl logs -f deployment/api-gateway -n zerodpd
```

## Scaling

### Scale Individual Services

```bash
# Scale collections-service to 5 replicas
kubectl scale deployment collections-service --replicas=5 -n zerodpd

# Scale api-gateway to 3 replicas
kubectl scale deployment api-gateway --replicas=3 -n zerodpd
```

## Monitoring

### Deploy Prometheus

```bash
helm install prometheus prometheus-community/kube-prometheus-stack -n zerodpd
```

### Deploy Grafana

```bash
kubectl port-forward svc/prometheus-grafana 3000:80 -n zerodpd
# Access at http://localhost:3000
```

## Database Initialization

### PostgreSQL Migrations

```bash
kubectl exec -it api-gateway-0 -n zerodpd -- \
  java -jar app.jar --migrate
```

## Troubleshooting

### Check Pod Logs

```bash
kubectl logs <pod-name> -n zerodpd
```

### SSH into Pod

```bash
kubectl exec -it <pod-name> -n zerodpd -- /bin/bash
```

### Check Service Connectivity

```bash
kubectl run debug --image=busybox --rm -it -- sh
# Inside pod:
ping api-gateway.zerodpd.svc.cluster.local
```

---

**Version**: 1.0  
**Last Updated**: June 2, 2026
