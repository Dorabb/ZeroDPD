# Orchestration - ZeroDPD

The Orchestration layer manages workflow definitions, business rules, and escalation policies for the loan recovery platform using BPMN (Business Process Model and Notation) and Camunda BPM.

## 🎯 Overview

The orchestration engine coordinates recovery workflows across different DPD (Days Past Due) buckets with intelligent routing, escalation policies, and business rules.

## 📂 Directory Structure

```
orchestration/
├── workflow-definitions/
│   ├── dpd-1-30.bpmn
│   ├── dpd-31-60.bpmn
│   ├── dpd-61-90.bpmn
│   ├── dpd-90plus.bpmn
│   └── settlement-workflow.bpmn
├── business-rules/
│   ├── escalation_rules.drl
│   ├── collection_rules.drl
│   ├── settlement_rules.drl
│   └── field_recovery_rules.drl
├── escalation-policies/
│   ├── policy_definitions.yaml
│   └── sms_escalation_policy.yaml
├── engine-config/
│   ├── camunda-config.yaml
│   ├── application.properties
│   └── spring-context.xml
├── Dockerfile
└── README.md
```

## 🔄 DPD Bucket Workflows

### DPD 1-30: Early Stage Collections

```
Entry → SMS Notification → Wait 3 Days → Call Attempt → 
  Decision: Contacted? 
    → YES: Negotiation Workflow
    → NO: Wait 7 Days → Retry
```

**Key Activities:**
- Automated SMS reminders
- Call scheduling
- Collection agent assignment
- Settlement negotiation initiation

**Exit Conditions:**
- Payment received
- Settlement agreed
- Escalation to next bucket

### DPD 31-60: Intermediate Collections

```
Entry → Email + SMS → Call Center → Field Recovery Check →
  Decision: Field Recovery Needed?
    → YES: Assign Field Agent
    → NO: Legal Notice Preparation
```

**Key Activities:**
- Omnichannel communication
- Call center routing
- Field recovery assignment
- Legal notice generation

### DPD 61-90: Advanced Collections

```
Entry → Legal Notice → Wait 15 Days → Field Recovery → 
  Decision: Recovered?
    → YES: Settlement Processing
    → NO: Legal Action Initiation
```

**Key Activities:**
- Legal notices
- Field recovery operations
- CIBIL/Credit bureau reporting
- Legal action preparation

### DPD 90+: Final Collections

```
Entry → Legal Action → Auction Process → Write-off Decision
```

**Key Activities:**
- Court proceedings
- Asset auctioning
- Write-off processing
- Final reporting

## 🚀 Deployment

### 1. Prerequisites

```bash
# Install Camunda BPM (Docker)
docker pull camunda/camunda-bpm-platform:latest

# Or via Maven dependency
mvn install
```

### 2. Deploy Workflows

#### Option A: Using Camunda Cockpit UI

1. Access Camunda Cockpit: `http://localhost:8080/camunda`
2. Login with default credentials
3. Go to **Admin** → **Deployment**
4. Upload BPMN files one by one

#### Option B: Using Camunda REST API

```bash
# Deploy single workflow
curl -F "deployment-name=dpd-1-30" \
     -F "dpd-1-30.bpmn=@workflow-definitions/dpd-1-30.bpmn" \
     http://localhost:8080/engine-rest/deployment/create

# Deploy all workflows
for workflow in workflow-definitions/*.bpmn; do
  curl -F "deployment-name=$(basename $workflow .bpmn)" \
       -F "$(basename $workflow)=@$workflow" \
       http://localhost:8080/engine-rest/deployment/create
done
```

#### Option C: Using Java API

```java
RepositoryService repositoryService = processEngine.getRepositoryService();

repositoryService.createDeployment()
  .addClasspathResource("dpd-1-30.bpmn")
  .addClasspathResource("dpd-31-60.bpmn")
  .addClasspathResource("dpd-61-90.bpmn")
  .addClasspathResource("dpd-90plus.bpmn")
  .deploy();
```

### 3. Deploy Business Rules (Drools)

```bash
# Compile and package rules
mvn clean package -DskipTests

# Deploy to Camunda
curl -X POST \
  -H "Content-Type: application/octet-stream" \
  --data-binary @target/orchestration-rules.jar \
  http://localhost:8080/engine-rest/deployment/create
```

### 4. Configure Escalation Policies

Edit `escalation-policies/policy_definitions.yaml`:

```yaml
escalation_policies:
  dpd_1_30:
    max_attempts: 5
    wait_days: 3
    next_bucket: dpd_31_60
    actions:
      - sms_reminder
      - call_attempt
      - email_notice
      
  dpd_31_60:
    max_attempts: 3
    wait_days: 7
    next_bucket: dpd_61_90
    actions:
      - field_recovery_check
      - legal_notice
      - credit_bureau_report
```

## 🔧 Configuration

### Camunda Engine Configuration

Edit `engine-config/camunda-config.yaml`:

```yaml
camunda:
  bpm:
    admin-user:
      id: admin
      password: admin
    
    authorization:
      enabled: true
    
    job-executor:
      core-pool-size: 10
      max-pool-size: 20
      queue-size: 100
```

### Database Connection

```properties
# application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/zerodpd
spring.datasource.username=zerodpd_user
spring.datasource.password=secure_password

# Camunda database
camunda.bpm.database.type=postgresql
camunda.bpm.database.schema-update=true
```

## 📊 Monitoring Workflows

### 1. Access Camunda Cockpit

```
http://localhost:8080/camunda/app/cockpit
```

### 2. Monitor Process Instances

- View running instances
- Track execution progress
- Debug suspended processes
- Inspect variables and history

### 3. View Task Lists

```
http://localhost:8080/camunda/app/tasklist
```

### 4. API Endpoints

```bash
# Get all process instances
curl http://localhost:8080/engine-rest/process-instance

# Get specific process instance
curl http://localhost:8080/engine-rest/process-instance/{instanceId}

# Get deployed processes
curl http://localhost:8080/engine-rest/process-definition

# Get process statistics
curl http://localhost:8080/engine-rest/process-definition/statistics
```

## 🔄 Workflow Execution Flow

```
Delinquent Account Created
         ↓
    Determine DPD
         ↓
    Select Workflow (DPD 1-30/31-60/61-90/90+)
         ↓
    Start Process Instance
         ↓
    Execute Service Tasks
         ↓
    Apply Business Rules
         ↓
    User Tasks (Agent)
         ↓
    Decision Gates
         ↓
    Escalate or Settle
         ↓
    Complete Process
```

## 📝 Creating Custom Workflows

### 1. Design BPMN File

Use Camunda Modeler (free tool):
- Download: https://camunda.com/download/modeler/
- Design workflow visually
- Configure service tasks, user tasks, gateways

### 2. Add Service Tasks

```xml
<serviceTask id="sendSMS" name="Send SMS" 
  camunda:class="com.dorabb.zerodpd.orchestration.tasks.SendSMSTask">
  <incoming>Flow_001</incoming>
  <outgoing>Flow_002</outgoing>
</serviceTask>
```

### 3. Implement Task Handler

```java
@Component
public class SendSMSTask implements JavaDelegate {
  
  @Override
  public void execute(DelegateExecution execution) throws Exception {
    String borrowerId = (String) execution.getVariable("borrower_id");
    // Send SMS logic
    execution.setVariable("sms_sent", true);
  }
}
```

### 4. Deploy Workflow

Place BPMN file in `workflow-definitions/` and deploy using any method above.

## 🧪 Testing Workflows

### Unit Tests

```bash
# Run workflow tests
mvn test -Dtest=WorkflowTest
```

### Integration Tests

```bash
# Start Camunda with H2 in-memory database
mvn test -Dtest=WorkflowIntegrationTest
```

### Manual Testing

```bash
# Start process instance via API
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "variables": {
      "borrower_id": {"value": "B123"},
      "loan_amount": {"value": 50000}
    }
  }' \
  http://localhost:8080/engine-rest/process-definition/key/dpd-1-30/start
```

## 📊 Performance Tuning

### Database Optimization

```sql
-- Index on process instance status
CREATE INDEX idx_act_inst_status ON ACT_RU_EXECUTION(PROC_INST_ID, ACTIVE_);

-- Index on task assignment
CREATE INDEX idx_task_assignee ON ACT_RU_TASK(ASSIGNEE_);
```

### Job Executor Configuration

```properties
# application.properties
camunda.bpm.job-executor.core-pool-size=20
camunda.bpm.job-executor.max-pool-size=100
camunda.bpm.job-executor.queue-size=1000
camunda.bpm.job-executor.wait-increase-factor=2
```

## 🔍 Troubleshooting

### Process Stuck at Service Task

```bash
# Check error logs
curl http://localhost:8080/engine-rest/process-instance/{id}/activity-instances

# Check job failures
curl http://localhost:8080/engine-rest/job
```

### Business Rule Not Firing

- Verify rule file deployed
- Check rule syntax in `.drl` file
- Review rule firing conditions
- Enable debug logging

### Variables Not Passing

- Verify variable serialization
- Check data types match
- Review execution flow

## 📚 Resources

- [Camunda Documentation](https://docs.camunda.org/)
- [BPMN 2.0 Specification](https://www.omg.org/spec/BPMN/2.0/)
- [Drools Documentation](https://www.drools.org/learn/documentation.html)
- [Camunda Modeler](https://camunda.com/download/modeler/)

---

**Last Updated**: June 2, 2026  
**Version**: 1.0.0
