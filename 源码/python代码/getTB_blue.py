import cv2
import numpy as np
img = cv2.imread(r'C:\Users\14570\Desktop\Python\fpga-convolution\lenna.jpg')
row, col, channel = img.shape
out = []
kernel = [[1, 0, 0], [1, 255, 0], [0, 1, 255]]
kernel = np.asarray(kernel,dtype=np.int8)
#write test byte 
out.append(np.int8(0xff))
for x in range(3):
    for y in range(3):
            #out.append(bytes(kernel[x][y][0]))
            out.append(kernel[x][y])
for y in range(col):
    out.append(img[0][y][0])
for x in range(row):
    out.append(img[x][0][0])
    for y in range(col):
        out.append(img[x][y][0])
    out.append(img[x][col-1][0])
for y in range(col):
    out.append(img[row-1][y][0])
file = open('TB_Blue.v','w',encoding='utf-8')
start = 'module	testbench();\nreg clk,rst,rx;\nwire tx;\ntop test(.clk(clk),.rst(rst),.rx(rx),.tx(tx));\ninitial\nbegin\n    rst = 1;\n    #50000 rst = 0;\n    #20000000 $stop;\nend\ninitial\nbegin\n    clk = 0;\n    forever #1 clk = ~clk;\nend\ninitial\nbegin\n    //每一帧以866开始（0），8个1736数据位，再以866（0）结束\n    rx = 0;\n    #50000      rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 1;\n    #1736       rx = 0;\n    #866        rx = 0;'
end = '\nend\nendmodule\n'
'''
    #866        rx = 0;
    #866        rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 1;
    #1736       rx = 0;
    #866        rx = 0;
'''
head = '\n    #866        rx = 0;'
tail = '\n    #1736       rx = 0;\n    #866        rx = 0;'
file.write(start)
for num in range(1200):
    file.write('\n//num == '+str(num)+'\n')
    file.write(head)
    binlist = [int(i) for i in list('{0:0b}'.format((out[num]%256)))] 
    for i in range(8 - len(binlist)):
        binlist.insert(0,0)
    binlist.reverse()
    for i in range(8):
        if(i==0):
            body = '\n    #866        rx = '+str(binlist[i])+';'
        else:
            body = '\n    #1736       rx = '+str(binlist[i])+';'
        file.write(body)
    file.write(tail)
file.write(end)