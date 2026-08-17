# Reproducibility Notes

The supplied files are sufficient for a strong professional portfolio repository, but they should **not yet be described as a fully reproducible research package** without addressing the items below.

These notes do not invalidate the academic project. They document places where the submitted paper and the supplied script are not perfectly aligned.

## 1. Absolute paths in the original R file
The original script contains Mac and Windows machine-specific paths.

**Repository treatment:**  
`analysis_original.R` is preserved unchanged.  
`analysis_portable.R` changes only those paths to repository-relative locations.

## 2. Bond-return methodology differs between report and visible code
The report states that weekly changes in long-term yields are combined with approximate duration-based price relationships to obtain long-duration bond returns.

In the supplied R script, the U.S. `10Y` and `30Y` columns are merged with other asset levels and then transformed with:

`log(. / lag(.))`

That is a log change in the yield level, not an explicit duration-based bond-price return.

**Action before claiming exact reproducibility:** determine whether a separate code segment/workbook produced the duration-based bond returns used in the final report, or revise the methodology statement to match the actual implemented calculation.

## 3. Risk-free-rate / Sharpe treatment is not fully aligned
The report describes a short-term risk-free-rate proxy and excess returns.

In the supplied script's summary-statistics section, Sharpe is calculated using:

`mean(ret_xts[,"30Y"])`

as the subtraction term.

That is not a documented short-term risk-free-rate series.

**Action:** locate the missing risk-free-rate implementation or revise the description/result calculation.

## 4. Portfolio constraints differ
The written report states that core portfolio weights may vary freely subject to summing to one and says short-sale/leverage constraints are not imposed.

The supplied R code explicitly adds:
- `full_investment`
- `long_only`

constraints.

**Action:** choose which version represents the intended final methodology and align the report/code accordingly.

## 5. One crisis-vs-control block uses a broad continuous period
In Stage 1A, the code defines:

`2000-01-01 <= Date <= 2021-06-30`

as the crisis index, making the entire continuous span a crisis period for that particular optimization block.

Later sections correctly use four separate crisis windows.

**Action:** confirm which block produced Table 3A / Figure 23 and, if necessary, rerun with the discrete crisis-window classification.

## 6. 8-week rolling language
The report refers to an "8-week rolling window with smoothing."

The supplied code performs:
1. 52-week rolling optimization;
2. an 8-week moving average of the resulting weights.

This is more precisely described as **8-week smoothing of 52-week rolling portfolio weights**.

## 7. Some report outputs are not visibly generated in the supplied script
The final paper includes cumulative-wealth, drawdown, portfolio-performance, and robustness outputs (notably Figures 16-21 and Tables 5-6).

The supplied script contains Stage 1-3 optimization and regional routines, but the specific construction code for all of those report outputs is not clearly present in the supplied file.

**Action:** if another R script or Excel workbook generated those results, add it to the repository.

## 8. U.K. equity-label discrepancy in the source workbook
The workbook `key` sheet labels its fifth equity assignment as `UK- MDAX`, while the supplied R code treats `Price.5` as `FTSE 250` / `FTSE`.

**Action:** verify the underlying series and correct either the workbook key or the code label before public release.

## 9. Data provenance and redistribution
The source workbook contains the analysis data but does not provide sufficient URL/license metadata to establish public redistribution rights for every series.

**Action:** document each source before making the data workbook public.

---

# Recommended publication position

For a job-search portfolio, the repository can be published once the data-rights issue and the U.K. index label are resolved, provided the README retains an honest reproducibility note.

For an academic replication repository, the methodological mismatches above should be resolved first.
