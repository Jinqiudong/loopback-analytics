# LoopBack Analytics

Data product for LoopBack's loan application processing pipeline.
Owned by the Data Analytics team.

## What this repo contains

| Folder | Contents |
|--------|----------|
| `schema/` | Source table definitions — raw ingestion layer |
| `metrics/` | Business metric calculations — approval rates, funnel analysis |
| `docs/` | Data model documentation, known issues, field ownership |

## Core metrics

**Approval rate** — the percentage of loan applications approved in a given period.
Calculated in `metrics/approval_rate.sql`. Primary KPI tracked by the BA team.

**Application funnel** — stage-by-stage conversion from submission to decision.

## Data owners

| Table | Owner | Updated |
|-------|-------|---------|
| `raw_applications` | Data Engineering | Daily |
| `da_approval_metrics` | Data Analytics | Daily |
| `product_types` | Product | On change |

## Known issues

See `docs/known_issues.md` for tracked data quality issues.
