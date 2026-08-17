# Replacement imports for GitHub CSV data files
# Run from the repository root.

gold_df <- read.csv("data/gold_prices.csv", check.names = FALSE)
silver_df <- read.csv("data/silver_prices.csv", check.names = FALSE)
treasury_df <- read.csv("data/treasury_yields.csv", check.names = FALSE)
index_df <- read.csv("data/equity_indexes.csv", check.names = FALSE)

# Existing downstream cleaning code can then continue.
