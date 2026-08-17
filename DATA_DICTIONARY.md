# Data Dictionary

The source workbook contains five sheets.

## `key`
Mapping sheet for regional precious-metal/treasury blocks and equity-index assignments.

Regional assignments:
1. United States
2. European Union
3. United Kingdom
4. Japan

Equity assignments shown in the workbook key:
1. SPX / S&P 500
2. NDX / NASDAQ
3. STOXX 50
4. STOXX 600
5. workbook label: `UK- MDAX` — **verify against code, which treats Price.5 as FTSE 250 / FTSE**
6. Nikkei 225
7. Nikkei 400

## `GOLD-AU`
Gold price blocks by region/currency.

The supplied R code uses:
- `Date.1`, `Price.1` — USA
- `Date.2`, `Price.2` — Europe
- `Date.3`, `Price.3` — Great Britain
- `Date.4`, `Price.4` — Japan

## `SILVER-AG`
Silver price blocks by region/currency using the same regional numbering convention.

## `Treasuries`
Regional 10-year and 30-year sovereign-yield series.

The supplied R code uses:
- U.S.: `10 Yr.1`, `30 Yr.1`
- Europe: `10Y.2`, `30Y.2`
- Great Britain: `10Y.3`, `30Y.3`
- Japan: `10Y.4`, `30Y.4`

## `Indexes`
Equity-index price blocks.

The supplied R code uses:
- `Price.1` — S&P 500
- `Price.2` — NASDAQ
- `Price.4` — STOXX 600
- `Price.5` — labeled as FTSE/FTSE 250 in code; verify against workbook key
- `Price.6` — Nikkei 225
- `Price.7` — Nikkei 400

For Japan, the code combines Nikkei 225 and Nikkei 400 using `coalesce()` to construct `JP_Index`.

## Provenance fields still needed before public redistribution
For every series, document:
- original publisher/provider;
- series/ticker;
- source URL;
- download date;
- units/currency;
- frequency;
- transformations;
- redistribution license.
