# Data Dictionary — LoopBack Analytics

Field definitions, business terms, and ownership for all tables in this data product.

---

## `raw_applications`

Raw loan application records ingested from the origination system. One row per application.

| Field | Type | Nullable | Description | Business Owner |
|-------|------|----------|-------------|----------------|
| `application_id` | uuid | NOT NULL | Unique application identifier | Engineering |
| `submitted_at` | timestamp | NOT NULL | When the application was submitted | Engineering |
| `applicant_id` | uuid | NOT NULL | Applicant reference ID | Engineering |
| `loan_amount` | numeric | NOT NULL | Requested loan amount in USD | Engineering |
| `product_type` | text | nullable | Loan product category (e.g. personal, auto, mortgage) | Product |
| `credit_score` | integer | NOT NULL | Applicant credit score at submission time | Risk |
| `status` | text | NOT NULL | Current application status: `pending`, `approved`, `rejected`, `withdrawn` | Engineering |
| `decided_at` | timestamp | nullable | When a final decision was made | Engineering |
| `decision_reason` | text | nullable | Reason code for rejection | Risk |
| `region` | text | NOT NULL | Geographic region | Engineering |
| `channel` | text | NOT NULL | Origination channel: `web`, `mobile`, `branch` | Product |

---

## `da_approval_metrics`

Daily aggregated approval metrics. Built on top of `raw_applications`.

| Field | Type | Description |
|-------|------|-------------|
| `metric_date` | date | The date these metrics represent |
| `product_type` | text | Loan product category |
| `region` | text | Geographic region |
| `total_applications` | integer | Total applications submitted this date |
| `approved_count` | integer | Applications approved this date |
| `rejected_count` | integer | Applications rejected this date |
| `pending_count` | integer | Applications still pending |
| `approval_rate` | numeric | `approved_count / (approved_count + rejected_count)` — excludes pending |
| `avg_credit_score` | numeric | Average credit score for this segment |

---

## `product_types` (reference table)

| Field | Type | Description |
|-------|------|-------------|
| `product_code` | text | Short code used in `raw_applications.product_type` |
| `product_name` | text | Human-readable product name |
| `risk_tier` | text | Risk classification: `standard`, `elevated`, `high` |
| `is_active` | boolean | Whether this product is currently offered |

---

## Business terms glossary

| Term | Definition |
|------|-----------|
| **Approval rate** | Percentage of decided applications that were approved. Excludes pending. |
| **Decision rate** | Percentage of submitted applications that have received a final decision. |
