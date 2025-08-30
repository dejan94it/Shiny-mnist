
server <- function(input, output, session) {
  vals = reactiveValues(x = NULL, y = NULL)
  draw = reactiveVal(FALSE)
  predicted_text = reactiveVal(NULL)

  # Carica il modello Keras una sola volta

  observeEvent(input$click, handlerExpr = {
    temp <<- draw()
    draw(!temp)
    if (!draw()) {
      vals$x <- c(vals$x, NA)
      vals$y <- c(vals$y, NA)
    }
  })

  observeEvent(input$reset, handlerExpr = {
    vals$x <- NULL
    vals$y <- NULL
    predicted_text(NULL)
  })

  observeEvent(input$hover, {
    if (draw()) {
      vals$x <- c(vals$x, input$hover$x)
      vals$y <- c(vals$y, input$hover$y)
    }
  })

  output$plot = renderPlot({
    plot(
      x = vals$x,
      y = vals$y,
      xlim = c(0, 28),
      ylim = c(0, 28),
      ylab = "y",
      xlab = "x",
      type = "l",
      lwd = 30
    )
  })

  output$digit_image <- renderPlot({
    req(vals$x, vals$y)
    img <- process_image(vals$x, vals$y)
    par(mar = c(0, 0, 0, 0))
    image(
      t(apply(img, 2, rev)),
      col = gray.colors(256, start = 0, end = 1),
      axes = FALSE
    )
  })

  observeEvent(input$predict, {
    req(vals$x, vals$y)
    img <- process_image(vals$x, vals$y)
    input_array <- array_reshape(img, c(1, 28, 28, 1))
    input_array <- input_array / max(input_array)

    pred <- as.array(model$predict(input_array))
    class <- which.max(pred) - 1
    predicted_text(paste(class))
  })

  output$prediction <- renderText({
    predicted_text()
  })
}
