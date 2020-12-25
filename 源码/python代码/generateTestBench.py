import cv2
import numpy as np
img = cv2.imread('lenna.jpg')
row, col, channel = img.shape
out = []
kernel = [[[1, 1, 255], [0, 1, 1], [0, 0, 0]],
          [[1, 255, 0], [255, 255, 1], [0, 0, 1]],
          [[0, 255, 1], [1, 0, 255], [255, 0, 1]]]
kernel = np.asarray(kernel,dtype=np.int8)
#write test byte 
for x in range(3):
    for y in range(3):
        for c in range(3):
            #out.append(bytes(kernel[x][y][c]))
            out.append(kernel[x][y][c])
for y in range(col):
    for c in range(channel):
        out.append(img[0][y][c])
for x in range(row):
    for c in range(channel):
        out.append(img[x][0][c])
    for y in range(col):
        for c in range(channel):
            out.append(img[x][y][c])
    for c in range(channel):
        out.append(img[x][col-1][c])
for y in range(col):
    for c in range(channel):
        out.append(img[row-1][y][c])
file = open('testbench.v','w',encoding='utf-8')
start = 'module	testbench();\nreg clk,rst,rx;\nwire tx;\ntop test(.clk(clk),.rst(rst),.rx(rx),.tx(tx));\ninitial\nbegin\n    rst = 1;\n    #50000 rst = 0;\n    #20000000 $stop;\nend\ninitial\nbegin\n    clk = 0;\n    forever #1 clk = ~clk;\nend\ninitial\nbegin\n    //每一帧以866开始（0），8个1736数据位，再以866（0）结束\n    rx = 0;\n    #100000      rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 0;\n    #1736        rx = 0;'
end = '\nend\nendmodule\n'
'''
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 0;
    #1736       rx = 0;
    
'''
tail = '\n    #1736       rx = 0;\n    #1736        rx = 0;'
file.write(start)
for num in range(1200):
    file.write('\n //num = '+str(num)+'\n')
    binlist = [int(i) for i in list('{0:0b}'.format((out[num]%256)))] 
    for i in range(8 - len(binlist)):
        binlist.insert(0,0)
    binlist.reverse()
    for i in range(8):
        body = '\n    #1736       rx = '+str(binlist[i])+';'
        file.write(body)
    file.write(tail)
file.write(end)