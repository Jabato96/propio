#!/usr/bin/python
import signal, sys, time, webbrowser
import platform
#print("Estamos en {}".format(sistema))

def def_handler(sig,frame):
 print("\n\n[*]Saliendo[*]")
 sys.exit(1)

#Ctrl+C
 signal.signal(signal.SIGINT,def_handler)

#Variables globales
Url = "https://www.speedguide.net/port.php?port="
Url2 = "https://es.adminsub.net/tcp-udp-port-finder/"
puerto = sys.argv[1:]
#print("Son los puertos: %s" %puertos)

def puertos():
 for i in puerto:
  #print ("Puerto: %s" %i)
  sistema = platform.system()
  if sistema == "Windows":
   chrome_path = 'C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe %s'
   webbrowser.get(chrome_path).open(Url+i)
   webbrowser.get(chrome_path).open(Url2+i)
   
  if sistema == "Linux":
   chrome_path = '/usr/bin/google-chrome %s'
   webbrowser.get(chrome_path).open(Url+i)
   webbrowser.get(chrome_path).open(Url2+i)
 
if __name__=='__main__':
 puertos()