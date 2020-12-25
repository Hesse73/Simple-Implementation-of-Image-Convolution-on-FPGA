import numpy as np
import cv2
kernel = [[1, 0, 0], [1, 255, 0], [0, 1, 255]]
kernel  = np.asarray(kernel,dtype=np.int8)
img = cv2.imread('lenna.jpg')
row, col, channel = img.shape
blue = np.ones((row,col),dtype=np.int8)
for x in range(row):
    for y in range(col):
        blue[x][y] = img[x][y][0]
out = cv2.filter2D(blue,-1,kernel)
cv2.imwrite('testbin.bin',out)