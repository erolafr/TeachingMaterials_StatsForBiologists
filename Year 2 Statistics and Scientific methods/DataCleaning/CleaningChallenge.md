
# Data cleaning challenge

# Introduction

This short **challenge** asks you to tidy and inspect the `palmerpenguins` dataset so that it is ready for downstream analysis. Work inside the code chunks and answer the numbered questions. Hints are provided but not required; try first and use hints only when stuck.

**Goal:** by the end you will have a cleaned `penguins_clean` tibble and a function `check_penguins()` that tests whether common problems were resolved and prints **"congrats, your data is clean!"** when everything passes.

------------------------------------------------------------------------

```{r setup}
# Setup: load packages and dataset
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("palmerpenguins", quietly = TRUE)) install.packages("palmerpenguins")
if (!requireNamespace("forcats", quietly = TRUE)) install.packages("forcats")
library(tidyverse)
library(palmerpenguins)
library(forcats)

penguins_raw <- penguins %>%
  mutate(species = as.character(species)) %>%
  mutate( island = as.character(island),   island = case_when(island == "Biscoe" & runif(n()) < 0.3 ~ "BISCOE",   island == "Biscoe" & runif(n()) < 0.3 ~ "biscoe",   island == "Torgersen" & runif(n()) < 0.3 ~ "Togegersen",  TRUE ~ island ) ) %>%
 mutate(body_mass_g = if_else(is.na(body_mass_g), "unknown", as.character(body_mass_g)),  body_mass_g = str_trim(body_mass_g),
    body_mass_g = replace(body_mass_g, sample(seq_len(n()), 5), "n/a")  ) %>%   mutate(sample_id = row_number())

```

------------------------------------------------------------------------

## Task 1 — Diagnosing Messiness (short answers & code)

1.1. Your initial dataset is called penguins_raw. How many rows and columns does `penguins` have? Use `glimpse()` or `dim()` and report.

1.2. For each column, compute how many `NA`s there are. Store this in `na_count`.

**Hint:** `summarise(across(everything(), ~ sum(is.na(.))))`.

```{r task1}
# Your code here

# Example hint (uncomment if needed):
# na_count <- penguins %>% summarise(across(everything(), ~ sum(is.na(.))))
```

------------------------------------------------------------------------

## Task 2 — Targeted NA removal

We will focus analyses on bill and flipper measurements. Define a new tibble `penguins_trim` that **keeps only rows where `bill_length_mm`, `bill_depth_mm`, and `flipper_length_mm` are present**.

2.1 Create `penguins_trim`.

**Hint:** Use `drop_na()` or `filter(complete.cases(...))`.

```{r task2}
# Your code here
```

------------------------------------------------------------------------

## Task 3 — Factor hygiene

3.1 Ensure `species`, `island`, and `sex` are factors. Convert or coerce them as necessary and store in `penguins_trim`.

3.2 Reorder `species` by median `body_mass_g` (smallest to largest) and save the result in `penguins_trim`.

3.3 Create a new factor `island_grouped` that lumps the least-common islands into `Other`, keeping the top 2 islands.

**Hints:** `factor()` or `as.factor()`; `fct_reorder()`, `fct_lump()`.

```{r task3}
# Your code here
```

------------------------------------------------------------------------

## Task 4 — Reshaping for comparison

4.1 Create a long-format tibble `penguins_long` that gathers `bill_length_mm`, `bill_depth_mm`, and `flipper_length_mm` into `measurement` and `value`.

4.2 Produce a faceted boxplot comparing distributions of those measurements across `species` (use `facet_wrap(~ measurement, scales = "free")`).

**Hints:** `pivot_longer()` and `ggplot2`.

```{r task4}
# Your code here
```

------------------------------------------------------------------------

## Task 5 — Detecting suspect numeric encoding

Sometimes numeric-looking variables are actually categories stored as numbers (IDs, years, codes). Check whether any variables are integer/numeric but have very few unique values (e.g. \< 10). Report those variables and suggest whether they should be turned into factors.

**Hint:** `summarise(across(where(is.numeric), ~ n_distinct(.)))` and filter.

```{r task5}
# Your code here
```

------------------------------------------------------------------------

## Task 6 — Create derived categorical variables

6.1 Create a categorical size class `size_class` from `body_mass_g` with three levels: - `Small` \< 3500 g - `Medium` 3500–4500 g - `Large` \> 4500 g

Make sure `size_class` is an ordered factor with levels `Small`, `Medium`, `Large`.

**Hint:** `cut()` or `case_when()` + `factor(..., levels = ...)`.

```{r task6}
# Your code here
```

------------------------------------------------------------------------

## Task 7 — Detection and correction checks

Write a function `check_penguins(df)` that accepts a data frame and runs a series of logical tests. If all tests pass it prints `"congrats, your data is clean!"`. If any test fails, it prints a short summary of failed checks.

Suggested checks (implement at least these): - No `NA`s in the measurement columns used for analysis: `bill_length_mm`, `bill_depth_mm`, `flipper_length_mm`, `body_mass_g`. - `species`, `island`, and `sex` are factors. - `species` levels are ordered by median body mass (i.e. `fct_reorder()` result). - `size_class` exists and is an ordered factor with three levels `Small`, `Medium`, `Large`. - No numeric columns with fewer than 5 unique values (except known integer counts or IDs). (Optional: check this with an allowlist.)

The function should return `TRUE` invisibly when all is clean and `FALSE` otherwise.

**Hint:** return a named logical vector of checks, then summarise.

```{r task7}
check_penguins <- function(df) {
  
  # 1. Required columns exist
  required_cols <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm",
                     "body_mass_g", "species", "island", "sex", "size_class")
  cols_exist <- all(required_cols %in% names(df))
  
  # 2. No NAs in key measurement columns
  no_nas_measurements <- all(!is.na(df$bill_length_mm) &
                               !is.na(df$bill_depth_mm) &
                               !is.na(df$flipper_length_mm) &
                               !is.na(df$body_mass_g))
  
  # 3. Correct data types
  species_is_factor <- is.factor(df$species)
  island_is_factor  <- is.factor(df$island)
  sex_is_factor     <- is.factor(df$sex)
  body_mass_numeric <- is.numeric(df$body_mass_g)
  
  # 4. Species ordered by median body mass
  species_order_correct <- FALSE
  if (species_is_factor && body_mass_numeric) {
    medians <- tapply(df$body_mass_g, df$species, median, na.rm = TRUE)
    species_order_correct <- identical(levels(df$species), names(sort(medians)))
  }
  
  # 5. size_class exists and is ordered correctly
  size_class_correct <- is.ordered(df$size_class) &&
    identical(levels(df$size_class), c("Small", "Medium", "Large"))
  
  # 6. No suspicious numeric columns with very few unique values (<5)
  numeric_cols <- df %>% select(where(is.numeric))
  few_unique <- sapply(numeric_cols, function(x) n_distinct(x) < 5)
  suspicious_numeric <- any(few_unique)
  
  tests <- c(
    cols_exist = cols_exist,
    no_nas_measurements = no_nas_measurements,
    species_is_factor = species_is_factor,
    island_is_factor = island_is_factor,
    sex_is_factor = sex_is_factor,
    body_mass_numeric = body_mass_numeric,
    species_order_correct = species_order_correct,
    size_class_correct = size_class_correct,
    no_suspicious_numeric = !suspicious_numeric
  )
  
  if (all(tests)) {
    message("congrats, your data is clean!")
    return(invisible(TRUE))
  } else {
    failed <- names(tests)[!tests]
    message("Some checks failed:\n - ", paste(failed, collapse = "\n - "))
    return(invisible(FALSE))
  }
}


```

```{r}
# Check your dataset: 
# check_penguins(penguins_clean)
```

### Hints (use only when stuck):

-   **Diagnosing NAs:** `summarise(across(everything(), ~ sum(is.na(.))))`
-   **Drop only specific NAs:** `drop_na(bill_length_mm, bill_depth_mm)`
-   **Factor ordering:** `fct_reorder(species, body_mass_g, .fun = median)`
-   **Lumping:** `fct_lump(island, n = 2)`
-   **Reshape:** `pivot_longer(cols = c(bill_length_mm, bill_depth_mm, flipper_length_mm), names_to = "measurement", values_to = "value")`
-   **Make ordered factor:** `factor(x, levels = c("Small","Medium","Large"), ordered = TRUE)`

# FINAL REFLECTIONS:

-   How did you discover what was wrong with the data?

-   When we removed missing values, what **assumption** did we implicitly make? Could this introduce **bias**?

-   What was the **most subtle data problem** in this exercise?

-   Which step required the **most judgement rather than just syntax**? Do you think being familiar with the data is useful when cleaning it? Is it necessary?

-   At what point do data cleaning decisions become **statistical decisions**?
