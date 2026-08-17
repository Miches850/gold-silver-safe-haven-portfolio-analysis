# ============================================================================ #
# PORTABLE PORTFOLIO VERSION
# Original analysis by Michael Shannon
#
# This file preserves the analytical logic of analysis_original.R.
# Changes made for GitHub portability:
#   1. Replaced machine-specific absolute input/output paths with relative paths.
#   2. Added creation of the outputs directory.
#
# IMPORTANT:
# No methodological choices, formulas, constraints, crisis definitions, or
# portfolio logic were intentionally changed in this portable version.
# See docs/REPRODUCIBILITY_NOTES.md before interpreting or extending results.
# ============================================================================ #

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

file_path <- "data/Master_of_Data_Indeed_v3.xlsx"

# ---------------------------- #
#          GOLD PRICES         #
# ---------------------------- #
gold_df <- read_excel(file_path, sheet = "GOLD-AU")

gold_long <- bind_rows(
  gold_df |> select(Date = `Date.1`, Price = `Price.1`) |> mutate(Region = "USA"),
  gold_df |> select(Date = `Date.2`, Price = `Price.2`) |> mutate(Region = "EURO"),
  gold_df |> select(Date = `Date.3`, Price = `Price.3`) |> mutate(Region = "GB"),
  gold_df |> select(Date = `Date.4`, Price = `Price.4`) |> mutate(Region = "JP")
) |>
  mutate(
    Price = as.numeric(gsub(",", "", Price)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date) & !is.na(Price))

ggplot(gold_long, aes(x = Date, y = Price, color = Region)) +
  geom_line() +
  labs(title = "Gold Prices by Region (1995–2025)", y = "Price (local currency)", x = NULL) +
  theme_minimal()

# ---------------------------- #
#         SILVER PRICES        #
# ---------------------------- #
silver_df <- read_excel(file_path, sheet = "SILVER-AG")

silver_long <- bind_rows(
  silver_df |> select(Date = `Date.1`, Price = `Price.1`) |> mutate(Region = "USA"),
  silver_df |> select(Date = `Date.2`, Price = `Price.2`) |> mutate(Region = "EURO"),
  silver_df |> select(Date = `Date.3`, Price = `Price.3`) |> mutate(Region = "GB"),
  silver_df |> select(Date = `Date.4`, Price = `Price.4`) |> mutate(Region = "JP")
) |>
  mutate(
    Price = as.numeric(gsub(",", "", Price)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date) & !is.na(Price))

ggplot(silver_long, aes(x = Date, y = Price, color = Region)) +
  geom_line() +
  labs(title = "Silver Prices by Region (1995–2025)", y = "Price (local currency)", x = NULL) +
  theme_minimal()

# ---------------------------- #
#       TREASURY YIELDS        #
# ---------------------------- #
treasury_df <- read_excel(file_path, sheet = "Treasuries")

treasury_long <- bind_rows(
  treasury_df |> select(Date = `Date.1`, `10Y` = `10 Yr.1`, `30Y` = `30 Yr.1`) |> mutate(Region = "USA"),
  treasury_df |> select(Date = `Date.2`, `10Y` = `10Y.2`, `30Y` = `30Y.2`) |> mutate(Region = "EURO"),
  treasury_df |> select(Date = `Date.3`, `10Y` = `10Y.3`, `30Y` = `30Y.3`) |> mutate(Region = "GB"),
  treasury_df |> select(Date = `Date.4`, `10Y` = `10Y.4`, `30Y` = `30Y.4`) |> mutate(Region = "JP")
) |>
  mutate(
    `10Y` = as.numeric(gsub(",", "", `10Y`)),
    `30Y` = as.numeric(gsub(",", "", `30Y`)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date)) |>
  pivot_longer(cols = c(`10Y`, `30Y`), names_to = "Maturity", values_to = "Yield") |>
  filter(!is.na(Yield))

ggplot(treasury_long, aes(x = Date, y = Yield, color = Region, linetype = Maturity)) +
  geom_line() +
  labs(title = "10Y and 30Y Government Yields (1995–2025)", y = "%", x = NULL) +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  theme_minimal()

# ---------------------------- #
#          INDEXES             #
# ---------------------------- #
index_df <- read_excel(file_path, sheet = "Indexes")

index_long <- bind_rows(
  index_df |> select(Date = `Date.1`, Price = `Price.1`) |> mutate(Index = "S&P 500"),
  index_df |> select(Date = `Date.2`, Price = `Price.2`) |> mutate(Index = "NASDAQ 100"),
  index_df |> select(Date = `Date.4`, Price = `Price.4`) |> mutate(Index = "EURO STOXX 600"),
  index_df |> select(Date = `Date.5`, Price = `Price.5`) |> mutate(Index = "FTSE 250"),
  index_df |> select(Date = `Date.6`, Price = `Price.6`) |> mutate(Index = "Nikkei 225"),
  index_df |> select(Date = `Date.7`, Price = `Price.7`) |> mutate(Index = "Nikkei 400")
) |>
  mutate(
    Price = as.numeric(gsub(",", "", Price)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date) & !is.na(Price))

ggplot(index_long, aes(x = Date, y = Price, color = Index)) +
  geom_line() +
  labs(title = "Equity Index Trends (1995–2025)", y = "Index Level", x = NULL) +
  theme_minimal()

# ---------------------------- #
#  NORMALIZED GOLD PRICES      #
# ---------------------------- #
gold_norm <- bind_rows(
  gold_df |> select(Date = `Date.1`, Price = `Price.1`) |> mutate(Region = "USA"),
  gold_df |> select(Date = `Date.2`, Price = `Price.2`) |> mutate(Region = "EURO"),
  gold_df |> select(Date = `Date.3`, Price = `Price.3`) |> mutate(Region = "GB"),
  gold_df |> select(Date = `Date.4`, Price = `Price.4`) |> mutate(Region = "JP")
) |>
  mutate(
    Price = as.numeric(gsub(",", "", Price)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date) & !is.na(Price)) |>
  group_by(Region) |>
  arrange(Date) |>
  mutate(Price_Index = (Price / first(Price)) * 100) |>
  ungroup()

ggplot(gold_norm, aes(x = Date, y = Price_Index, color = Region)) +
  geom_line() +
  labs(title = "Normalized Gold Price Index by Region (1995 = 100)", 
       y = "Index (1995 = 100)", x = NULL) +
  theme_minimal()

# ---------------------------- #
#  NORMALIZED SILVER PRICES    #
# ---------------------------- #
silver_norm <- bind_rows(
  silver_df |> select(Date = `Date.1`, Price = `Price.1`) |> mutate(Region = "USA"),
  silver_df |> select(Date = `Date.2`, Price = `Price.2`) |> mutate(Region = "EURO"),
  silver_df |> select(Date = `Date.3`, Price = `Price.3`) |> mutate(Region = "GB"),
  silver_df |> select(Date = `Date.4`, Price = `Price.4`) |> mutate(Region = "JP")
) |>
  mutate(
    Price = as.numeric(gsub(",", "", Price)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date) & !is.na(Price)) |>
  group_by(Region) |>
  arrange(Date) |>
  mutate(Price_Index = (Price / first(Price)) * 100) |>
  ungroup()

ggplot(silver_norm, aes(x = Date, y = Price_Index, color = Region)) +
  geom_line() +
  labs(title = "Normalized Silver Price Index by Region (1995 = 100)", 
       y = "Index (1995 = 100)", x = NULL) +
  theme_minimal()

# ---------------------------- #
#  NORMALIZED EQUITY INDEXES   #
# ---------------------------- #
index_norm <- bind_rows(
  index_df |> select(Date = `Date.1`, Price = `Price.1`) |> mutate(Index = "S&P 500"),
  index_df |> select(Date = `Date.2`, Price = `Price.2`) |> mutate(Index = "NASDAQ 100"),
  index_df |> select(Date = `Date.4`, Price = `Price.4`) |> mutate(Index = "EURO STOXX 600"),
  index_df |> select(Date = `Date.5`, Price = `Price.5`) |> mutate(Index = "FTSE 250"),
  index_df |> select(Date = `Date.6`, Price = `Price.6`) |> mutate(Index = "Nikkei 225"),
  index_df |> select(Date = `Date.7`, Price = `Price.7`) |> mutate(Index = "Nikkei 400")
) |>
  mutate(
    Price = as.numeric(gsub(",", "", Price)),
    Date = as.Date(Date)
  ) |>
  filter(!is.na(Date) & !is.na(Price)) |>
  group_by(Index) |>
  arrange(Date) |>
  mutate(Price_Index = (Price / first(Price)) * 100) |>
  ungroup()

ggplot(index_norm, aes(x = Date, y = Price_Index, color = Index)) +
  geom_line() +
  labs(title = "Normalized Equity Index Levels (1995 = 100)", 
       y = "Index (1995 = 100)", x = NULL) +
  theme_minimal()

# ---------------------------- #
# Prep Crisis Periods Using for All Plots with Crisis Shading #
# ---------------------------- #
# Define crisis periods for shading
crisis_periods <- data.frame(
  Crisis = c("Dot-Com", "GFC", "EU Debt Crisis", "COVID"),
  Start = as.Date(c("2000-01-01", "2007-07-01", "2010-01-01", "2020-01-01")),
  End   = as.Date(c("2002-12-31", "2009-03-31", "2012-12-31", "2021-06-30"))
)

add_crisis_shading <- function(p) {
  for (i in 1:nrow(crisis_periods)) {
    p <- p + annotate("rect",
                      xmin = crisis_periods$Start[i],
                      xmax = crisis_periods$End[i],
                      ymin = -Inf, ymax = Inf,
                      alpha = 0.1, fill = "red")
  }
  return(p)
}
# ---------------------------- #
# Figure 2: S&P 500 Total Annual Returns #
# ---------------------------- #
library(lubridate)

spx_df <- index_df |>
  select(Date = `Date.1`, SPX = `Price.1`) |>
  mutate(Date = as.Date(Date),
         Year = year(Date)) |>
  filter(!is.na(Date) & !is.na(SPX)) |>
  group_by(Year) |>
  summarize(AnnualReturn = (last(SPX) / first(SPX)) - 1)

ggplot(spx_df, aes(x = Year, y = AnnualReturn)) +
  geom_col(fill = "steelblue") +
  geom_hline(yintercept = 0, color = "black") +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "S&P 500 Annual Returns", y = "Return", x = NULL) +
  theme_minimal()

# ---------------------------- #
# Figure 3: SPX Drawdowns vs. Gold/Silver #
# ---------------------------- #
library(PerformanceAnalytics)
library(xts)
library(purrr)  # ✅ This is what was missing

# Prepare SPX, Gold, Silver series
drawdown_df <- index_norm |>
  filter(Index == "S&P 500") |>
  select(Date, SPX = Price_Index)

gold_rebased <- gold_norm |>
  filter(Region == "USA") |>
  select(Date, Gold = Price_Index)

silver_rebased <- silver_norm |>
  filter(Region == "USA") |>
  select(Date, Silver = Price_Index)

# Merge them
merged_df <- reduce(list(drawdown_df, gold_rebased, silver_rebased), full_join, by = "Date") |>
  arrange(Date)

# Create drawdown xts object
drawdowns_xts <- xts(merged_df$SPX, order.by = merged_df$Date)
drawdown_series <- data.frame(
  Date = index(drawdowns_xts),
  Drawdown = Drawdowns(drawdowns_xts)[, 1]
)

# Plot drawdowns + gold/silver overlay
ggplot(drawdown_series, aes(x = Date, y = Drawdown)) +
  geom_line(color = "red") +
  geom_line(data = gold_rebased, aes(y = Gold - 100, color = "Gold"), size = 0.8) +
  geom_line(data = silver_rebased, aes(y = Silver - 100, color = "Silver"), size = 0.8) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(title = "SPX Drawdowns with Gold and Silver (Indexed)", 
       y = "Drawdown / Relative Return", x = NULL) +
  scale_color_manual(values = c("Gold" = "goldenrod", "Silver" = "gray")) +
  theme_minimal()

# ---------------------------- #
# Figure 4 (Revised): Realized Volatility Ratios (Gold/Silver vs. S&P 500)
# ---------------------------- #

library(readxl)
library(dplyr)
library(ggplot2)
library(zoo)
library(tidyr)

# Load index data (S&P 500)
index_df <- read_excel(file_path, sheet = "Indexes")
spx <- index_df |>
  select(Date = `Date.1`, Price = `Price.1`) |>
  filter(!is.na(Price)) |>
  arrange(Date) |>
  mutate(Return_SPX = (Price / lag(Price)) - 1)

# Load gold data (AUX/USD)
gold_df <- read_excel(file_path, sheet = "GOLD-AU")
gold <- gold_df |>
  select(Date = `Date.1`, Price = `Price.1`) |>
  filter(!is.na(Price)) |>
  arrange(Date) |>
  mutate(Return_GOLD = (Price / lag(Price)) - 1)

# Load silver data (AGX/USD)
silver_df <- read_excel(file_path, sheet = "SILVER-AG")
silver <- silver_df |>
  select(Date = `Date.1`, Price = `Price.1`) |>
  filter(!is.na(Price)) |>
  arrange(Date) |>
  mutate(Return_SILVER = (Price / lag(Price)) - 1)

# Merge step-by-step
vol_data <- full_join(spx, gold, by = "Date") |>
  full_join(silver, by = "Date") |>
  arrange(Date)

# Calculate 8-week rolling volatility
vol_data <- vol_data |>
  mutate(
    Vol_SPX = rollapply(Return_SPX, width = 8, FUN = sd, fill = NA, align = "right"),
    Vol_GOLD = rollapply(Return_GOLD, width = 8, FUN = sd, fill = NA, align = "right"),
    Vol_SILVER = rollapply(Return_SILVER, width = 8, FUN = sd, fill = NA, align = "right"),
    Gold_SPX_Ratio = Vol_GOLD / Vol_SPX,
    Silver_SPX_Ratio = Vol_SILVER / Vol_SPX
  )

# Reshape for plotting
vol_long <- vol_data |>
  select(Date, Gold_SPX_Ratio, Silver_SPX_Ratio) |>
  pivot_longer(cols = -Date, names_to = "Asset", values_to = "Volatility_Ratio") |>
  mutate(Asset = case_when(
    Asset == "Gold_SPX_Ratio" ~ "Gold / S&P 500",
    Asset == "Silver_SPX_Ratio" ~ "Silver / S&P 500"
  ))

# Plot
ggplot(vol_long, aes(x = Date, y = Volatility_Ratio, color = Asset)) +
  geom_line() +
  labs(
    title = "Rolling 8-Week Realized Volatility Ratio: Gold & Silver vs. S&P 500",
    y = "Volatility Ratio", x = NULL
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.01))


# ---------------------------- #
# Figure 6: Gold/Silver in EUR and JPY #
# ---------------------------- #
gold_fx <- gold_norm |> filter(Region %in% c("EURO", "JP"))
silver_fx <- silver_norm |> filter(Region %in% c("EURO", "JP"))

gold_fx$Metal <- "Gold"
silver_fx$Metal <- "Silver"

fx_df <- bind_rows(gold_fx, silver_fx)

ggplot(fx_df, aes(x = Date, y = Price_Index, color = Region)) +
  geom_line() +
  facet_wrap(~ Metal, ncol = 1) +
  labs(title = "Gold and Silver in EUR and JPY (Normalized)", y = "Index (1995 = 100)", x = NULL) +
  theme_minimal()

# ---------------------------- ## ---------------------------- #
# Figure 7: Rolling Beta of Metals vs. SPX
# ---------------------------- #

library(zoo)
library(tidyr)  # for drop_na()

# Step 1: Merge normalized prices for Gold, Silver, and SPX
returns_df <- reduce(list(
  gold_norm |> filter(Region == "USA") |> select(Date, Gold = Price_Index),
  silver_norm |> filter(Region == "USA") |> select(Date, Silver = Price_Index),
  index_norm |> filter(Index == "S&P 500") |> select(Date, SPX = Price_Index)
), full_join, by = "Date") |>
  arrange(Date) |>
  mutate(across(-Date, ~log(. / lag(.)))) |>  # log returns
  drop_na()  # fix the previous error

# Step 2: Define a rolling beta function
rolling_beta <- function(x, y, width = 52) {
  rollapply(
    data = data.frame(x, y),
    width = width,
    FUN = function(df) {
      model <- lm(x ~ y, data = as.data.frame(df))
      coef(model)[2]  # return beta coefficient
    },
    by.column = FALSE,
    align = "right",
    fill = NA
  )
}

# Step 3: Apply rolling beta (52-week window)
returns_df <- returns_df |>
  mutate(
    Beta_Gold = rolling_beta(Gold, SPX),
    Beta_Silver = rolling_beta(Silver, SPX)
  )

# Step 4: Plot
ggplot(returns_df, aes(x = Date)) +
  geom_line(aes(y = Beta_Gold, color = "Gold")) +
  geom_line(aes(y = Beta_Silver, color = "Silver")) +
  labs(
    title = "52-Week Rolling Beta of Gold and Silver vs. S&P 500",
    y = "Rolling Beta",
    color = "Asset"
  ) +
  theme_minimal()


# ---------------------------- #
# Figure 9: Correlation Matrix (Crisis vs. Non-Crisis) #
# ---------------------------- #
library(corrr)

# Use weekly returns for SPX, Gold, Silver, DXY, 10Y
# Assume you’ve created a `returns_wide` dataframe with these

returns_wide <- merged_df |> 
  mutate(across(-Date, ~log(. / lag(.)))) |> 
  filter(Date >= as.Date("2000-01-01")) |> 
  drop_na()

returns_wide <- returns_wide |>
  mutate(Period = case_when(
    Date >= as.Date("2000-01-01") & Date <= as.Date("2002-12-31") ~ "Crisis",
    Date >= as.Date("2007-07-01") & Date <= as.Date("2009-03-31") ~ "Crisis",
    Date >= as.Date("2010-01-01") & Date <= as.Date("2012-12-31") ~ "Crisis",
    Date >= as.Date("2020-01-01") & Date <= as.Date("2021-06-30") ~ "Crisis",
    TRUE ~ "Control"
  ))

# Crisis correlation
crisis_corr <- returns_wide |> filter(Period == "Crisis") |> select(-Date, -Period) |> correlate()

# Control correlation
control_corr <- returns_wide |> filter(Period == "Control") |> select(-Date, -Period) |> correlate()

# Print or visualize
crisis_corr
control_corr


library(corrr)

# Plot: Crisis
rplot(crisis_corr) +
  ggtitle("Figure 9a: Correlation Matrix (Crisis Periods)") +
  theme_minimal()

# Plot: Control
rplot(control_corr) +
  ggtitle("Figure 9b: Correlation Matrix (Control Periods)") +
  theme_minimal()









# ===================================================== #
#       PORTFOLIO OPTIMIZATION – 1A                     #
# ===================================================== #
# Purpose: Determine optimal portfolio compositions of 
# USGold, USSilver, S&P500, NASDAQ, 10Y, and 30Y bonds.
# ===================================================== #


library(PerformanceAnalytics)
library(quadprog)
library(PortfolioAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(ROI.plugin.glpk)
library(xts)
library(ggthemes)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)

# ---- 1. Prepare weekly price data ----
# ---- 1. Prepare weekly price data (fixed join) ----

# Select and clean each dataset
gold_us  <- gold_df  |> 
  select(Date = `Date.1`, Gold = `Price.1`) |> 
  mutate(Date = as.Date(Date),
         Gold = as.numeric(gsub(",", "", Gold))) |> 
  distinct(Date, .keep_all = TRUE)

silver_us <- silver_df |> 
  select(Date = `Date.1`, Silver = `Price.1`) |> 
  mutate(Date = as.Date(Date),
         Silver = as.numeric(gsub(",", "", Silver))) |> 
  distinct(Date, .keep_all = TRUE)

index_us <- index_df |> 
  select(Date = `Date.1`, SPX = `Price.1`, NASDAQ = `Price.2`) |> 
  mutate(Date = as.Date(Date),
         across(c(SPX, NASDAQ), ~as.numeric(gsub(",", "", .)))) |> 
  distinct(Date, .keep_all = TRUE)

bond_us <- treasury_df |> 
  select(Date = `Date.1`, `10Y` = `10 Yr.1`, `30Y` = `30 Yr.1`) |> 
  mutate(Date = as.Date(Date),
         across(c(`10Y`, `30Y`), ~as.numeric(gsub(",", "", .)))) |> 
  distinct(Date, .keep_all = TRUE)

# Merge using sequential joins on Date
assets_df <- gold_us |> 
  full_join(silver_us, by = "Date") |> 
  full_join(index_us, by = "Date") |> 
  full_join(bond_us, by = "Date") |> 
  arrange(Date) |> 
  filter(!is.na(Date))

# Inspect merge result
cat("✅ Assets merged successfully. Rows:", nrow(assets_df), "Columns:", ncol(assets_df), "\n")
head(assets_df)


# ---- 2. Compute weekly log returns ----
assets_ret <- assets_df |>
  mutate(across(-Date, ~log(. / lag(.)))) |>
  drop_na()

ret_xts <- xts(assets_ret[,-1], order.by = assets_ret$Date)

# ---- 3. Summary statistics ----
stats <- data.frame(
  Mean = apply(ret_xts, 2, mean) * 52,
  SD = apply(ret_xts, 2, sd) * sqrt(52)
)
stats$Sharpe <- (stats$Mean - mean(ret_xts[,"30Y"])) / stats$SD
print(round(stats, 4))

# ---- 4. Mean–Variance Model ----
assets <- colnames(ret_xts)
port_spec <- portfolio.spec(assets)
port_spec <- add.constraint(port_spec, type = "full_investment")
port_spec <- add.constraint(port_spec, type = "long_only")
port_spec <- add.objective(port_spec, type = "risk", name = "var")
port_spec <- add.objective(port_spec, type = "return", name = "mean")

# Optimize portfolios
min_var_port <- optimize.portfolio(R = ret_xts, portfolio = port_spec,
                                   optimize_method = "ROI", trace = FALSE)
tangency_port <- optimize.portfolio(R = ret_xts, portfolio = port_spec,
                                    optimize_method = "ROI",
                                    maximize = TRUE,
                                    momentFUN = set.portfolio.moments,
                                    trace = FALSE)

min_var_w <- extractWeights(min_var_port)
tangency_w <- extractWeights(tangency_port)

# ---- 5. Efficient Frontier (Scaled x100 for % Display) ----
frontier <- create.EfficientFrontier(
  R = ret_xts,
  portfolio = port_spec,
  type = "mean-StdDev",
  n.portfolios = 50
)

# Convert results into a tidy dataframe (scale returns ×100 for %)
frontier_points <- data.frame(
  Risk = unlist(frontier$sd) * sqrt(52),        # Annualized σ
  Return = unlist(frontier$mean) * 52 * 100     # Annualized mean return (%)
)

# ---- 6. Plot Efficient Frontier (Percentage Scale) ----
ggplot(frontier_points, aes(x = Risk, y = Return)) +
  geom_path(color = "#1B9E77", linewidth = 1.2) +  # Frontier curve
  geom_point(aes(
    x = sd(ret_xts %*% min_var_w) * sqrt(52),
    y = mean(ret_xts %*% min_var_w) * 52 * 100
  ),
  color = "#E7298A", size = 4, shape = 17) +       # Min variance marker
  geom_point(aes(
    x = sd(ret_xts %*% tangency_w) * sqrt(52),
    y = mean(ret_xts %*% tangency_w) * 52 * 100
  ),
  color = "#7570B3", size = 4, shape = 15) +       # Tangency marker
  labs(
    title = "Efficient Frontier: Weekly Returns (1995–2025, Annualized %)",
    x = "Portfolio Risk (σ, annualized)",
    y = "Portfolio Return (%)",
    caption = "Pink = Min Variance | Purple = Tangency Portfolio | Returns scaled ×100 for clarity"
  ) +
  coord_cartesian(xlim = c(0.07, 0.14), ylim = c(0, 8)) +  # wider visible range
  geom_text(
    aes(x = 0.085, y = 7.5, label = "Efficient Frontier Region"),
    color = "gray30", size = 3
  ) +
  theme_economist_white() +
  theme(plot.title = element_text(size = 13, face = "bold"))

# ---- 7. Optimal Portfolio Weights ----
weights_df <- data.frame(
  Asset = names(min_var_w),
  MinVar = as.numeric(min_var_w),
  Tangency = as.numeric(tangency_w)
) |> pivot_longer(cols = -Asset, names_to = "Portfolio", values_to = "Weight")

ggplot(weights_df, aes(x = Asset, y = Weight, fill = Portfolio)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("MinVar" = "#E7298A", "Tangency" = "#7570B3")) +
  labs(title = "Optimal Portfolio Weights (Weekly Data)",
       y = "Portfolio Weight", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

# ---- 8. Crisis vs Control Optimization ----
crisis_idx <- which(assets_ret$Date >= as.Date("2000-01-01") &
                      assets_ret$Date <= as.Date("2021-06-30"))
control_idx <- which(!(assets_ret$Date %in% assets_ret$Date[crisis_idx]))

ret_crisis_xts <- ret_xts[crisis_idx, ]
ret_control_xts <- ret_xts[control_idx, ]

min_var_crisis <- optimize.portfolio(R = ret_crisis_xts, portfolio = port_spec,
                                     optimize_method = "ROI", trace = FALSE)
min_var_control <- optimize.portfolio(R = ret_control_xts, portfolio = port_spec,
                                      optimize_method = "ROI", trace = FALSE)

weights_comp <- data.frame(
  Asset = names(extractWeights(min_var_crisis)),
  Crisis = extractWeights(min_var_crisis),
  Control = extractWeights(min_var_control)
) |> pivot_longer(cols = -Asset, names_to = "Period", values_to = "Weight")

ggplot(weights_comp, aes(x = Asset, y = Weight, fill = Period)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Crisis" = "#D95F02", "Control" = "#1B9E77")) +
  labs(title = "Minimum Variance Portfolio Weights: Crisis vs Control (Weekly)",
       y = "Weight", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

# ---- 9. Export All Results to Excel (Fixed) ----
export_path <- "outputs/PortfolioOptimization_Results.xlsx"

wb <- createWorkbook()
addWorksheet(wb, "SummaryStats")
addWorksheet(wb, "OptimalWeights")
addWorksheet(wb, "CrisisVsControlWeights")
addWorksheet(wb, "EfficientFrontier")

# Round numeric columns only
writeData(wb, "SummaryStats", round(stats, 5), rowNames = TRUE)
writeData(wb, "OptimalWeights", weights_df |> mutate(across(where(is.numeric), ~round(., 5))))
writeData(wb, "CrisisVsControlWeights", weights_comp |> mutate(across(where(is.numeric), ~round(., 5))))
writeData(wb, "EfficientFrontier", frontier_points |> mutate(across(where(is.numeric), ~round(., 5))))

saveWorkbook(wb, export_path, overwrite = TRUE)
cat("✅ Excel export complete. File saved as:", export_path, "\n")

# ===================================================== #
# END OF PORTFOLIO OPTIMIZATION 1A                      #
# ===================================================== #



# ===================================================== #
#               STAGE 1B – DYNAMIC PORTFOLIOS           #
# ===================================================== #
# Purpose: Rolling, Smoothed, and Crisis-specific analysis
# ===================================================== #

library(PerformanceAnalytics)
library(PortfolioAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(zoo)

# ===================================================== #
# Workbook path and initialization
# ===================================================== #

export_path_rolling <- "outputs/Rolling_Crisis_PortfolioResults.xlsx"
wb2 <- createWorkbook()
addWorksheet(wb2, "RollingWeights")
addWorksheet(wb2, "RollingSmoothedWeights")
addWorksheet(wb2, "CrisisWeights")

# ===================================================== #
# 1B-1 52-Week Rolling Mean–Variance Optimization
# ===================================================== #

rolling_window <- 52  # 52-week rolling window

roll_optimize <- function(start_idx) {
  end_idx <- start_idx + rolling_window - 1
  if (end_idx > nrow(ret_xts)) return(NULL)
  sub_ret <- ret_xts[start_idx:end_idx, ]
  port <- optimize.portfolio(R = sub_ret,
                             portfolio = port_spec,
                             optimize_method = "ROI",
                             trace = FALSE)
  as.numeric(extractWeights(port))
}

rolling_weights <- lapply(1:(nrow(ret_xts) - rolling_window + 1), roll_optimize)
rolling_weights <- do.call(rbind, rolling_weights)
rolling_dates <- assets_ret$Date[rolling_window:nrow(assets_ret)]
rolling_df <- data.frame(Date = rolling_dates, rolling_weights)
colnames(rolling_df)[-1] <- colnames(ret_xts)

# ---- Plot Rolling Portfolio Weights ----
rolling_long <- rolling_df |>
  pivot_longer(-Date, names_to = "Asset", values_to = "Weight")

ggplot(rolling_long, aes(x = Date, y = Weight, fill = Asset)) +
  geom_area(alpha = 0.8) +
  labs(title = "Rolling 52-Week Minimum-Variance Portfolio Weights (1995–2025)",
       y = "Weight", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

# ---- Save Rolling Weights ----
writeData(wb2, "RollingWeights",
          rolling_df |> mutate(across(where(is.numeric), ~round(., 5))))

# ===================================================== #
# 1.B-1.5 Rolling 8-Week Smoothed Portfolio Weights
# ===================================================== #

# Apply 8-week moving average to each asset weight
rolling_smoothed <- rolling_df
rolling_smoothed[,-1] <- apply(rolling_df[,-1], 2,
                               function(x) rollapply(x, width = 8,
                                                     FUN = mean, fill = NA,
                                                     align = "right"))

rolling_smooth_long <- rolling_smoothed |>
  pivot_longer(-Date, names_to = "Asset", values_to = "Smoothed_Weight")

# Define crisis periods for shading
crisis_periods <- data.frame(
  Crisis = c("Dot-Com", "GFC", "EU Debt", "COVID"),
  Start  = as.Date(c("2000-01-01", "2007-07-01", "2010-01-01", "2020-01-01")),
  End    = as.Date(c("2002-12-31", "2009-03-31", "2012-12-31", "2021-06-30"))
)

# ---- Plot Smoothed Weights with Shaded Crises ----
ggplot(rolling_smooth_long, aes(x = Date, y = Smoothed_Weight, fill = Asset)) +
  geom_rect(data = crisis_periods,
            aes(xmin = Start, xmax = End, ymin = -Inf, ymax = Inf, fill = NULL),
            inherit.aes = FALSE, alpha = 0.12, color = NA) +
  geom_area(alpha = 0.9) +
  labs(title = "Rolling 8-Week Smoothed Minimum-Variance Portfolio Weights (1995–2025)",
       subtitle = "Crisis periods shaded | Smoothed from 52-week rolling optimizations",
       y = "Smoothed Weight", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top",
        plot.subtitle = element_text(size = 10, color = "gray30"))

# ---- Save Smoothed Weights ----
writeData(wb2, "RollingSmoothedWeights",
          rolling_smoothed |> mutate(across(where(is.numeric), ~round(., 5))))

# ===================================================== #
# 1B-2. Crisis-Specific Mean–Variance Optimization
# ===================================================== #

crisis_periods <- data.frame(
  Crisis = c("DotCom", "GFC", "EU_Debt", "COVID"),
  Start = as.Date(c("2000-01-01", "2007-07-01", "2010-01-01", "2020-01-01")),
  End   = as.Date(c("2002-12-31", "2009-03-31", "2012-12-31", "2021-06-30"))
)

get_weights_by_period <- function(start, end, label) {
  sub_ret <- ret_xts[paste0(start, "/", end)]
  if (nrow(sub_ret) < 10) return(NULL)
  port <- optimize.portfolio(R = sub_ret,
                             portfolio = port_spec,
                             optimize_method = "ROI",
                             trace = FALSE)
  w <- extractWeights(port)
  data.frame(Asset = names(w), Weight = as.numeric(w), Crisis = label)
}

crisis_weights_list <- lapply(1:nrow(crisis_periods), function(i) {
  with(crisis_periods[i, ],
       get_weights_by_period(Start, End, Crisis))
})
crisis_weights <- bind_rows(crisis_weights_list)

# ---- Plot Crisis-Specific Portfolio Weights ----
ggplot(crisis_weights, aes(x = Asset, y = Weight, fill = Crisis)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Crisis-Specific Minimum Variance Portfolio Weights (Weekly Data)",
       y = "Weight", x = NULL) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

# ---- Save Crisis Weights ----
writeData(wb2, "CrisisWeights",
          crisis_weights |> mutate(across(where(is.numeric), ~round(., 5))))

# ===================================================== #
# 1B-3. Final Save Workbook
# ===================================================== #

saveWorkbook(wb2, export_path_rolling, overwrite = TRUE)
cat("✅ All Rolling, Smoothed & Crisis Portfolio Results saved to:",
    export_path_rolling, "\n")
















# ===================================================== #
#                   STAGE 2 – REGIONAL PORTFOLIOS       #
# ===================================================== #
# Purpose: Extend Stage 1 logic to EURO, GB, and JAPAN
#          using mean–variance optimization per region,
#          and manually tracing a frontier between
#          min-variance and max-return portfolios.
# ===================================================== #

library(PortfolioAnalytics)
library(PerformanceAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(xts)

export_path_regions <- "outputs/Regional_PortfolioResults.xlsx"
wb_reg <- createWorkbook()

# ----------------------------------------------------- #
# Helper: build simple returns from a merged price panel
# ----------------------------------------------------- #
build_returns <- function(price_df, region_name) {
  ret_df <- price_df |>
    arrange(Date) |>
    mutate(across(-Date, ~ (. / lag(.)) - 1)) |>
    drop_na()
  
  cat(region_name, "- rows after return calc:", nrow(ret_df),
      "| assets:", paste(colnames(ret_df)[-1], collapse = ", "), "\n")
  
  if (nrow(ret_df) < 52 || ncol(ret_df) < 3) {
    warning("⚠️ ", region_name, ": insufficient data for optimization.")
    return(NULL)
  }
  
  ret_df
}

# ----------------------------------------------------- #
# Helper: region frontier (min-var to max-return)
#   – now with internal asset cleaning (drop zero / bad sd)
# ----------------------------------------------------- #
region_frontier <- function(ret_df, region_name) {
  if (is.null(ret_df)) {
    return(list(
      frontier = data.frame(Risk = NA, Return = NA, Region = region_name),
      weights  = data.frame(Asset = character(), MinVar = numeric(), MaxReturn = numeric())
    ))
  }
  
  ret_xts <- xts(ret_df[,-1], order.by = ret_df$Date)
  
  # ---- drop assets with non-finite mean/sd or zero volatility ----
  mu  <- colMeans(ret_xts, na.rm = TRUE)
  sig <- apply(ret_xts, 2, sd, na.rm = TRUE)
  keep <- is.finite(mu) & is.finite(sig) & sig > 0
  
  if (!any(keep)) {
    message("⚠️ ", region_name, ": all assets have non-finite or zero volatility.")
    return(list(
      frontier = data.frame(Risk = NA, Return = NA, Region = region_name),
      weights  = data.frame(Asset = character(), MinVar = numeric(), MaxReturn = numeric())
    ))
  }
  
  if (!all(keep)) {
    message("ℹ️ ", region_name, 
            ": dropping assets with non-finite/zero sd: ",
            paste(colnames(ret_xts)[!keep], collapse = ", "))
  }
  
  ret_xts <- ret_xts[, keep, drop = FALSE]
  assets  <- colnames(ret_xts)
  
  if (length(assets) < 2) {
    message("⚠️ ", region_name, ": fewer than 2 usable assets after cleaning.")
    return(list(
      frontier = data.frame(Risk = NA, Return = NA, Region = region_name),
      weights  = data.frame(Asset = assets,
                            MinVar = 1,
                            MaxReturn = 1)
    ))
  }
  
  # --- Min-variance spec ---
  spec_min <- portfolio.spec(assets) |>
    add.constraint(type = "full_investment") |>
    add.constraint(type = "long_only") |>
    add.objective(type = "risk", name = "var")
  
  # --- Max-return spec ---
  spec_max <- portfolio.spec(assets) |>
    add.constraint(type = "full_investment") |>
    add.constraint(type = "long_only") |>
    add.objective(type = "return", name = "mean")
  
  # --- Solve optimizations (ROI) ---
  min_port <- optimize.portfolio(
    R = ret_xts,
    portfolio = spec_min,
    optimize_method = "ROI",
    trace = FALSE
  )
  
  max_port <- optimize.portfolio(
    R = ret_xts,
    portfolio = spec_max,
    optimize_method = "ROI",
    trace = FALSE
  )
  
  w_min <- extractWeights(min_port)
  w_max <- extractWeights(max_port)
  
  # --- Manually trace "frontier" by interpolating weights ---
  lambdas <- seq(0, 1, length.out = 50)
  
  frontier_points <- lapply(lambdas, function(l) {
    w <- (1 - l) * w_min + l * w_max
    # guard against NA weights
    if (any(is.na(w))) return(c(Risk = NA_real_, Return = NA_real_))
    
    p_ret <- as.numeric(ret_xts %*% w)
    p_ret <- p_ret[is.finite(p_ret)]
    
    if (length(p_ret) < 2) return(c(Risk = NA_real_, Return = NA_real_))
    
    mu <- mean(p_ret) * 52 * 100    # annualized %, *100
    sd_ <- sd(p_ret) * sqrt(52)     # annualized sigma
    
    c(Risk = sd_, Return = mu)
  })
  
  frontier_df <- do.call(rbind, frontier_points) |> as.data.frame()
  frontier_df$Region <- region_name
  
  # --- Weights summary ---
  weights_df <- data.frame(
    Asset     = names(w_min),
    MinVar    = as.numeric(w_min),
    MaxReturn = as.numeric(w_max)
  )
  
  list(frontier = frontier_df, weights = weights_df)
}

# ===================================================== #
# 2A. EURO REGION – Gold(EUR), Silver(EUR),
#      STOXX 600, 10Y, 30Y
# ===================================================== #

euro_gold <- gold_df |>
  select(Date = `Date.2`, Gold = `Price.2`) |>
  mutate(Date = as.Date(Date),
         Gold = as.numeric(gsub(",", "", Gold))) |>
  distinct(Date, .keep_all = TRUE)

euro_silver <- silver_df |>
  select(Date = `Date.2`, Silver = `Price.2`) |>
  mutate(Date = as.Date(Date),
         Silver = as.numeric(gsub(",", "", Silver))) |>
  distinct(Date, .keep_all = TRUE)

euro_stoxx600 <- index_df |>
  select(Date = `Date.4`, STOXX600 = `Price.4`) |>
  mutate(Date = as.Date(Date),
         STOXX600 = as.numeric(gsub(",", "", STOXX600))) |>
  distinct(Date, .keep_all = TRUE)

euro_bonds <- treasury_df |>
  select(Date = `Date.2`,
         `10Y` = `10Y.2`,
         `30Y` = `30Y.2`) |>
  mutate(Date = as.Date(Date),
         `10Y` = as.numeric(gsub(",", "", `10Y`)),
         `30Y` = as.numeric(gsub(",", "", `30Y`))) |>
  distinct(Date, .keep_all = TRUE)

euro_prices <- euro_gold |>
  inner_join(euro_silver,   by = "Date") |>
  inner_join(euro_stoxx600, by = "Date") |>
  inner_join(euro_bonds,    by = "Date") |>
  arrange(Date)

cat("EURO price rows (after inner_join):", nrow(euro_prices), "\n")

euro_ret <- build_returns(euro_prices, "EURO")
euro_res <- region_frontier(euro_ret, "EURO")
euro_pts <- euro_res$frontier
euro_wts <- euro_res$weights

addWorksheet(wb_reg, "EURO_Frontier")
addWorksheet(wb_reg, "EURO_Weights")
writeData(wb_reg, "EURO_Frontier", euro_pts |> mutate(across(where(is.numeric), round, 5)))
writeData(wb_reg, "EURO_Weights",  euro_wts |> mutate(across(where(is.numeric), round, 5)))

ggplot(euro_pts, aes(Risk, Return)) +
  geom_path(color = "#1B9E77", linewidth = 1.2) +
  labs(
    title = "EURO Regional Frontier (MinVar–MaxReturn span, %)",
    x = "Risk (σ, annualized)", y = "Return (%)"
  ) +
  theme_minimal()

# ===================================================== #
# 2B. GREAT BRITAIN (GB) – Gold(GBP), Silver(GBP),
#      FTSE 250, 10Y, 30Y
# ===================================================== #

gb_gold <- gold_df |>
  select(Date = `Date.3`, Gold = `Price.3`) |>
  mutate(Date = as.Date(Date),
         Gold = as.numeric(gsub(",", "", Gold))) |>
  distinct(Date, .keep_all = TRUE)

gb_silver <- silver_df |>
  select(Date = `Date.3`, Silver = `Price.3`) |>
  mutate(Date = as.Date(Date),
         Silver = as.numeric(gsub(",", "", Silver))) |>
  distinct(Date, .keep_all = TRUE)

gb_ftse <- index_df |>
  select(Date = `Date.5`, FTSE = `Price.5`) |>
  mutate(Date = as.Date(Date),
         FTSE = as.numeric(gsub(",", "", FTSE))) |>
  distinct(Date, .keep_all = TRUE)

gb_bonds <- treasury_df |>
  select(Date = `Date.3`,
         `10Y` = `10Y.3`,
         `30Y` = `30Y.3`) |>
  mutate(Date = as.Date(Date),
         `10Y` = as.numeric(gsub(",", "", `10Y`)),
         `30Y` = as.numeric(gsub(",", "", `30Y`))) |>
  distinct(Date, .keep_all = TRUE)

gb_prices <- gb_gold |>
  inner_join(gb_silver, by = "Date") |>
  inner_join(gb_ftse,   by = "Date") |>
  inner_join(gb_bonds,  by = "Date") |>
  arrange(Date)

cat("GB price rows (after inner_join):", nrow(gb_prices), "\n")

gb_ret <- build_returns(gb_prices, "GB")
gb_res <- region_frontier(gb_ret, "GB")
gb_pts <- gb_res$frontier
gb_wts <- gb_res$weights

addWorksheet(wb_reg, "GB_Frontier")
addWorksheet(wb_reg, "GB_Weights")
writeData(wb_reg, "GB_Frontier", gb_pts |> mutate(across(where(is.numeric), round, 5)))
writeData(wb_reg, "GB_Weights",  gb_wts |> mutate(across(where(is.numeric), round, 5)))

ggplot(gb_pts, aes(Risk, Return)) +
  geom_path(color = "#7570B3", linewidth = 1.2) +
  labs(
    title = "GB Regional Frontier (MinVar–MaxReturn span, %)",
    x = "Risk (σ, annualized)", y = "Return (%)"
  ) +
  theme_minimal()

# ===================================================== #
# 2C. JAPAN (JP) – Gold(JPY), Silver(JPY),
#      Nikkei 225 / 400 stitched, 10Y, 30Y
# ===================================================== #

jp_gold <- gold_df |>
  select(Date = `Date.4`, Gold = `Price.4`) |>
  mutate(Date = as.Date(Date),
         Gold = as.numeric(gsub(",", "", Gold))) |>
  distinct(Date, .keep_all = TRUE)

jp_silver <- silver_df |>
  select(Date = `Date.4`, Silver = `Price.4`) |>
  mutate(Date = as.Date(Date),
         Silver = as.numeric(gsub(",", "", Silver))) |>
  distinct(Date, .keep_all = TRUE)

jp_n225 <- index_df |>
  select(Date = `Date.6`, N225 = `Price.6`) |>
  mutate(Date = as.Date(Date),
         N225 = as.numeric(gsub(",", "", N225))) |>
  distinct(Date, .keep_all = TRUE)

jp_n400 <- index_df |>
  select(Date = `Date.7`, N400 = `Price.7`) |>
  mutate(Date = as.Date(Date),
         N400 = as.numeric(gsub(",", "", N400))) |>
  distinct(Date, .keep_all = TRUE)

jp_index <- full_join(jp_n225, jp_n400, by = "Date") |>
  mutate(JP_Index = dplyr::coalesce(N225, N400)) |>
  select(Date, JP_Index) |>
  distinct(Date, .keep_all = TRUE) |>
  filter(!is.na(JP_Index)) |>
  arrange(Date)

jp_bonds <- treasury_df |>
  select(Date = `Date.4`,
         `10Y` = `10Y.4`,
         `30Y` = `30Y.4`) |>
  mutate(Date = as.Date(Date),
         `10Y` = as.numeric(gsub(",", "", `10Y`)),
         `30Y` = as.numeric(gsub(",", "", `30Y`))) |>
  distinct(Date, .keep_all = TRUE)

jp_prices <- jp_gold |>
  inner_join(jp_silver, by = "Date") |>
  inner_join(jp_index,  by = "Date") |>
  inner_join(jp_bonds,  by = "Date") |>
  arrange(Date)

cat("JP price rows (after inner_join):", nrow(jp_prices), "\n")

jp_ret <- build_returns(jp_prices, "JP")
jp_res <- region_frontier(jp_ret, "JP")
jp_pts <- jp_res$frontier
jp_wts <- jp_res$weights

addWorksheet(wb_reg, "JP_Frontier")
addWorksheet(wb_reg, "JP_Weights")
writeData(wb_reg, "JP_Frontier", jp_pts |> mutate(across(where(is.numeric), round, 5)))
writeData(wb_reg, "JP_Weights",  jp_wts |> mutate(across(where(is.numeric), round, 5)))

ggplot(jp_pts, aes(Risk, Return)) +
  geom_path(color = "#D95F02", linewidth = 1.2) +
  labs(
    title = "JP Regional Frontier (MinVar–MaxReturn span, %)",
    x = "Risk (σ, annualized)", y = "Return (%)"
  ) +
  theme_minimal()

# ----------------------------------------------------- #
# Save all regional results
# ----------------------------------------------------- #
saveWorkbook(wb_reg, export_path_regions, overwrite = TRUE)
cat("✅ Regional portfolio results saved to:", export_path_regions, "\n")











# ===================================================== #
#           STAGE 2B – REGIONAL DYNAMIC PORTFOLIOS      #
# ===================================================== #
# Purpose: For EURO, GB, and JP:
#   - build weekly return panels (gold, silver, index, 10Y, 30Y)
#   - run 52-week rolling minimum-variance optimization
#   - smooth weights with 8-week moving average
#   - plot smoothed rolling weights with crisis shading
#   - export all rolling & smoothed weights to Excel
# ===================================================== #

library(PortfolioAnalytics)
library(PerformanceAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(xts)
library(zoo)

# ----------------------------------------------------- #
# Export workbook for regional rolling results
# ----------------------------------------------------- #
export_path_reg_rolling <- "outputs/Regional_Rolling_Portfolios.xlsx"
wb_roll <- createWorkbook()

# ----------------------------------------------------- #
# Helper 1: build simple returns from a merged price df
# ----------------------------------------------------- #
build_returns_reg <- function(price_df) {
  price_df |>
    arrange(Date) |>
    mutate(across(-Date, ~ (. / lag(.)) - 1)) |>
    drop_na()
}

# ----------------------------------------------------- #
# Helper 2: 52-week rolling minimum-variance weights
# ----------------------------------------------------- #
rolling_minvar_weights <- function(ret_xts, window = 52) {
  n <- nrow(ret_xts)
  assets <- colnames(ret_xts)
  
  port_spec_reg <- portfolio.spec(assets) |>
    add.constraint(type = "full_investment") |>
    add.constraint(type = "long_only") |>
    add.objective(type = "risk", name = "var")
  
  weights_list <- vector("list", length = n - window + 1)
  
  for (i in 1:(n - window + 1)) {
    sub_ret <- ret_xts[i:(i + window - 1), ]
    opt <- optimize.portfolio(
      R = sub_ret,
      portfolio = port_spec_reg,
      optimize_method = "ROI",
      trace = FALSE
    )
    weights_list[[i]] <- extractWeights(opt)
  }
  
  dates <- index(ret_xts)[window:n]
  weights_mat <- do.call(rbind, weights_list)
  
  out <- data.frame(
    Date = as.Date(dates),
    weights_mat,
    check.names = FALSE
  )
  rownames(out) <- NULL
  out
}

# ----------------------------------------------------- #
# Helper 3: plot smoothed rolling weights (trim empty LHS)
# ----------------------------------------------------- #
plot_smoothed_rolling <- function(smoothed_df, region_label) {
  
  # Crisis periods
  crisis_periods <- data.frame(
    Crisis = c("DotCom", "GFC", "EU_Debt", "COVID"),
    Start  = as.Date(c("2000-01-01", "2007-07-01", "2010-01-01", "2020-01-01")),
    End    = as.Date(c("2002-12-31", "2009-03-31", "2012-12-31", "2021-06-30"))
  )
  
  # Find first & last dates with any non-NA smoothed weight
  num_cols <- setdiff(names(smoothed_df), "Date")
  non_na_row <- apply(!is.na(smoothed_df[, num_cols, drop = FALSE]), 1, any)
  
  first_date <- min(smoothed_df$Date[non_na_row], na.rm = TRUE)
  last_date  <- max(smoothed_df$Date[non_na_row], na.rm = TRUE)
  
  # Small padding so plot doesn't start exactly at first_date
  pad_days <- 60
  x_min <- first_date - pad_days
  x_max <- last_date
  
  # Only crises that overlap plotting window
  crisis_plot <- crisis_periods |>
    dplyr::filter(End >= x_min & Start <= x_max)
  
  # Long format and drop NA weights
  plot_df <- smoothed_df |>
    dplyr::filter(Date >= x_min & Date <= x_max) |>
    tidyr::pivot_longer(-Date, names_to = "Asset", values_to = "Smoothed_Weight") |>
    dplyr::filter(!is.na(Smoothed_Weight))
  
  ggplot(plot_df, aes(x = Date, y = Smoothed_Weight, fill = Asset)) +
    # crisis shading
    geom_rect(
      data = crisis_plot,
      aes(xmin = Start, xmax = End, ymin = -Inf, ymax = Inf),
      inherit.aes = FALSE,
      alpha = 0.12,
      fill = "grey70",
      color = NA
    ) +
    geom_area(alpha = 0.9) +
    scale_x_date(
      limits = c(x_min, x_max),
      expand = expansion(mult = c(0, 0.01))
    ) +
    labs(
      title    = paste(region_label, "Rolling 8-Week Smoothed Min-Var Portfolio Weights"),
      subtitle = "Crisis periods shaded | Derived from 52-week rolling optimizations",
      x        = NULL,
      y        = "Smoothed Weight"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      legend.position = "top",
      plot.subtitle   = element_text(size = 10, color = "gray30")
    )
}

# ===================================================== #
# 2B.1 EURO – Rolling Portfolios
#       Assets: Gold(EUR), Silver(EUR), STOXX600, 10Y, 30Y
# ===================================================== #

euro_gold <- gold_df |>
  select(Date = `Date.2`, Gold = `Price.2`) |>
  mutate(
    Date = as.Date(Date),
    Gold = as.numeric(gsub(",", "", Gold))
  ) |>
  distinct(Date, .keep_all = TRUE)

euro_silver <- silver_df |>
  select(Date = `Date.2`, Silver = `Price.2`) |>
  mutate(
    Date   = as.Date(Date),
    Silver = as.numeric(gsub(",", "", Silver))
  ) |>
  distinct(Date, .keep_all = TRUE)

euro_stoxx600 <- index_df |>
  select(Date = `Date.4`, STOXX600 = `Price.4`) |>
  mutate(
    Date     = as.Date(Date),
    STOXX600 = as.numeric(gsub(",", "", STOXX600))
  ) |>
  distinct(Date, .keep_all = TRUE)

euro_bonds <- treasury_df |>
  select(Date = `Date.2`,
         `10Y` = `10Y.2`,
         `30Y` = `30Y.2`) |>
  mutate(
    Date = as.Date(Date),
    `10Y` = as.numeric(gsub(",", "", `10Y`)),
    `30Y` = as.numeric(gsub(",", "", `30Y`))
  ) |>
  distinct(Date, .keep_all = TRUE)

euro_prices <- euro_gold |>
  inner_join(euro_silver,   by = "Date") |>
  inner_join(euro_stoxx600, by = "Date") |>
  inner_join(euro_bonds,    by = "Date") |>
  arrange(Date)

euro_ret <- build_returns_reg(euro_prices)
ret_euro_xts <- xts(euro_ret[,-1], order.by = euro_ret$Date)

euro_roll <- rolling_minvar_weights(ret_euro_xts, window = 52)

# 8-week moving-average smoothing
euro_smoothed <- euro_roll
euro_smoothed[,-1] <- apply(euro_roll[,-1], 2, function(x)
  rollapply(x, width = 8, FUN = mean, fill = NA, align = "right"))

addWorksheet(wb_roll, "EURO_RollingWeights")
addWorksheet(wb_roll, "EURO_RollingSmoothed")
writeData(wb_roll, "EURO_RollingWeights",
          euro_roll |> mutate(across(where(is.numeric), ~ round(., 5))))
writeData(wb_roll, "EURO_RollingSmoothed",
          euro_smoothed |> mutate(across(where(is.numeric), ~ round(., 5))))

plot_smoothed_rolling(euro_smoothed, "EURO")

# ===================================================== #
# 2B.2 GREAT BRITAIN (GB) – Rolling Portfolios
#       Assets: Gold(GBP), Silver(GBP), FTSE, 10Y, 30Y
# ===================================================== #

gb_gold <- gold_df |>
  select(Date = `Date.3`, Gold = `Price.3`) |>
  mutate(
    Date = as.Date(Date),
    Gold = as.numeric(gsub(",", "", Gold))
  ) |>
  distinct(Date, .keep_all = TRUE)

gb_silver <- silver_df |>
  select(Date = `Date.3`, Silver = `Price.3`) |>
  mutate(
    Date   = as.Date(Date),
    Silver = as.numeric(gsub(",", "", Silver))
  ) |>
  distinct(Date, .keep_all = TRUE)

gb_ftse <- index_df |>
  select(Date = `Date.5`, FTSE = `Price.5`) |>
  mutate(
    Date = as.Date(Date),
    FTSE = as.numeric(gsub(",", "", FTSE))
  ) |>
  distinct(Date, .keep_all = TRUE)

gb_bonds <- treasury_df |>
  select(Date = `Date.3`,
         `10Y` = `10Y.3`,
         `30Y` = `30Y.3`) |>
  mutate(
    Date = as.Date(Date),
    `10Y` = as.numeric(gsub(",", "", `10Y`)),
    `30Y` = as.numeric(gsub(",", "", `30Y`))
  ) |>
  distinct(Date, .keep_all = TRUE)

gb_prices <- gb_gold |>
  inner_join(gb_silver, by = "Date") |>
  inner_join(gb_ftse,   by = "Date") |>
  inner_join(gb_bonds,  by = "Date") |>
  arrange(Date)

gb_ret <- build_returns_reg(gb_prices)
ret_gb_xts <- xts(gb_ret[,-1], order.by = gb_ret$Date)

gb_roll <- rolling_minvar_weights(ret_gb_xts, window = 52)

gb_smoothed <- gb_roll
gb_smoothed[,-1] <- apply(gb_roll[,-1], 2, function(x)
  rollapply(x, width = 8, FUN = mean, fill = NA, align = "right"))

addWorksheet(wb_roll, "GB_RollingWeights")
addWorksheet(wb_roll, "GB_RollingSmoothed")
writeData(wb_roll, "GB_RollingWeights",
          gb_roll |> mutate(across(where(is.numeric), ~ round(., 5))))
writeData(wb_roll, "GB_RollingSmoothed",
          gb_smoothed |> mutate(across(where(is.numeric), ~ round(., 5))))

plot_smoothed_rolling(gb_smoothed, "GB")

# ===================================================== #
# 2B.3 JAPAN (JP) – Rolling Portfolios
#       Assets: Gold(JPY), Silver(JPY), JP_Index (N225/400),
#               10Y, 30Y
# ===================================================== #

jp_gold <- gold_df |>
  select(Date = `Date.4`, Gold = `Price.4`) |>
  mutate(
    Date = as.Date(Date),
    Gold = as.numeric(gsub(",", "", Gold))
  ) |>
  distinct(Date, .keep_all = TRUE)

jp_silver <- silver_df |>
  select(Date = `Date.4`, Silver = `Price.4`) |>
  mutate(
    Date   = as.Date(Date),
    Silver = as.numeric(gsub(",", "", Silver))
  ) |>
  distinct(Date, .keep_all = TRUE)

jp_n225 <- index_df |>
  select(Date = `Date.6`, N225 = `Price.6`) |>
  mutate(
    Date = as.Date(Date),
    N225 = as.numeric(gsub(",", "", N225))
  ) |>
  distinct(Date, .keep_all = TRUE)

jp_n400 <- index_df |>
  select(Date = `Date.7`, N400 = `Price.7`) |>
  mutate(
    Date = as.Date(Date),
    N400 = as.numeric(gsub(",", "", N400))
  ) |>
  distinct(Date, .keep_all = TRUE)

jp_index <- full_join(jp_n225, jp_n400, by = "Date") |>
  mutate(JP_Index = dplyr::coalesce(N225, N400)) |>
  select(Date, JP_Index) |>
  distinct(Date, .keep_all = TRUE) |>
  filter(!is.na(JP_Index)) |>
  arrange(Date)

jp_bonds <- treasury_df |>
  select(Date = `Date.4`,
         `10Y` = `10Y.4`,
         `30Y` = `30Y.4`) |>
  mutate(
    Date = as.Date(Date),
    `10Y` = as.numeric(gsub(",", "", `10Y`)),
    `30Y` = as.numeric(gsub(",", "", `30Y`))
  ) |>
  distinct(Date, .keep_all = TRUE)

jp_prices <- jp_gold |>
  inner_join(jp_silver, by = "Date") |>
  inner_join(jp_index,  by = "Date") |>
  inner_join(jp_bonds,  by = "Date") |>
  arrange(Date)

jp_ret <- build_returns_reg(jp_prices)
ret_jp_xts <- xts(jp_ret[,-1], order.by = jp_ret$Date)

jp_roll <- rolling_minvar_weights(ret_jp_xts, window = 52)

jp_smoothed <- jp_roll
jp_smoothed[,-1] <- apply(jp_roll[,-1], 2, function(x)
  rollapply(x, width = 8, FUN = mean, fill = NA, align = "right"))

addWorksheet(wb_roll, "JP_RollingWeights")
addWorksheet(wb_roll, "JP_RollingSmoothed")
writeData(wb_roll, "JP_RollingWeights",
          jp_roll |> mutate(across(where(is.numeric), ~ round(., 5))))
writeData(wb_roll, "JP_RollingSmoothed",
          jp_smoothed |> mutate(across(where(is.numeric), ~ round(., 5))))

plot_smoothed_rolling(jp_smoothed, "JP")

# ----------------------------------------------------- #
# Save regional rolling workbook
# ----------------------------------------------------- #
saveWorkbook(wb_roll, export_path_reg_rolling, overwrite = TRUE)
cat("✅ Regional rolling portfolio results saved to:", export_path_reg_rolling, "\n")









# ===================================================== #
#        STAGE 3 – GLOBAL vs REGIONAL COMPARISONS       #
# ===================================================== #
# Purpose:
#   3A. Compare efficient frontiers: Global vs EURO, GB, JP
#   3B. Rolling Gold–Equity correlations (safe-haven test)
#   3C. Min-Variance performance by region & crisis regime
#   3D. Global vs Regional Gold weights (static & rolling)
# ===================================================== #

library(PortfolioAnalytics)
library(PerformanceAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(xts)
library(zoo)

# Workbook for Stage 3 outputs
export_path_stage3 <- "outputs/Stage3_GlobalRegional_Summary.xlsx"
wb3 <- createWorkbook()

# ----------------------------------------------------- #
# Helper: build min-variance portfolio returns
# ----------------------------------------------------- #
minvar_portfolio_returns <- function(ret_xts) {
  spec <- portfolio.spec(colnames(ret_xts)) |>
    add.constraint(type = "full_investment") |>
    add.constraint(type = "long_only") |>
    add.objective(type = "risk", name = "var")
  
  port <- optimize.portfolio(
    R = ret_xts,
    portfolio = spec,
    optimize_method = "ROI",
    trace = FALSE
  )
  
  w <- extractWeights(port)
  p_ret <- xts(as.numeric(ret_xts %*% w), order.by = index(ret_xts))
  colnames(p_ret) <- "Ret"
  
  list(returns = p_ret, weights = w)
}

# ----------------------------------------------------- #
# Helper: crisis regimes
# ----------------------------------------------------- #
crisis_periods <- data.frame(
  Regime = c("DotCom", "GFC", "EU_Debt", "COVID"),
  Start  = as.Date(c("2000-01-01", "2007-07-01", "2010-01-01", "2020-01-01")),
  End    = as.Date(c("2002-12-31", "2009-03-31", "2012-12-31", "2021-06-30"))
)

label_regime <- function(d) {
  out <- rep("Other", length(d))
  out[d >= crisis_periods$Start[1] & d <= crisis_periods$End[1]] <- "DotCom"
  out[d >= crisis_periods$Start[2] & d <= crisis_periods$End[2]] <- "GFC"
  out[d >= crisis_periods$Start[3] & d <= crisis_periods$End[3]] <- "EU_Debt"
  out[d >= crisis_periods$Start[4] & d <= crisis_periods$End[4]] <- "COVID"
  factor(out, levels = c("Other", "DotCom", "GFC", "EU_Debt", "COVID"))
}

# ===================================================== #
# 3A. COMBINED EFFICIENT FRONTIERS
# ===================================================== #
# Uses: ret_xts & port_spec from Stage 1,
#       euro_pts, gb_pts, jp_pts from Stage 2.

# --- Global frontier (recompute to be self-contained) ---
global_front <- create.EfficientFrontier(
  R         = ret_xts,
  portfolio = port_spec,
  type      = "mean-StdDev",
  n.portfolios = 50
)

global_pts <- data.frame(
  Risk   = unlist(global_front$sd)   * sqrt(52),
  Return = unlist(global_front$mean) * 52 * 100,
  Region = "GLOBAL"
)

# Make sure region points carry Region labels
euro_front_pts <- euro_pts |>
  mutate(Region = "EURO")
gb_front_pts <- gb_pts |>
  mutate(Region = "GB")
jp_front_pts <- jp_pts |>
  mutate(Region = "JP")

front_all <- bind_rows(global_pts, euro_front_pts, gb_front_pts, jp_front_pts)

# Export combined frontier table
addWorksheet(wb3, "Frontiers_AllRegions")
writeData(wb3, "Frontiers_AllRegions",
          front_all |> mutate(across(where(is.numeric), ~round(., 5))))

# Plot combined frontier
ggplot(front_all, aes(x = Risk, y = Return, color = Region)) +
  geom_path(linewidth = 1.2) +
  labs(
    title = "Global vs Regional Efficient Frontiers (Weekly Data, Annualized %",
    x = "Risk (σ, annualized)",
    y = "Return (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

# ===================================================== #
# 3B. ROLLING GOLD–EQUITY CORRELATIONS (SAFE-HAVEN TEST)
# ===================================================== #
# Uses: euro_ret, gb_ret, jp_ret from Stage 2 / 2B.
# If needed, they can be rebuilt with build_returns_reg().

rolling_corr_gold_equity <- function(ret_df, index_col, region_name,
                                     window = 52) {
  # Expect columns: Date, Gold, <index_col>
  df <- ret_df |> select(Date, Gold, Index = all_of(index_col)) |> drop_na()
  
  roll_c <- zoo::rollapply(
    df[, c("Gold", "Index")],
    width = window,
    FUN   = function(x) cor(x[, 1], x[, 2], use = "complete.obs"),
    by.column = FALSE,
    align = "right",
    fill = NA
  )
  
  data.frame(
    Date      = df$Date,
    RollCorr  = as.numeric(roll_c),
    Region    = region_name
  )
}

# Build rolling correlations
euro_corr <- rolling_corr_gold_equity(euro_ret, "STOXX600", "EURO")
gb_corr   <- rolling_corr_gold_equity(gb_ret,   "FTSE",     "GB")
jp_corr   <- rolling_corr_gold_equity(jp_ret,   "JP_Index", "JP")

corr_all <- bind_rows(euro_corr, gb_corr, jp_corr)

# Export
addWorksheet(wb3, "Gold_Equity_RollCorr")
writeData(wb3, "Gold_Equity_RollCorr",
          corr_all |> mutate(across(where(is.numeric), ~round(., 5))))

# Plot rolling correlations with crisis shading
ggplot(corr_all, aes(x = Date, y = RollCorr, color = Region)) +
  # crisis shading
  geom_rect(data = crisis_periods,
            aes(xmin = Start, xmax = End, ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE, fill = "grey70", alpha = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line(linewidth = 0.9) +
  facet_wrap(~Region, ncol = 1) +
  labs(
    title = "Rolling 52-Week Correlation: Gold vs Regional Equity Index",
    subtitle = "Crisis periods shaded",
    x = NULL,
    y = "Correlation (Gold, Equity Index)"
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none")

# ===================================================== #
# 3C. MIN-VARIANCE PERFORMANCE BY REGION & REGIME
# ===================================================== #
# Build static min-var portfolios for: GLOBAL, EURO, GB, JP
# and summarize annualized return / risk / Sharpe across regimes.

# --- Compute min-var portfolio returns & weights ---
global_min <- minvar_portfolio_returns(ret_xts)
euro_min   <- minvar_portfolio_returns(ret_euro_xts)
gb_min     <- minvar_portfolio_returns(ret_gb_xts)
jp_min     <- minvar_portfolio_returns(ret_jp_xts)

# Helper to turn xts into tidy DF with region label + regime
to_regime_df <- function(p_xts, region_label) {
  df <- data.frame(
    Date   = as.Date(index(p_xts)),
    Return = as.numeric(p_xts$Ret),
    Region = region_label
  )
  df$Regime <- label_regime(df$Date)
  df
}

perf_df <- bind_rows(
  to_regime_df(global_min$returns, "GLOBAL"),
  to_regime_df(euro_min$returns,   "EURO"),
  to_regime_df(gb_min$returns,     "GB"),
  to_regime_df(jp_min$returns,     "JP")
)

performance_table <- perf_df |>
  group_by(Region, Regime) |>
  summarise(
    Ann_Return = mean(Return) * 52 * 100,
    Ann_Risk   = sd(Return)   * sqrt(52) * 100,
    Sharpe     = ifelse(Ann_Risk == 0, NA_real_, Ann_Return / Ann_Risk),
    .groups    = "drop"
  ) |>
  arrange(Region, factor(Regime, levels = c("Other", "DotCom", "GFC", "EU_Debt", "COVID")))

# Export performance table
addWorksheet(wb3, "MinVar_Performance")
writeData(wb3, "MinVar_Performance",
          performance_table |> mutate(across(where(is.numeric), ~round(., 3))))

# ===================================================== #
# 3D. GLOBAL vs REGIONAL GOLD WEIGHTS
#      (Static min-var + Rolling 8-week smoothed)
# ===================================================== #

# ---------- 3D.1 Static min-variance weights ----------
# Collect min-var weights from the objects we just built
weights_static <- bind_rows(
  data.frame(Region = "GLOBAL", Asset = names(global_min$weights),
             Weight = as.numeric(global_min$weights)),
  data.frame(Region = "EURO",   Asset = names(euro_min$weights),
             Weight = as.numeric(euro_min$weights)),
  data.frame(Region = "GB",     Asset = names(gb_min$weights),
             Weight = as.numeric(gb_min$weights)),
  data.frame(Region = "JP",     Asset = names(jp_min$weights),
             Weight = as.numeric(jp_min$weights))
)

addWorksheet(wb3, "Static_MinVar_Weights")
writeData(wb3, "Static_MinVar_Weights",
          weights_static |> mutate(across(where(is.numeric), ~round(., 4))))

# Bar chart: Gold weight by region
gold_static <- weights_static |> filter(Asset == "Gold")

ggplot(gold_static, aes(x = Region, y = Weight, fill = Region)) +
  geom_col(width = 0.6) +
  labs(
    title = "Gold Weight in Static Minimum-Variance Portfolios",
    y = "Weight", x = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")

# ---------- 3D.2 Rolling Gold weights (8-week smoothed) ----------
# Uses: rolling_smoothed (GLOBAL) from Stage 1B,
#       euro_smoothed, gb_smoothed, jp_smoothed from Stage 2B.

gold_roll_global <- rolling_smoothed |>
  select(Date, Gold) |>
  mutate(Region = "GLOBAL")

gold_roll_euro <- euro_smoothed |>
  select(Date, Gold) |>
  mutate(Region = "EURO")

gold_roll_gb <- gb_smoothed |>
  select(Date, Gold) |>
  mutate(Region = "GB")

gold_roll_jp <- jp_smoothed |>
  select(Date, Gold) |>
  mutate(Region = "JP")

gold_roll_all <- bind_rows(
  gold_roll_global,
  gold_roll_euro,
  gold_roll_gb,
  gold_roll_jp
) |> arrange(Date)

addWorksheet(wb3, "Gold_RollingWeights")
writeData(wb3, "Gold_RollingWeights",
          gold_roll_all |> mutate(across(where(is.numeric), ~round(., 5))))

# Plot rolling Gold weight comparison
ggplot(gold_roll_all, aes(x = Date, y = Gold, color = Region)) +
  geom_rect(data = crisis_periods,
            aes(xmin = Start, xmax = End, ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE, fill = "grey80", alpha = 0.2) +
  geom_line(linewidth = 0.9) +
  labs(
    title = "Rolling 8-Week Smoothed Gold Weights: Global vs Regions",
    subtitle = "Crisis periods shaded | Based on 52-week rolling optimizations",
    x = NULL,
    y = "Gold Weight"
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top")

# ----------------------------------------------------- #
# Save Stage 3 workbook
# ----------------------------------------------------- #
saveWorkbook(wb3, export_path_stage3, overwrite = TRUE)
cat("✅ Stage 3 summary workbook saved to:", export_path_stage3, "\n")

# ---------------------------- #
# END STAGE 3
# ---------------------------- #

# ---------------------------- #
# END #
# ---------------------------- #
