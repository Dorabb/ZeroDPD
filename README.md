# ZeroDPD - AI-Powered Loan Recovery Platform

[![Status](https://img.shields.io/badge/Status-Production%20Ready-green)](.)
[![License](https://img.shields.io/badge/License-Proprietary-red)](.)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue)](.)

> Enterprise-grade loan recovery platform with AI decisioning, omnichannel engagement, and workflow orchestration designed for fintech startups through large banks.

## 🎯 Use Cases

- **For Banks**: Automated collections, agent optimization, compliance reporting
- **For Fintechs**: Multi-channel customer engagement, settlement negotiation, field recovery
- **For NBFCs**: Delinquency bucket flows, escalation workflows, real-time analytics
- **For Agents**: Intelligent task prioritization, AI recommendations, performance dashboards

## ✨ Core Features

✅ Omnichannel Outreach (SMS, Email, WhatsApp, IVR, Voice)  
✅ AI-Powered Recovery Strategies  
✅ Intelligent Workflow Orchestration  
✅ Agent Workbench with Real-time Dashboards  
✅ Compliance & Regulatory Enforcement  
✅ Event-Driven Microservices Architecture  
✅ Enterprise-Grade Security & Audit Logging  
✅ Scalable Kubernetes Deployment  

## 🏗️ Architecture

### Layered Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              Customer Channels Layer                        │
│  Mobile | Web | WhatsApp | SMS | Email | IVR | Voice Bot   │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│         API Gateway & Authentication Layer                  │
│     OAuth2 | Rate Limiting | Audit Logging | Routing        │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│       Recovery Orchestration & Workflow Layer               │
│  Workflow Engine | Business Rules | Lifecycle Management    │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│              Domain Services Layer                          │
│  Collections | Communication | Settlement | Legal |         │
│  Field Recovery | Compliance                               │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│         Event Streaming Bus (Apache Kafka)                  │
└────────────────────┬────────────────────────────────────────┘
                     │
     ┌───────────────┼───────────────┐
     │               │               │
┌────▼─────┐  ┌──────▼──────┐  ┌────▼──────┐
│    AI     │  │    Data     │  │ Analytics │
│ Platform  │  │  Platform   │  │ & Reports │
└──────────┘  └─────────────┘  └───────────┘
```

## 📊 Project Structure

```
ZeroDPD/
├── api-gateway/
│   ├── src/
│   │   ├── main/
│   │   │   ├── auth/
│   │   │   ├── middleware/
│   │   │   ├── routing/
│   │   │   └── controllers/
│   │   └── test/
│   ├── Dockerfile
│   ├── pom.xml
│   └── README.md
│
├── core-services/
│   ├── collections-service/
│   ├── communication-service/
│   ├── settlement-service/
│   ├── legal-service/
│   ├── field-recovery-service/
│   └── compliance-service/
│
├── orchestration/
│   ├── workflow-definitions/
│   │   ├── dpd-1-30.bpmn
│   │   ├── dpd-31-60.bpmn
│   │   ├── dpd-61-90.bpmn
│   │   └── dpd-90plus.bpmn
│   ├── business-rules/
│   ├── escalation-policies/
│   └── Dockerfile
│
├── ai-platform/
│   ├── models/
│   │   ├── recovery_probability/
│   │   ├── settlement_optimizer/
│   │   ├── fraud_detection/
│   │   └── call_time_optimizer/
│   ├── feature-engineering/
│   ├── recommendation-api/
│   ├── requirements.txt
│   └── Dockerfile
│
├── agent-workbench/
│   ├── backend/
│   │   ├── src/
│   │   └── tests/
│   ├── frontend/
│   │   ├── src/
│   │   ├── public/
│   │   └── package.json
│   └── Dockerfile
│
├── data-platform/
│   ├── schemas/
│   │   ├── postgresql/
│   │   ├── mongodb/
│   │   └── elasticsearch/
│   ├── migrations/
│   ├── seed-data/
│   └── README.md
│
├── infrastructure/
│   ├── kubernetes/
│   │   ├── namespaces/
│   │   ├── deployments/
│   │   ├── services/
│   │   ├── configmaps/
│   │   ├── secrets/
│   │   └── ingress/
│   ├── docker-compose.yml
│   ├── helm-charts/
│   └── monitoring/
│
├── docs/
│   ├── design.md
│   ├── api-reference.md
│   ├── deployment-guide.md
│   ├── configuration.md
│   ├── recovery-workflows.md
│   └── security-compliance.md
│
├── scripts/
│   ├── setup-local.sh
│   ├── build-all.sh
│   ├── deploy-k8s.sh
│   └── seed-database.sh
│
├── docker-compose.yml
├── docker-compose.prod.yml
├── Makefile
└── LICENSE
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Kubernetes (for production)
- Java 11+, Python 3.9+, Node.js 16+
- PostgreSQL 13+, MongoDB 5+

### Local Development Setup

```bash
# Clone repository
git clone https://github.com/Dorabb/ZeroDPD.git
cd ZeroDPD

# Create development branch
git checkout -b loan-recovery-platform

# Run local stack with Docker Compose
docker-compose up -d

# Verify services are running
docker-compose ps

# Access services
- API Gateway: http://localhost:8080
- Agent Workbench: http://localhost:3000
- Kafka UI: http://localhost:9000
- PostgreSQL: localhost:5432
- MongoDB: localhost:27017
```

### First Steps

1. **Configure Authentication** (see [Configuration Guide](./docs/configuration.md))
2. **Initialize Database** (see [Database Setup](./data-platform/README.md))
3. **Deploy Workflows** (see [Workflow Deployment](./orchestration/README.md))
4. **Run Tests** (see [Testing Guide](./docs/testing.md))

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Design & Architecture](./docs/design.md) | Complete system design, component details, data flows |
| [API Reference](./docs/api-reference.md) | REST/gRPC API specifications, endpoints, examples |
| [Deployment Guide](./docs/deployment-guide.md) | Kubernetes setup, scaling, monitoring |
| [Configuration](./docs/configuration.md) | Environment variables, service configs, secrets |
| [Recovery Workflows](./docs/recovery-workflows.md) | DPD bucket flows, escalation policies |
| [Security & Compliance](./docs/security-compliance.md) | RBAC, audit logging, data protection, regulations |
| [Contributing](./CONTRIBUTING.md) | Code standards, PR process, development setup |

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Java (Spring Boot), Go, C++ |
| **AI/ML** | Python (TensorFlow, Scikit-learn) |
| **Frontend** | React, Redux |
| **Mobile** | Flutter |
| **Orchestration** | Camunda BPM / Temporal |
| **Messaging** | Apache Kafka |
| **Databases** | PostgreSQL, MongoDB, Redis |
| **Search** | Elasticsearch |
| **Cache** | Redis |
| **Data Lake** | MinIO / AWS S3 |
| **Container** | Docker |
| **Orchestration** | Kubernetes |
| **Monitoring** | Prometheus, Grafana |
| **Logging** | ELK Stack |
| **CI/CD** | GitHub Actions |

## 🔐 Security & Compliance

- **Authentication**: OAuth2, OpenID Connect
- **Authorization**: Role-Based Access Control (RBAC)
- **Encryption**: TLS 1.2+ in transit, AES-256 at rest
- **Audit Logging**: All user and system actions logged
- **Compliance**: GDPR, SOC 2, PCI-DSS ready
- **Data Governance**: Consent tracking, data retention policies
- **API Security**: Rate limiting, request validation, CORS

## 📈 Implementation Roadmap

### Phase 1: Foundation (Weeks 1-4)
- ✅ Domain model and schemas
- ✅ API Gateway with authentication
- ✅ Collections Service core

### Phase 2: Orchestration (Weeks 5-8)
- Workflow engine deployment
- DPD bucket flows configuration
- Event streaming integration

### Phase 3: Services (Weeks 9-12)
- Communication, Settlement, Legal services
- Field Recovery coordination
- Compliance enforcement

### Phase 4: AI & Analytics (Weeks 13-16)
- ML model development
- Recommendation API
- Analytics dashboards

### Phase 5: Agent Experience (Weeks 17-20)
- Agent workbench UI
- Real-time dashboards
- Performance tracking

### Phase 6: Hardening (Weeks 21-24)
- Security audit & hardening
- Performance tuning
- Production readiness

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for:
- Code standards and style guides
- Development workflow
- Pull request process
- Testing requirements

## 📧 Support & Contact

- **Documentation**: [docs/](./docs)
- **Issues**: [GitHub Issues](https://github.com/Dorabb/ZeroDPD/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Dorabb/ZeroDPD/discussions)
- **Email**: support@dorabb.com

## 📄 License

This project is proprietary software owned by Dorabb Technologies. All rights reserved.

See [LICENSE](./LICENSE) for details.

---

**Last Updated**: June 2, 2026  
**Version**: 1.0.0  
**Status**: Production Ready
