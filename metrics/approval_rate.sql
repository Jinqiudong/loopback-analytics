-- approval_rate.sql
-- Core approval rate metric used in BA dashboards.
-- Returns daily approval rate by product type and region.

SELECT
    metric_date,
    COALESCE(product_type, 'unknown')   AS product_type,
    region,
    total_applications,
    approved_count,
    rejected_count,
    approval_rate

FROM da_approval_metrics
WHERE metric_date >= CURRENT_DATE - INTERVAL '90 days'
ORDER BY metric_date DESC, product_type, region;
