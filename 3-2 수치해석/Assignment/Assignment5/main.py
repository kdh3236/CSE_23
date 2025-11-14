import os
import sys
import cv2
import numpy as np

IMAGE_DIR = './images'

def safe_value(image, y, x):
    h, w, c = image.shape

    if 0 <= y < h and 0 <= x < w:
        return image[y, x].astype(np.float32)
    else: # 경계 밖: Zero Padding
        return np.zeros((c,), dtype=np.float32) # c채널 0으로 반환
    
def interpolation(p0, p1, p2, p3, dx, dy):    
    return (1 - dy) * ((1 - dx) * p0 + dx * p2) + dy * ((1 - dx) * p1 + dx * p3)

def upsample(image, new_height, new_width):
    h, w, c = image.shape
    resized_image = np.zeros((new_height, new_width, c), dtype=np.uint8)

    x_ratio = w / new_width  
    y_ratio = h / new_height

    for y in range(new_height):
        for x in range(new_width):
            new_x = x * x_ratio   
            new_y = y * y_ratio

            int_x = int(new_x)
            int_y = int(new_y)

            dx = new_x - int_x
            dy = new_y - int_y

            p11 = safe_value(image, int_y, int_x)
            p21 = safe_value(image, int_y, int_x+1)
            p12 = safe_value(image, int_y+1, int_x)
            p22 = safe_value(image, int_y+1, int_x+1)

            value = interpolation(p11, p12, p21, p22, dx, dy)

            resized_image[y, x] = np.clip(value, 0, 255).astype(np.uint8)

    return resized_image

def downsample(image, new_height, new_width):
    h, w, c = image.shape 
    resized_image = np.zeros((new_height, new_width, c), dtype=np.uint8)

    x_ratio = w / new_width
    y_ratio = h / new_height

    for y in range(new_height):
        for x in range(new_width):
            new_x = x * x_ratio   
            new_y = y * y_ratio

            int_x = int(new_x)
            int_y = int(new_y)

            dx = new_x - int_x
            dy = new_y - int_y

            # 이미지 크기 벗어나면 잘라냄
            x1 = min(int_x + 1, w - 1)
            y1 = min(int_y + 1, h - 1)

            p11 = image[int_y, int_x].astype(np.float32)
            p21 = image[int_y, x1].astype(np.float32)
            p12 = image[y1, int_x].astype(np.float32)
            p22 = image[y1, x1].astype(np.float32)

            value = interpolation(p11, p12, p21, p22, dx, dy)

            resized_image[y, x] = np.clip(value, 0, 255).astype(np.uint8)

    return resized_image


def main(new_height, new_width):
    original_image = cv2.imread(os.path.join(IMAGE_DIR, 'original_dog.png'))

    # 원본 이미지 출력
    print("Original Image Shape:", original_image.shape)
    cv2.imshow('Original Image', original_image)

    # Resampling
    if new_height > original_image.shape[0] or new_width > original_image.shape[1]: # upsampling
        custom_resampled_image = upsample(original_image, new_height, new_width)
        opencv_resampled_image = cv2.resize(original_image, (new_width, new_height), interpolation=cv2.INTER_LINEAR)
    else: # downsampling
        custom_resampled_image = downsample(original_image, new_height, new_width)
        opencv_resampled_image = cv2.resize(original_image, (new_width, new_height), interpolation=cv2.INTER_LINEAR)

    # 결과 출력
    print("Resampled Image using custom function Shape:", custom_resampled_image.shape)
    cv2.imshow("Resampled image using custom function", custom_resampled_image)

    print("Resampled Image using opencv library function Shape:", opencv_resampled_image.shape)
    cv2.imshow("Resampled image using opencv library function", opencv_resampled_image)
    cv2.waitKey()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main(int(sys.argv[1]), int(sys.argv[2]))