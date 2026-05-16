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
Built a Random Forest classifier to predict customer churn using feature engineering across 5 tables in DuckDb. Discovered data leakage and ultimately concluded that the traditional churn prediction model is not good approach for the Olist, because of the fact that the business revolves around one time buyers, and not keeping the customers for the long run.
### 02 - Customer Segmentation (`notebooks/02_customer_segmentation.ipynb`)
Applied RFM analysis and KMeans clustering to segment 93,358 customers. KMeans found mathematically valid clusters but since the data was in a way that clear segmentation was not compatible with the business model, I chose to pursue a manual RFM scoring.

# Key Findings
## Churn Analysis Findings:
Initial ROC-AUC was 1.0, This revealed data leakage from `recency_days` (Because churn label derived directly from it). After I fixed the leakage, ROC-AUC dropped to 0.53, which was barely above random. The root cause was the 0.69% year-over-year retention rate. The median customer returns within 28 days, but 90% never return at all. In the end, Traditional churn modeling is not appropriate for this business model.

## Segmentation findings
KMeans silhouette score was 0.37. Pure RFM clustering found mathematical clusters but identical business profiles, so there was no meaningful separation. Fell back to manual RFM scoring which produced 4 actionable segments. The following table is the RFM Segments we found:

|Segment|% Customers|Avg Recency|Avg Orders|Avg Spend|
|-------|-----------|-----------|----------|---------|
|Champions|0.6%     |119 days   |2.37      |$437     |
|Loyal Customers|37.8%|184 days |1.06      |$254     |
|Potential Loyalist|42.6%|311 days| 1.01   |$130     |
|At Risk|19%        |443 days   |1.00      |$57      |

# Business Recommendations
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