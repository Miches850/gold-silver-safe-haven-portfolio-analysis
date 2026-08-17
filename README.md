# What Exactly Does Gold Protect You From?
## A Gold vs. Silver Test Across Equities and Bonds

**Michael Shannon & Will Holt — ECON 675 Capstone, 2025**

**Primary tools:** R, RStudio, Excel  
**Methods:** weekly return analysis, drawdowns, rolling volatility, rolling beta/correlation, mean-variance portfolio optimization, minimum-variance portfolios, tangency portfolios, rolling portfolio weights, crisis/control analysis, and regional efficient-frontier analysis.

---

## Project overview

This empirical financial-economics capstone asks a focused question:

> **What does gold actually protect investors from, and does silver provide comparable protection?**

The project evaluates gold and silver alongside equities and long-term government bonds across the United States, Europe, Japan, and the United Kingdom. Rather than relying only on unconditional correlations, the analysis examines drawdowns, volatility, Sharpe ratios, crisis-specific performance, portfolio weights, rolling allocations, and regional portfolio frontiers.

The report studies four major stress periods:

- Dot-com bust: 2000-2002
- Global Financial Crisis: 2007-2009
- European sovereign-debt crisis: 2010-2012
- COVID-19 crisis: 2020-2021

---

## Main findings reported in the capstone

The paper's central conclusion is that **gold behaves as a state-dependent safe haven, while silver generally does not**.

The report finds that:

- gold becomes more valuable in portfolio construction during severe equity-driven crises;
- silver is substantially more volatile and behaves more like a cyclical/high-beta asset;
- crisis-period minimum-variance allocations rotate strongly toward gold;
- dynamic rolling allocations outperform several static benchmarks in the reported analysis;
- the pattern is not limited to the United States, with gold receiving meaningful minimum-variance allocations in Europe, Japan, and the United Kingdom.

These are findings from the submitted capstone report. See `report/Gold_Silver_Capstone_Final_Report.pdf` for the complete analysis, definitions, figures, tables, literature review, limitations, and citations.

---

## Selected results

### U.S. optimal portfolio weights

The submitted report gives full-sample U.S. minimum-variance and tangency weights of approximately:

| Asset | Minimum Variance | Tangency |
|---|---:|---:|
| Gold | 25.49% | 25.49% |
| NASDAQ | 74.51% | 74.51% |
| Silver | 0.00% | 0.00% |
| S&P 500 | 0.00% | 0.00% |
| 10Y | 0.00% | 0.00% |
| 30Y | 0.00% | 0.00% |

### Crisis vs. control weights

The report gives the U.S. minimum-variance allocation as approximately:

| Asset | Crisis | Control |
|---|---:|---:|
| Gold | 73.82% | 0.00% |
| NASDAQ | 26.18% | 100.00% |
| Other assets | 0.00% | 0.00% |

### Regional minimum-variance gold weights

| Region | Gold weight |
|---|---:|
| Europe | 50.34% |
| United Kingdom | 47.88% |
| Japan | 58.51% |

---

## Selected figures

### S&P 500 drawdowns with gold and silver

![S&P 500 drawdowns with gold and silver](figures/figure_02.png)

### Rolling U.S. minimum-variance portfolio weights

![Rolling U.S. portfolio weights](figures/figure_11.png)

### U.S. efficient frontier

![U.S. efficient frontier](figures/figure_24.png)

### Regional dynamic vs. static portfolio comparison

![Regional dynamic vs static comparison](figures/figure_27.png)

---

## Repository structure

```text
gold-silver-safe-haven-portfolio-analysis/
├── README.md
├── .gitignore
├── LICENSE_CODE.txt
├── code/
│   ├── analysis_original.R
│   ├── analysis_portable.R
│   └── README.md
├── data/
│   ├── Master_of_Data_Indeed_v3.xlsx
│   └── README.md
├── figures/
│   ├── figure_01.png
│   ├── ...
│   ├── figure_30.png
│   └── README.md
├── report/
│   ├── Gold_Silver_Capstone_Final_Report.pdf
│   └── README.md
├── docs/
│   ├── PROJECT_SUMMARY.md
│   ├── METHODOLOGY_SUMMARY.md
│   ├── REPRODUCIBILITY_NOTES.md
│   ├── DATA_DICTIONARY.md
│   └── GITHUB_UPLOAD_GUIDE.md
└── outputs/
    └── README.md
```

---

## Running the analysis

The GitHub-oriented script is:

```text
code/analysis_portable.R
```

Run it from the repository root so that the relative file paths resolve correctly.

The original submitted script is preserved unchanged as:

```text
code/analysis_original.R
```

The portable script changes **file paths only**. It does not intentionally alter the original analytical methodology.

### R packages referenced by the analysis

The script references:

- `readxl`
- `dplyr`
- `tidyr`
- `ggplot2`
- `scales`
- `lubridate`
- `PerformanceAnalytics`
- `xts`
- `purrr`
- `zoo`
- `corrr`
- `quadprog`
- `PortfolioAnalytics`
- `ROI`
- `ROI.plugin.quadprog`
- `ROI.plugin.glpk`
- `ggthemes`
- `openxlsx`

---

## Reproducibility status

**Portfolio-ready, but not yet certified as fully reproducible.**

The actual submitted code, dataset, report, and report figures are all present. However, the original materials contain several differences between the written methodology and the attached R script. These are documented transparently in:

`docs/REPRODUCIBILITY_NOTES.md`

The repository therefore preserves the submitted work while clearly distinguishing the original analysis from any later methodological cleanup.

---

## Data and redistribution note

The workbook used in the submitted analysis is included because it is part of the supplied project materials. Before making the repository public, verify the redistribution rights for the underlying market data.

The workbook itself does not contain sufficient source URLs or licensing metadata to establish public redistribution rights for every underlying series.

If redistribution is not permitted, remove the workbook from the public repository and replace it with source/download instructions.

---

## Authorship

The final written report lists **Michael Shannon and Will Holt** as authors. The report is included as the submitted academic artifact. Do not apply the code license to the coauthored report.

The R code supplied for this repository was provided by Michael Shannon as his project code.

---

## Investment disclaimer

This repository documents an academic research project. It is not investment advice, a live trading system, or a recommendation to buy or sell any asset.
