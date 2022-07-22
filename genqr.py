#! /usr/bin/python
import pyqrcode, png, sys

def creationqr():
 url = "%s" %sys.argv[1]
 qr_code = pyqrcode.create(url)
 imagen = sys.argv[2]
 qr_code.png(imagen, scale=5)

def helpanel():
   print("usage python3 genqr.py +url +Name of image")

if __name__ == '__main__':
    if len(sys.argv) < 3:
      helpanel()
    else:
     creationqr()
   
