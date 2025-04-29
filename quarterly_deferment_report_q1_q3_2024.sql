/*
===============================================================================
QUARTERLY DEFERRED INCOME SQL SCRIPT FOR FINANCE DEPARTMENT
Author: [Wasiu Musa Oladipupo]
Company: [Renewable energy Company]
Purpose: To extract deferment and repayment data for financial reporting
===============================================================================
*/

/* =============================================================================
  SECTION 1: LEGACY CONTRACTS DEFERMENT SCRIPT (As of Q1 2024)
============================================================================= */

SELECT DISTINCT 
    a.`crmcontract`,
    a.`customer_status`,
    a.`generation`,
    a.`created_date`,
    a.`ltoperiod`,
    b.`paidperiod`,
    DATE(COALESCE(c.Payment_date, a.`last_payment_date`)) AS Paymentdate,
    a.payment_end_date,
    SUM(amount) AS charged_amount,
    SUM(duration) AS paid_duration
FROM (
    -- Combine legacy contracts from two different tables
    SELECT DISTINCT
        `contract_number` AS `crmcontract`,
        `customer_status`,
        `generation`,
        `contract_creation_date` AS `created_date`,
        `ltoperiod`,
        `next_status_update` AS payment_end_date,
        `last_payment_date`
    FROM `b9_b7_status`
    WHERE `report_date` = '2024-03-31' AND `generation` = 'Legacy'

    UNION ALL

    SELECT DISTINCT
        `crmcontract`,
        `customer_status`,
        `generation`,
        `created_date`,
        `ltoperiod`,
        `activation_end_date` AS payment_end_date,
        '' AS `last_payment_date`
    FROM `b9_b7_mar_customer_status`
) a

-- Join paid periods
LEFT OUTER JOIN (
    SELECT DISTINCT `contract_number`, `paidperiod`
    FROM `b9_b7_paidperiod`
    WHERE `updated_date` = '2024-03-31'
) b ON a.`crmcontract` = b.`contract_number`

-- Join repayment data for Q1 2024
LEFT OUTER JOIN (
    SELECT 
        `contract_number`, 
        SUM(`charged_amount`) AS amount,
        SUM(`days`) AS duration,
        MAX(`payment_datetime`) AS Payment_date
    FROM `b9_b7_repayment_data_lake`
    WHERE `payment_date` BETWEEN '2024-02-01' AND '2024-03-31'
      AND `check` != 'Invalid'
    GROUP BY `contract_number`
) c ON a.`crmcontract` = c.`contract_number`

GROUP BY 
    `crmcontract`, `customer_status`, `generation`, `created_date`, `ltoperiod`,
    `paidperiod`, Paymentdate, payment_end_date;



/* =============================================================================
  SECTION 2: B7_B9 DEFERRED INCOME SCRIPT (As of Q3 2024)
============================================================================= */

SELECT DISTINCT 
    a.`contract_number`,
    a.`spsid`,
    a.`customer_status`,
    a.`tenant_name`,
    a.`generation`,
    a.`created_date`,
    a.`ltoperiod`,
    b.`paidperiod`,
    DATE(COALESCE(c.Payment_date, a.`last_payment_date`)) AS Paymentdate,
    a.payment_end_date,
    SUM(amount) AS charged_amount,
    SUM(duration) AS paid_duration
FROM (
    SELECT DISTINCT
        `contract_number`,
        `spsid`,
        `customer_status`,
        `tenant_name`,
        `generation`,
        `contract_creation_date` AS `created_date`,
        `ltoperiod`,
        `next_status_update` AS payment_end_date,
        `last_payment_date`
    FROM `b9_b7_status_table`
    WHERE `report_date` = '2024-09-30'
) a

-- Join paid period as of Q3 2024
LEFT OUTER JOIN (
    SELECT DISTINCT `contract_number`, `paidperiod`
    FROM `b9_b7_paidperiod`
    WHERE `updated_date` = '2024-09-30'
) b ON a.`contract_number` = b.`contract_number`

-- Join repayment data for Q3 2024
LEFT OUTER JOIN (
    SELECT 
        `contract_number`,
        SUM(`charged_amount`) AS amount,
        SUM(`days`) AS duration,
        MAX(`payment_date`) AS Payment_date
    FROM `b9_b7_repayment_data_lake`
    WHERE `payment_date` BETWEEN '2024-07-01' AND '2024-09-30'
      AND `check` != 'Invalid'
    GROUP BY `contract_number`
) c ON a.`contract_number` = c.`contract_number`

GROUP BY 
    `contract_number`, `customer_status`, `generation`, `created_date`, `ltoperiod`,
    `paidperiod`, Paymentdate, payment_end_date, `spsid`, `tenant_name`;



/* =============================================================================
  SECTION 3: L1 PLATFORM DEFERMENT SCRIPT (As of Q3 2024)
============================================================================= */

SELECT DISTINCT 
    a.`contract_number`,
    a.`system_id`,
    a.`created_date`,
    `active_status`,
    `ltoperiod` AS LTOPeriod,
    `paidperiod`,
    DATE(COALESCE(payment_date, `last_status_update`)) AS payment_date,
    DATE(COALESCE(payment_end_date, `next_status_update`)) AS payment_end_date,
    `status`,
    charged_amount,
    paid_day
FROM (
    -- Base L1 activity data excluding outright contracts
    SELECT * 
    FROM `upya_activity_log`
    WHERE `report_date` = '2024-09-30'
      AND `tenure` != 'Outright plan'
) a

-- Join repayment summaries
LEFT JOIN (
    SELECT 
        `contract_number`,
        MAX(`payment_date`) AS payment_date,
        MAX(`payment_end_date`) AS payment_end_date,
        SUM(`amount`) AS charged_amount,
        SUM(`total_days_activated`) AS paid_day
    FROM `upya_daily_transactions`
    WHERE `report_date` BETWEEN '2024-07-01' AND '2024-09-30'
    GROUP BY `contract_number`
) b ON a.`contract_number` = b.`contract_number`;
