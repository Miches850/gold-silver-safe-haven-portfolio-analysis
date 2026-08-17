# Methodology Summary

This document summarizes the methods described in the submitted report and represented in the supplied R code.

## Returns and risk
The analysis works with weekly market observations and calculates return-based risk measures, including:
- returns/log returns;
- annualized volatility;
- Sharpe ratios;
- drawdowns;
- maximum drawdowns;
- rolling volatility relationships;
- rolling beta/correlation measures.

## Portfolio optimization
The R code uses `PortfolioAnalytics` and `ROI` to estimate portfolio allocations.

The supplied code explicitly applies:
- full-investment constraints;
- long-only constraints;
- variance-risk objectives;
- mean-return objectives in selected portfolio specifications.

## Dynamic portfolios
The code performs 52-week rolling minimum-variance optimization and then applies an 8-week moving-average smoothing procedure to the resulting weights.

## Regional analysis
Separate panels are constructed for Europe, the United Kingdom, and Japan using regional:
- gold prices;
- silver prices;
- equity indices;
- 10-year yields;
- 30-year yields.

## Crisis windows used in the supplied code
- Dot-com: 2000-01-01 to 2002-12-31
- GFC: 2007-07-01 to 2009-03-31
- European debt: 2010-01-01 to 2012-12-31
- COVID: 2020-01-01 to 2021-06-30

See `REPRODUCIBILITY_NOTES.md` for differences between the written report and the supplied script.
