-- ============================================
-- Loan Default / Credit Risk Analysis
-- Dataset: lending_club_loan_two (~396K rows)
-- ============================================

-- Q0: Check the distinct loan status values and their counts
-- This confirms exact label spelling/casing before filtering on them below
SELECT loan_status, COUNT(*) AS n
FROM lending_club_loan_two
GROUP BY loan_status
ORDER BY n DESC;


-- Q1: What is the default rate by loan grade?
-- Grade is LendingClub's own risk rating (A = safest, G = riskiest)
SELECT grade,
       COUNT(*) AS total_loans,
       SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS defaults,
       ROUND(100 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM lending_club_loan_two
WHERE loan_status IN ('Fully Paid', 'Charged Off')
GROUP BY grade
ORDER BY grade;


-- Q2: What is the default rate by loan purpose?
-- Helps identify which reasons for borrowing carry the most risk
SELECT purpose,
       COUNT(*) AS total_loans,
       ROUND(100 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM lending_club_loan_two
WHERE loan_status IN ('Fully Paid', 'Charged Off')
GROUP BY purpose
ORDER BY default_rate_pct DESC;


-- Q3: Does loan term (36 vs 60 months) affect default rate?
-- Longer loans may carry more risk due to longer exposure
SELECT term,
       COUNT(*) AS total_loans,
       ROUND(100 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM lending_club_loan_two
WHERE loan_status IN ('Fully Paid', 'Charged Off')
GROUP BY term;


-- Q4: What is the average interest rate and loan amount by grade?
-- Checks whether riskier grades are correctly priced with higher interest
SELECT grade,
       ROUND(AVG(int_rate), 2) AS avg_interest_rate,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amount
FROM lending_club_loan_two
GROUP BY grade
ORDER BY grade;


-- Q5: How does borrower income relate to default rate?
-- Buckets borrowers into income bands to spot risk patterns
SELECT
  CASE
    WHEN annual_inc < 40000 THEN 'Under 40k'
    WHEN annual_inc < 80000 THEN '40k-80k'
    WHEN annual_inc < 120000 THEN '80k-120k'
    ELSE '120k+'
  END AS income_band,
  COUNT(*) AS total_loans,
  ROUND(100 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM lending_club_loan_two
WHERE loan_status IN ('Fully Paid', 'Charged Off')
GROUP BY income_band
ORDER BY MIN(annual_inc);


-- Q6: Does home ownership status affect default rate?
-- Compares renters, mortgage holders, and outright owners
SELECT home_ownership,
       COUNT(*) AS total_loans,
       ROUND(100 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM lending_club_loan_two
WHERE loan_status IN ('Fully Paid', 'Charged Off')
GROUP BY home_ownership
ORDER BY default_rate_pct DESC;