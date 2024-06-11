class Nave{
	var  velocidad = 0
	var  direccion = 0
	var  combustible = 0
	
	method acelerar(cuanto){velocidad = 100000.min(velocidad + cuanto)}
	method desacelerar(cuanto){velocidad = 0.max(velocidad - cuanto)}
	
	method irHaciaElSol(){direccion = 10}
	method escaparDelSol(){direccion = -10}
	method ponerseParaleloAlSol(){direccion = 0}
	
	method acercarseUnPocoAlSol(){direccion = 10.min(direccion + 1)} 
	method alejarseUnPocoDelSol(){direccion = -10.max(direccion - 1)}
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method cargarCombustible(cantidad){combustible+=cantidad}
	method descargarCombustible(cantidad){combustible = 0.max(combustible-cantidad)}
	
	method estaTranquila(){
		return (combustible >= 4000) and (velocidad <= 12000)
	}
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	method escapar()//metodo abstracto
	method avisar()//metodo abstracto
	
	method estaDeRelajo(){
		return self.estaTranquila() and self.pocaActividad()
	}
	
	method pocaActividad()//metodo abstracto
}


class NavesBaliza inherits Nave{
	var colorBaliza
	var cambio = false
	
	method cambiarColorDeBaliza(color){
		colorBaliza = color
		cambio = true
	}
	
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila(){
		return super() and colorBaliza != "rojo"
	}
	
	override method escapar(){self.irHaciaElSol()}	
	override method avisar(){self.cambiarColorDeBaliza("rojo")}
	
	override method pocaActividad(){return not cambio}
}

class NavesDePasajeros inherits Nave{
	const pasajeros
	var racionesDeComida = 0
	var racionesDeBebida = 0
	var racionesComidaServidas = 0
	
	method cargarComida(cantidad){racionesDeComida += cantidad}
	method cargarBebida(cantidad){racionesDeBebida += cantidad}
	method descargarComida(cantidad){racionesDeComida = 0.max(racionesDeComida-cantidad)}
	method descargarBebidas(cantidad){racionesDeBebida = 0.max(racionesDeBebida-cantidad)}
	
	method servirComida(cuanto){
		racionesComidaServidas += racionesDeComida.min(cuanto)
		self.descargarComida(cuanto)
	}
	
	
	override method prepararViaje(){
		super()
		self.cargarComida(pasajeros*4)
		self.cargarBebida(pasajeros*6)
		self.acercarseUnPocoAlSol()
	}
	
	override method escapar(){self.acelerar(velocidad)}
	override method avisar(){
		self.servirComida(pasajeros)
		self.descargarBebidas(pasajeros*2)
	}
	
	override method pocaActividad(){
		return racionesComidaServidas < 50
	}
}

class NavesDeCombate inherits Nave{
	var visible
	var misilesActivos
	const property mensajesEmitidos = []
	
	method ponerseVisible(){visible = true}
	method ponerseInvisible(){visible = false}
	method estaInvisible() = not visible
	
	method desplegarMisiles(){misilesActivos = true}
	method replegarMisiles(){misilesActivos = false}
	method misilesDesplegados() = misilesActivos
	
	method emitirMensaje(mensaje){mensajesEmitidos.add(mensaje)}
	method mensajesEmitidos() = mensajesEmitidos
	method primerMensajeEmitido() = mensajesEmitidos.first()
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	method esEscueta() = not mensajesEmitidos.any({m=>m.size()>30})
	//mensajes.all({m=>m.size()<=30}) otra forma
	method emitioMensaje(mensaje) =  mensajesEmitidos.contains(mensaje)
	
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	
	override method estaTranquila(){
		return super() and not self.misilesDesplegados()
	}
	
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){self.emitirMensaje("Amenaza recibida")}
	
	override method pocaActividad(){
		return self.esEscueta()
	}
}

class NaveHospital inherits NavesDePasajeros{
	var quirofanosPreparados = false
	
	method prepararQuirofanos(){quirofanosPreparados = true}
	method noPrepararQuirofanos(){quirofanosPreparados = false}
	
	override method estaTranquila(){
		return super() and not quirofanosPreparados
	}
	
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
	}
}

class NaveDeCombateSigilosa inherits NavesDeCombate{
	override method estaTranquila(){
		return super() and not self.estaInvisible()
	}
	
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}