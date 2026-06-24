-- da_approval_metrics
-- Daily aggregated approval metrics built on raw_applications.
-- Refreshed nightly. Used by the BA team for KPI tracking.

CREATE TABLE IF NOT EXISTS da_approval_metrics (
    metric_date          DATE        NOT NULL,
    product_type         TEXT,       -- NULL rows = applications with no product_type captured
    region               TEXT        NOT NULL,
    total_applications   INTEGER     NOT NULL DEFAULT 0,
    approved_count       INTEGER     NOT NULL DEFAULT 0,
    rejected_count       INTEGER     NOT NULL DEFAULT 0,
    pending_count        INTEGER     NOT NULL DEFAULT 0,
    approval_rate        NUMERIC,    -- approved / (approved + rejected), NULL if no decided apps
    avg_credit_score     NUMERIC,
    refreshed_at         TIMESTAMP   NOT NULL DEFAULT NOW(),

    PRIMARY KEY (metric_date, region, COALESCE(product_type, '__null__'))
);

-- The daily refresh query that populates this table:
--
-- INSERT INTO da_approval_metrics (...)
-- SELECT
--     DATE(submitted_at)                              AS metric_date,
--     product_type,                                   -- will be NULL for pre-migration records
--     region,
--     COUNT(*)                                        AS total_applications,
--     COUNT(*) FILTER (WHERE status = 'approved')     AS approved_count,
--     COUNT(*) FILTER (WHERE status = 'rejected')     AS rejected_count,
--     COUNT(*) FILTER (WHERE status = 'pending')      AS pending_count,
--     ROUND(
--         COUNT(*) FILTER (WHERE status = 'approved')::NUMERIC
--         / NULLIF(
--             COUNT(*) FILTER (WHERE status IN ('approved', 'rejected')),
--             0
--         ), 4
--     )                                               AS approval_rate,
--     AVG(credit_score)                               AS avg_credit_score
-- FROM raw_applications
-- GROUP BY DATE(submitted_at), product_type, region;
--
-- NOTE: Because product_type is nullable in raw_applications, a significant
-- portion of records are grouped under product_type = NULL. These records are
-- NOT counted in per-product approval rates. If the volume of NULL product_type
-- records is high, the overall approval rate across all products will appear
-- artificially low because approved applications with NULL product_type are
-- excluded from the denominator of any product-segmented calculation.
