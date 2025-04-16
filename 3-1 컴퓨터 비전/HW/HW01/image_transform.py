import cv2, skimage.data
import numpy as np
import matplotlib.pyplot as plt

def image_difference(image1, image2, name):
    d = np.sum((image1 - image2) ** 2)  
    diff = d / float(512 * 512)
    print(f"{name}\'s difference: {diff}")

def printImage(image, name):
    plt.imshow(image)
    plt.title(name)
    plt.show()
    
def rotation(I, a, name): #I: image, a: angle
    M = np.array(
        [[np.cos(a), -np.sin(a), 1],
        [np.sin(a), np.cos(a), 1]], dtype=np.float32)

    rotation_image = cv2.warpAffine(I, M, (0, 0))

    printImage(rotation_image, name)

    return rotation_image

def similarity(I, s, a, x, y, name):
    M = np.array(
        [[s*np.cos(a), -s*np.sin(a), x],
         [s*np.sin(a), s*np.cos(a), y]], dtype=np.float32)

    similarity_image = cv2.warpAffine(I, M, (0,0))

    printImage(similarity_image, name)

    return similarity_image


def affine(I, scale, shear, name):
    M = np.array(
        [[scale, shear, 0],
         [shear, scale, 0]], dtype=np.float32) 

    affine_image = cv2.warpAffine(I, M, (0, 0))

    printImage(affine_image, name)

    return affine_image

def projective(I, M, name):
    projective_image = cv2.warpPerspective(I, M, (0, 0))

    printImage(projective_image, name)

    return projective_image


image = skimage.data.astronaut()
print(image.shape) # (512, 512, 3)

printImage(image, "Original image")

r_test = cv2.imread("rotation_test.jpg")
rotation_test = cv2.resize(r_test, (512, 512))
image_difference(rotation(image, 0.305, "Rotation"), rotation_test, "Rotation transformation")

s_test = cv2.imread("similarity_test.jpg")
similarity_test = cv2.resize(s_test, (512, 512))
image_difference(similarity(image, 0.5, 0.45, -1, -1, "Similarity transformation"), similarity_test, "Similarity")

a_test = cv2.imread("affine_test.jpg")
affine_test = cv2.resize(a_test, (512, 512))
image_difference(affine(image, 0.77, 0.28, "Affine"), affine_test, "Affine transformation")

p_test = cv2.imread("projective_test.jpg")
projective_test = cv2.resize(p_test, (512, 512))
m = np.array(
        [[1, 0.1, 0],
         [1, 0.8, 0], 
         [0.001, 0.0003, 1]], dtype=np.float32) 
image_difference(projective(image, m, "Projective"), projective_test, "Projective transformation")

# 내 이미지로 테스팅
img = cv2.imread("dog.jpg")
myImage = cv2.resize(img, (512, 512))
plt.imshow(myImage)
plt.show()

rotation(myImage, -0.25, "My image rotation transformation")

similarity(myImage, 1.2, 0.9, -1, -1, "My image similarity transformation")

affine(myImage, 0.77, -0.1, "My image affine transformation")

pm = np.array(
        [[1, 0.1, 0],
         [1, 0.8, 0], 
         [-0.001, 0.0003, 1]], dtype=np.float32) 
projective(myImage, pm, "My image projective transformation")