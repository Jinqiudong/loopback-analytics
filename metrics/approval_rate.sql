-- approval_rate.sql
-- Core approval rate metric used in BA dashboards.
-- Returns daily approval rate by product type and region.
--
-- Known limitation: rows where product_type IS NULL represent applications
-- submitted before the March 2026 schema migration. These are included in
-- total_applications but excluded from product-segmented rates.
-- See docs/known_issues.md #003.

SELECT
    metric_date,
    COALESCE(product_type, 'unknown')   AS product_type,
    region,
    total_applications,
    approved_count,
    rejected_count,
    approval_rate,

    -- Flag periods with high NULL product_type volume — likely data quality issue
    CASE
        WHEN product_type IS NULL AND total_applications > 50
        THEN TRUE
        ELSE FALSE
    END                                 AS high_null_product_type_volume

FROM da_approval_metrics
WHERE metric_date >= CURRENT_DATE - INTERVAL '90 days'
ORDER BY metric_date DESC, product_type, region;
