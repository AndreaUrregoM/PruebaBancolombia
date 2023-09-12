
---Eliminar la tabla si existe---
DROP TABLE IF EXISTS Obligaciones_tasa;

---Declarar la tabla---
CREATE TABLE Obligaciones_tasa (
	"radicado"	INTEGER NOT NULL,
	"num_documento"	INTEGER NOT NULL,
	"cod_segm_tasa"	TEXT,
	"cod_subsegm_tasa"	INTEGER,
	"cal_interna_tasa"	TEXT,
	"id_producto"	TEXT NOT NULL,
	"tipo_id_producto"	TEXT,
	"valor_inicial"	REAL NOT NULL,
	"fecha_desembolso"	TEXT NOT NULL,
	"plazo"	REAL,
	"cod_periodicidad"	NUMERIC,
	"periodicidad"	TEXT,
	"saldo_deuda"	REAL,
	"modalidad"	TEXT,
	"tipo_plazo"	TEXT,
	"numero_periodo" INTEGER,
	"tasa_asignada" TEXT,
	"tasa" REAL,
	"tasa_esperada" REAL,
	"valor_final"	REAL);

---Copiar la data dentro de la tabla---
INSERT INTO Obligaciones_tasa
SELECT	o.radicado 
	,	o.num_documento
	,	o.cod_segm_tasa
	,	o.cod_subsegm_tasa
	,	o.cal_interna_tasa
	,	o.id_producto
	,	o.tipo_id_producto
	,	cast(replace(o.valor_inicial, ',','.') as float)
	,	o.fecha_desembolso
	,	o.plazo
	,	o.cod_periodicidad
	,	o.periodicidad
	,	cast(replace(o.saldo_deuda, ',','.') as float)
	,	o.modalidad
	,	o.tipo_plazo 
	,	case periodicidad
			when 'MENSUAL' then 1
			when 'BIMENSUAL' then 2
			when 'TRIMESTRAL' then 3
			when 'SEMESTRAL' then 6
			when 'ANUAL' then 12
			else 1
		end as numero_periodo
	,	case 
		  when o.id_producto like '%cartera%' or o.id_producto like '%Cartera%'then 'cartera'
		  when o.id_producto like '%operacion_especifica%' or o.id_producto like '%Operacion_especifica%' then 'operacion_especifica '
		  when o.id_producto like '%hipotecario%' or o.id_producto like '%Hipotecario%'  then 'hipotecario'
		  when o.id_producto like '%leasing%' or o.id_producto like '%Leasing%'then 'leasing'
		  when o.id_producto like '%sufi%' or o.id_producto like '%Sufi%' then 'sufi'
		  when o.id_producto like '%factoring%' or o.id_producto like '%Factoring%' then 'factoring'
		  when o.id_producto like '%tarjeta%' or o.id_producto like '%Tarjeta%' then 'tarjeta'
		  else null
		end
	,	case 
		  when o.id_producto like '%cartera%' or o.id_producto like '%Cartera%' then cast(replace(t.tasa_cartera, ',','.') as float)  
		  when o.id_producto like '%operacion_especifica%' or o.id_producto like '%Operacion_especifica%' then cast(replace(t.tasa_operacion_especifica, ',','.') as float) 
		  when o.id_producto like '%hipotecario%' or o.id_producto like '%Hipotecario%' then cast(replace(t.tasa_hipotecario, ',','.') as float)
		  when o.id_producto like '%leasing%' or o.id_producto like '%Leasing%' then cast(replace(t.tasa_leasing, ',','.') as float)
		  when o.id_producto like '%sufi%' or o.id_producto like '%Sufi%' then cast(replace(t.tasa_sufi, ',','.') as float)
		  when o.id_producto like '%factoring%' or o.id_producto like '%Factoring%' then cast(replace(t.tasa_factoring, ',','.') as float)
		  when o.id_producto like '%tarjeta%' or o.id_producto like '%Tarjeta%' then cast(replace(t.tasa_tarjeta, ',','.') as float)
		 else 0.0
		end 
		,0.0
		,0.0
FROM 
Obligaciones_clientes o 
INNER JOIN tasas_productos t ON o.cod_segm_tasa = t.cod_segmento  
							AND o.cod_subsegm_tasa = t.cod_subsegmento
							AND o.cal_interna_tasa = t.calificacion_riesgos;
	
---actualizar la data de la tabla temporal---

UPDATE Obligaciones_tasa
SET tasa_esperada = ((pow((1.0+cast(replace(tasa, ',','.') as float)),(1.0/(12.0/numero_periodo)))-1.0)) ,
		valor_final = ((pow((1.0+cast(replace(tasa, ',','.') as float)),(1.0/(12.0/numero_periodo)))-1.0))*valor_inicial;
	
---Seleccionar la data de la tabla temporal---
SELECT * FROM Obligaciones_tasa;
