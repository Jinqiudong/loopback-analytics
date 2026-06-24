# Known Data Quality Issues

Tracked issues with current data quality. Each issue has a severity, owner, and status.

---

## Issue #001 — Duplicate applications from web channel
**Severity:** Low  
**Status:** Resolved (2026-01-15)  
**Owner:** Data Engineering  
**Description:** A bug in the web origination system caused some applications to be
submitted twice within a 5-second window. Resolved by adding deduplication logic in ETL.

---

## Issue #002 — Credit score lag on weekend decisions
**Severity:** Medium  
**Status:** Monitoring  
**Owner:** Risk  
**Description:** Credit scores pulled on Friday evening are used for decisions made
Saturday and Sunday, even if the score changes. Affects ~3% of weekend decisions.

---

## Issue #003 — `product_type` NULL values in `raw_applications`
**Severity:** High  
**Status:** Open — root cause identified, fix pending  
**Owner:** Data Engineering + Product  
**Identified:** 2026-03-14  
**Description:**  
The `product_type` field was added to `raw_applications` during the March 12, 2026
schema migration. The migration script backfilled existing records using a lookup
table, but approximately 18% of records submitted between March 12–19 have
`product_type = NULL` because the origination system had not yet been updated to
send this field.

**Impact:**  
Applications with `product_type = NULL` are excluded from per-product approval rate
calculations. During the affected period, total approved applications appear ~40% lower
than actual when segmented by product type. The overall approval rate metric
(`da_approval_metrics`) understates actual performance for this period.

**Root cause:**  
`raw_applications.product_type` was defined as nullable during the migration to avoid
breaking existing ETL pipelines. The origination system integration was not updated
to send `product_type` until March 19. The fix is to:
1. Backfill NULL product_type values using the product lookup table
2. Add NOT NULL constraint to `raw_applications.product_type`
3. Update ETL validation to reject records with missing product_type

**Workaround:**  
Exclude the date range 2026-03-12 to 2026-03-19 from approval rate analysis, or
filter `WHERE product_type IS NOT NULL` when running product-segmented queries.

---

## Issue #004 — Region field inconsistency (legacy values)
**Severity:** Low  
**Status:** Open  
**Owner:** Data Engineering  
**Description:** Some historical records use deprecated region codes (e.g. "NE" instead
of "Northeast"). Affects reporting for periods before 2025-06-01.
