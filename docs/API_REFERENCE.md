# ZeroDPD API Reference

## Base URL

```
https://api.zerodpd.com/v1
```

## Authentication

All API endpoints require OAuth2 Bearer token authentication.

```
Authorization: Bearer {access_token}
```

## Collections Service API

### GET /customers/{customerId}

Retrieve customer details and associated loans.

**Response:**
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

### POST /cases

Create a new recovery case.

**Request:**
```json
{
  "customerId": "cust-12345",
  "loanId": "ln-456",
  "dpd": 35,
  "bucket": "31-60"
}
```

**Response:**
```json
{
  "caseId": "case-789",
  "customerId": "cust-12345",
  "loanId": "ln-456",
  "dpd": 35,
  "bucket": "31-60",
  "status": "ACTIVE",
  "createdAt": "2026-06-02T10:30:00Z"
}
```

### GET /cases/{caseId}

Get recovery case details.

**Response:**
```json
{
  "caseId": "case-789",
  "customerId": "cust-12345",
  "loanId": "ln-456",
  "dpd": 35,
  "bucket": "31-60",
  "status": "ACTIVE",
  "assignedAgent": "agent-001",
  "aiScores": {
    "recovery_probability": 0.78,
    "settlement_likelihood": 0.65
  },
  "createdAt": "2026-06-02T10:30:00Z"
}
```

## Communication Service API

### POST /communications/sms

Send SMS to customer.

**Request:**
```json
{
  "customerId": "cust-12345",
  "message": "Your EMI is due. Please pay today.",
  "templateId": "tpl-sms-01"
}
```

**Response:**
```json
{
  "communicationId": "comm-001",
  "channel": "SMS",
  "status": "SENT",
  "sentAt": "2026-06-02T10:35:00Z"
}
```

### GET /communications/history/{customerId}

Get communication history for customer.

**Response:**
```json
{
  "customerId": "cust-12345",
  "communications": [
    {
      "communicationId": "comm-001",
      "channel": "SMS",
      "message": "Your EMI is due",
      "sentAt": "2026-06-02T10:35:00Z",
      "status": "DELIVERED"
    }
  ]
}
```

## Settlement Service API

### POST /settlements/offers

Create settlement offer.

**Request:**
```json
{
  "caseId": "case-789",
  "settledAmount": 100000,
  "installments": 3,
  "validTillDate": "2026-06-30"
}
```

**Response:**
```json
{
  "settlementId": "settle-001",
  "caseId": "case-789",
  "settledAmount": 100000,
  "installments": 3,
  "status": "PENDING_APPROVAL",
  "createdAt": "2026-06-02T11:00:00Z"
}
```

## Agent Workbench API

### GET /workbench/assignments

Get agent assignments and cases.

**Response:**
```json
{
  "agentId": "agent-001",
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

### PUT /workbench/cases/{caseId}/status

Update case status.

**Request:**
```json
{
  "status": "RESOLVED",
  "notes": "Customer committed to pay",
  "promiseToPayDate": "2026-06-03"
}
```

## AI Platform API

### POST /ai/recommendations

Get AI recommendations for case.

**Request:**
```json
{
  "caseId": "case-789"
}
```

**Response:**
```json
{
  "recommendations": [
    {
      "action": "CALL",
      "score": 0.92,
      "reason": "High probability of recovery"
    },
    {
      "action": "SETTLEMENT",
      "score": 0.65,
      "reason": "Customer likely to accept settlement"
    }
  ]
}
```

## Error Responses

All errors return standard HTTP status codes with error details.

**Format:**
```json
{
  "error": "INVALID_CASE_ID",
  "message": "Case ID not found",
  "timestamp": "2026-06-02T10:30:00Z"
}
```

**Status Codes:**
- `200 OK` - Successful request
- `201 Created` - Resource created
- `400 Bad Request` - Invalid parameters
- `401 Unauthorized` - Missing/invalid token
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

---

**API Version**: 1.0  
**Last Updated**: June 2, 2026
