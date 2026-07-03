# ZeroDPD Configuration Guide

## Environment Variables

### Core Services

```bash
# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=zerodpd
POSTGRES_USER=zerodpd_user
POSTGRES_PASSWORD=secure_password

# Kafka
KAFKA_BROKERS=localhost:9092
KAFKA_TOPIC_RECOVERY_EVENTS=recovery.events

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Elasticsearch
ELASTICSEARCH_HOST=localhost
ELASTICSEARCH_PORT=9200
```

### API Gateway

```bash
API_PORT=8080
API_LOG_LEVEL=INFO
OAUTH2_CLIENT_ID=zerodpd-client
OAUTH2_CLIENT_SECRET=client_secret
```

### Collections Service

```bash
COLLECTIONS_SERVICE_PORT=8081
MAX_BATCH_SIZE=1000
DEFAULT_ESCALATION_DAYS=30
```

### Communication Service

```bash
SMS_GATEWAY=twilio
SMS_ACCOUNT_SID=account_sid
SMS_AUTH_TOKEN=auth_token
WHATSAPP_GATEWAY=whatsapp_business
EMAIL_SMTP_HOST=smtp.gmail.com
```

### AI Platform

```bash
AI_MODEL_PATH=/models
AI_MIN_CONFIDENCE=0.7
AI_BATCH_SIZE=32
```

## Feature Flags

```bash
ENABLE_AI_RECOMMENDATIONS=true
ENABLE_FIELD_RECOVERY=false
ENABLE_LEGAL_ESCALATION=true
ENABLE_AUDIT_LOGGING=true
```

## Database Configuration

See `data-platform/schemas/` for database initialization scripts.
