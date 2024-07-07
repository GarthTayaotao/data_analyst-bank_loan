CREATE TABLE loan (
	id INT,
	address_state CHAR(2),
	application_type VARCHAR(256),
	emp_length VARCHAR(256),
	emp_title VARCHAR(256),
	grade CHAR(1),
	home_ownership VARCHAR(256),
	issue_date DATE,
	last_credit_pull_date DATE,
	last_payment_date DATE,
	loan_status VARCHAR(256),
	next_payment_date DATE,
	member_id INT,
	purpose VARCHAR(256),
	sub_grade CHAR(2),
	term VARCHAR(256),
	verification_status VARCHAR(256),
	annual_income NUMERIC,
	dti NUMERIC,
	installment NUMERIC,
	int_rate NUMERIC,
	loan_amount INT,
	total_acc INT,
	total_payment INT,
	PRIMARY KEY(id)
);

COPY loan 
FROM 'D:\Projects\Data Analyst\Bank Loan\Raw Data\financial_loan.csv'
DELIMITER ','
CSV HEADER;

SELECT * 
FROM loan;

-- Queries for Power BI visualization
-- 1. Total Loan Applications
SELECT
	COUNT(DISTINCT id) AS total_loan_applications
FROM loan;

-- 2. Total Funded Amount
SELECT
	SUM(loan_amount) AS total_funded_amount
FROM loan;

-- 3. Total Amount Repaid
SELECT
	SUM(total_payment) AS total_amount_repaid
FROM loan;

-- 4. Avg Interest Rate
SELECT
	(AVG(int_rate) * 100)::NUMERIC(10, 2) AS avg_interest_rate
FROM loan;

-- 5. Avg DTI
SELECT
	(AVG(dti) * 100)::NUMERIC(10, 2) AS avg_dti
FROM loan;

-- 6. Good Loans Issued
SELECT
	COUNT(DISTINCT id) AS good_loan_applications,
	SUM(loan_amount) AS good_loan_funded_amount,
	SUM(total_payment) AS good_loan_total_received,
	(COUNT(DISTINCT id) * 100 / 
		(SELECT COUNT(DISTINCT id) FROM loan))::NUMERIC(10,2) AS good_loan_percentage
FROM loan
WHERE loan_status IN ('Fully Paid', 'Current');

-- 7. Bad Loans Issued
SELECT
	COUNT(DISTINCT id) AS good_loan_applications,
	SUM(loan_amount) AS good_loan_funded_amount,
	SUM(total_payment) AS good_loan_total_received,
	(COUNT(DISTINCT id) * 100 / 
		(SELECT COUNT(DISTINCT id) FROM loan))::NUMERIC(10,2) AS bad_loan_percentage
FROM loan
WHERE loan_status = 'Charged Off';

-- 8. Monthly Total Loan Applications, Amount Funded and Amount Repaid
SELECT
	EXTRACT(MONTH FROM issue_date) AS month_number,
	TO_CHAR(issue_date, 'Mon') AS month,
	COUNT(DISTINCT id) AS loan_applications,
	SUM(loan_amount) AS amount_funded,
	SUM(total_payment) AS amount_repaid
FROM loan
GROUP BY month_number, month
ORDER BY month_number ASC;

-- 9. Total Loan Applications, Amount Funded and Amount Repaid by State
SELECT
	address_state AS state,
	COUNT(DISTINCT id) AS loan_applications,
	SUM(loan_amount) AS amount_funded,
	SUM(total_payment) AS amount_repaid
FROM loan
GROUP BY state
ORDER BY state ASC;	
	
-- 10. Total Loan Applications, Amount Funded and Amount Repaid by Loan Term
SELECT
	term,
	COUNT(DISTINCT id) AS loan_applications,
	SUM(loan_amount) AS amount_funded,
	SUM(total_payment) AS amount_repaid
FROM loan
GROUP BY term
ORDER BY term ASC;	
	
-- 11. Total Loan Applications, Amount Funded and Amount Repaid by Employment Length
SELECT
	emp_length,
	COUNT(DISTINCT id) AS loan_applications,
	SUM(loan_amount) AS amount_funded,
	SUM(total_payment) AS amount_repaid
FROM loan
GROUP BY emp_length
ORDER BY emp_length ASC;	
	
-- 12. Total Loan Applications, Amount Funded and Amount Repaid by Purpose
SELECT
	purpose,
	COUNT(DISTINCT id) AS loan_applications,
	SUM(loan_amount) AS amount_funded,
	SUM(total_payment) AS amount_repaid
FROM loan
GROUP BY purpose
ORDER BY purpose ASC;	
	
-- 12. Total Loan Applications, Amount Funded and Amount Repaid by Home Ownership
SELECT
	home_ownership,
	COUNT(DISTINCT id) AS loan_applications,
	SUM(loan_amount) AS amount_funded,
	SUM(total_payment) AS amount_repaid
FROM loan
GROUP BY home_ownership
ORDER BY home_ownership ASC;	