import numpy as np
import cv2
import struct
def conv(img, kernel):
    out_img = np.ones((500,500),dtype=np.int8)
    for x in range(500):
        for y in range(500):
            out_img[x][y] = kernel[0][0]*img[x][y] + kernel[0][1]*img[x][y+1] + kernel[0][2]*img[x][y+2] + kernel[1][0]*img[x+1][y] + kernel[1][1] * \
                img[x+1][y+1] + kernel[1][2]*img[x+1][y+2]+kernel[2][0]*img[x + 2][y] + kernel[2][1]*img[x+2][y+1] + kernel[2][2]*img[x+2][y+2]
    return out_img

kernel = [[1, 0, 0], [1, 255, 0], [0, 1, 255]]
kernel  = np.asarray(kernel)
img = cv2.imread('lenna.jpg')
row,col,channel = img.shape
img,g,r = cv2.split(img)
content = np.ones((502,502),dtype=np.int8)
content[0][0] = img[0][0]
content[0][501] = img[0][col-1]
content[501][0] = img[row-1][0]
content[501][501] = img[row-1][col-1]
for y in range(col):
    content[0][y] = img[0][y]
    content[501][y] = img[row-1][y]
for x in range(row):
    content[x+1][0] = img[x][0]
    content[x+1][501] = img[x][col-1]
    for y in range(col):
        content[x+1][y+1] = img[x][y]
out = conv(content,kernel)
with open('out.bin','w') as file:
    for i in out:
        file.write(str(i)+' ')