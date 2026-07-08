-- raw_applications
-- Source table: loan application records from the origination system.
-- Ingested daily via ETL. One row per application.

CREATE TABLE IF NOT EXISTS raw_applications (
    application_id   UUID        PRIMARY KEY,
    submitted_at     TIMESTAMP   NOT NULL,
    applicant_id     UUID        NOT NULL,
    loan_amount      NUMERIC     NOT NULL CHECK (loan_amount > 0),

    -- Product categorisation. Required for approval logic and reporting.
    -- This field is nullable.
    product_type     TEXT,

    credit_score     INTEGER     NOT NULL CHECK (credit_score BETWEEN 300 AND 850),
    status           TEXT        NOT NULL CHECK (status IN ('pending', 'approved', 'rejected', 'withdrawn')),
    decided_at       TIMESTAMP,
    decision_reason  TEXT,
    region           TEXT        NOT NULL,
    channel          TEXT        NOT NULL CHECK (channel IN ('web', 'mobile', 'branch')),
    created_at       TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_raw_applications_submitted_at ON raw_applications(submitted_at);
CREATE INDEX idx_raw_applications_product_type ON raw_applications(product_type);
CREATE INDEX idx_raw_applications_status ON raw_applications(status);
