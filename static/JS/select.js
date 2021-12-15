let select_origen = document.getElementById('origen');
let select_destino = document.getElementById('destino');

select_origen.onchange = function() {
	origen = select_origen.value;
	fetch('/destino/' + origen).then(function(response) {
		response.json().then(function(data) {
			let optionHTML = ''
			for (let destino of data.Destinos) {
				if (origen != destino.name){
					optionHTML += '<option value="' + destino.name + '">' + destino.name + '</option>';
				}
			}
			select_destino.innerHTML = optionHTML;
		});
	});
}