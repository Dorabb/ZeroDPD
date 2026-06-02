-- ZeroDPD PostgreSQL Schema
-- This script initializes all database tables for the loan recovery platform

-- Create schema
CREATE SCHEMA IF NOT EXISTS zerodpd;

-- Customers table
CREATE TABLE IF NOT EXISTS zerodpd.customers (
  customer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20) UNIQUE,
  date_of_birth DATE,
  kyc_status VARCHAR(50) DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Loans table
CREATE TABLE IF NOT EXISTS zerodpd.loans (
  loan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES zerodpd.customers(customer_id) ON DELETE CASCADE,
  loan_amount DECIMAL(15,2) NOT NULL,
  emi_amount DECIMAL(10,2) NOT NULL,
  tenure_months INTEGER NOT NULL,
  emi_start_date DATE NOT NULL,
  emi_end_date DATE NOT NULL,
  interest_rate DECIMAL(5,2),
  status VARCHAR(50) DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EMI Schedule table
CREATE TABLE IF NOT EXISTS zerodpd.emi_schedule (
  emi_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id UUID NOT NULL REFERENCES zerodpd.loans(loan_id) ON DELETE CASCADE,
  emi_number INTEGER NOT NULL,
  emi_amount DECIMAL(10,2) NOT NULL,
  due_date DATE NOT NULL,
  principal_amount DECIMAL(10,2),
  interest_amount DECIMAL(10,2),
  status VARCHAR(50) DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment History table
CREATE TABLE IF NOT EXISTS zerodpd.payment_history (
  payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id UUID NOT NULL REFERENCES zerodpd.loans(loan_id) ON DELETE CASCADE,
  emi_id UUID REFERENCES zerodpd.emi_schedule(emi_id),
  payment_amount DECIMAL(10,2) NOT NULL,
  payment_date DATE NOT NULL,
  transaction_id VARCHAR(100),
  payment_method VARCHAR(50),
  status VARCHAR(50) DEFAULT 'SUCCESS',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Delinquency History table
CREATE TABLE IF NOT EXISTS zerodpd.delinquency_history (
  delinquency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id UUID NOT NULL REFERENCES zerodpd.loans(loan_id) ON DELETE CASCADE,
  days_past_due INTEGER NOT NULL,
  bucket VARCHAR(20),
  status VARCHAR(50) DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recovery Cases table
CREATE TABLE IF NOT EXISTS zerodpd.recovery_cases (
  case_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id UUID NOT NULL REFERENCES zerodpd.loans(loan_id) ON DELETE CASCADE,
  customer_id UUID NOT NULL REFERENCES zerodpd.customers(customer_id) ON DELETE CASCADE,
  days_past_due INTEGER NOT NULL,
  bucket VARCHAR(20) NOT NULL,
  status VARCHAR(50) DEFAULT 'ACTIVE',
  assigned_agent_id UUID,
  assigned_at TIMESTAMP,
  priority VARCHAR(50) DEFAULT 'MEDIUM',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  closed_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Communications table
CREATE TABLE IF NOT EXISTS zerodpd.communications (
  communication_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id UUID NOT NULL REFERENCES zerodpd.recovery_cases(case_id) ON DELETE CASCADE,
  customer_id UUID NOT NULL REFERENCES zerodpd.customers(customer_id) ON DELETE CASCADE,
  channel VARCHAR(50) NOT NULL,
  message TEXT,
  template_id VARCHAR(100),
  status VARCHAR(50) DEFAULT 'PENDING',
  sent_at TIMESTAMP,
  delivered_at TIMESTAMP,
  response TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Settlements table
CREATE TABLE IF NOT EXISTS zerodpd.settlements (
  settlement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id UUID NOT NULL REFERENCES zerodpd.recovery_cases(case_id) ON DELETE CASCADE,
  loan_id UUID NOT NULL REFERENCES zerodpd.loans(loan_id) ON DELETE CASCADE,
  settled_amount DECIMAL(15,2) NOT NULL,
  total_installments INTEGER NOT NULL,
  status VARCHAR(50) DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  approved_at TIMESTAMP,
  completed_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Settlement Installments table
CREATE TABLE IF NOT EXISTS zerodpd.settlement_installments (
  installment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  settlement_id UUID NOT NULL REFERENCES zerodpd.settlements(settlement_id) ON DELETE CASCADE,
  installment_number INTEGER NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  due_date DATE NOT NULL,
  paid_date DATE,
  status VARCHAR(50) DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Legal Cases table
CREATE TABLE IF NOT EXISTS zerodpd.legal_cases (
  legal_case_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id UUID NOT NULL REFERENCES zerodpd.recovery_cases(case_id) ON DELETE CASCADE,
  loan_id UUID NOT NULL REFERENCES zerodpd.loans(loan_id) ON DELETE CASCADE,
  case_type VARCHAR(50),
  status VARCHAR(50) DEFAULT 'FILED',
  filing_date DATE,
  court_name VARCHAR(255),
  case_number VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI Scores table
CREATE TABLE IF NOT EXISTS zerodpd.ai_scores (
  score_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id UUID NOT NULL REFERENCES zerodpd.recovery_cases(case_id) ON DELETE CASCADE,
  recovery_probability DECIMAL(5,4),
  settlement_likelihood DECIMAL(5,4),
  call_time_score DECIMAL(5,4),
  fraud_risk_score DECIMAL(5,4),
  customer_segment VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Log table
CREATE TABLE IF NOT EXISTS zerodpd.audit_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50),
  resource_id UUID,
  old_value TEXT,
  new_value TEXT,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_customers_email ON zerodpd.customers(email);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON zerodpd.customers(phone);
CREATE INDEX IF NOT EXISTS idx_loans_customer_id ON zerodpd.loans(customer_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON zerodpd.loans(status);
CREATE INDEX IF NOT EXISTS idx_recovery_cases_loan_id ON zerodpd.recovery_cases(loan_id);
CREATE INDEX IF NOT EXISTS idx_recovery_cases_customer_id ON zerodpd.recovery_cases(customer_id);
CREATE INDEX IF NOT EXISTS idx_recovery_cases_status ON zerodpd.recovery_cases(status);
CREATE INDEX IF NOT EXISTS idx_recovery_cases_bucket ON zerodpd.recovery_cases(bucket);
CREATE INDEX IF NOT EXISTS idx_communications_case_id ON zerodpd.communications(case_id);
CREATE INDEX IF NOT EXISTS idx_communications_channel ON zerodpd.communications(channel);
CREATE INDEX IF NOT EXISTS idx_settlements_case_id ON zerodpd.settlements(case_id);
CREATE INDEX IF NOT EXISTS idx_settlements_status ON zerodpd.settlements(status);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON zerodpd.audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource_id ON zerodpd.audit_logs(resource_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON zerodpd.audit_logs(created_at);

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA zerodpd TO zerodpd_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA zerodpd TO zerodpd_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA zerodpd TO zerodpd_user;
