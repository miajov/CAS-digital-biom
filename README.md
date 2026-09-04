# 📊 CAS: Descriptives Codebook

---

## 👋 Overview

This document explains the starting variables in the dataset.

- 👥 **Total Participants:** 1,068

---

## 👤 DEMOGRAPHIC VARIABLES

### 🆔 participant_id
- **Type:** Numeric ID
- **Description:** Unique identifier for each participant
- **Range:** 1001 to 2068
- **Example:** 1001, 1002, 1003
- **Use:** Links data rows to specific individuals

### ♀️♂️ sex
- **Type:** Categorical
- **Description:** Biological sex of participant
- **Categories:** 
  - W = Woman 👩
  - M = Man 👨
- **Count:** ~534 Women, ~534 Men
- **Missing:** ✅ None

### 🎂 age
- **Type:** Continuous (numeric)
- **Description:** Age in years at study enrollment
- **Range:** 20 to 89 years
- **Mean:** ~62 years
- **Missing:** ✅ None

---

## 🏥 STUDY GROUP VARIABLES

### 📋 study_group
- **Type:** Categorical (ordered by severity)
- **Description:** Diabetes severity classification

| Group | Status | Details | N |
|-------|--------|---------|---|
| 🟢 Healthy | No diabetes | Normal glucose metabolism | ~372 |
| 🟡 Pre-diabetes | At risk | Elevated glucose, not yet diabetic | ~242 |
| 🟠 Diabetic (Oral med) | Type 2 | Controlled with oral medication | ~324 |
| 🔴 Diabetes (Insulin Dependent) | Type 2 | Requires insulin injections | ~130 |

---

## 🔬 BIOMARKER VARIABLES

### 📊 HbA1c
- **Type:** Continuous (numeric)
- **Description:** Hemoglobin A1c - measures average blood glucose over 3 months
- **Range:** 4.8% to 10.5%
- **Unit:** Percentage (%)

| Value | Meaning | Status |
|-------|---------|--------|
| < 5.7% | 🟢 Normal glucose metabolism | Healthy |
| 5.7% - 6.4% | 🟡 Pre-diabetes range | At risk |
| ≥ 6.5% | 🔴 Diabetes diagnosis | Diabetic |
| < 7% | ✅ Generally controlled | Good |
| ≥ 8% | ⚠️ Poor glycemic control | Needs improvement |

- **Missing:** ✅ None

### 📊 HbA1c_binary
- **Type:** Categorical (binary)
- **Description:** Simplified HbA1c classification
- **Categories:**
  - 🟢 Below 5.7 (Normal) = Healthy glucose metabolism
  - 🔴 Above 5.7 (Elevated) = Pre-diabetes or diabetes range
- **Use:** For simple prevalence comparisons
- **Missing:** ✅ None

### ⚖️ BMI (Body Mass Index)
- **Type:** Continuous (numeric)
- **Description:** Body weight relative to height (weight in kg / height in m²)
- **Range:** 17.0 to 48.5 kg/m²
- **Unit:** kg/m²

| Range | Classification |
|-------|-----------------|
| < 18.5 | 🟡 Underweight |
| 18.5 - 24.9 | 🟢 Normal weight |
| 25.0 - 29.9 | 🟡 Overweight |
| ≥ 30 | 🔴 Obese |


### 📏 waist_circum (Waist Circumference)
- **Type:** Continuous (numeric)
- **Description:** Distance around waist at navel level
- **Range:** 60 to 140 cm
- **Unit:** Centimeters (cm)

| Category | Women | Men |
|----------|-------|-----|
| ✅ Healthy | ≤ 88 cm | ≤ 102 cm |
| ⚠️ Elevated Risk | > 88 cm | > 102 cm |

- **Key Insight:** 🎯 Indicates abdominal/visceral fat - linked to metabolic disease

### 📐 waist_to_hip_ratio
- **Type:** Continuous (numeric)
- **Description:** Waist circumference ÷ hip circumference
- **Range:** 0.60 to 1.15

| Category | Women | Men |
|----------|-------|-----|
| ✅ Healthy | ≤ 0.85 | ≤ 0.90 |
| ⚠️ Elevated Risk | > 0.85 | > 0.90 |

---

## 🫘 KIDNEY HEALTH VARIABLES

### 💧 albuminuria
- **Type:** Continuous (numeric)
- **Description:** Protein (albumin) in urine - indicates kidney damage
- **Unit:** mg/g creatinine (albumin-to-creatinine ratio; UACR)
- **Range:** 0 to 3,000+ mg/g


- **Key Insight:** ⚠️ Early sign of diabetes complications
- **Missing:** ✅ None

### 📊 alb_binary
- **Type:** Binary (0/1)
- **Description:** Presence of albuminuria (kidney damage)
- **Categories:**
  - 0 = 🟢 No albuminuria (normal). **UACR < 30 mg/g** 
  - 1 = 🔴 Albuminuria present (kidney damage detected) **UACR ≥ 30 mg/g** 

---

## 🧠 COGNITIVE FUNCTION VARIABLES

### 🎯 total_moca
- **Type:** Continuous (numeric)
- **Description:** Montreal Cognitive Assessment total score
- **Range:** 0 to 30 points
- **Unit:** Points

- **What it measures:** 🧩 Overall cognitive function:
  - Memory 🧠
  - Attention 👁️
  - Language 💬
  - Visuo-spatial abilities 🎨
  - Executive function 🎯

### 📊 moca_binary
- **Type:** Binary (0/1)
- **Description:** Presence of cognitive impairment
- **Categories:**
  - 0 = 🟢 No impairment (score ≥ 26)
  - 1 = 🔴 Cognitive impairment detected (score < 26)

---

## MENTAL HEALTH VARIABLES

### 😔 cesd (Center for Epidemiologic Studies Depression Scale)
- **Type:** Continuous (numeric)
- **Description:** Depression symptom severity score
- **Range:** 0 to 60 points
- **Unit:** Points

- **What it measures:** 📋 Depressive symptoms from past week:
  - Sadness 😢
  - Guilt 😔
  - Worthlessness 😞
  - Appetite changes 🍴
  - Sleep problems 😴
  - Concentration issues 🧠

### 📊 cesd_binary
- **Type:** Binary (0/1)
- **Description:** Presence of significant depression
- **Categories:**
  - 0 = 🟢 No signs of depression (score < 16)
  - 1 = 🔴 Signs of depression (score ≥ 16)
---

## 💊 LIPID VARIABLES

### 💉 dyslipidemia_binary

- **Type:** Binary (0/1)
- **Description:** Presence of abnormal blood lipid levels
Triglycerides ≥ 150 mg/dL
OR LDL-C ≥ 130 mg/dL
OR HDL-C < 40 mg/dL (men) / < 50 mg/dL (women)
- **Categories:**
  - 0 = 🟢 Normal lipid profile
  - 1 = 🔴 Abnormal lipids (high cholesterol, triglycerides, or low HDL)
---

## 📱 DATA SOURCE VARIABLES

These variables show which measurement methods were used:

### 📍 cardiac_ecg
- **Type:** Boolean (TRUE/FALSE)
- **Description:** Electrocardiogram (heart electrical activity)
- **Values:** 
  - ✅ TRUE = ECG data collected
  - ❌ FALSE = No ECG data

### 📋 clinical_data
- **Type:** Boolean (TRUE/FALSE)
- **Description:** Clinical measurements (blood pressure, labs, etc.)
- **Values:**
  - ✅ TRUE = Clinical data available
  - ❌ FALSE = No clinical data

### 🌍 environment
- **Type:** Boolean (TRUE/FALSE)
- **Description:** Environmental data collection
- **Values:**
  - ✅ TRUE = Environmental data available
  - ❌ FALSE = No environmental data

### 🏃 wearable_activity_monitor
- **Type:** Boolean (TRUE/FALSE)
- **Description:** Activity tracking device worn
- **Values:**
  - ✅ TRUE = Activity data collected
  - ❌ FALSE = No activity data

### 📊 wearable_blood_glucose
- **Type:** Boolean (TRUE/FALSE)
- **Description:** Continuous glucose monitor worn
- **Values:**
  - ✅ TRUE = Glucose monitoring data available
  - ❌ FALSE = No continuous glucose data

---

## 📋 SUMMARY TABLE

| Variable | Type | Range/Categories | Status |
|----------|------|------------------|--------|
| participant_id | Numeric | 1001-2068 | ✅ Complete |
| study_group | Categorical | 4 groups | ✅ Complete |
| age | Continuous | 20-89 years | ✅ Complete |
| sex | Categorical | W, M | ✅ Complete |
| HbA1c | Continuous | 4.8-10.5% | ✅ Complete |
| HbA1c_binary | Categorical | Below/Above 5.7% | ✅ Complete |
| BMI | Continuous | 17.0-48.5 kg/m² | ✅ Complete |
| waist_circum | Continuous | 60-140 cm | ✅ Complete |
| waist_to_hip_ratio | Continuous | 0.60-1.15 | ✅ Complete |
| albuminuria | Continuous | 0-3000+ mg/g | ✅ Complete |
| alb_binary | Binary | 0, 1 | ✅ Complete |
| total_moca | Continuous | 0-30 points | ✅ Complete |
| moca_binary | Binary | 0, 1 | ✅ Complete |
| cesd | Continuous | 0-60 points | ✅ Complete |
| cesd_binary | Binary | 0, 1 | ✅ Complete |
| dyslipidemia_binary | Binary | 0, 1 | ✅ Complete |
| cardiac_ecg | Boolean | TRUE, FALSE | ✅ Complete |
| clinical_data | Boolean | TRUE, FALSE | ✅ Complete |
| environment | Boolean | TRUE, FALSE | ✅ Complete |
| wearable_activity_monitor | Boolean | TRUE, FALSE | ✅ Complete |
| wearable_blood_glucose | Boolean | TRUE, FALSE | ✅ Complete |

---

## 🎯 OUTCOME VARIABLES (For Student Projects)

Your group will analyze ONE of these outcomes:

### 🫘 Group 1: Albuminuria (Kidney Damage)
- **Outcome:** `alb_binary` (0 = no kidney damage, 1 = kidney damage present)


### 🧠 Group 2: Cognitive Impairment
- **Outcome:** `moca_binary` (0 = normal cognition, 1 = impairment detected)

### 😔 Group 3: Depression
- **Outcome:** `cesd_binary` (0 = no depression, 1 = significant depression)

### 💊 Group 4: Dyslipidemia (Abnormal Lipids)
- **Outcome:** `dyslipidemia_binary` (0 = normal, 1 = abnormal)

---

## 🔍 KEY DESCRIPTIVE QUESTIONS

### 1️⃣ What is the overall prevalence of your outcome?
"In the entire sample, what percentage have this condition?"

### 2️⃣ How does it differ by study group?
"Is there a pattern correlated with diabetes severity? Does it get worse from healthy → insulin dependent?"

### 3️⃣ How does it differ by age?
"Are older participants more affected? Or younger? Is there a cutoff age?"

### 4️⃣ How does it differ by sex?
"Do men and women show different patterns? Any major differences?"

---

## 💡 WHY EACH VARIABLE MATTERS

### 🎯 Metabolic Markers (HbA1c, BMI, Waist)
- Track overall metabolic health 📊
- Indicate diabetes control 📈
- Predict complications ⚠️

### 🫘 Kidney Function (Albuminuria)
- Early sign of kidney disease 🔴
- One of the major diabetes complications ⚠️
- Can progress to kidney failure if untreated 🆘

### 🧠 Cognitive Function (MOCA)
- Diabetes accelerates cognitive decline 📉
- Related to vascular damage in brain 🧠
- Important for quality of life 🎯

### 😊 Mental Health (CESD)
- Depression is 2-3x more common in diabetes 🔴
- Can worsen metabolic control 📉
- Important for holistic care 💚

### 💊 Lipids (Dyslipidemia)
- Major cardiovascular risk factor ❤️
- Common in insulin resistance 📊
- Treatable with lifestyle and medication 💪

---

## 🎓 GOOD LUCK WITH YOUR ANALYSIS & HAVE FUN! 💪

---

*Last Updated: September 2026*
*Dataset: v1.0*
*Participants: 1,068*
