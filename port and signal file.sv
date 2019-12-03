dma_if
CLK
RESET

dif.
CS_N
IOR_N
IOW_N


drf.

[7:0]baseAddrReg[4]
[7:0]baseWordReg[4]
[7:0]currAddrReg[4]
[5:0]modeReg[4]
[7:0]tempAddrReg
[7:0]currWordReg[4]
[7:0]tempWordReg
[7:0]commandReg
[7:0]requestReg
[7:0]maskReg
[7:0]tempReg
[7:0]statusReg
[7:0]readBuf 
[7:0]writeBuf 
FF
masterClear

cif.
Program
ioAddrBuf
TC[4]
enCurrReg
ldTempCurrAddr    // to load tempAddrReg to currAddrReg
ldTempCurrWord   // to load tempWordReg to currWordReg
[3:0]outAddrBuf
[3:0]ioAddrBuf
ldCurrAddrTemp   // to load currAddrReg into tempAddrReg
ldCurrWordTemp    // to load currWordReg into tempWordReg
[7:0]ioDataBuf
enReadBuf     // to load data from read buffer to io data buffer
enWriteBuf     // to load data into write buffer from the io data buffer
