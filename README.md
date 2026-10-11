# Healthcare Operations Analytics

Analyze 9,000+ patient encounters to understand hospital demand, waiting times, and patient experience.  
Use SQL-driven insights to identify operational bottlenecks and recommend practical improvements to patient flow.

## Project Overview

This project analyzes historical hospital encounter data from **April 2023 to October 2024** to understand how patient demand, department-level delays, and staffing patterns affect operational efficiency and patient experience.

The goal is to turn hospital data into actionable recommendations that improve patient flow, reduce waiting times, and enhance service delivery.

## Dataset Used

- **Records:** 9,000+ patient encounters
- **Time Period:** April 2023 – October 2024
- **Patient Demographics:** Age, gender, race
- **Visit Details:** Admission date and time, visit type
- **Operational Metrics:** Department referral, wait time, doctor ID
- **Outcomes:** Admission status, patient satisfaction score
- **Related Data:** Doctor details linked through doctor ID

**Data Quality Considerations:**
- Retained missing satisfaction scores as potential non-responses.
- Replaced missing department values with `Unknown`.
- Standardized inconsistent gender entries.
- Converted date values from text to a proper date format.
- Preserved missing doctor IDs to maintain data integrity.

## Project Workflow

1. **Data Exploration:** Reviewed record counts, date ranges, distributions, and missing values.
2. **Data Cleaning:** Standardized inconsistent entries, handled missing values, and corrected date formats.
3. **Patient Demand Analysis:** Examined monthly and yearly trends, visit types, and arrival patterns.
4. **Wait Time Analysis:** Compared waiting times across departments and identified delays exceeding 30 minutes.
5. **Bottleneck Identification:** Analyzed department-hour combinations and doctor shifts to uncover operational pressure points.
6. **Outcome Analysis:** Evaluated patient satisfaction, admission rates, and the relationship between waiting times and admissions.
7. **Business Recommendations:** Translated findings into practical strategies for improving hospital operations.

## Tools Used

- **SQL:** Data cleaning, aggregations, trend analysis, and business-focused queries
- **Snowflake** Cloud Data Warehouse

## How to Use This Project

1. Clone or download this repository.
2. Review the dataset documentation and SQL scripts.
3. Load the dataset into your SQL database.
4. Run the data cleaning and analysis queries, updating table or column names if necessary.
5. Review the findings and business recommendations to understand the operational challenges.

*Note: Add the dataset source, database requirements, and exact execution instructions to make the analysis fully reproducible.*

## Key Insights & Recommendations

| Key Insight | Business Implication | Recommendation |
|---|---|---|
| Patient demand is growing year over year, without sharp monthly surges. | Gradual growth requires proactive capacity planning. | Forecast demand regularly and adjust staffing plans accordingly. |
| Emergency visits are the largest visit category. | Emergency demand is less predictable and requires responsive intake. | Optimize triage and intake processes while protecting emergency capacity. |
| Wait times are consistently high across departments, with many patients waiting over 30 minutes. | Delays appear to be a system-wide issue rather than an isolated departmental problem. | Improve intake and patient flow processes, and track progress toward a sub-30-minute wait target. |
| Specific department-hour combinations experience higher delays. | Overall averages can hide localized operational bottlenecks. | Investigate high-delay periods, including Neurology at night and Physiotherapy in the morning. |
| Night-shift doctors handle more patients, and efficiency varies across shifts. | Staffing and workload may not be aligned with actual demand. | Rebalance doctor assignments and staffing based on shift-level workload. |
| Patient satisfaction is relatively low and similar across departments. | Patient experience may require hospital-wide improvements. | Track satisfaction alongside wait times and gather patient feedback. |
| Department admission rates are similar, at approximately 48%–51%. Longer waits are not directly associated with a higher likelihood of admission. | Waiting time alone is not a reliable indicator of admission outcomes. | Evaluate admission patterns alongside clinical and operational factors. |

### Overall Business Recommendation

Prioritize **reducing waiting times, resolving department-hour bottlenecks, and balancing doctor workloads** before assuming that additional hospital capacity is the only solution.
