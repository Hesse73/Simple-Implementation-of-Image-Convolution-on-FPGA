import cv2
import numpy as np
file = open('test.bin', 'wb')
kernel = [[[1, 1, 255], [0, 1, 1], [0, 0, 0]],
          [[1, 255, 0], [255, 255, 1], [0, 0, 1]],
          [[0, 255, 1], [1, 0, 255], [255, 0, 1]]]
kernel = np.asarray(kernel,dtype=np.int8)
file.write(np.int8(0xff))
for x in range(3):
    for y in range(3):
        for c in range(3):
            #file.write(bytes(kernel[x][y][c]))
            file.write(kernel[x][y][c])
for x in range(12):
    for i in range(3):
        file.write(np.int8(x))
file.close()