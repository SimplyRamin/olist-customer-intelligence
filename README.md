![Python](https://img.shields.io/badge/Python-3.11-blue)
![MLflow](https://img.shields.io/badge/MLflow-tracking-orange)
![DuckDB](https://img.shields.io/badge/DuckDB-SQL-yellow)
![License](https://img.shields.io/badge/License-MIT-green)


# Olist Customer Segmentation and Churn Analysis
In this project I have tried to perform a churn analysis and customer segmentation in an data-driven way for the Olist, given their data from 2016-2018.

# Background & Problem Statement
Olist is a Brazilian e-commerce marketplace platform that helps small retailers sell on major marketplace. The dataset available to us covered 2016 to 2018, and it had 93,358 customers and 96,478 delivered orders. The problem we tried to tackle was segmentation and churn analysis of the customers. The business model of Olist was in a way that the traditional churn analysis wouldn't help us. Olist is like a big local marketplace that customers go to and buy the products they need from different booths. The booths in this example, are sellers that are selling their item on Olist. The issue was that there are no guarantee that sellers would be active, thus customers search the item they need and buy it if they find it on Olist, its not like Amazon or Ebay. This is the reason that traditional churn analysis was not good choice, because most of the customers only buy one time here.

# Projects Overview
### 01 - Churn Prediction (`notebooks/01_churn_prediction.ipynb`)
Built Random Forest and XGBoost classifiers to predict customer churn using feature engineering across 5 tables in DuckDB. Initial models achieved ROC-AUC of 0.53 due to insufficient features. After engineering 4 additional behavioral sugnals (delivery delay, freight ratio, late delivery rate, purchase day of week), performance improved to ROC-AUC 0.706 (Random Forest) and 0.767 (XGBoost). SHAP analysis revealed delivery experience as the strongest churn predictor.
### 02 - Customer Segmentation (`notebooks/02_customer_segmentation.ipynb`)
Applied RFM analysis and KMeans clustering to segment 93,358 customers. KMeans found mathematically valid clusters but since the data was in a way that clear segmentation was not compatible with the business model, I chose to pursue a manual RFM scoring.
### 03 - Customer Value Scoring (`notebooks/03_customer_value_scoring.ipynb`)
Built a Random Forest classifier to identify high-value customers based on first-order characteristics only. Achieved ROC-AUC of 0.98, but feature importance analysis revealed first_order_value dominates at 79%, a dataset artifact of the single-purchaes marketplace model where first order value equals lifetime value for 90% of customers. Documents the fundamental limitation of behavioral ML on this dataset.

# Key Findings
## Churn Analysis Findings:
- Initial models achieved ROC-AUC of 0.53, barely above random guessing
- Root cause: insufficient behavioral features, not algorithm choice
- After engineering delivery delay, freight ratio and purchase behavior features, ROC-AUC improved to 0.706 (RF) and 0.767 (XGBoost)
- SHAP analysis identified avg_delivery_delay_days as the strongest churn predictor, late deliveries significantly increase chrun probability
- Random Forest outperforms XGBoost for identifying loyal customers (class 0 recall 0.46 vs 0.06) despite lower ROC-Auc
- 0.69% year-over-year retention rate confirms single-purchase marketplace nature, modest model performance reflects geniune data limitations, not modeling failure
## Segmentation findings
KMeans silhouette score was 0.37. Pure RFM clustering found mathematical clusters but identical business profiles, so there was no meaningful separation. Fell back to manual RFM scoring which produced 4 actionable segments. The following table is the RFM Segments we found:

|Segment|% Customers|Avg Recency|Avg Orders|Avg Spend|
|-------|-----------|-----------|----------|---------|
|Champions|0.6%     |119 days   |2.37      |$437     |
|Loyal Customers|37.8%|184 days |1.06      |$254     |
|Potential Loyalist|42.6%|311 days| 1.01   |$130     |
|At Risk|19%        |443 days   |1.00      |$57      |

## Customer Value Scoring Findings
- ROC-AUC of 0.98 achieved but driven by a single feature: first_order_value (79% importance)
- Root cause: 90% of customers buy once, making first order value equivalent to lifetime value
- Model is technically correct but adds minimal value beyond a simple threshold rule
- Confirms dataset-wide finding: single-purchase marketplace limits predictive ML across all approaches

# Business Recommendations
- From Shap analysis: Delivery experience is the strongest predictor of customer retention. Sellers should prioritize on-time delivery over discounting strategies.
- From churn: Olist's data model can't support traditional churn prediction. Recommend tracking customers across sessions, not just transactions.
- From segmentation: Focus marketing investment on Potential Loyalists (42.6% of customers) — largest segment with highest ROI potential.

**Champions (0.6% of customers, $437 avg spend)**
Offer personalized discount codes based on purchase history. Consider early access to new products. Protect this segment at all costs — losing one Champion costs more than losing 7 average customers.  
**Loyal Customers (37.8%, $254 avg spend)**
Recency is slipping to 184 days — approaching the at-risk threshold. Trigger personalized re-engagement campaigns before they cross 270 days. Category-based recommendations based on past purchases.  
**Potential Loyalists (42.6%, $130 avg spend)**
Largest and most important segment. Audit their review scores — if satisfaction is low, a service recovery campaign before 365 days could convert a significant portion. This segment represents the highest ROI marketing opportunity.  
**At Risk (19%, $57 avg spend)**
Low spend and 443 days inactive. Generic reactivation campaign with broad discounts — not worth personalization investment. Accept that most will not return.

# Limitations
The limitation I faced during this project was that the dataset was limited to 2016 - 2018, that indicated no recent behavior. No customer demographic, browsing, or session data was available. The single-purchase nature severely limits the behavioral modeling, and no cross-session customer tracking was available in raw data.

# Next Steps
I aim to add product category and delivery time features to enrich segmentation, Build CLV regression model on repeat-buyer segment, Investigate seller-side churn, and integrate dbt for production-ready feature engineering pipeline.

# Technical Stack
- Python 3.11, uv package manager
- DuckDB — SQL feature engineering
- MLflow — experiment tracking and model registry
- scikit-learn, XGBoost — modeling
- KMeans, DBSCAN — clustering
- TablePlus — SQL development

# How to Run
1. Clone the repository
2. Run `uv sync` to install dependencies
3. Add `olist.db` to the `data/` folder
4. Run `uv run mlflow ui --port 5000` in a terminal
5. Open notebooks in order: `01_churn_prediction.ipynb`, `02_customer_segmentation.ipynb`