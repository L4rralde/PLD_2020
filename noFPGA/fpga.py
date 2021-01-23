import serial

def readData():
	data = ser.read(2)
	sel = 0
	if(data[0]>128):#
		sel = 1 
	temp = data[sel]+128*(data[1-sel]%2)
	tempmod = int(data[1-sel]/2)%8 
	velmod = int(data[1-sel]/16)%8
	return (temp, velmod, tempmod)

from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def index(): 
	#t.start()
	ser = serial.Serial(port = "COM4", baudrate=9600,
                           bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
	data = ser.read(2)
	sel = 0
	if(data[0]>128):#
		sel = 1 
	temp = data[sel]+128*(data[1-sel]%2)
	tempmod = int(data[1-sel]/2)%8 
	velmod = int(data[1-sel]/16)%8
	return """
	<!doctype html>
		<html>
		<head><meta http-equiv="refresh" content="0.5">
			<title>Agitador Magnético</title>
			</head>
			<body>
				<h1>Agitador Magnético</h1>
				<p>Velocidad seleccionada: {}</p>
				<p>Temperatura seleccionada: {}</p>
				<p>Temperatura medida: {} °C</p>
			</body>
		</html>
	""".format(velmod, tempmod, temp)
