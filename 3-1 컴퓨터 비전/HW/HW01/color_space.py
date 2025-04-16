import cv2, skimage.data
import numpy as np
import matplotlib.pyplot as plt

def printForOneChannel(image, name, option):
    plt.imshow(image, cmap = option) 
    plt.title(name)
    plt.show()

def printForAllChannels(image, name):
    plt.imshow(image)
    plt.title(name)
    plt.show()

class RGB:
    def __init__(self, r, g, b):
        self.R = r
        self.G = g
        self.B = b

    def make_rgb(self):
        return self.R, self.G, self.B

    def blue_incresing(self, value):
        self.B = np.add(self.B, value)
        self.B = np.clip(self.B, 0, 255).astype(np.uint8)
        return self.B
    
    def printRGB (self):
        printForOneChannel(self.R, "Red", "gray")
        printForOneChannel(self.G, "Green", "gray") 
        printForOneChannel(self.B, "Blue", "gray")

class HSI():
    def __init__(self, r, g, b):
        self.R = r.astype(float)
        self.G = g.astype(float)
        self.B = b.astype(float)
        self.h = np.zeros((512, 512), dtype=float) 
        self.s = np.zeros((512, 512), dtype=float)
        self.i = np.zeros((512, 512), dtype=float)
        self.newR = np.zeros((512, 512), dtype=float)
        self.newG = np.zeros((512, 512), dtype=float)
        self.newB = np.zeros((512, 512), dtype=float)

    def make_hsi(self):
        Rn = self.R / 255.0
        Gn = self.G / 255.0
        Bn = self.B / 255.0

        for i in range(512):
            for j in range(512):
                # Intensity
                self.i[i][j] = (Rn[i][j] + Gn[i][j] + Bn[i][j]) / 3
                
                # Saturation
                if (self.i[i][j] == 0): self.i[i][j] += 0.0001
                self.s[i][j] = 1 - (np.min([Rn[i][j], Gn[i][j], Bn[i][j]]) / self.i[i][j])

                # Hue
                temp = (2 * np.sqrt((Rn[i][j] - Gn[i][j]) ** 2 + (Rn[i][j] - Bn[i][j]) * (Gn[i][j] - Bn[i][j])))
                if (temp == 0): temp += 0.0001
                angle = (2 * Rn[i][j] - Gn[i][j] - Bn[i][j]) / temp
                angle = np.clip(angle, -1, 1)   
                self.h[i][j] = np.arccos(angle) / (2 * np.pi)
                if Bn[i][j] > Gn[i][j]:
                    self.h[i][j] = 1 - self.h[i][j]

        self.h = np.clip(self.h, 0, 1)
        self.s = np.clip(self.s, 0, 1)
        self.i = np.clip(self.i, 0, 1)

        return self.h, self.s, self.i

    def hsi_to_rgb(self):
        for i in range(512):
            for j in range(512):
                H = self.h[i][j] * 2 * np.pi  
                S = self.s[i][j]
                I = self.i[i][j]
                
                # 0 <= H < 2π/3
                if 0 <= H < 2 * np.pi/3:
                    self.newB[i][j] = I * (1 - S)
                    temp = np.cos(np.pi/3 - H)
                    if temp == 0: temp += 0.0001
                    self.newR[i][j] = I * (1 + (S * np.cos(H)) / temp)
                    self.newG[i][j] = 3 * I - (self.newR[i][j] + self.newB[i][j])
                
                # 2π/3 <= H < 4π/3
                elif 2 * np.pi/3 <= H < 4 * np.pi/3:
                    H = H - 2 * np.pi/3
                    self.newR[i][j] = I * (1 - S)
                    temp = np.cos(np.pi/3 - H)
                    if temp == 0: temp += 0.0001
                    self.newG[i][j] = I * (1 + (S * np.cos(H)) / temp)
                    self.newB[i][j] = 3 * I - (self.newR[i][j] + self.newG[i][j])
                
                # 4π/3 <= H < 2π
                elif 4 * np.pi/3 <= H < 2 * np.pi:
                    H = H - 4 * np.pi/3
                    self.newG[i][j] = I * (1 - S)
                    temp = np.cos(np.pi/3 - H)
                    if temp == 0: temp += 0.0001
                    self.newB[i][j] = I * (1 + (S * np.cos(H)) / temp)
                    self.newR[i][j] = 3 * I - (self.newG[i][j] + self.newB[i][j])

        self.newR = (np.clip(self.newR, 0, 1) * 255).astype(np.uint8)
        self.newG = (np.clip(self.newG, 0, 1) * 255).astype(np.uint8)
        self.newB = (np.clip(self.newB, 0, 1) * 255).astype(np.uint8)

        return self.newR, self.newG, self.newB

    def s_increasing(self, value):
        self.s = np.add(self.s, value)
        self.s = np.clip(self.s, 0, 1)
        return 0;

class YCbCr():
    def __init__(self, r, g, b):
        self.R = r.astype(float)
        self.G = g.astype(float)
        self.B = b.astype(float)

    def make_ycbcr(self):
        self.y = (77*self.R + 150*self.G + 29*self.B) / 256.0
        self.cb = ((-43*self.R - 84*self.G + 127*self.B) / 256.0) + 128
        self.cr = ((127*self.R - 106*self.G - 21*self.B) / 256.0) + 128

        self.y = np.clip(self.y, 0, 255).astype(np.uint8)
        self.cb = np.clip(self.cb, 0, 255).astype(np.uint8)
        self.cr = np.clip(self.cr, 0, 255).astype(np.uint8)
    
    def printYCbCr (self):
        print("Y min:", np.min(self.y), ", Y max:", np.max(self.y))
        print("Cb min:", np.min(self.cb), ", Cb max:", np.max(self.cb))
        print("Cr min:", np.min(self.cr), ", Cr max:", np.max(self.cr), end = "\n\n")

        printForOneChannel(self.y, "Luminance", "gray")
        printForOneChannel(self.cb, "Chroma Blue", "gray") 
        printForOneChannel(self.cr, "Chroma Red", "gray")


    
image = skimage.data.astronaut()
# rgb
rgb = RGB(image[:,:,0], image[:,:,1], image[:,:,2])
R, G, B = rgb.make_rgb()
rgb.printRGB()

# RGB to YCbCr
ycbcr = YCbCr(R, G, B)
ycbcr.make_ycbcr()
ycbcr.printYCbCr()

# RGB to HSI
hsi = HSI(R, G, B)
h, s, i = hsi.make_hsi()  

h = (np.clip(h, 0, 1) * 255).astype(np.uint8)
s = (np.clip(s, 0, 1) * 255).astype(np.uint8)
i = (np.clip(i, 0, 1) * 255).astype(np.uint8)

print("Hue min:", np.min(h), ", Hue max:", np.max(h))
print("Saturation min:", np.min(s), ", Saturation max:", np.max(s))
print("Intensity min:", np.min(i), ", Intensity max:", np.max(i), end = "\n\n")

printForOneChannel(h, "Hue", "gray")
printForOneChannel(s, "Saturation", "gray") 
printForOneChannel(i, "Intensity", "gray")

# Increasing Blue 
newB = rgb.blue_incresing(30)
BlueIncresedImage = np.stack((R, G, newB), axis=2)
BlueIncresedImage = np.clip(BlueIncresedImage, 0, 255).astype(np.uint8)
printForAllChannels(BlueIncresedImage, "Blue Increased Image")

# Increasing Saturation
hsi.s_increasing(0.2)
newr, newg, newb = hsi.hsi_to_rgb()
SaturationIncresedImage = np.stack((newr, newg, newb), axis=2)
SaturationIncresedImage = np.clip(SaturationIncresedImage, 0, 255).astype(np.uint8)
printForAllChannels(SaturationIncresedImage, "Saturation Increased Image")

# My image
img = cv2.imread("rainbow.jpg") # BGR 순서
myImage = cv2.resize(img, (512, 512))

# my RGB
myRGB = RGB(myImage[:,:,2], myImage[:,:,1], myImage[:,:,0])
myRGB.printRGB()
myR, myG, myB = myRGB.make_rgb()

# my YCbCr
myYcbcr = YCbCr(myR, myG, myB)
myYcbcr.make_ycbcr()
myYcbcr.printYCbCr()

# my HSI
myHsi = HSI(myR, myG, myB)
myH, myS, myI = myHsi.make_hsi()  

myH = (np.clip(myH, 0, 1) * 255).astype(np.uint8)
myS = (np.clip(myS, 0, 1) * 255).astype(np.uint8)
myI = (np.clip(myI, 0, 1) * 255).astype(np.uint8)

print("Hue min:", np.min(myH), ", Hue max:", np.max(myH))
print("Saturation min:", np.min(myS), ", Saturation max:", np.max(myS))
print("Intensity min:", np.min(myI), ", Intensity max:", np.max(myI), end = "\n\n")

printForOneChannel(myH, "Hue", "gray")
printForOneChannel(myS, "Saturation", "gray") 
printForOneChannel(myI, "Intensity", "gray")

# my RGB image, blue decreasing
myNewB = myRGB.blue_incresing(-75)
myBlueDecresedImage = np.stack((myR, myG, myNewB), axis=2)
myBlueDecresedImage = np.clip(myBlueDecresedImage, 0, 255).astype(np.uint8)
printForAllChannels(myBlueDecresedImage, "My Blue Decreased Image")

# my HSI image, saturation decreasing
myHsi.s_increasing(-0.5)
myNewr, myNewg, myNewb = myHsi.hsi_to_rgb()
mySaturationDecresedImage = np.stack((myNewr, myNewg, myNewb), axis=2)
mySaturationDecresedImage = np.clip(mySaturationDecresedImage, 0, 255).astype(np.uint8)
printForAllChannels(mySaturationDecresedImage, "My Saturation Decreased Image")

# HSI를 다시 확인
img2 = cv2.imread("racoon.jpg") # BGR 순서
myImage2 = cv2.resize(img2, (512, 512))
printForAllChannels(myImage2, "My image2")

# my RGB
myRGB2 = RGB(myImage2[:,:,2], myImage2[:,:,1], myImage2[:,:,0])
myR2, myG2, myB2 = myRGB2.make_rgb()

myHsi2 = HSI(myR2, myG2, myB2)
myH2, myS2, myI2 = myHsi2.make_hsi()  

myH2 = (np.clip(myH2, 0, 1) * 255).astype(np.uint8)
myS2 = (np.clip(myS2, 0, 1) * 255).astype(np.uint8)
myI2 = (np.clip(myI2, 0, 1) * 255).astype(np.uint8)

print("Hue min:", np.min(myH2), ", Hue max:", np.max(myH2))
print("Saturation min:", np.min(myS2), ", Saturation max:", np.max(myS2))
print("Intensity min:", np.min(myI2), ", Intensity max:", np.max(myI2), end = "\n\n")

printForOneChannel(myH2, "Hue", "gray")
printForOneChannel(myS2, "Saturation", "gray") 
printForOneChannel(myI2, "Intensity", "gray")