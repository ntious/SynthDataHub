# M3 and M4 Labs – R Scripts for Exploratory Data Analysis & Inferential Statistics, Regression, Classification & Clustering  
School of Information Technology • Course: Data Tech Essentials​

Welcome! This repository contains **four fully-annotated R scripts** that walk you through
core supervised and unsupervised learning techniques using `mtcars`, `iris`, and the UCI
Wi-Fi RSSI dataset.

| Lab | Script | Main Topics | Estimated Runtime |
|-----|--------|-------------|-------------------|
| **4.1** | `M4Lab1_Regression.R` | Simple & Multiple Linear Regression | ~40 min |
| **4.2** | `M4Lab2_Classification.R` | *k*-NN, Naïve Bayes, Logistic Regression | ~40 min |
| **4.3** | `M4Lab3_Clustering.R` | Determining *k*, K-Means, PCA visualisation | ~40 min |
| **3.3** | `M3Lab_EDA_Inferential Statistics.R` | Exploratory Data Analysis & Inferential Statistics  | ~55 min |
---

## 1  Prerequisites

| Item | Version / Note |
|------|----------------|
| **R** | 4.2 or newer (earlier versions usually fine) |
| **RStudio** | 2022.12+ recommended for “Run Section (Ctrl + Alt + T)” hot-key |
| **Internet** | Needed for first-time package installs and to fetch the Wi-Fi dataset |
| **R Packages** | `tidyverse`, `caTools`, `class`, `e1071`, `factoextra`, `cluster`<br>→ All scripts auto-install missing packages on first run |

> **Tip:** If your machine blocks external downloads, pre-install the packages
> from an R console with  
> `install.packages(c("tidyverse","caTools","class","e1071","factoextra","cluster"))`

---

## 2  Repository Structure

SYNTHDATAHUB/
├── Agriculture/
├── Cybersecurity Threat Intelligence/
├── Edge Computing and IoT Security/
├── …                                            # other domain folders
├── Scripts/
│   ├── Python/
│   └── R / Data Tech Essentials/labs/
│                               ├── M3Lab_EDA_Inferential.R
│                               ├── M4Lab1_Regression.R
│                               ├── M4Lab2_Classification.R
│                               ├── M4Lab3_Clustering.R
│                               └── README.rst
├── .gitignore
├── LICENSE
└── README.rst


# License & Attribution
Scripts © 2025 I.K. Nti A., licensed for educational use within Data Tech Essentials.
Datasets:

mtcars & iris – R Base (Public Domain)
Wi-Fi RSSI – UCI Machine Learning Repository (Creative Commons CC BY 4.0)
Happy coding — and remember to commit early & often! 🚀