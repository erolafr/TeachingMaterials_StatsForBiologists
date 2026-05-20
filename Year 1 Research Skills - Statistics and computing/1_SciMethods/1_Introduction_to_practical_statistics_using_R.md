## 0. Overview of this practical

In this session we will cover:

-   Introduction to the practical side of the course
-   Checking R: updating R and RStudio and installing packages
-   Reproducible science

This computer practical will take place in **Computer Lab 1 in the
LaMB**, where you will be able to use desktop computers with all the
required packages already installed.

If you prefer, you are very welcome to bring your own laptop, especially
for this first session. Today we will be installing, updating, and
checking your **R** and **RStudio** versions, so that you are set up for
the rest of the year (and beyond).

The practicals will introduce you to **R** and **RStudio**, and to using
R for statistical analyses that reinforce the statistical concepts you
will be learning during the lectures. They are designed to give you time
to work through examples and exercises with support available.

During *Research Skills: Computing & Statistics* in MT you already
learned the basics of R. If you already feel comfortable using R,
today’s emphasis will be on keeping R and RStudio properly updated and
on introducing the idea of reproducible scientific workflows.

## Quarto for reproducible coding

In this course we will use **Quarto** documents (`.qmd` files).

A Quarto document allows you to combine: written explanations (text), R
code, the results produced by that code (tables, figures, numbers), all
in a single file.

> *Personal note:* For me, this is the best way to support my own
> learning. It is like taking a photograph when you want to remember
> something. Using Quarto links results directly to the code that
> produced them, so your future self can easily understand and remember
> what you did.

This is an important part of **reproducible science**: anyone with the
same data and the same code should be able to re-run your document and
obtain the same results.

In practice, this means that:

\- your analysis and your explanations are kept together,

\- you do not need to copy and paste results by hand,

\- your work is easier to check, update, and share.

## How to work through these exercises

The exercises in this practical are designed to help you **learn by
doing**.

Not all the information you need is provided directly in this document.
In several exercises, you are expected to **look for information
yourself**, for example by: reading R help pages, searching online
(e.g. using a search engine), etc.

This is a normal and important part of learning how to use R and how to
work as a scientist.

When writing R code, you are strongly encouraged to **add comments**
using the `#` symbol. Comments are short notes written for humans, not
for R. They help you (and others) understand what the code is doing and
*why* it is being used.

For example:

``` {r}
3 * 120 # This line calculates the result of 3 multiplied by 120
```

**EXERCICE 1.** Make sure you have installed R, R Studio and Quarto.

**1.1.** After installing R and RStudio, prove that you know how to use
RStudio as a **calculator**, by calculating 3\*120 (*or any other
operation you like*).

ANSWER:

**1.2.** Explain in your own words: what is the difference between R and
RStudio? Could we work with R alone?

ANSWER:

**1.3.** To check if you have Quarto installed:

1.  In RStudio, click:  
    **File → New File → Quarto Document**

2.  Choose:

<!-- -->

    -    Title: anything you like

    -    Author: your name

    -    Format: HTML

3.  Click **Create**.

If a new document opens with some example text, **Quarto is correctly
installed**.

Close the Quarto file you have created and open the one that is provided
in Canvas (this one that you are reading right now). Make sure you open
this file in R Studio.

**QUESTION FOR SELF-EXPLORATION:** What does the “**Render**” button do
in the Quarto file?

ANSWER:

**QUESTION FOR SELF-REFLECTION:** Why do we use **Quarto**?

ANSWER:

**EXERCICE 2. Check the R version that you have installed:**

**2.1.** Find the command that prints the R version. Is it the most
up-to-date version?

``` {r}
# ANSWER:
```

**2.2.** Find the command to update R and write it here (no need to do
it now):

ANSWER:

**2.3.** Why do you think it is important to know which R version you
are using?

ANSWER:

**EXERCICE 3. Using packages.**

**3.1.** What is an R package? Define it in your own words. Do you think
you will ever create one?

ANSWER:

**3.2.** Find an R package you like, install it, and load it. Make sure
you add all the commands properly annotated (remember using \# before
any explanation). If possible, also note the version of the package
used.

``` {r}
# ANSWER: 
```

*Hint: Feel free to dive into the CRAN page to find a package.
<https://cran.r-project.org/web/packages/available_packages_by_name.html>*

**3.3.** Is `"install.packages()"`enough to work with a package in R?

ANSWER:

**TO EXPAND:** In other programming languages, packages have different
names. Can you find how packages are called in **Python**?

ANSWER:
