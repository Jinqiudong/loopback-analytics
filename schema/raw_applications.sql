-- raw_applications
-- Source table: loan application records from the origination system.
-- Ingested daily via ETL. One row per application.
--
-- IMPORTANT: product_type is nullable because the origination system did not
-- enforce this field prior to 2026-03-12. Applications submitted before the
-- schema migration may have NULL product_type values.
-- See: docs/known_issues.md #003

CREATE TABLE IF NOT EXISTS raw_applications (
    application_id   UUID        PRIMARY KEY,
    submitted_at     TIMESTAMP   NOT NULL,
    applicant_id     UUID        NOT NULL,
    loan_amount      NUMERIC     NOT NULL CHECK (loan_amount > 0),

    -- Product categorisation. Required for approval logic and reporting.
    -- NULL values indicate product_type was not captured at ingestion time.
    -- This field SHOULD be NOT NULL but was made nullable during the March 2026
    -- schema migration when the product_type column was first added.
    -- Tracked in known_issues.md as issue #003.
    product_type     TEXT,       -- intentionally nullable (see note above)

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
