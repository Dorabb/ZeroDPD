# ZeroDPD - Architecture & Design Document

## 1. Executive Summary

ZeroDPD is a scalable, enterprise-grade loan recovery platform designed for fintech startups through large banks. It uses event-driven architecture with omnichannel customer engagement, workflow orchestration, AI decisioning, strong security, and data governance.

## 2. Architecture Overview

### 2.1 Layered Architecture

```
Customer Channels -> API Gateway -> Orchestration -> Domain Services -> Event Bus -> AI/Data/Analytics
```

### 2.2 Core Components

- **API Gateway**: OAuth2, rate limiting, routing, audit logging
- **Recovery Orchestration**: Workflow engine, business rules, DPD bucket management
- **Domain Services**: Collections, Communication, Settlement, Legal, Field Recovery, Compliance
- **Event Bus**: Apache Kafka for asynchronous processing
- **AI Platform**: Recovery probability, settlement optimizer, call time optimization
- **Data Platform**: PostgreSQL, MongoDB, Redis, Elasticsearch, MinIO/S3

## 3. Recovery Workflow

### DPD-Based Escalation

- **EMI Missed (Day 0)**: Case creation, AI risk scoring
- **1-30 DPD**: Automated SMS, Email, WhatsApp outreach
- **31-60 DPD**: Assign to agent for voice calls, capture PTP
- **61-90 DPD**: Settlement team takes over, negotiate payment terms
- **90+ DPD**: Field recovery activation, legal escalation if needed

## 4. Data Model

Core entities:
- Customer
- Loan (EMI Schedule, Payment History, Delinquency History)
- Recovery Case
- Communication History
- Settlement
- Legal Case
- AI Scores

## 5. Security & Compliance

- OAuth2/OpenID Connect authentication
- Role-Based Access Control (RBAC)
- TLS 1.2+ encryption in transit, AES-256 at rest
- Comprehensive audit logging for all actions
- GDPR, SOC 2, PCI-DSS compliance ready
- Consent and disclosure tracking

## 6. Implementation Phases

### Phase 1: Foundation
- Domain models and database schemas
- API Gateway with OAuth2 authentication
- Collections Service core functionality

### Phase 2: Orchestration
- Workflow engine setup (Camunda/Temporal)
- DPD bucket BPMN workflows
- Kafka event streaming integration

### Phase 3: Services
- Communication Service (SMS, Email, WhatsApp)
- Settlement Service
- Legal and Field Recovery Services
- Compliance enforcement

### Phase 4: AI & Analytics
- Feature engineering pipelines
- Recovery prediction models
- Recommendation API
- Analytics dashboards

### Phase 5: Agent Experience
- Agent Workbench UI
- Real-time dashboards and metrics
- AI-guided recommendations

### Phase 6: Hardening
- Security audit and penetration testing
- Performance optimization
- Production readiness validation

---

**Version**: 1.0  
**Last Updated**: June 2, 2026  
**Author**: Dorabb Technologies
