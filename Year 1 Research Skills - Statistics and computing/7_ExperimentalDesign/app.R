###############################################################
# Interactive Experiment Design Training App
# 
# This Shiny application guides students through key concepts 
# in experimental design using four progressive levels:
#
# Level 1: Controlled laboratory experiment (control, randomisation, replication)
# Level 2: Field experiment (confounding, blocking, environmental variation)
# Level 3: Factorial design (multiple factors, interactions, balance)
# Level 4: Design diagnosis (identify flaws and consolidate learning)
#
# The app combines interactive visualisations, simulations, 
# and immediate feedback to support conceptual understanding.
#
# Final activity: Students reflect by designing the “worst possible experiment”
# and explaining why it would lead to misleading conclusions.
#
# Author: Erola Fenollosa
# Course: Research skills Y1 Biology - University of Oxford
# Date: May 2026
###############################################################



library(shiny)
library(ggplot2)
library(shinyjs)

# Total plants for Level 3
TOTAL_L3 <- 23

# Helper for Level 4 feedback boxes
feedback_box <- function(status, text) {
  styles <- list(
    green  = list(border = "#2e7d32", bg = "#e8f5e9", icon = "✔"),
    orange = list(border = "#ef6c00", bg = "#fff3e0", icon = "⚠"),
    red    = list(border = "#c62828", bg = "#ffebee", icon = "✖"),
    gray   = list(border = "#546e7a", bg = "#eceff1", icon = "•")
  )
  
  s <- styles[[status]]
  
  HTML(paste0(
    "<div style='margin-top:8px; padding:10px 12px; border-left:5px solid ", s$border,
    "; background:", s$bg,
    "; color:", s$border,
    "; border-radius:4px; font-weight:600; line-height:1.35;'>",
    "<span style='font-size:1.1em; margin-right:8px;'>", s$icon, "</span>",
    text,
    "</div>"
  ))
}

ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$link(rel = "stylesheet",
              href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"),
    tags$style(HTML("\
      .level-note { color: #555; font-style: italic; margin-top: 6px; }\n\
      .final-challenge { margin-top: 18px; }\n    "))
  ),
  
  titlePanel("Experimental Design - The game"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "level", "Select Level:",
        choices = c(
          "Level 1: Lab experiment",
          "Level 2: Field experiment",
          "Level 3: Factorial design",
          "Level 4: Diagnose the design"
        )
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 1: Lab experiment'",
        h4("Scenario"),
        p("You are working in a plant biology laboratory that has been asked to evaluate a new commercial fertiliser."),
        p("The manufacturer claims that, when applied at the recommended dose, the fertiliser increases plant growth. However, this claim has not yet been independently tested."),
        p("Your task is to design a simple experiment to assess whether this fertiliser actually works."),
        p("To ensure a fair test, you are given a large number of genetically identical tomato plants (clones), all grown under strictly controlled laboratory conditions (same light, soil, temperature, and watering)."),
        p("Previous work shows that both measurement error and environmental variation are very low."),
        p(strong("How would you design an experiment to test whether this fertiliser increases plant growth?")),
        hr(),
        h4("Variability Information"),
        tags$ul(
          tags$li("Genetically identical plants"),
          tags$li("Controlled environment"),
          tags$li("Low measurement error"),
          tags$li(strong("Expected variability: LOW"))
        ),
        hr(),
        h4("Your Design Choices"),
        radioButtons(
          "l1_response", "Choose response variable:",
          choices = c("Plant height after 2 weeks", "Leaf colour", "Number of pots"),
          selected = character(0)
        ),
        radioButtons(
          "l1_unit", "Experimental unit:",
          choices = c("Individual plant", "Tray of plants", "Laboratory"),
          selected = character(0)
        ),
        radioButtons(
          "l1_treatment", "Treatments:",
          choices = c("Control + Fertiliser", "Only fertiliser", "Multiple doses"),
          selected = character(0)
        ),
        radioButtons(
          "l1_random", "Treatment assignment:",
          choices = c("Random assignment", "First half gets treatment", "Choose largest plants"),
          selected = character(0)
        ),
        sliderInput("l1_replicates", "Replicates per group:", min = 1, max = 50, value = 2),
        hr(),
        actionButton("l1_simulate", "Simulate Results")
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 2: Field experiment'",
        h4("Scenario"),
        p("You are continuing your work evaluating a commercial fertiliser, but this time the experiment must be carried out under real field conditions rather than in the laboratory."),
        p("The manufacturer claims that the fertiliser increases plant growth when applied at the recommended dose, and you want to test whether this effect holds outside controlled conditions."),
        p("However, the field site you are working in is not uniform:"),
        tags$ul(
          tags$li("Soil quality varies across the field"),
          tags$li("Some areas receive more sunlight than others"),
          tags$li("Small differences in moisture and microclimate may also affect plant growth")
        ),
        p("From previous experience, you know that these environmental differences can have a strong influence on plant growth, potentially masking or exaggerating the effect of the fertiliser."),
        p("As in the laboratory experiment, you are using a single fertiliser dose (the manufacturer’s recommended amount), and you will compare it to a control without fertiliser."),
        p(strong("How would you design your experiment?")),
        hr(),
        h4("Design Choices"),
        radioButtons(
          "l2_treatment", "Treatments:",
          choices = c("Control + Fertiliser", "Only fertiliser", "Multiple doses"),
          selected = character(0)
        ),
        radioButtons(
          "l2_blocking", "Design strategy:",
          choices = c("No blocking", "Random distribution", "Block by field position"),
          selected = character(0)
        ),
        sliderInput("l2_replicates", "Replicates", min = 1, max = 30, value = 2),
        hr(),
        actionButton("l2_simulate", "Simulate Results")
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 3: Factorial design'",
        h4("Scenario"),
        p("You are continuing your investigation into the effects of a commercial fertiliser on plant growth. Previous experiments suggested that the fertiliser may increase growth, but results have been inconsistent across different environments."),
        p("You now suspect that water availability may also play an important role. In particular, it is possible that the fertiliser only works under certain watering conditions."),
        p("To investigate this, you plan to run an experiment where plants are grown under different combinations of:"),
        tags$ul(
          tags$li("Fertiliser: with or without fertiliser"),
          tags$li("Water availability: well-watered or drought conditions")
        ),
        p("This means that plant growth may depend not only on each factor individually, but also on how these factors interact with each other."),
        p("This time you have a total of 23 plants available, and you must decide how to allocate them across the different treatment combinations."),
        p(strong("How would you design an experiment that allows you to test the effects of fertiliser, water availability, and their interaction?")),
        hr(),
        radioButtons(
          "l3_design", "Choose treatments:",
          choices = c(
            "Well watered + Fertilised",
            "Well watered + Fertilised + Control",
            "Well watered + drought + Fertilised + Control"
          ),
          selected = character(0)
        ),
        hr(),
        h4("Allocate 23 plants across treatments"),
        uiOutput("l3_sliders_ui"),
        hr(),
        actionButton("l3_simulate", "Simulate Results")
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 4: Diagnose the design'",
        h4("Scenario"),
        p("This final activity is a diagnosis round. Read each proposed experiment carefully and decide what is wrong with it."),
        p("The aim is to spot missing controls, lack of randomisation, pseudoreplication, poor balance, and other design problems."),
        p(strong("Answer all questions. When you finish, the final challenge will appear."))
      )
    ),
    
    mainPanel(
      conditionalPanel(
        condition = "input.level == 'Level 1: Lab experiment'",
        h3("Design Summary"),
        verbatimTextOutput("l1_summary"),
        hr(),
        h3("Experimental Design Visualisation"),
        plotOutput("l1_design_plot", height = "300px"),
        hr(),
        h3("Feedback"),
        uiOutput("l1_feedback"),
        hr(),
        h3("Simulated Results"),
        plotOutput("l1_plot")
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 2: Field experiment'",
        h3("Design Visualisation"),
        plotOutput("l2_design_plot", height = "350px"),
        hr(),
        h3("Feedback"),
        uiOutput("l2_feedback"),
        hr(),
        h3("Simulated Results"),
        plotOutput("l2_plot")
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 3: Factorial design'",
        h3("Design Visualisation"),
        plotOutput("l3_design_plot"),
        hr(),
        h3("Feedback"),
        uiOutput("l3_feedback"),
        hr(),
        h3("Simulated Results"),
        plotOutput("l3_sim_plot")
      ),
      
      conditionalPanel(
        condition = "input.level == 'Level 4: Diagnose the design'",
        wellPanel(
          h4("Q1. Independence / pseudoreplication"),
          p("A researcher measures 50 leaves from a single tree and compares them with 50 leaves from another tree. What is the main problem?"),
          radioButtons(
            "l4_q1", NULL,
            choices = c(
              "The sample size is too small.",
              "The leaves are not independent observations.",
              "There is no control group.",
              "The measurements are too precise."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q1")
        ),
        
        wellPanel(
          h4("Q2. Observational vs experimental"),
          p("A study compares biodiversity in protected and unprotected areas without assigning treatments. What type of study is this?"),
          radioButtons(
            "l4_q2", NULL,
            choices = c(
              "Experimental study.",
              "Observational study.",
              "Randomised controlled trial.",
              "Factorial experiment."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q2")
        ),
        
        wellPanel(
          h4("Q3. Blinding"),
          p("Why is blinding important in experiments?"),
          radioButtons(
            "l4_q3", NULL,
            choices = c(
              "It increases sample size.",
              "It prevents bias in measurement or behaviour.",
              "It reduces environmental variation.",
              "It ensures equal sample sizes."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q3")
        ),
        
        wellPanel(
          h4("Q4. Sample size / power"),
          p("What is the main consequence of having too few replicates?"),
          radioButtons(
            "l4_q4", NULL,
            choices = c(
              "Increased bias.",
              "Reduced ability to detect real effects.",
              "Loss of independence.",
              "Incorrect randomisation."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q4")
        ),
        
        wellPanel(
          h4("Q5. Matching / stratification"),
          p("In an observational study, how can you reduce differences between groups?"),
          radioButtons(
            "l4_q5", NULL,
            choices = c(
              "Randomise treatments.",
              "Increase measurement precision.",
              "Match similar units across groups.",
              "Remove the control group."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q5")
        ),
        
        wellPanel(
          h4("Q6. Balance"),
          p("Why is a balanced design with equal sample sizes preferred?"),
          radioButtons(
            "l4_q6", NULL,
            choices = c(
              "It eliminates bias.",
              "It reduces sampling error and improves precision.",
              "It removes the need for randomisation.",
              "It makes the analysis easier."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q6")
        ),
        
        wellPanel(
          h4("Q7. Design before inference"),
          p("Why is experimental design important before collecting data?"),
          radioButtons(
            "l4_q7", NULL,
            choices = c(
              "It determines which statistical analysis is appropriate.",
              "It guarantees correct results.",
              "It increases the number of variables.",
              "It makes the experiment easier to analyse later."
            ),
            selected = character(0)
          ),
          uiOutput("l4_fb_q7")
        ),
        
        hr(),
        uiOutput("l4_completion_ui")
      )
    )
  )
)

server <- function(input, output, session) {
  
  # ----------------------
  # Level 1
  # ----------------------
  l1_data <- eventReactive(input$l1_simulate, {
    req(input$l1_response, input$l1_unit, input$l1_treatment, input$l1_random, input$l1_replicates)
    
    n <- input$l1_replicates
    control_mean <- 10
    treatment_effect <- 2
    
    noise_sd <- ifelse(n < 5, 4, ifelse(n < 10, 2, 1))
    bias_shift <- ifelse(input$l1_random != "Random assignment", 2, 0)
    
    control <- rnorm(n, mean = control_mean + bias_shift, sd = noise_sd)
    treatment <- rnorm(n, mean = control_mean + treatment_effect, sd = noise_sd)
    
    data.frame(
      value = c(control, treatment),
      group = rep(c("Control", "Treatment"), each = n)
    )
  })
  
  output$l1_summary <- renderText({
    if (is.null(input$l1_response) || is.null(input$l1_unit) || is.null(input$l1_treatment) || is.null(input$l1_random)) {
      return("Complete all selections to view your design summary.")
    }
    
    paste(
      "Units:", input$l1_unit,
      "\nResponse:", input$l1_response,
      "\nTreatments:", input$l1_treatment,
      "\nAssignment:", input$l1_random,
      "\nReplicates per group:", input$l1_replicates
    )
  })
  
  output$l1_design_plot <- renderPlot({
    req(input$l1_response, input$l1_unit, input$l1_treatment, input$l1_random)
    
    n <- input$l1_replicates
    
    unit_label <- switch(input$l1_unit,
                         "Individual plant" = "🌱",
                         "Tray of plants" = "🧺🪴",
                         "Laboratory" = "🏢"
    )
    
    data <- data.frame(
      x = rep(c(1, 2), each = n),
      y = rep(1:n, times = 2),
      group = rep(c("Control", "Treatment"), each = n)
    )
    
    if (input$l1_random == "Random assignment") {
      data$y <- jitter(data$y, amount = 0.3)
    }
    
    ggplot(data, aes(x = x, y = y, color = group)) +
      geom_text(aes(label = unit_label), size = 8) +
      scale_color_manual(values = c("Control" = "#4CAF50", "Treatment" = "#1E88E5")) +
      annotate("text", x = 1, y = max(data$y) + 1, label = "Control", fontface = "bold") +
      annotate("text", x = 2, y = max(data$y) + 1, label = "Treatment", fontface = "bold") +
      xlim(0.5, 2.5) +
      theme_void() +
      theme(legend.position = "none")
  })
  
  output$l1_feedback <- renderUI({
    if (is.null(input$l1_response) || is.null(input$l1_unit) || is.null(input$l1_treatment) || is.null(input$l1_random)) {
      return(tags$div(
        style = "color:gray; font-style:italic;",
        "Please complete all design choices to see feedback."
      ))
    }
    
    make_msg <- function(text, color, icon) {
      paste0(
        "<div style='color:", color,
        "; font-weight:600; margin-bottom:8px; display:flex; align-items:center;'>",
        "<i class='fa fa-", icon, "'></i>",
        "<span style='margin-left:8px;'>", text, "</span>",
        "</div>"
      )
    }
    
    feedback_html <- ""
    bias <- 0
    error <- 0
    
    if (input$l1_response == "Plant height after 2 weeks") {
      feedback_html <- paste0(feedback_html, make_msg("Good response variable.", "green", "check-circle"))
    } else {
      feedback_html <- paste0(feedback_html, make_msg("Does not measure growth directly.", "red", "times-circle"))
    }
    
    if (input$l1_unit == "Individual plant") {
      feedback_html <- paste0(feedback_html, make_msg("Correct experimental unit.", "green", "check-circle"))
    } else {
      feedback_html <- paste0(feedback_html, make_msg("Incorrect unit (loss of independence).", "red", "times-circle"))
    }
    
    if (input$l1_treatment == "Control + Fertiliser") {
      feedback_html <- paste0(feedback_html, make_msg("Control allows comparison.", "green", "check-circle"))
    } else if (input$l1_treatment == "Only fertiliser") {
      feedback_html <- paste0(feedback_html, make_msg("No control → cannot estimate effect.", "red", "times-circle"))
      bias <- bias + 2
    } else {
      feedback_html <- paste0(feedback_html, make_msg("More complex than needed.", "orange", "exclamation-triangle"))
      bias <- bias + 1
    }
    
    if (input$l1_random == "Random assignment") {
      feedback_html <- paste0(feedback_html, make_msg("Randomisation reduces bias.", "green", "check-circle"))
    } else {
      feedback_html <- paste0(feedback_html, make_msg("Non-random assignment introduces bias.", "red", "times-circle"))
      bias <- bias + 2
    }
    
    if (input$l1_replicates < 3) {
      feedback_html <- paste0(feedback_html, make_msg("Too few replicates.", "red", "times-circle"))
      error <- error + 2
    } else if (input$l1_replicates < 10) {
      feedback_html <- paste0(feedback_html, make_msg("Low replication: limited precision.", "orange", "exclamation-triangle"))
      error <- error + 1
    } else {
      feedback_html <- paste0(feedback_html, make_msg("Good replication.", "green", "check-circle"))
    }
    
    total <- bias + error
    
    summary_html <- if (total <= 1) {
      "<div style='background:#d4edda;color:#155724;padding:10px;border-radius:5px;margin-bottom:10px;'><b>✔ Strong design: low bias and good precision.</b></div>"
    } else if (total <= 3) {
      "<div style='background:#fff3cd;color:#856404;padding:10px;border-radius:5px;margin-bottom:10px;'><b>⚠ Acceptable design: some improvements needed.</b></div>"
    } else {
      "<div style='background:#f8d7da;color:#721c24;padding:10px;border-radius:5px;margin-bottom:10px;'><b>✘ Problematic design: high bias or error.</b></div>"
    }
    
    HTML(paste0(summary_html, feedback_html))
  })
  
  output$l1_score <- renderText({
    if (is.null(input$l1_response) || is.null(input$l1_unit) || is.null(input$l1_treatment) || is.null(input$l1_random)) {
      return("")
    }
    
    bias <- 0
    error <- 0
    
    if (input$l1_treatment != "Control + Fertiliser") bias <- bias + 2
    if (input$l1_random != "Random assignment") bias <- bias + 2
    
    if (input$l1_replicates < 5) error <- error + 2
    if (input$l1_replicates < 10) error <- error + 1
    
    paste(
      "Bias score (lower is better):", bias,
      "\nSampling error score (lower is better):", error
    )
  })
  
  output$l1_plot <- renderPlot({
    df <- l1_data()
    req(df)
    
    ggplot(df, aes(x = group, y = value, fill = group)) +
      geom_boxplot() +
      scale_fill_manual(values = c("Control" = "#4CAF50", "Treatment" = "#1E88E5")) +
      labs(y = "Plant height", x = "") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")
  })
  
  # ----------------------
  # Level 2
  # ----------------------
  get_l2_groups <- reactive({
    req(input$l2_treatment)
    
    if (input$l2_treatment == "Control + Fertiliser") {
      c("Control", "Fertiliser")
    } else if (input$l2_treatment == "Only fertiliser") {
      c("Fertiliser")
    } else {
      c("Control", "Low dose", "High dose")
    }
  })
  
  l2_data <- eventReactive(input$l2_simulate, {
    req(input$l2_treatment, input$l2_blocking, input$l2_replicates)
    
    n <- input$l2_replicates
    groups <- get_l2_groups()
    gradient <- seq(0, 4, length.out = n)
    
    data_list <- list()
    
    for (g in groups) {
      base <- ifelse(g == "Control", 10,
                     ifelse(g == "Fertiliser", 12,
                            ifelse(g == "Low dose", 11, 13)))
      
      if (input$l2_blocking == "No blocking") {
        values <- rnorm(n, base + sample(gradient), 2)
      } else if (input$l2_blocking == "Random distribution") {
        values <- rnorm(n, base + sample(gradient), 2)
      } else {
        values <- rnorm(n, base + sample(gradient), 1.5)
      }
      
      data_list[[g]] <- data.frame(value = values, group = g)
    }
    
    do.call(rbind, data_list)
  })
  
  output$l2_design_plot <- renderPlot({
    req(input$l2_treatment, input$l2_blocking)
    
    n <- input$l2_replicates
    groups <- get_l2_groups()
    k <- length(groups)
    unit_label <- "🌱"
    
    gradient_df <- data.frame(
      x = seq(0, 10, length.out = 100),
      y = 1,
      fill = seq(0, 1, length.out = 100)
    )
    
    p <- ggplot() +
      geom_tile(data = gradient_df, aes(x = x, y = y, fill = fill), height = 2) +
      scale_fill_gradient(low = "#fff7bc", high = "#fec44f")
    
    if (input$l2_blocking == "No blocking") {
      x_pos <- seq(0, 10, length.out = n)
      group <- rep(groups, length.out = n)
      group <- sort(group)
      
      df <- data.frame(
        x = x_pos,
        y = jitter(rep(1, n), amount = 0.2),
        group = group
      )
      
      p <- p +
        geom_point(data = df, aes(x, y, color = group), size = 6) +
        geom_text(data = df, aes(x, y, label = unit_label), vjust = -1.2)
      
    } else if (input$l2_blocking == "Random distribution") {
      x_pos <- seq(0, 10, length.out = n)
      group <- sample(rep(groups, length.out = n))
      
      df <- data.frame(
        x = sample(x_pos),
        y = jitter(rep(1, n), amount = 0.2),
        group = group
      )
      
      p <- p +
        geom_point(data = df, aes(x, y, color = group), size = 6) +
        geom_text(data = df, aes(x, y, label = unit_label), vjust = -1.2)
      
    } else {
      blocks <- data.frame(x_center = seq(0.5, 9.5, length.out = n))
      
      df <- data.frame(
        x = rep(blocks$x_center, each = k),
        y = rep(seq(0.85, 1.15, length.out = k), times = n),
        group = rep(groups, times = n)
      )
      
      rects <- data.frame(
        xmin = blocks$x_center - 0.3,
        xmax = blocks$x_center + 0.3,
        ymin = 0.75,
        ymax = 1.25
      )
      
      p <- p +
        geom_rect(data = rects,
                  aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
                  fill = NA, color = "black") +
        geom_point(data = df, aes(x, y, color = group), size = 5) +
        geom_text(data = df, aes(x, y, label = unit_label), vjust = -1.2)
    }
    
    p +
      scale_color_manual(values = c(
        "Control" = "#4CAF50",
        "Fertiliser" = "#1E88E5",
        "Low dose" = "#ff9800",
        "High dose" = "#e64a19"
      )) +
      annotate("text", x = 0, y = 1.5, label = "Poor soil", hjust = 0) +
      annotate("text", x = 10, y = 1.5, label = "Rich soil", hjust = 1) +
      theme_void() +
      theme(legend.position = "none")
  })
  
  output$l2_feedback <- renderUI({
    req(input$l2_treatment, input$l2_blocking)
    
    make_msg <- function(text, color, icon) {
      paste0(
        "<div style='color:", color,
        "; font-weight:600; margin-bottom:8px; display:flex; align-items:center;'>",
        "<i class='fa fa-", icon, "'></i> ",
        text,
        "</div>"
      )
    }
    
    feedback_html <- ""
    
    if (input$l2_treatment == "Only fertiliser") {
      feedback_html <- paste0(feedback_html,
                              make_msg("No control group: cannot estimate treatment effect.", "red", "times-circle"))
    }
    
    if (input$l2_treatment == "Multiple doses") {
      feedback_html <- paste0(feedback_html,
                              make_msg("Multiple doses allow more detailed understanding of response.", "green", "check-circle"))
    }
    
    if (input$l2_blocking == "No blocking") {
      feedback_html <- paste0(feedback_html,
                              make_msg("Confounding likely due to soil variation.", "red", "times-circle"))
    } else if (input$l2_blocking == "Random distribution") {
      feedback_html <- paste0(feedback_html,
                              make_msg("Randomisation removes bias but variability remains.", "orange", "exclamation-triangle"))
    } else if (input$l2_blocking == "Block by field position") {
      feedback_html <- paste0(feedback_html,
                              make_msg("Blocking controls environmental variation effectively.", "green", "check-circle"))
    }
    
    HTML(feedback_html)
  })
  
  output$l2_plot <- renderPlot({
    df <- l2_data()
    req(df)
    
    ggplot(df, aes(group, value, fill = group)) +
      geom_boxplot() +
      scale_fill_manual(values = c(
        "Control" = "#4CAF50",
        "Fertiliser" = "#1E88E5",
        "Low dose" = "#ff9800",
        "High dose" = "#e64a19"
      )) +
      theme_minimal(base_size = 14) +
      labs(y = "Plant growth", x = "") +
      theme(legend.position = "none")
  })
  
  # ----------------------
  # Level 3
  # ----------------------
  get_l3_groups <- reactive({
    req(input$l3_design)
    
    if (input$l3_design == "Well watered + Fertilised") {
      c("Fertilised (Wet)")
    } else if (input$l3_design == "Well watered + Fertilised + Control") {
      c("Control (Wet)", "Fertilised (Wet)")
    } else {
      c("Control (Dry)", "Control (Wet)", "Fertilised (Dry)", "Fertilised (Wet)")
    }
  })
  
  output$l3_sliders_ui <- renderUI({
    groups <- get_l3_groups()
    n <- length(groups)
    
    tagList(lapply(seq_len(n), function(i) {
      sliderInput(
        paste0("l3_n", i),
        label = groups[i],
        min = 0,
        max = TOTAL_L3,
        value = if (i == 1) TOTAL_L3 - (n - 1) else 1
      )
    }))
  })
  
  get_l3_counts <- reactive({
    groups <- get_l3_groups()
    n <- length(groups)
    
    vals <- numeric(n)
    for (i in seq_len(n)) {
      val <- input[[paste0("l3_n", i)]]
      if (is.null(val)) return(NULL)
      vals[i] <- val
    }
    vals
  })
  
  observe({
    counts <- get_l3_counts()
    if (is.null(counts)) return()
    
    diff <- TOTAL_L3 - sum(counts)
    if (diff != 0) {
      last <- length(counts)
      id <- paste0("l3_n", last)
      updateSliderInput(session, id, value = max(0, min(TOTAL_L3, input[[id]] + diff)))
    }
  })
  
  output$l3_design_plot <- renderPlot({
    groups <- get_l3_groups()
    counts <- get_l3_counts()
    req(groups, counts)
    
    df <- do.call(rbind, lapply(seq_along(groups), function(i) {
      if (counts[i] == 0) return(NULL)
      data.frame(
        group = groups[i],
        x = runif(counts[i]),
        y = runif(counts[i])
      )
    }))
    
    ggplot(df, aes(x, y, color = group)) +
      geom_point(size = 5) +
      geom_text(label = "🌱", vjust = -1.2) +
      facet_wrap(~group) +
      theme_minimal() +
      theme(
        legend.position = "none",
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank()
      )
  })
  
  output$l3_feedback <- renderUI({
    groups <- get_l3_groups()
    counts <- get_l3_counts()
    req(groups, counts)
    
    make_msg <- function(txt, col) {
      paste0("<p style='color:", col, "; font-weight:600;'>", txt, "</p>")
    }
    
    msgs <- ""
    
    if (length(groups) == 1) {
      msgs <- paste0(msgs, make_msg("Only one treatment: no comparison possible.", "red"))
    } else if (length(groups) == 2) {
      msgs <- paste0(msgs, make_msg("Missing drought conditions: cannot assess interaction.", "orange"))
    } else {
      msgs <- paste0(msgs, make_msg("Full factorial design: allows testing interactions.", "green"))
    }
    
    if (sd(counts) > 5) {
      msgs <- paste0(msgs, make_msg("Unbalanced design reduces precision.", "orange"))
    } else {
      msgs <- paste0(msgs, make_msg("Balanced allocation improves precision.", "green"))
    }
    
    HTML(msgs)
  })
  
  l3_data <- eventReactive(input$l3_simulate, {
    groups <- get_l3_groups()
    counts <- get_l3_counts()
    req(groups, counts)
    
    df <- do.call(rbind, lapply(seq_along(groups), function(i) {
      g <- groups[i]
      n <- counts[i]
      if (n == 0) return(NULL)
      
      Fertiliser <- ifelse(grepl("Fertilised", g), "Fertilised", "Control")
      Water <- ifelse(grepl("Wet", g), "Wet", "Dry")
      
      base <- if (Fertiliser == "Control" && Water == "Dry") 10 else
        if (Fertiliser == "Control" && Water == "Wet") 12 else
          if (Fertiliser == "Fertilised" && Water == "Dry") 10 else 16
      
      data.frame(
        Fertiliser = Fertiliser,
        Water = Water,
        value = rnorm(n, base, 1)
      )
    }))
    
    df$Water <- factor(df$Water, levels = c("Dry", "Wet"))
    df
  })
  
  output$l3_sim_plot <- renderPlot({
    df <- l3_data()
    req(df)
    
    # Raw data panel
    p1 <- ggplot(df, aes(x = interaction(Water, Fertiliser), y = value, fill = Fertiliser)) +
      geom_boxplot(outlier.shape = NA) +
      geom_jitter(width = 0.2, alpha = 0.5) +
      labs(x = "Treatment", y = "Growth", title = "Raw data") +
      theme_minimal()
    
    # Interaction plot panel
    means <- aggregate(value ~ Water + Fertiliser, df, mean)
    
    p2 <- ggplot(means, aes(x = Water, y = value, group = Fertiliser, color = Fertiliser)) +
      geom_point(size = 4) +
      geom_line() +
      labs(title = "Interaction plot", y = "Mean growth") +
      theme_minimal()
    
    gridExtra::grid.arrange(p1, p2, ncol = 2)
  })
  
  # ----------------------
  # Level 4
  # ----------------------
  output$l4_fb_q1 <- renderUI({
    if (is.null(input$l4_q1)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q1,
      "The sample size is too small." = feedback_box("red", "Not quite. Fifty observations sound large, but the real problem is that the leaves are not independent."),
      "The leaves are not independent observations." = feedback_box("green", "Correct. Leaves from the same tree share conditions, so the true independent units are trees, not leaves."),
      "There is no control group." = feedback_box("red", "Not quite. There is a comparison, but the issue is that the observations are nested within trees."),
      "The measurements are too precise." = feedback_box("red", "Not correct. Precision is not the problem here.")
    )
  })
  
  output$l4_fb_q2 <- renderUI({
    if (is.null(input$l4_q2)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q2,
      "Experimental study." = feedback_box("red", "Not correct. The researcher did not assign treatments."),
      "Observational study." = feedback_box("green", "Correct. The researcher observed existing protected and unprotected areas without random assignment."),
      "Randomised controlled trial." = feedback_box("red", "Not correct. There was no random allocation."),
      "Factorial experiment." = feedback_box("red", "Not correct. There was only one main comparison.")
    )
  })
  
  output$l4_fb_q3 <- renderUI({
    if (is.null(input$l4_q3)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q3,
      "It increases sample size." = feedback_box("red", "Not correct. Blinding does not change the sample size."),
      "It prevents bias in measurement or behaviour." = feedback_box("green", "Correct. Blinding reduces conscious or unconscious bias."),
      "It reduces environmental variation." = feedback_box("red", "Not correct. That is the role of blocking."),
      "It ensures equal sample sizes." = feedback_box("red", "Not correct. That is balance, not blinding.")
    )
  })
  
  output$l4_fb_q4 <- renderUI({
    if (is.null(input$l4_q4)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q4,
      "Increased bias." = feedback_box("red", "Not correct. Bias comes from design problems such as poor randomisation or missing controls."),
      "Reduced ability to detect real effects." = feedback_box("green", "Correct. Too few replicates reduce power."),
      "Loss of independence." = feedback_box("red", "Not correct. Independence is a separate issue."),
      "Incorrect randomisation." = feedback_box("red", "Not correct. Randomisation can be fine even if the sample size is small.")
    )
  })
  
  output$l4_fb_q5 <- renderUI({
    if (is.null(input$l4_q5)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q5,
      "Randomise treatments." = feedback_box("red", "Not correct. In an observational study you usually cannot randomise treatments."),
      "Increase measurement precision." = feedback_box("red", "Not correct. Precision does not remove group differences."),
      "Match similar units across groups." = feedback_box("green", "Correct. Matching helps reduce confounding by making groups more comparable."),
      "Remove the control group." = feedback_box("red", "Not correct. Removing the control group makes the comparison weaker.")
    )
  })
  
  output$l4_fb_q6 <- renderUI({
    if (is.null(input$l4_q6)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q6,
      "It eliminates bias." = feedback_box("red", "Not correct. A balanced design does not remove bias on its own."),
      "It reduces sampling error and improves precision." = feedback_box("green", "Correct. Equal sample sizes usually improve precision."),
      "It removes the need for randomisation." = feedback_box("red", "Not correct. Randomisation is still needed."),
      "It makes the analysis easier." = feedback_box("orange", "Partly true. Balanced data can be easier to analyse, but the main benefit is better precision.")
    )
  })
  
  output$l4_fb_q7 <- renderUI({
    if (is.null(input$l4_q7)) return(feedback_box("gray", "Select an answer to see feedback."))
    switch(
      input$l4_q7,
      "It determines which statistical analysis is appropriate." = feedback_box("green", "Correct. Design and analysis are tightly linked."),
      "It guarantees correct results." = feedback_box("red", "Not correct. Good design improves inference, but nothing guarantees the right answer."),
      "It increases the number of variables." = feedback_box("red", "Not correct. Experimental design is about controlling and organising variables."),
      "It makes the experiment easier to analyse later." = feedback_box("orange", "Partly true. Good design can help later analysis, but the main point is that design determines what analysis is valid.")
    )
  })
  
  question_ids <- paste0("l4_q", 1:7)
  
  all_answered <- reactive({
    all(vapply(question_ids, function(id) !is.null(input[[id]]), logical(1)))
  })
  
  output$l4_completion_ui <- renderUI({
    if (!all_answered()) {
      return(feedback_box("gray", "Complete all questions to unlock the final challenge."))
    }
    
    HTML(
      paste0(
        "<div style='margin-top:18px; padding:16px 18px; border-left:6px solid #2e7d32; ",
        "background:#e8f5e9; border-radius:6px; color:#1b5e20; font-size:1.05em; line-height:1.45;'>",
        "<div style='font-size:1.25em; font-weight:700; margin-bottom:10px;'>",
        "You completed the experiment design training",
        "</div>",
        "<div style='font-weight:600; margin-bottom:8px;'>",
        "Before you leave, team up and describe the worst experimental design possible and explain it to me. Feel free to draw it on a paper",
        "</div>",
        "</div>"
      )
    )
  })
}

shinyApp(ui = ui, server = server)
