#################################################
# Penguins Data Cleaning Challenge — SOLUTIONS
#################################################

library(tidyverse)
library(palmerpenguins)
library(forcats)

set.seed(42)

#################################################
# Create messy dataset
#################################################

penguins_raw <- penguins %>%
  mutate(species = as.character(species)) %>%
  mutate(
    island = as.character(island),
    island = case_when(
      island == "Biscoe" & runif(n()) < 0.3 ~ "BISCOE",
      island == "Biscoe" & runif(n()) < 0.3 ~ "biscoe",
      island == "Torgersen" & runif(n()) < 0.3 ~ "Togegersen",
      TRUE ~ island
    )
  ) %>%
  mutate(
    body_mass_g = if_else(is.na(body_mass_g), "unknown", as.character(body_mass_g)),
    body_mass_g = str_trim(body_mass_g),
    body_mass_g = replace(body_mass_g, sample(seq_len(n()), 5), "n/a")
  ) %>%
  mutate(sample_id = row_number())


#################################################
# TASK 1 — Diagnose NA problems
#################################################

na_count <- penguins_raw %>%
  summarise(across(everything(), ~ sum(is.na(.))))

#################################################
# TASK 2 — Clean numeric column + drop key NAs
#################################################

penguins_clean <- penguins_raw %>%
  # Fix body_mass_g (remove bad strings → numeric)
  mutate(body_mass_g = na_if(body_mass_g, "unknown"),
         body_mass_g = na_if(body_mass_g, "n/a"),
         body_mass_g = as.numeric(body_mass_g)) %>%
  
  # Fix island names (standardise)
  mutate(island = str_to_title(island),
         island = if_else(island == "Togegersen", 
                          "Torgersen", island)) %>%
  
  # Drop rows missing key measurements
  drop_na(bill_length_mm, bill_depth_mm, 
          flipper_length_mm, body_mass_g)


#################################################
# TASK 3 — Factor hygiene
#################################################

penguins_clean <- penguins_clean %>%
  mutate(
    species = as.factor(species),
    island  = as.factor(island),
    sex     = as.factor(sex),
    year    = as.factor(year)
  ) %>%
  
  # Reorder species by median body mass
  mutate(species = fct_reorder(species, body_mass_g, .fun = median)) %>%
  
  # Lump rare islands (keep top 2)
  mutate(island_grouped = fct_lump(island, n = 2))


#################################################
# TASK 4 — Reshape to long format
#################################################

penguins_long <- penguins_clean %>%
  pivot_longer(
    cols = c(bill_length_mm, bill_depth_mm, flipper_length_mm),
    names_to = "measurement",
    values_to = "value"
  )

# Example plot
ggplot(penguins_long, aes(species, value)) +
  geom_boxplot() +
  facet_wrap(~ measurement, scales = "free")


#################################################
# TASK 5 — Detect suspicious numeric variables
#################################################

numeric_summary <- penguins_clean %>%
  summarise(across(where(is.numeric), n_distinct))

numeric_summary


#################################################
# TASK 6 — Create ordered size class
#################################################

penguins_clean <- penguins_clean %>%
  mutate(
    size_class = case_when(
      body_mass_g < 3500 ~ "Small",
      body_mass_g <= 4500 ~ "Medium",
      body_mass_g > 4500 ~ "Large"
    ),
    size_class = factor(size_class,
                        levels = c("Small", "Medium", "Large"),
                        ordered = TRUE)
  )


#################################################
# TASK 7 — Final checking function
#################################################

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

# Run final check
check_penguins(penguins_clean)

#################################################
# END
#################################################