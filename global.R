library(shiny)
library(keras)   # per il modello
library(imager)
library(shinyWidgets)

model <- load_model_hdf5("CNNmnist.hdf5")

  process_image <- function(x, y) {
    require(imager)
    img_big <- matrix(0, 56, 56)
    
    n <- length(x)
    for (i in 2:n) {
      if (!is.na(x[i-1]) & !is.na(x[i]) & !is.na(y[i-1]) & !is.na(y[i])) {
        xs <- seq(x[i-1], x[i], length.out = 20) * 2  # scala su 56x56
        ys <- seq(y[i-1], y[i], length.out = 20) * 2
        for (j in seq_along(xs)) {
          for (dx in -2:2) for (dy in -2:2) {
            xx <- round(xs[j]) + dx
            yy <- round(ys[j]) + dy
            if (xx >= 1 && xx <= 56 && yy >= 1 && yy <= 56) {
              img_big[57 - yy, xx] <- 1
            }
          }
        }
      }
    }
    # Blur per rendere più simile a scrittura vera
    img <- as.cimg(img_big)
    img <- isoblur(img, sigma = 2.2)
    img <- as.matrix(img)
    img <- img / max(img)
    
    # Ritaglia bounding box intorno alla cifra
    thr <- 0.05
    rows <- which(apply(img, 1, max) > thr)
    cols <- which(apply(img, 2, max) > thr)
    if (length(rows) < 2 || length(cols) < 2) return(matrix(0, 28, 28))
    img_crop <- img[min(rows):max(rows), min(cols):max(cols)]
    
    # Ridimensiona a 20x20 (stile MNIST centrato)
    img_cropped <- as.cimg(img_crop)
    img_resize <- resize(img_cropped, size_x = 20, size_y = 20)
    img_resize <- as.matrix(img_resize)
    
    # Centra su canvas 28x28
    final_img <- matrix(0, 28, 28)
    x_off <- floor((28 - 20) / 2)
    y_off <- floor((28 - 20) / 2)
    final_img[(1 + y_off):(20 + y_off), (1 + x_off):(20 + x_off)] <- img_resize
    
    # Normalizza
    final_img <- final_img / max(final_img)
    final_img[is.na(final_img)] <- 0
    
    return(final_img)
  }