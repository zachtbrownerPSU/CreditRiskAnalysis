# Credit Risk Behavioral Scoring & Analytics

## Executive Summary
This project analyzes 300,000+ loan applications to identify the behavioral drivers of default. Using Azure SQL Database, I engineered custom risk features to build a Credit Risk Scoring Engine. The final model segmented the population into four distinct Risk Tiers, with the Critical Tier showing a default rate of 21.97%, compared to just 6.36% in the Low Tier, a 3.4x increase in predictive accuracy.

## Feature Engineering: Key Insights

### 1. The "Payment Gap" Behavioral Signal
By comparing total billed installments to actual payments, I found clear evidence of insolvency.
- Non-Defaulters (Target 0): Maintain a negative gap (Avg: -7,231), indicating consistent overpayment.
- Defaulters (Target 1): Maintain a positive gap (Avg: +9,832), indicating systemic underpayment.

### 2. Occupational Data
Analysis of occupational data revealed:
- High skill tech staff carry the highest average credit utilization (1.068), yet maintain a low 6.16% default rate.
- Conversely, Low-skill Laborers default at nearly triple that rate (17.15%) despite having significantly lower utilization (0.147).
- Business Insight: Debt volume is less dangerous than income instability.

## Model Validation & Risk Tiering
To ensure model stability for automated decisioning, I implemented a tiered scoring system (0-100).

| Risk Tier | Total Applicants | Default Rate % |
| :--- | :--- | :--- |
| 90 - 100 (Critical) | 915 | 21.97% |
| 70 - 89 (High) | 28,705 | 11.89% |
| 40 - 69 (Medium) | 94,590 | 10.1% |
| 0 - 39 (Low) | 183,301 | 6.36% |

Validation Results: Risk Tiers show a clear, ascending default probability.
