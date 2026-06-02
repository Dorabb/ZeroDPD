# ZeroDPD Deployment Guide

## Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (1.20+)
- kubectl configured
- Helm 3.0+
- Docker registry access

### Environment Setup

1. Create namespace:
```bash
kubectl create namespace zerodpd
```

2. Create ConfigMaps and Secrets:
```bash
kubectl create configmap zerodpd-config --from-file=config/ -n zerodpd
kubectl create secret generic zerodpd-secrets --from-file=secrets/ -n zerodpd
```

### Deploy Services

1. Deploy PostgreSQL:
```bash
helm install postgres bitnami/postgresql -n zerodpd
```

2. Deploy Kafka:
```bash
helm install kafka confluentinc/cp-helm-charts -n zerodpd
```

3. Deploy ZeroDPD services:
```bash
helm install zerodpd ./helm-charts/zerodpd -n zerodpd
```

### Verify Deployment

```bash
kubectl get pods -n zerodpd
kubectl get services -n zerodpd
```

### Scale Services

```bash
kubectl scale deployment api-gateway --replicas=3 -n zerodpd
kubectl scale deployment collections-service --replicas=5 -n zerodpd
```

### Monitor Logs

```bash
kubectl logs -f deployment/api-gateway -n zerodpd
```

## Docker Compose (Local Development)

```bash
docker-compose up -d
```

This starts:
- PostgreSQL
- MongoDB
- Redis
- Kafka
- All ZeroDPD services
