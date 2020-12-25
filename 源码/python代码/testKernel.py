import cv2
import numpy as np
import time
img = cv2.imread('lenna.jpg')
start = time.time()
b, g, r = cv2.split(img)
kernelR = [[1, 1, 0], [-1, -1, 0], [-1, 0, 0]]
kernelB = [[1, 0, 0], [1, -1, 0], [0, 1, -1]]
kernelG = [[-1, 1, 0], [0, 1, 1], [1, -1, 1]]
kernelB = np.asfarray(kernelB)
kernelG = np.asfarray(kernelG)
kernelR = np.asfarray(kernelR)
b = cv2.filter2D(b, -1, kernelB)
g = cv2.filter2D(g, -1, kernelG)
r = cv2.filter2D(r, -1, kernelR)
out = b + g+r
end = time.time()
cv2.imshow('out',out)
cv2.waitKey(0)
print(end-start)