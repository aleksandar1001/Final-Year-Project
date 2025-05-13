
import tensorflow as tf
from sklearn.utils import shuffle
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
import numpy as np
import pandas as pd
import os
from PIL import Image
import re
import cv2 as cv
import matplotlib.pyplot as plt

ImageDataGenerator = tf.keras.preprocessing.image.ImageDataGenerator
Sequential = tf.keras.models.Sequential
Conv2D = tf.keras.layers.Conv2D
Activation = tf.keras.layers.Activation
MaxPooling2D = tf.keras.layers.MaxPooling2D
Flatten = tf.keras.layers.Flatten
Dropout = tf.keras.layers.Dropout
Dense = tf.keras.layers.Dense



#-------------------------------------------DATASET---------------------------------------------------------
image_path = 'kaggle/car_logos/images/'
imgs = os.listdir(image_path)  #imena slika u formi niza
img_x = img_y = 50   #dimenzije slika
n_samples = np.size(imgs)
#print(n_samples) ima 20778 slika u datasetu

images = []

for img in imgs:
    temp = Image.open(image_path + img).convert("RGB")
    temp = temp.resize((img_x, img_y))
    temp = np.array(temp).flatten()
    images.append(np.array(temp, dtype='uint8'))

#print(np.shape(images))  #(20778, 7500)

cars = ['Alfa Romeo', 'Audi', 'BMW', 'Chevrolet', 'Citroen', 'Dacia', 'Daewoo', 'Dodge',
        'Ferrari', 'Fiat', 'Ford', 'Honda', 'Hyundai', 'Jaguar', 'Jeep', 'Kia', 'Lada',
        'Lancia', 'Land Rover', 'Lexus', 'Maserati', 'Mazda', 'Mercedes', 'Mitsubishi',
        'Nissan', 'Opel', 'Peugeot', 'Porsche', 'Renault', 'Rover', 'Saab', 'Seat',
        'Skoda', 'Subaru', 'Suzuki', 'Tata', 'Tesla', 'Toyota', 'Volkswagen', 'Volvo']
labels = []
#shorting on the basies of label
for i in range(n_samples):
    temp = cars.index(re.match(r"(^\D+)", imgs[i])[0])
    labels.append(np.array(temp))

#print(np.shape(labels))  (20778,)

dataset, labelset = shuffle(images, labels, random_state=42)  #mesanje podataka
training_data = [dataset, labelset]

X_train, X_test, y_train, y_test = train_test_split(training_data[0], training_data[1], test_size=0.2)
X_train = np.reshape(X_train, (np.shape(X_train)[0], img_x, img_x, 3))
X_test = np.reshape(X_test, (np.shape(X_test)[0], img_x, img_x, 3))

X_train = X_train.astype('float32') / 255
X_test = X_test.astype('float32') / 255

X_train = np.subtract(X_train, 0.5)
X_test = np.subtract(X_test, 0.5)

X_train = np.multiply(X_train, 2.0)
X_test = np.multiply(X_test, 2.0)

Y_train = tf.keras.utils.to_categorical(y_train, num_classes=len(cars))
Y_test = tf.keras.utils.to_categorical(y_test, num_classes=len(cars))

datagen = ImageDataGenerator(
    # featurewise_center=False,
    # samplewise_center=False,
    # featurewise_std_normalization=True,
    # samplewise_std_normalization=True,
    # zca_whitening=True,
    rotation_range=45,
    width_shift_range=0.2,
    height_shift_range=0.2,
    horizontal_flip=True,
    vertical_flip=True)
datagen.fit(X_train)

#X_train = X_train[:500]
#Y_train = Y_train[:500]
#X_test = X_test[:100]
#Y_test = Y_test[:100]

#-----------------------------------------NEURONSKA MREZE----------------------------------------------------
model = Sequential()

model.add(Conv2D(32, (3, 3), padding='valid', input_shape=(img_x, img_y, 1)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(64, (3, 3), padding='valid'))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(128, (3, 3), padding='valid'))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(256, (3, 3), padding='valid'))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Flatten())
model.add(Dense(4096, activation='relu', bias_initializer='glorot_uniform'))
model.add(Dropout(0.5))

model.add(Dense(4096, activation='relu', bias_initializer='glorot_uniform'))
model.add(Dropout(0.5))

model.add(Dense(40))
model.add(Activation('softmax'))

model.summary()

take_best_model = tf.keras.callbacks.ModelCheckpoint('model_filter.h5', verbose=0, save_freq=25, save_best_only=False)
optimizer = tf.keras.optimizers.Adam(lr=0.005)
model.compile(loss='categorical_crossentropy', optimizer=optimizer, metrics=['categorical_accuracy'])

n_epochs = 10
batch = 128

model.fit_generator(datagen.flow(X_train, Y_train, batch_size=batch), steps_per_epoch=X_train.shape[0]//batch,
                    epochs=n_epochs, callbacks=[take_best_model], validation_data=(X_test, Y_test))

  #model.load_weights('/kaggle/input/car-logo-classification-weights/car_CNN_13AUGM_CMCMCMCMF.h5py')

scores = model.evaluate(X_test, Y_test)
print("Accuracy test: %.2f%%" % (scores[1]*100))


put_do_slike = input("Unesite put do logoa: ")

slika = cv.imread(put_do_slike)

slika = cv.cvtColor(slika, cv.IMREAD_GRAYSCALE)
dim = (50, 50)
slika_resize = cv.resize(slika, dim)
cv.imshow("Slika ", slika)
cv.waitKey(0)


plt.imshow(slika_resize, cmap=plt.cm.binary)

prediction = model.predict(np.array([slika_resize]) / 255)
index = np.argmax(prediction)
print(f'Na slici se nalazi {cars[index]}')