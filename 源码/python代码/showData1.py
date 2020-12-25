import numpy as np
import cv2
import struct
from array import array

#kernel = [[1,0,0],[1,-1,0],[0,1,-1]]
#kernel = np.asfarray(kernel)
#img = cv2.imread('lenna.jpg')
#b,g,r = cv2.split(img)
#b = cv2.filter2D(b,-1,kernel)
#cv2.imshow('b',b)
#cv2.waitKey(0)

data = open('out1.DAT','rb')

content = array('B')
content.fromfile(data, 126003)
data.close()
Sum = 502*502
out = np.ones(Sum)
for i in range(int(Sum/2 - 1)):
    num = content[i]
    out[2*i] = num
    out[2*i+1] = num
img = np.ones((502,502),dtype=np.uint8)
for x in range(502):
    for y in range(502):
        img[x][y] = out[502*x + y]
cv2.imshow('img',img)
cv2.waitKey(0)

