library(keras)

#first try
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

# reshape
x_train <- array_reshape(x_train, c(nrow(x_train), 784))
x_test <- array_reshape(x_test, c(nrow(x_test), 784))
# rescale
x_train <- x_train / 255
x_test <- x_test / 255


y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)


model <- keras_model_sequential()
model %>%
  layer_dense(units = 256, activation = "relu", input_shape = c(784)) %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 10, activation = "softmax")
model

model %>%
  compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_rmsprop(),
    metrics = c("accuracy")
  )

history <- model %>%
  fit(
    x_train,
    y_train,
    epochs = 30,
    batch_size = 128,
    validation_split = 0.2
  )

model %>% evaluate(x_test, y_test)

predictions <- model %>% predict(x_test) %>% k_softmax()


#CNN -> best model
dim(x_train)
img_rows <- 28
img_cols <- 28

x_train <- array_reshape(x_train, c(nrow(x_train), img_rows, img_cols, 1))
x_test <- array_reshape(x_test, c(nrow(x_test), img_rows, img_cols, 1))

dim(x_train)

x_train <- x_train / 255
x_test <- x_test / 255

num_classes = 10
y_train <- to_categorical(y_train, num_classes)
y_test <- to_categorical(y_test, num_classes)


modelconv <- keras_model_sequential()
modelconv %>%
  layer_conv_2d(
    filters = 8,
    kernel_size = c(3, 3),
    padding = "same",
    input_shape = c(28, 28, 1)
  ) %>%
  layer_max_pooling_2d() %>%
  layer_conv_2d(filters = 4, kernel_size = c(3, 3), padding = "same") %>%
  layer_max_pooling_2d() %>%
  layer_flatten() %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 10, activation = "softmax")

modelconv


modelconv %>%
  compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_adam(),
    metrics = c("accuracy")
  )


history <- modelconv %>%
  fit(
    x_train,
    y_train,
    epochs = 10, #batch_size = 128,
    validation_split = 0.2
  )

modelconv %>% evaluate(x_test, y_test)

save_model_hdf5(modelconv, "CNNmnist.hdf5")
