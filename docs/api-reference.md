# ZeroDPD API Reference

## Overview

ZeroDPD exposes a comprehensive REST API for loan recovery management, agent operations, and administrative functions.

## Base URL

```
https://api.zerodpd.com/v1
```

## Authentication

All API endpoints require OAuth2 Bearer token authentication.

```bash
Authorization: Bearer {access_token}
```

## Collections Service API

### Get Customer

```
GET /customers/{customerId}
```

Response:
```json
{
  "customerId": "cust-12345",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+91-9876543210",
  "loans": [
    {
      "loanId": "ln-456",
      "amount": 500000,
      "emiAmount": 15000,
      "daysPassedDue": 35,
      "status": "DELINQUENT"
    }
  ]
}
```

### Get Recovery Case

```
GET /cases/{caseId}
```

Response:
```json
{
  "caseId": "case-789",
  "customerId": "cust-12345",
  "loanId": "ln-456",
  "dpd": 35,
  "bucket": "1-30",
  "status": "ACTIVE",
  "assignedAgent": "agent-001",
  "createdAt": "2026-05-20T10:30:00Z"
}
```

### Create Recovery Case

```
POST /cases
```

Request:
```json
{
  "customerId": "cust-12345",
  "loanId": "ln-456",
  "dpd": 35,
  "bucket": "31-60"
}
```

## Communication Service API

### Send SMS

```
POST /communications/sms
```

Request:
```json
{
  "customerId": "cust-12345",
  "message": "Dear customer, your EMI of Rs. 15,000 is due. Please pay by tomorrow.",
  "templateId": "tpl-sms-01"
}
```

### Get Communication History

```
GET /communications/history/{customerId}
```

## Settlement Service API

### Create Settlement Offer

```
POST /settlements/offers
```

Request:
```json
{
  "caseId": "case-789",
  "settledAmount": 100000,
  "installments": 3,
  "validTillDate": "2026-06-30"
}
```

## Agent Workbench API

### Get Agent Assignments

```
GET /workbench/assignments
```

Response:
```json
{
  "totalCases": 25,
  "cases": [
    {
      "caseId": "case-789",
      "customerName": "John Doe",
      "amount": 15000,
      "dpd": 35,
      "priority": "HIGH",
      "recommendedAction": "Call customer"
    }
  ]
}
```

### Update Case Status

```
PUT /workbench/cases/{caseId}/status
```

Request:
```json
{
  "status": "RESOLVED",
  "notes": "Customer committed to pay tomorrow",
  "promiseToPayDate": "2026-06-03"
}
```

## Error Responses

All errors follow standard HTTP status codes:

- `200 OK` - Successful request
- `400 Bad Request` - Invalid parameters
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

Error response format:
```json
{
  "error": "INVALID_CASE_ID",
  "message": "Case ID not found",
  "timestamp": "2026-06-02T10:30:00Z"
}
```
