function tipoViaje(){
	//Si la opcion con id Conocido_1 (dentro del documento > formulario con name fcontacto >     y a la vez dentro del array de Conocido) esta activada
	if (document.compra.viaje[1].checked == true) {
		//muestra (cambiando la propiedad display del estilo) el div con id 'desdeotro'
		document.getElementById('regreso').style.display='inline-block';
		document.getElementById('l_regreso').style.display='block';
		document.getElementById('divi').className='form-group col-md-3 divH';
		//document.getElementById('sencillo').style.display='none';
		//document.getElementById('redondo').style.display='inline';
		//por el contrario, si no esta seleccionada
	}
	else if (document.compra.viaje[0].checked == true) {
		//oculta el div con id 'desdeotro'
		document.getElementById('regreso').style.display='none';
		document.getElementById('l_regreso').style.display='none';
		document.getElementById('divi').className='form-group col-sm-4 offset-sm-4';
		//document.getElementById('sencillo').style.display='inline';
		//document.getElementById('redondo').style.display='none';
	}
}

function ubicacionTerminal(){
	//Si la opcion con id Conocido_1 (dentro del documento > formulario con name fcontacto >     y a la vez dentro del array de Conocido) esta activada
	if (document.ubicacion.terminal[0].checked == true) {
		document.getElementById('CDMX').style.display='inline-block';
		document.getElementById('cuernavaca').style.display='none';
		document.getElementById('puebla').style.display='none';
		document.getElementById('xalapa').style.display='none';
	}
	else if (document.ubicacion.terminal[1].checked == true) {
		document.getElementById('CDMX').style.display='none';
		document.getElementById('cuernavaca').style.display='inline-block';
		document.getElementById('puebla').style.display='none';
		document.getElementById('xalapa').style.display='none';
	}
	else if (document.ubicacion.terminal[2].checked == true) {
		document.getElementById('CDMX').style.display='none';
		document.getElementById('cuernavaca').style.display='none';
		document.getElementById('puebla').style.display='inline-block';
		document.getElementById('xalapa').style.display='none';
	}
	else if (document.ubicacion.terminal[3].checked == true) {
		document.getElementById('CDMX').style.display='none';
		document.getElementById('cuernavaca').style.display='none';
		document.getElementById('puebla').style.display='none';
		document.getElementById('xalapa').style.display='inline-block';
	}
}

function changeAction(val){
   $("#compra").get(0).setAttribute("action",val);
};

function changeAction1(val){
   $("#informe").get(0).setAttribute("action",val);
};

function changeAction2(val){
   $("#rutas").get(0).setAttribute("action",val);
};