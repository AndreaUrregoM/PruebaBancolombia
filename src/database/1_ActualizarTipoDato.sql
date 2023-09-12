UPDATE Obligaciones_clientes
SET valor_inicial = cast(replace(valor_inicial, ',','.') as float)
	,saldo_deuda =	cast(replace(saldo_deuda, ',','.') as float);
	
UPDATE tasas_productos
SET 	tasa_cartera = cast(replace(tasa_cartera, ',','.') as float)
	,	tasa_operacion_especifica = cast(replace(tasa_operacion_especifica, ',','.') as float)
	,	tasa_hipotecario = cast(replace(tasa_hipotecario, ',','.') as float)
	,	tasa_leasing = cast(replace(tasa_leasing, ',','.') as float)
	, 	tasa_sufi = cast(replace(tasa_sufi, ',','.') as float)
	,	tasa_factoring = cast(replace(tasa_factoring, ',','.') as float)
	,	tasa_tarjeta = cast(replace(tasa_tarjeta, ',','.') as float);
		 