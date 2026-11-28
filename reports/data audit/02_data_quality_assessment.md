# Retail Sales Analysis Project
# Data Quality Assessment Report

## 1. Assessment Overview

**Project:** Retail Sales & Business Performance Analysis  
**Assessment:** Data Quality Assessment  
**Database:** Retail Sales Database  
**Assessment date:** 18 November 2026  
**Database platform:** MySQL  

### 1.1 Objective

The objective of this assessment was to evaluate the quality, consistency, accuracy, and reliability of the data contained in the Retail Sales database before proceeding with exploratory data analysis and business performance analysis.

The assessment focused on identifying missing values, blank fields, duplicate records, inconsistent text values, invalid numerical values, pricing discrepancies, and discount anomalies.

It also involved validating relationships between tables and verifying the corrections made during the assessment.

### 1.2 Database Scope

The assessment covered eight related tables:

| Table | Records | Columns |
|---|---:|---:|
| customers | 241 | 7 |
| categories | 8 | 2 |
| products | 55 | 7 |
| suppliers | 18 | 4 |
| stores | 8 | 6 |
| staff | 24 | 5 |
| orders | 2,600 | 8 |
| order_items | 4,155 | 6 |

**Total records assessed: 7,093**

## 2. Data Familiarisation and Relationship Validation

Before conducting the data quality checks, the database structure and relationships between the tables were reviewed.

The following foreign key relationships were validated using LEFT JOIN queries to identify records with unmatched references.

| Child table | Foreign key | Referenced table |
|---|---|---|
| orders | customer_id | customers |
| orders | store_id | stores |
| orders | staff_id | staff |
| order_items | order_id | orders |
| order_items | product_id | products |
| products | category_id | categories |
| products | supplier_id | suppliers |
| staff | store_id | stores |

**Finding:** All eight relationships returned zero unmatched records.

**Status:** Passed.

No orphaned records were identified in the relationships examined.

## 3. Data Quality Checks and Findings

### 3.1 Missing Values (NULL Check)

**Objective:** Identify missing or NULL values across all columns in the eight database tables.

**Method:** Used `IS NULL` with conditional aggregation to count NULL values in each column.

**Findings:**

- All columns across the eight tables were checked.
- No NULL values were identified.
- Every column returned a NULL count of zero.

**Status:** Passed.

No corrections were required.

### 3.2 Blank Values Check

**Objective:** Identify text fields containing empty or whitespace-only values.

**Method:** Used `TRIM()` to identify text fields containing blank values.

**Finding:**

One blank value was identified in the `customers` table.

| Table | Column | Blank records |
|---|---|---:|
| customers | city | 1 |

All other applicable text columns returned zero blank records.

**Correction performed:**

The blank city value was updated to `Unknown`.

```sql
UPDATE customers
SET city = 'Unknown'
WHERE TRIM(city) = '';
```

The record was subsequently verified to confirm that the correction had been applied.

**Status:** Passed after correction.

**Note:** The standard MySQL `TRIM()` function does not remove every possible whitespace character. Additional inspection was therefore necessary when investigating the product-name inconsistency discussed in Section 3.4.

### 3.3 Duplicate Records Check

**Objective:** Identify duplicate records in primary key columns and investigate possible duplicate transaction lines.

**Method:** Used `GROUP BY` and `HAVING COUNT(*) > 1`.

The following identifier columns were checked:

| Table | Column | Finding |
|---|---|---|
| customers | customer_id | No duplicates |
| categories | category_id | No duplicates |
| products | product_id | No duplicates |
| suppliers | supplier_id | No duplicates |
| staff | staff_id | No duplicates |
| stores | store_id | No duplicates |
| orders | order_id | No duplicates |

For the `order_items` table, the combination of `order_id` and `line_number` was checked because an order can legitimately contain multiple line items.

**Finding:**

One duplicated composite-key combination was identified.

| Order ID | Line number | Number of records |
|---|---:|---:|
| ORD000033 | 1 | 2 |

Both records were identical:

| order_id | line_number | product_id | quantity | unit_price | discount_pct |
|---|---:|---|---:|---:|---:|
| ORD000033 | 1 | P0019 | 10 | 2,100 | 0 |
| ORD000033 | 1 | P0019 | 10 | 2,100 | 0 |

Further investigation established that:

- The parent order exists in the `orders` table.
- The order contains only these two identical line-item records.
- The parent order status is `Returned`.
- The combined quantity recorded across both rows is 20.
- The combined line value before considering any return-accounting treatment is ₦42,000.

If one record were confirmed as accidental duplication, the corresponding quantity would be 10 and the line value ₦21,000. However, the correct treatment depends on the business rules governing returned transactions.

**Action required:** Do not delete either record until the business meaning of the duplicate has been confirmed.

**Status:** Unresolved; pending business-rule confirmation.

### 3.4 Inconsistent Text Values

**Objective:** Identify inconsistent text entries, including differences in capitalization and unwanted leading or trailing whitespace.

**Method:** Used `DISTINCT`, `TRIM()`, `LENGTH()`, `HEX()`, and targeted filtering to investigate suspicious values.

The assessment identified the following issues:

| Table | Column | Identified issue | Records affected |
|---|---|---|---:|
| customers | customer_type | Lowercase value with trailing whitespace (`retail `) | 4 |
| products | product_name | Leading whitespace, including a non-breaking space, and trailing whitespace | 1 |
| stores | store_name | Trailing whitespace | 1 |

**Corrections performed:**

**A. Customers table**

Four customer records contained the inconsistent value `retail `.

The values were standardized to `Retail`.

```sql
UPDATE customers
SET customer_type = 'Retail'
WHERE LOWER(TRIM(customer_type)) = 'retail';
```

The distinct values were checked again to verify that the inconsistent entry no longer appeared.

**B. Products table**

Product `P0006`, named `Green Tea 25 Bags`, contained unwanted leading and trailing whitespace. The leading characters included a non-breaking space.

The product name was corrected:

```sql
UPDATE products
SET product_name = 'Green Tea 25 Bags'
WHERE product_id = 'P0006';
```

The corrected name was verified using `LENGTH()` and `HEX()`.

**C. Stores table**

Store `STR003` contained the name `Yaba Market ` with a trailing space.

The value was standardized:

```sql
UPDATE stores
SET store_name = 'Yaba Market'
WHERE store_id = 'STR003';
```

The corrected value was verified.

**Additional observations:**

The distinct values and applicable whitespace checks for other reviewed text fields, including staff roles, sales channels, payment methods, order statuses, category names, supplier regions, supplier names, and staff names, did not reveal further inconsistencies.

**Status:** Passed after corrections.

### 3.5 Invalid Numerical Values

**Objective:** Identify numerical values that could be invalid or inconsistent with expected business rules.

**Method:** Used conditional filters to investigate zero, negative, and potentially invalid numerical values.

#### A. Quantity validation

The `order_items.quantity` column was checked for zero and negative quantities.

Two records were identified:

| Order ID | Line | Product ID | Quantity |
|---|---:|---|---:|
| ORD001731 | 1 | P0021 | -2 |
| ORD002194 | 2 | P0021 | 0 |

Further investigation revealed:

**ORD001731**

- Product: Bleach 1L.
- Quantity: -2.
- Unit price: ₦950.
- Discount: 0%.
- Order status: Completed.
- Calculated line value: -₦1,900.
- This was the only negative-quantity record identified in the dataset.

The transaction was investigated against the customer's other transactions and the product's transaction history. No supporting evidence was found to establish that the negative quantity represented a valid return or reversal.

**ORD002194**

- Product: Bleach 1L.
- Quantity: 0.
- Unit price: ₦950.
- Discount: 15%.
- Order status: Completed.
- Calculated line value: ₦0.
- This was the only zero-quantity record identified in the dataset.

The parent order contained other product lines with positive quantities.

**Quantity reconciliation:**

| Quantity classification | Number of records |
|---|---:|
| Negative quantities | 1 |
| Zero quantities | 1 |
| Positive quantities | 4,153 |
| **Total** | **4,155** |

**Action required:** Both records remain unchanged pending confirmation of the business rules governing negative and zero quantities.

#### B. Other numerical checks

The following additional checks were performed:

| Table | Column | Check | Finding |
|---|---|---|---|
| order_items | unit_price | Zero or negative prices | None found |
| products | unit_price | Zero or negative prices | None found |
| products | unit_cost | Zero or negative costs | None found |
| products | reorder_level | Negative values | None found |
| suppliers | payment_terms_days | Negative values | None found |

The maximum quantity recorded was 12. No obvious extreme quantity was identified from this check alone.

**Status:** Unresolved quantity anomalies; other checks passed.

### 3.6 Price Validation

**Objective:** Evaluate the consistency of transaction prices recorded in `order_items` against the reference selling prices in `products`.

**Method:** Joined `order_items` and `products` using `product_id` and compared `order_items.unit_price` with `products.unit_price`.

#### A. Price comparison

A total of 19 records had transaction prices that differed from the reference product prices.

| Price comparison | Records |
|---|---:|
| Equal to reference price | 4,136 |
| Lower than reference price | 11 |
| Higher than reference price | 8 |
| **Total** | **4,155** |

The differences represented:

- 99.54% of records with prices equal to the reference price.
- 0.26% with prices below the reference price.
- 0.19% with prices above the reference price.

#### B. Investigation of price differences

All 19 price differences were either 15% above or 15% below the reference price.

An additional check compared each transaction price against the expected price calculated using the recorded discount:

`Expected Price = Reference Price × (1 - discount_pct)`

Results:

- 2 of the 19 records matched the calculated expected price.
- 17 records did not match the calculated expected price.

This indicates that the recorded discount does not consistently explain the observed transaction-price differences.

#### C. Below-cost validation

Transaction prices were also compared with the corresponding product costs.

No transaction prices below the reference product cost were identified.

**Conclusion:**

The 19 price differences are exceptions requiring further investigation. They cannot automatically be classified as incorrect because the database does not currently establish whether historical price changes, approved pricing adjustments, or other business rules explain them.

**Action required:** Confirm the applicable pricing rules and historical price records before making any changes.

**Status:** Price discrepancies identified; pending business-rule confirmation.

### 3.7 Discount Validation

**Objective:** Identify discount values outside the expected range.

**Expected range:** 0 to 1, representing 0% to 100%.

**Method:** Checked for discount values below zero or above one.

```sql
SELECT *
FROM order_items
WHERE discount_pct < 0
   OR discount_pct > 1;
```

**Finding:**

Eight records were identified with a discount value of `1.2`, equivalent to 120%.

All eight records were associated with orders marked `Completed`.

#### Discount distribution

| Discount value | Number of records |
|---:|---:|
| 0 | 2,223 |
| 0.05 | 768 |
| 0.10 | 615 |
| 0.15 | 376 |
| 0.20 | 165 |
| 1.20 | 8 |
| **Total** | **4,155** |

The distribution confirms that all 4,155 records were accounted for.

**Finding summary:**

- 4,147 records fall within the expected discount range.
- 8 records contain a discount value of 1.2.
- No NULL discount values were identified.

**Action required:** The eight records should be reviewed against the original transaction or approved discount information.

The value `1.2` should not automatically be changed to `0.12`, as the intended discount has not been independently confirmed.

**Status:** Unresolved; pending business-rule confirmation.

## 4. Summary of Findings

The following table summarizes the outcome of the assessment.

| Assessment area | Key finding | Outcome |
|---|---|---|
| Foreign key validation | Zero unmatched records across eight relationships | Passed |
| Missing values | Zero NULL values across all columns | Passed |
| Blank values | One blank customer city corrected | Corrected |
| Duplicate records | One duplicated order-item combination | Unresolved |
| Inconsistent text values | Four customer types, one product name, and one store name issue corrected | Corrected |
| Invalid numerical values | One negative and one zero quantity | Unresolved |
| Price validation | 19 transaction-price differences identified | Pending confirmation |
| Discount validation | Eight records contain 120% discounts | Unresolved |

## 5. Corrective Actions Performed

The following corrections were completed during the assessment:

| Table | Column | Issue | Action taken | Records affected |
|---|---|---|---|---:|
| customers | city | Blank value | Updated to `Unknown` | 1 |
| customers | customer_type | Inconsistent lowercase value and trailing whitespace | Standardized to `Retail` | 4 |
| products | product_name | Leading and trailing whitespace | Corrected product name | 1 |
| stores | store_name | Trailing whitespace | Standardized to `Yaba Market` | 1 |

All listed corrections were verified after the updates.

**Total affected records across the correction actions: 7.**

This is a count of records affected by the individual correction actions, not necessarily seven distinct records.

## 6. Outstanding Issues and Recommendations

The following issues remain unresolved and should be reviewed before the dataset is considered fully validated for business analysis.

| Issue | Affected records | Recommended action |
|---|---:|---|
| Duplicate order-item line | 1 duplicated combination involving 2 rows | Confirm whether one row is accidental duplication before deletion |
| Negative quantity | 1 | Confirm whether the negative value represents a return, reversal, or data-entry error |
| Zero quantity | 1 | Confirm whether zero-quantity order lines are permitted |
| Transaction-price differences | 19 | Compare against approved pricing rules and historical price records |
| Discount values above 100% | 8 | Verify against original transaction records or approved discount values |

### General recommendations

1. Introduce appropriate database constraints where applicable to prevent invalid quantities and discount values from being entered.
2. Establish clear business rules for returned transactions and negative quantities.
3. Maintain historical product pricing records to support the validation of transaction prices.
4. Introduce validation rules for discount percentages.
5. Enforce appropriate uniqueness constraints on transaction line identifiers, subject to confirmation of the intended order-item structure.
6. Perform routine data quality checks to identify inconsistencies before they affect reporting and business decisions.
7. Retain a record of all data corrections for traceability and audit purposes.

## 7. Overall Assessment Conclusion

The data quality assessment covered eight related database tables containing a total of 7,093 records.

The assessment confirmed that:

- All eight foreign key relationships examined had no unmatched records.
- No NULL values were identified across the assessed columns.
- One blank customer city was identified and corrected.
- Four customer-type entries, one product name, and one store name were standardized.
- No duplicate primary-key values were identified in the seven identifier columns examined.
- One duplicate order-item combination was identified.
- Two quantity anomalies were found: one negative quantity and one zero quantity.
- Nineteen transaction-price differences were identified when compared with reference product prices.
- Eight records contained discount values outside the expected range.

Several issues were successfully corrected and verified. However, the duplicate order-item record, quantity anomalies, price differences, and discount anomalies remain subject to business-rule confirmation.

**Overall conclusion:** The assessment has identified and corrected several data quality issues and documented the remaining exceptions. The database is ready for the next stage of analysis with the outstanding issues clearly documented and appropriately considered during interpretation of business results.

---

**End of Report**