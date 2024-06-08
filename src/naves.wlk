class Nave{
	var property velocidad
	var property direccion
	var property combustible
	
	method acelerar(cuanto){velocidad = 100000.min(velocidad + cuanto)}
	method desacelerar(cuanto){velocidad = 0.max(velocidad - cuanto)}
	
	method irHaciaElSol(){direccion = 10}
	method escaparDelSol(){direccion = -10}
	method ponerseParaleloAlSol(){direccion = 0}
	
	method acercarseUnPocoAlSol(){direccion += if(direccion < 10) 1 else 0} 
	method alejarseUnPocoDelSol(){direccion -= if(direccion > -10) 1 else 0}
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method cargarCombustible(cantidad){combustible+=cantidad}
	method descargarCombustible(cantidad){combustible = 0.max(combustible-cantidad)}
	
	method estaTranquila(){
		return (combustible >= 4000) and (velocidad < 12000)
	}
	
	method estaDeRelajo(){
		return self.estaTranquila()
	}
}


class NavesBaliza inherits Nave{
	var colorBaliza
	var cantCambios
	
	method colorBaliza() = colorBaliza
	method cambiarColorDeBaliza(color){
		colorBaliza = color
		cantCambios += 1
	}
	
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila(){
		return super() and colorBaliza != "rojo"
	}
	
	method recibirAmenaza(){
		self.irHaciaElSol()
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method estaDeRelajo(){
		return super() and cantCambios==0
	}
}

class NavesDePasajeros inherits Nave{
	var property pasajeros = 0
	var property racionesDeComida 
	var property racionesDeBebida 
	
	method cargarComida(cantidad){racionesDeComida+=cantidad}
	method descargarComida(cantidad){racionesDeComida = 0.max(racionesDeComida-cantidad)}
	method cargarBebida(cantidad){racionesDeBebida+=cantidad}
	method descargarBebidas(cantidad){racionesDeBebida = 0.max(racionesDeBebida-cantidad)}
	
	override method prepararViaje(){
		super()
		self.cargarComida(pasajeros*4)
		self.cargarBebida(pasajeros*6)
		self.acercarseUnPocoAlSol()
	}
	
	method recibirAmenaza(){
		self.acelerar(velocidad*2)
		self.descargarComida(pasajeros)
		self.descargarBebidas(pasajeros*2)
	}
	
	override method estaDeRelajo(){
		return super() and self.racionesDeComida()<50
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
	method primerMensajeEmitido() = mensajesEmitidos.first()
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	method esEscueta() = mensajesEmitidos.any({m=>m.size()>30})
	method emitioMensaje(mensaje) = mensajesEmitidos.any({m=>m == mensaje})
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	
	override method estaTranquila(){
		return super() and misilesActivos
	}
	
	method recibirAmenaza(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method estaDeRelajo(){
		return super() and self.esEscueta()
	}
}

class NaveHospital inherits NavesDePasajeros{
	var quirofanosPreparados
	
	method prepararQuirofano(){quirofanosPreparados=true}
	method tieneQuirofanoPreparado() = quirofanosPreparados
	
	override method estaTranquila(){
		return super() and not quirofanosPreparados
	}
	
	override method recibirAmenaza(){
		super()
		self.prepararQuirofano()
	}
}

class NaveDeCombateSigilosa inherits NavesDeCombate{
	override method estaTranquila(){
		return super() and visible
	}
	
	override method recibirAmenaza(){
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}