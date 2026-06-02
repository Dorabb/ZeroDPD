# ZeroDPD - AI-Powered Loan Recovery Platform: Architecture Design Document

## 1. Executive Summary

This document defines a scalable, enterprise-grade loan recovery platform designed for fintech startups through large banks. It uses an event-driven architecture with omnichannel customer engagement, workflow orchestration, AI decisioning, strong security, and data governance.

## 2. Architecture Overview

### 2.1 Layers

- **Customer Channels**
  - Mobile App, Web, WhatsApp, SMS, Email, IVR, Voice Bot
- **API Gateway Layer**
  - Authentication, Rate Limiting, Routing, Audit Logging
- **Recovery Orchestration Layer**
  - Workflow Engine: Camunda / Temporal
  - Business Rules Engine
  - Recovery Lifecycle Management
- **Domain Services**
  - Collections Service
  - Communication Service
  - Settlement Service
  - Legal Service
  - Field Recovery Service
  - Compliance Service
- **Event Streaming Bus**
  - Apache Kafka / RabbitMQ
- **AI Decision Platform**
  - Prediction Models, Recommendation API
- **Data Platform**
  - PostgreSQL, MongoDB, Redis, Elasticsearch, MinIO / S3, Data Warehouse
- **External Systems**
  - Core Banking, Loan Management System, Credit Bureau, Payment Gateway, CRM

### 2.2 Data Flow

1. Customer interaction enters via channel adapters
2. API Gateway authenticates and routes requests to orchestration or service endpoints
3. Recovery Orchestration determines next actions and emits events
4. Domain services handle execution and publish events to event bus
5. AI Decision Platform consumes events and returns recommendations
6. Analytics and reporting layers consume data for insights and dashboards

## 3. Component Summary

### 3.1 API Gateway

- Expose unified REST/gRPC APIs
- Enforce OAuth2 / OpenID Connect
- Apply rate limiting and routing
- Capture audit logs for security and compliance

### 3.2 Recovery Orchestration

- Controls delinquency bucket flows and escalation policies
- Coordinates automated and human-assisted recovery actions
- Supports conditional branching, SLA timers, and manual overrides

### 3.3 Collections Service

- Manages account status, delinquency buckets, and recovery lifecycle
- Tracks payment plans, promises, and case assignment
- Owns core loan and recovery transaction data

### 3.4 Communication Service

- Sends omnichannel outreach through SMS, Email, WhatsApp, IVR, and voice bot
- Records contact attempts, responses, and opt-in consent
- Supports channel-specific templates and compliance messaging

### 3.5 Settlement Service

- Manages settlement offers, negotiation workflows, and approvals
- Tracks settlement agreements and payment execution
- Stores settlement eligibility criteria and audit history

### 3.6 Legal Service

- Tracks legal cases, notices, court filings, and escalation events
- Manages documentation and legal status updates
- Integrates with compliance and case management systems

### 3.7 Field Recovery Service

- Coordinates field visits, agent dispatch, and asset inspections
- Captures evidence, photographs, and field reports
- Supports route planning, case handoff, and field status updates

### 3.8 Compliance Service

- Enforces regulatory checks and business policies
- Records consent, disclosures, and audit trails
- Evaluates communication rules and escalation criteria

### 3.9 AI Decision Platform

- Builds features from customer, loan, and behavior data
- Provides models for recovery probability, settlement likelihood, call timing, fraud detection, and segmentation
- Exposes a Recommendation API to workflows, dashboards, and bots

### 3.10 Agent Workbench

- Displays daily targets, priority accounts, and AI recommendations
- Provides call queue, follow-up queue, promise-to-pay tracker, settlement request dashboard, and performance metrics
- Enables agents to take action and update case progress in real time

## 4. Recovery Workflow

### 4.1 EMI Missed

- Bucket assignment and AI risk scoring
- Recovery prioritization and scheduling

### 4.2 1–30 DPD

- Automatic outreach via SMS, WhatsApp, Email
- Monitor responses and payments
- Close the case if paid

### 4.3 31–60 DPD

- Assign to collection agent for voice call
- Capture promise-to-pay and schedule follow-up
- Close if paid or escalate if missed

### 4.4 61–90 DPD

- Transfer to settlement team
- Negotiate payment terms and settlement offers
- Close on recovery if accepted, else escalate

### 4.5 90+ DPD

- Activate field recovery and physical collection
- Escalate to legal team if field recovery fails
- Close case on recovery, write-off, or legal resolution

## 5. AI Layer Architecture

### 5.1 Data Sources

- Customer profiles
- Loan details and payment history
- Delinquency and interaction history
- External bureau and credit data
- Channel engagement signals

### 5.2 Feature Engineering

- Behavioral features: payment patterns, response rates, channel preference
- Credit features: bureau score, loan vintage, collateral status
- Recovery features: bucket history, prior promises, settlement history
- Time-series features: days past due, delinquency trajectory

### 5.3 Models

- Default Prediction Model
- Recovery Probability Model
- Settlement Recommendation Model
- Agent Assignment Optimizer
- Call Time Optimizer
- Fraud Detection Model
- Customer Segmentation Model

### 5.4 Recommendation API

- Provides ranked actions for agents, channels, settlement offers, and contact timing
- Supports workflow decisions and dashboard analytics
- Delivers explainable scores and reason codes

## 6. Data Model

### 6.1 Core Entities

- `Customer`
  - `Loans`
    - EMI Schedule
    - Payment History
    - Delinquency History
  - `Contact History`
  - `Recovery Cases`
  - `Settlements`
  - `Legal Cases`
  - `AI Scores`

## 7. Security & Compliance

- Identity Provider with SSO
- OAuth2 / OpenID Connect
- Role-Based Access Control
- Audit logging for all user and system actions
- Encryption in transit and at rest
- Consent tracking, disclosure management, and policy enforcement
