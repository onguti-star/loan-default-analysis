# Loan Default / Credit Risk Analysis

Lenders lose money when borrowers default. This project looks at roughly 396,000 LendingClub loan records to find out which loan and borrower characteristics line up with higher default rates, then builds a model to flag risky loans before they're issued.

## Dataset

- **Source:** LendingClub loan data (`lending_club_loan_two`, ~396K rows, 27 columns)
- **Key fields:** loan amount, term, interest rate, grade, purpose, annual income, home ownership, loan status

## Tools

- **MySQL / DBeaver** — data loading and SQL analysis
- **Looker Studio** — dashboard
- **Python (Colab)** — EDA, feature engineering, modeling (Logistic Regression, XGBoost)

## SQL Analysis

Six queries look at default rate by grade, purpose, term, income band, and home ownership, plus interest rate pricing by grade. Full queries are in [`sql/loan_default_queries.sql`](Script-4.sql).

**What the data shows:**
- Default rate rises sharply as grade drops from A to G — G-grade loans default several times more often than A-grade loans.
- Small business loans have the highest default rate of any purpose, ahead of moving, renewable energy, and medical loans. Home improvement loans default the least.
- Higher grades also carry lower average interest rates, so LendingClub's pricing tracks the same risk pattern the default data shows.

## Dashboard

![Loan Default Dashboard](dashboard_screenshot.png)

[View the interactive dashboard on Looker Studio](https://datastudio.google.com/reporting/fd913507-4f62-42f2-9a04-52acb644d72b)

The dashboard breaks down default rate and loan volume by grade, purpose, and home ownership.

## Modeling

Loans still marked "Current" were dropped, since they haven't resolved yet. The target is binary: Charged Off (default) vs. Fully Paid.

| Model | ROC-AUC |
|---|---|
| Logistic Regression | 0.704 |
| XGBoost | 0.717 |

XGBoost edges out Logistic Regression, which is typical for this kind of tabular credit data — the features here only explain part of what drives default, so neither model gets close to a perfect score.

Full notebook: [`notebooks/loan_default_model.ipynb`](notebooks/loan_default_model.ipynb)

### Top features driving default

See [`charts/feature_importance.html`](feature_importance.html) for the full ranking. Interest rate, grade/sub-grade, and debt-to-income ratio come out as the strongest predictors, which fits the SQL findings above.

## Key Insights

- Loan grade is the clearest single signal of default risk, and LendingClub's pricing already reflects it.
- Purpose matters too — small business loans are worth a closer look for underwriting, since they default well above the average.
- A model based on these features gets moderately useful separation (AUC ~0.72) but isn't precise enough to replace manual underwriting on its own — it's better suited as one input among several.

## Project Structure

```
loan-default-analysis/
├── data/           # source CSV
├── sql/            # SQL queries + exported query results
├── notebooks/       # EDA and modeling notebook
├── charts/         # Plotly chart exports, dashboard screenshot
└── README.md
```
