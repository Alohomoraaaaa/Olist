# Olist Insights: Brazilian E-Commerce Intelligence Dashboard

## Project Overview
Olist Insights is an end-to-end Data Analytics and Business Intelligence project built on the Brazilian Olist e-commerce dataset. The project combines SQL, Python, Power BI, and Machine Learning to analyze sales performance, logistics efficiency, customer satisfaction, and review behavior across more than 100,000 marketplace orders.

The goal was to transform raw transactional data into actionable business insights while also building a predictive model capable of identifying potentially dissatisfied customers.

## Business Problem

The Olist marketplace generates large volumes of transactional, customer, seller, payment, logistics, and review data.

Key business questions:
- Which categories generate the highest revenue?
- Which states contribute most to marketplace performance?
- How reliable is the delivery network?
- What factors influence customer reviews?
- Can negative customer experiences be predicted before reviews are submitted?

## Dataset

Source: Olist Brazilian E-Commerce Dataset (Kaggle)

Raw dataset location:
Olist/dataset/

Cleaned datasets:
Olist/dataset/clean/

The project integrates Orders, Customers, Sellers, Products, Reviews, Payments and Geolocation tables.

## Technology Stack

| Category | Tools |
|-----------|--------|
| Database | PostgreSQL |
| Querying | SQL |
| Analysis | Python |
| Libraries | Pandas, NumPy, Matplotlib, Scikit-learn, XGBoost |
| BI & Visualization | Power BI |
| Machine Learning | Logistic Regression, Random Forest, XGBoost |
| Version Control | Git, GitHub |
| Environment | Jupyter Notebook |

## Detailed Project Workflow

### 1. Data Understanding
- Studied relationships across seven business tables.
- Mapped customer journey from purchase to review.
- Examined order lifecycle and delivery process.

### 2. Data Cleaning & Transformation
- Missing value handling
- Data type corrections
- Date conversions
- Duplicate validation
- Revenue calculations
- Delivery KPI generation
- Feature engineering

### 3. Exploratory Data Analysis
- Revenue trends
- Order volume trends
- Category performance
- Review behavior
- Delivery efficiency
- Regional performance

### 4. Dashboard Development

#### Data Modeling
Fact Tables:
- Orders
- Reviews
- Payments

Dimension Tables:
- Customers
- Sellers
- Products
- Geography
- Date Table

DAX measures were created for revenue, orders, customers, reviews and delivery KPIs.

### 5. Machine Learning

#### Objective
Predict whether an order is likely to receive a negative customer review using operational and transactional features.

#### Model Comparison

| Model | Recall | F1 Score | ROC-AUC |
|---------|---------|---------|---------|
| Logistic Regression | 0.11 | 0.19 | 0.699 |
| Random Forest | 0.28 | 0.39 | 0.726 |
| XGBoost | **0.28** | **0.40** | **0.747** |

#### Final Model
XGBoost

| Metric | Score |
|----------|----------|
| ROC-AUC | 74.7% |
| F1 Score | 0.40 |
| Recall | 28% |

### Limitations
Customer dissatisfaction depends on factors not present in the dataset:
- Product quality
- Packaging condition
- Seller communication
- Customer expectations
- Review text
- Product images

The model predicts dissatisfaction using only operational and transactional data, which explains the lower recall.

## SQL Analysis

Used:
- JOINs
- CTEs
- GROUP BY
- CASE statements
- Window Functions
- Ranking Functions

## Dashboard Walkthrough

### Home Page
![Home Dashboard](notebooks/img/1.png)

### Overview Dashboard
![Overview Dashboard](notebooks/img/2.png)

Focus:
- Revenue
- Orders
- Customers
- Revenue trends
- Top categories
- Top states

Key Insight:
Revenue is concentrated in a few product categories and major states, with São Paulo contributing the highest share.

### Operations Dashboard
![Operations Dashboard](notebooks/img/3.png)

Focus:
- Delivery performance
- On-time delivery
- Delivery status distribution
- State-wise logistics performance

Key Insight:
96% of orders were successfully delivered with an average delivery time close to 12 days.

### Experience Dashboard
![Experience Dashboard](notebooks/img/4.png)

Focus:
- Review behavior
- Rating distribution
- Customer satisfaction
- Predictive analytics

Key Insight:
58% of reviews are 5-star ratings while low-rated reviews account for roughly 15% of total reviews.

## Dashboard Demo

Video walkthrough:

notebooks/img/dashboard_demo.mp4

## Business Impact

- Track marketplace growth
- Monitor operational efficiency
- Understand customer satisfaction
- Identify high-performing regions
- Detect dissatisfaction earlier

## Key Findings

- Health & Beauty generated the highest revenue.
- Top 10 categories contribute approximately 72% of revenue.
- São Paulo contributes the largest share of revenue.
- Average customer review remains above 4 stars.
- Approximately 58% of reviews are 5-star ratings.
- Delivery performance strongly influences customer experience.

## Future Improvements

- Review text sentiment analysis
- SHAP feature importance
- Seller history features
- Customer history features
- Improved recall using richer features
- Power BI Service deployment

## Final Business Conclusions

The Olist marketplace demonstrates strong operational performance, high delivery success rates and positive customer satisfaction.

Revenue remains concentrated among a small number of categories and regions, while the predictive model achieved a respectable ROC-AUC of 74.7%, providing a useful foundation for future customer satisfaction prediction systems.

## Author

Rutuja

Computer Engineering Student

Built using SQL, Python, Power BI and Machine Learning.
