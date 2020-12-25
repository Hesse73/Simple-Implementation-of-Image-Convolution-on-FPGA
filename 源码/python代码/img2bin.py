'''
需要更改文件格式，改为三通道先后计算
'''
import cv2
import numpy as np
img = cv2.imread('lenna.jpg')
row, col, channel = img.shape
file = []
file.append(open('lennab.bin', 'wb'))
file.append(open('lennag.bin', 'wb'))
file.append(open('lennar.bin', 'wb'))
kernel = [[[1, 1, 255], [0, 1, 1], [0, 0, 0]],
          [[1, 255, 0], [255, 255, 1], [0, 0, 1]],
          [[0, 255, 1], [1, 0, 255], [255, 0, 1]]]
kernel = np.asarray(kernel,dtype=np.int8)
#write test byte 
for c in range(3):
    file[c].write(np.int8(0xff))
for x in range(3):
    for y in range(3):
        for c in range(3):
            #file.write(bytes(kernel[x][y]))
            file[c].write(kernel[x][y][c])
for c in range(3):
    file[c].write(img[0][0][c])
for y in range(col):
    for c in range(channel):
        file[c].write(img[0][y][c])
for c in range(3):
    file[c].write(img[0][col-1][c])
for x in range(row):
    for c in range(channel):
        file[c].write(img[x][0][c])
    for y in range(col):
        for c in range(channel):
            file[c].write(img[x][y][c])
    for c in range(channel):
        file[c].write(img[x][col-1][c])
for c in range(3):
    file[c].write(img[row-1][0][c])
for y in range(col):
    for c in range(channel):
        file[c].write(img[row-1][y][c])
for c in range(3):
    file[c].write(img[row-1][col-1][c])
for c in range(3):
    file[c].close()
