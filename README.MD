# 🖊️ Shiny Digit Recognizer

This is a simple and interactive **Shiny App** for handwritten digit recognition. It uses a **Convolutional Neural Network (CNN)** trained on the **MNIST** dataset via `keras`, allowing users to draw a digit directly in the UI and get a real-time prediction.

## 📸 Preview

![shinyapp_demo](preview.gif) <!-- Add a GIF or screenshot of your app here -->

---

## 🚀 Features

- Freehand digit drawing (0-9) on a 28x28 canvas
- Automatic image preprocessing:
  - Cropping
  - Resizing
  - Blurring and centering on a 28x28 canvas
- Real-time prediction using a pre-trained CNN model
- Display of both preprocessed image and predicted digit

---

## 🧠 Model

The CNN model is trained on the **MNIST** dataset and saved in `.hdf5` format (`CNNmnist.hdf5`). Make sure the model file is placed in the root directory of the app.

---

## 📦 Dependencies

Install the required R packages:

```r
install.packages("shiny")
install.packages("imager")
# keras requires TensorFlow backend
install.packages("keras")
keras::install_keras()
```