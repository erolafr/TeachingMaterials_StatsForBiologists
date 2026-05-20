
# Is Habitat protection working?

Natural area protection is one of the key management strategies for preserving biodiversity. However, many landscapes are under strong economic and development pressures, and the effectiveness of conservation measures must be demonstrated.

A few years ago, the government implemented protection measures across several natural sites, including wetlands, forests, and grasslands. These measures included limiting human access (e.g., restricting vehicles and public entry), restoring vegetation, and controlling invasive species.

Data were collected: **Before protection (baseline)** and **After 2 years of protection**. At each site, local managers measured:

-    🌱 **Species richness** (number of species)

-    🌿 **Vegetation cover (%)**

-    🐸 **Abundance of an indicator species** *European tree frog (Hyla arborea) (* Sensitive to environmental change and Reflect ecosystem health)

A preliminary report compared the "before” values vs the“after” values , aiming to demonstrate that the protection has improved the natural areas. However, the conclusion was ⚠️**“There is no clear improvement after protection.”**

And the government is facing the decision to revert area protection. A key aspect that the preliminary study didn't consider is that the protected areas are very different from each other. Some are naturally rich ecosystems, other are degraded, some are large, others small. This creates a huge between-site variability.

## 🧠 Your mission

1.   Reanalyse the data properly
2.   Decide: Is protection working?
3.   Communicate: A recommendation to policymakers

# 

# 📊 The Data

```{r}
set.seed(42)
n_sites <- 20
site <- paste0("Site_", 1:n_sites)
habitat <- sample(c("Wetland", "Grassland", "Forest"), n_sites, replace = TRUE)

# --- Species richness (counts) ---
richness_before <- pmax(0, round(rnorm(n_sites, 20, 10)))

# --- Vegetation cover (0–100%) ---
veg_before <- pmin(100, pmax(0, rnorm(n_sites, 50, 20)))

# --- Frog abundance (counts) ---
frog_before <- pmax(0, round(rnorm(n_sites, 8, 4)))

# --- Improvements ---
richness_after <- pmax(0, round(richness_before + rnorm(n_sites, 3, 2)))
veg_after <- pmin(100, pmax(0, veg_before + rnorm(n_sites, 8, 5)))
frog_after <- pmax(0, round(frog_before + rnorm(n_sites, 2, 1.5)))

# --- Introduce declines ---
decline_sites <- sample(1:n_sites, 3)
richness_after[decline_sites] <- pmax(0, round(richness_before[decline_sites] - rnorm(3, 2, 1)) )
veg_after[decline_sites] <- pmin(100, pmax(0, veg_before[decline_sites] - rnorm(3, 5, 2)) )
frog_after[decline_sites] <- pmax(0,round(frog_before[decline_sites] - rnorm(3, 2, 1)))

# --- Final dataset ---
data <- data.frame( site, habitat, richness_before, richness_after,  veg_before, veg_after,  frog_before, frog_after)

data
```

------------------------------------------------------------------------

# 🧠 THINK FIRST (before any analysis)

::: callout-important
### ✍️ Question 1. Expectation

Do you expect all sites to improve after protection?

-   Yes / No\
-   Why?
:::

------------------------------------------------------------------------

# 📈 Visualisation 1

```{r}
library(ggplot2)

ggplot(data) +
  geom_density(aes(x = richness_before), fill = "blue", alpha = 0.4) +
  geom_density(aes(x = richness_after), fill = "red", alpha = 0.4) +
  labs(title = "Species Richness: Before vs After")
```

------------------------------------------------------------------------

::: callout-warning
### ✍️ Question 2. First observations

Based on this plot:

👉 Does protection seem effective?

-   Yes / No / Unclear\
-   Why?

Can you think (and draw/code) an alternative visualisation for this data? When facing this questions you can always explore <https://datavizcatalogue.com/> or <https://r-graph-gallery.com/>

Should we check if this data is normally distributed?
:::

<details>

<summary>💡 Click for discussion</summary>

The distributions overlap strongly → unclear effect.\
BUT this ignores that each point comes from the same site.

An alternative plot could be a violin plot or a box plot that shows in the X axis the before and after data separately. If we want to consider the differences, my preference is a cleveland dot plot.

We could test if this data is normally distributed, but depending on the test we choose it might have different requirements

</details>

------------------------------------------------------------------------

# 🔍 Why might this be misleading?

::: callout-tip
Sites are very different from each other!
:::

------------------------------------------------------------------------

# 🔗 Visualisation 2: Pairing

```{r}
ggplot(data, aes(x = richness_before, y = richness_after)) +
  geom_point(size = 3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(title = "Each site before vs after")
```

------------------------------------------------------------------------

::: callout-important
### ✍️ Question 3. Scatter plot interpretation

What does it mean if a point is:

-   Above the line?
-   Below the line?
:::

<details>

<summary>💡 Answer</summary>

-   Above = improvement\
-   Below = decline

</details>

------------------------------------------------------------------------

# 📉 Visualisation 3: CHANGE 

```{r}
data$richness_change <- data$richness_after - data$richness_before

ggplot(data, aes(x = richness_change)) +
  geom_histogram(bins = 10, fill = "darkgreen") +
  labs(title = "Change in richness")
```

------------------------------------------------------------------------

::: callout-important
### ✍️ Question 4. Richness change

Now answer:

👉 Is the **average change** positive? (Calculate it in R, you know how).

👉 Are the differences (after-before) approximately normally distributed?

👉 Are all sites improving?

Can you add a vertical line at the 0 value so we can clearly distinguish the sites that improved and the sites that went worse? Try to add as well the average value.
:::

<details>

<summary>💡 Click for discussion</summary>

Calculate the average change by `mean(data$richness_change)`. Not all sites are improving, but since the mean is positive, most of them are (in terms of species richness). Add the vertical line with `geom_vline().`

A normal distribution of the differences look *reasonable enough*.

</details>

------------------------------------------------------------------------

# 🧠 Concept Check

::: callout-warning
❌ Wrong question\
Are before and after different?

✅ Correct question\
Is the **change within sites different from zero?**
:::

------------------------------------------------------------------------

# 📊 Statistical Tests

## ✅ Paired t-test

```{r}
t.test(data$richness_after, data$richness_before, paired = TRUE)
```

------------------------------------------------------------------------

## ❌ Ignoring pairing

```{r}
t.test(data$richness_after, data$richness_before, paired = FALSE)
```

------------------------------------------------------------------------

::: callout-important
### ✍️ Question 5. Compare tests

Compare the two results:

-   Which test detects an effect?
-   Why are they different?
:::

<details>

<summary>💡 Explanation</summary>

Paired test removes variation between sites → clearer signal.

Unpaired test includes all variability → weaker signal.

</details>

------------------------------------------------------------------------

# 🐸 Indicator Species: Frog

Now it is your turn, provide further evidence for the impacts of nature protection with the data of the indicator species. This time you will have to code it yourself.

```{r}
# Calculate frog_change here>


# Visualise the distribution of frog_change>

```

------------------------------------------------------------------------

::: callout-important
### ✍️ Question 6. Frog abundance

Is the frog population responding to protection?

Why might frogs be especially informative?
:::

<details>

<summary>💡 Explanation</summary>

The required code could be:

`data$frog_change <- data$frog_after - data$frog_before`

`ggplot(data, aes(x = frog_change)) +   geom_histogram(fill = "purple", bins = 10) +   labs(title = "Change in frog abundance")`

This frog species is an "indicator species", and therefore is strongly informative of the "health of the habitat". Sometimes this could be a better indicator rather than the number of species (which could include invasive species for example).

</details>

------------------------------------------------------------------------

::: callout-important
### ✍️ Question 7 (open interpretation)

Why might some sites decline?

Think biologically: - Habitat quality? - Time lag? - External disturbances?
:::

------------------------------------------------------------------------

# 📝 FINAL TASK (Policy Report)

You must advise the government.

------------------------------------------------------------------------

## ✍️ Your Report

Answer:

1.  Is habitat protection working?
2.  Is biodiversity increasing?
3.  Is vegetation improving?
4.  Is the frog population responding?
5.  Should protection continue?

------------------------------------------------------------------------

::: callout-tip
### 💡 Tip

Do NOT just say "significant" or "not significant". Explain: - Direction of change - Strength of evidence (effect size) - Uncertanity - Biological meaning

------------------------------------------------------------------------
:::

# 🎯 Test yourself

::: callout-important
1.  Pairing removes baseline differences between sites, but how could we account for broader environmental changes, such as global temperature increases?

<!-- -->

2.  Even when data are naturally paired, should we always use a paired test? Can you think of an example where, despite having a before/after design or repeated measurements, a paired test might not be appropriate?

3.  Since not all sites improved, would you suggest further data exploration? For example, should we analyse results by habitat type? What other factors might determine the success of area protection, and therefore, what additional variables would you include in the dataset (e.g., protected area size)?

4.  Is a paired test a two-sample test?\
    *(Hint: No — it is a one-sample test on the differences.)*

5.  Why is the p-value not the only aspect that matters? Why does effect size matter as well?

6.  You have heard that CBD production in plants might increase under mild drought stress, and *just for learning purposes*, you want to try it. Since you want to measure the concentration of that magical compound at different water availability levels, how would you design the experiments in terms of number of plants? Would you:

    -   Apply a progressive drought treatment to the same plants and compare before and after measurements, or

    -    Use two groups of plants, one well-watered and one exposed to drought?

    Would your choice of design affect the statistical test you use? Explain your reasoning and how you would decide on the experimental design.

7.   After completing this exercise, I would contact the company to show them the results. Do you think this could be a good way to represent the results? What would you add/change?

    If the image is not displayed [find it in this link:](https://unioxfordnexus-my.sharepoint.com/:i:/g/personal/zool2620_ox_ac_uk/IQCISLj_rsTmS6WAK4loaUgfAfmeNQswO7wSQfSKEgnAVig?e=sR7akP)
:::

![](FinalReport.png)
