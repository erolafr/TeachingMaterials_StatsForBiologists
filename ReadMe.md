# Teaching Materials — Statistics for Biologists

Teaching materials developed for Biology students at the University of Oxford, focused on learning statistics through real biological questions, data exploration, and scientific reasoning using **R** and **Quarto**.

The materials are organised as practical sessions that progressively introduce students to statistical thinking through ecological, conservation, behavioural, and experimental biology examples. Rather than treating statistics as abstract mathematics, the course frames analyses around biological interpretation, uncertainty, and decision-making.

---

# Repository Structure

## Year 1 — Research Skills: Statistics and Computing

These sessions introduce students to R, data visualisation, hypothesis testing, and statistical modelling through applied biological case studies.

### 1. Introduction to Practical Statistics Using R
📄 [1_Introduction_to_practical_statistics_using_R.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/1_SciMethods/1_Introduction_to_practical_statistics_using_R.md)

An introduction to RStudio, basic data handling, plotting, and reproducible workflows. Students begin learning how statistics connects to biological reasoning and scientific communication.

---

### 2. Descriptors and Visualisations
📄 [2_Descriptors_and_visualisations.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/2_Descriptors_and_visualisations/2_Descriptors_and_visualisations.md)

This practical will build on the introduction to R and RStudio from the first session and begin applying these tools to topics in statistical inference (specifically, data description) and data visualisation, following the early chapters of Analysis of Biological Data by Whitlock and Schluter. Specifically, we will play good/bad visualisation games and use R to explore red kite longevity data to learn how to summarise a biological variable. You will calculate key statistics, create simple visualisations, and think about how to communicate typical lifespan, variation, and uncertainty when answering the question: “How long will my red kite live?”

---

### 3. Catfish Diet — Comparing Groups
📄 [CatfishDiet.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/3_Probability/CatfishDiet.md)

This practical builds on the introduction to R and RStudio and applies these tools to probability concepts in a biological context. Using a simulated dataset inspired by real ecological studies, we will explore catfish diet composition to learn how probabilities are used to describe biological observations. You will use R to generate data, calculate probabilities and build simple probability trees. Throughout the session, you will think critically about sample size, variability, and study design while addressing the question: “Is climate change shifting the catfish diet?”. A few functions are provided to play with sampling effort and the representativity of proportions.

---

### 4. Biostimulants — Experimental Comparisons
📄 [Biostimulants.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/4_Hypothesis_testing/Biostimulants.md)

This practical builds on previous sessions and introduces hypothesis testing as a tool for answering biological questions about treatment effects. Using a simple experimental example inspired by plant biology, we will test whether a biostimulant affects plant growth compared to an untreated control. You will use R to explore the data, visualise differences between groups, define the null and alternative hypoteses, and apply basic statistical tests to evaluate whether observed differences are likely due to the treatment or to random variation. Throughout the session, you will focus on interpreting results in a biological context and understanding what it means to conclude that a treatment “works” or “does not work”.

---

### 5. Rewild or Wait — Analysing Proportions
📄 [Rewild_or_Wait_analysing_proportions_with_Answers.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/5_Proportions/Rewild_or_Wait_analysing_proportions_with_Answers.md)

This practical uses a seed-germination rewilding scenario to teach proportion and count data analysis in R. You will visualise germination proportions, estimate germination rates with Agresti–Coull confidence intervals and exact binomial tests, compare treatments using two-sample proportion tests (χ² / Fisher) and effect-size CIs, and apply goodness-of-fit tests (χ² / G-test and Poisson fit) where appropriate. Finally, you will quantify uncertainty with simple simulations, use a Risk Matrix to turn CIs into management actions (Proceed / Delay), and run an interactive decision simulator that links probabilities, seed availability and costs to a defensible conservation recommendation.

---

### 6. T-test: Habitat Protection
📄 [interactive_habitat_protection.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/6_t-test/interactive_habitat_protection.md)

A practical exploring habitat protection and biodiversity responses. Students evaluate evidence and statistical outputs within realistic conservation contexts.Does habitat protection work? In this practical, you will use paired t-tests and visualisations to analyse ecological data and uncover the answer.

---

### 7. Experimental Designing - The game
📄 [Link to the app](https://erolafenollosa.shinyapps.io/ExperimentalDesignGame/)

In this session, you will explore key principles of experimental design through interactive activities. You will design experiments, identify potential sources of bias and variability, and investigate how factors and their interactions influence results. The session concludes with a short challenge to diagnose and critique experimental designs. Code is archived in the [corresponding folder](https://github.com/erolafr/TeachingMaterials_StatsForBiologists/tree/main/Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/7_ExperimentalDesign).

---

### 8. Your First ANOVA
📄 [Your_first_ANOVA.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/8_ANOVA/Your_first_ANOVA.md)

In this session, we will explore the connecting thread between t-tests, linear regression, and ANOVA. Specifically, you will learn how to use a one-way ANOVA in R to test whether a grouping variable affects a continuous variable. You will create and visualise your own dataset, check ANOVA assumptions, interpret the ANOVA table, and perform post hoc tests to identify which groups differ. Finally, you will apply this knowledge to a real scientific article, identifying how ANOVA is used and how the results are visualised and interpreted in a biological context.

---

### 9. Can we predict animal behaviour? Building and evaluating linear models in Ecology
📄 [PredictHumanImpact.md](./Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/9_LinearModels/PredictHumanImpact.md)

In this session, we will learn how to fit and interpret linear models in R, report the information they provide, and distinguish between good and poor predictive models. Using a wildlife conservation scenario, we will investigate whether human activity can predict changes in animal behaviour and discuss how these models can inform real management decisions.

---
### 10. Hourses for Courses - The Game
	
In this session, we step back and connect everything you’ve learned. From probability rules to hypothesis tests, from t-tests to chi-square, we will bring all the pieces together into one clear decision framework. Through an interactive challenge, you’ll practise identifying the structure of a problem, distinguishing probability from inference, and matching each research question to the most appropriate statistical method and visualisation. By the end of the class, you’ll have a simple decision map you can reuse next term and beyond, helping you confidently answer one of the most important questions in statistics: Which method should I use — and why?
All the game contents, and results can be downloaded from [the folder](https://github.com/erolafr/TeachingMaterials_StatsForBiologists/tree/main/Year%201%20Research%20Skills%20-%20Statistics%20and%20computing/Final_CoursesForHorses/Final_CoursesForHorses). 

---

## Year 2 — Statistics and Scientific Methods

These materials build on the Year 1 practicals by moving further into data preparation, workflow design, and reproducible scientific analysis. The emphasis shifts from performing statistical tests to developing reliable coding habits, organising analyses clearly, and treating R as a scientific tool for transparent and reproducible research. The two included sessions are 2h computer practicals that fit in a series of sessions on R skills. 

---


### 1. Workflow, Pipes and Functions
📄 [WorkflowChallenge.md](./Year%202%20Statistics%20and%20Scientific%20methods/Workflow_pipes_and_functions/WorkflowChallenge.md)

This session focuses on building more efficient and readable workflows in R using functions, pipes, and structured code. Students move from isolated commands toward cleaner analytical workflows that are easier to understand, reproduce, and expand. The practical has several levels of programing thinking to develop their skills.

### 2. Data Cleaning
📄 [CleaningChallenge.md](./Year%202%20Statistics%20and%20Scientific%20methods/DataCleaning/CleaningChallenge.md)

This practical introduces the realities of messy biological data and the importance of checking, tidying, and preparing datasets before analysis. Students develop good practices around data quality, transparency, and reproducible workflows through a data cleaning challenge, with a final function that evaluates how clean their dataset is.

---


# Teaching Philosophy

These materials were developed around several core principles:

- Statistics should be learned through meaningful biological questions.
- Visualisation and interpretation are as important as calculations.
- Students learn best when analyses are connected to uncertainty and decision-making.
- Coding is treated as a scientific tool rather than a technical barrier.
- Practical sessions should encourage curiosity, discussion, and experimentation.

The sessions aim to help students move from:
- *“Which test should I use?”*  
to:
- *“What biological question am I trying to answer?”*

---

# Technologies Used

- **R**
- **tidyverse**
- **ggplot2**
- **Quarto**
- **Shiny** 

---

# License

This repository is shared for educational purposes under the MIT License.

---

# Author

Developed by **Erola Fenollosa**  [Contact info](https://erolafenollosa.weebly.com/)

Department of Biology  
University of Oxford
