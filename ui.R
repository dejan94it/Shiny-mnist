ui <- fluidPage(
  theme = bslib::bs_theme(version = 5, bootswatch = "flatly"), # Optional: modern Bootstrap theme

  br(),
  panel(
    heading = h3("🖊️ Draw a Digit"),
    status = "primary",
    solidHeader = TRUE,
    collapsible = FALSE,

    fluidRow(
      column(
        width = 6,

        tags$p(
          "Click on the plot to start drawing. Move the mouse to draw, and click again to stop."
        ),

        plotOutput(
          "plot",
          width = "380px",
          height = "380px",
          hover = hoverOpts(
            id = "hover",
            delay = 100,
            delayType = "throttle",
            clip = TRUE,
            nullOutside = TRUE
          ),
          click = "click"
        ),

        br(),
        fluidRow(
          column(
            width = 12,
            actionBttn(
              "reset",
              "Reset",
              style = "material-flat",
              color = "danger",
              icon = icon("redo")
            ),
            actionBttn(
              "predict",
              "Predict",
              style = "material-flat",
              color = "success",
              icon = icon("search")
            )
          )
        )
      ),

      column(
        width = 6,

        h4("Model Output", class = "section-title"),

        wellPanel(
          style = "background-color: #f9fcff; border-radius: 10px;",

          h5("Preprocessed Image:"),
          plotOutput("digit_image", width = "200px", height = "200px"),

          br(),

          h5("Prediction:"),
          tags$div(
            style = "font-size:2em; font-weight:bold; color:#2c3e50;",
            textOutput("prediction")
          )
        )
      )
    )
  )
)
