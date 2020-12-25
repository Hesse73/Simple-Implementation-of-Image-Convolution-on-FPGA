import numpy as np
import cv2
import struct
from array import array

#kernel = [[1,0,0],[1,-1,0],[0,1,-1]]
#kernel = np.asfarray(kernel)
#img = cv2.imread(r'lenna.jpg')
#b,g,r = cv2.split(img)
#b = cv2.filter2D(b,-1,kernel)
#cv2.imshow('b',b)
#cv2.waitKey(0)

data = open(r'out3.DAT','rb')

content = array('B')
content.fromfile(data, 500*501)
data.close()
Sum = 500*501
out = np.ones(Sum)
for i in range(Sum):
    num = content[i]
    out[i] = num
img = np.ones((500,501),dtype=np.uint8)
for x in range(500):
    for y in range(501):
        img[x][y] = out[501*x + y]
cv2.imshow('img',img)
cv2.waitKey(0)

