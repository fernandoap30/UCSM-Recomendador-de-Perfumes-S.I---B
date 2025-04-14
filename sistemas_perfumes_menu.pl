% Sistema experto para recomendar perfumes
% Autor: [Tu Nombre o Equipo]
% Fecha: [Fecha]

:- dynamic si/1, no/1.

inicio :-
    limpiar_respuestas,
    nl, write('-------------------------------------------'), nl,
    write('   Bienvenido al sistema experto de perfumes'), nl,
    write('-------------------------------------------'), nl,
    mostrar_menu.

mostrar_menu :- 
    nl,
    write('Seleccione una opcion:'), nl,
    write('1. Obtener una recomendacion de perfume'), nl,
    write('2. Ver listado de perfumes disponibles'), nl,
    write('3. Salir'), nl,
    read(Opcion),
    nl,
    (   (Opcion == 1 ; Opcion == 2 ; Opcion == 3)
    ->  procesar_opcion(Opcion)
    ;   write('Opcion no valida. Intente nuevamente.'), nl, mostrar_menu).


procesar_opcion(1) :-
    nl, write('Iniciando recomendacion...'), nl,
    recomendar_perfume,
    preguntar_otra_vez.
procesar_opcion(2) :-
    nl, write('Perfumes disponibles:'), nl,
    listar_perfumes,
    preguntar_otra_vez.
procesar_opcion(3) :-
    nl, write('Gracias por usar el sistema experto. ¡Hasta luego!'), nl.
procesar_opcion(_) :-
    nl, write('Opcion no valida. Intente nuevamente.'), nl,
    mostrar_menu.

preguntar_otra_vez :-
    nl, write('¿Desea realizar otra accion? (s/n)'), nl,
    read(Respuesta),
    (Respuesta == s -> mostrar_menu ; write('Hasta luego.'), nl).

limpiar_respuestas :-
    retract(si(_)), fail.
limpiar_respuestas :-
    retract(no(_)), fail.
limpiar_respuestas.

% ------------------------------
% Familia olfativa
% ------------------------------
familia(floral).
familia(amaderado).
familia(citrico).
familia(oriental).
familia(frutal).
familia(fougere).
familia(aromatico).

% Tipo de perfume por concentración
tipo_perfume(parfum, muy_larga).
tipo_perfume(eau_de_parfum, larga).
tipo_perfume(eau_de_toilette, moderada).
tipo_perfume(eau_de_cologne, corta).
tipo_perfume(eau_fraiche, muy_corta).

% Intensidad
intensidad(suave).
intensidad(media).
intensidad(fuerte).

% Ocasiones
ocasion(diaria).
ocasion(noche).
ocasion(elegante).
ocasion(verano).
ocasion(invierno).
ocasion(oficina).
ocasion(cita).

% Notas olfativas preferidas
nota(rosa).
nota(vainilla).
nota(limon).
nota(madera).
nota(lavanda).
nota(manazana).
nota(ambar).
nota(sandalo).
nota(coco).
nota(bergamota).
nota(jazmin).
nota(musk).

% Edad sugerida
edad(joven).
edad(adulto).
edad(maduro).

% ------------------------------
% Reglas para determinar familia olfativa por notas
% ------------------------------
es_familia(floral, Notas) :-
    member(rosa, Notas);
    member(jazmin, Notas).

es_familia(amaderado, Notas) :-
    member(madera, Notas);
    member(sandalo, Notas).

es_familia(citrico, Notas) :-
    member(limon, Notas);
    member(bergamota, Notas).

es_familia(oriental, Notas) :-
    member(vainilla, Notas);
    member(ambar, Notas).

es_familia(frutal, Notas) :-
    member(manazana, Notas);
    member(coco, Notas).

es_familia(fougere, Notas) :-
    member(lavanda, Notas);
    member(musk, Notas).

es_familia(aromatico, Notas) :-
    member(lavanda, Notas);
    member(romero, Notas).

% ------------------------------
% Reglas para duracion segun tipo
% ------------------------------
duracion_perfume(Tipo, Duracion) :-
    tipo_perfume(Tipo, Duracion).

% ------------------------------
% Reglas de recomendacion por ocasion
% ------------------------------
recomendar_por_ocasion(diaria, eau_de_toilette).
recomendar_por_ocasion(noche, parfum).
recomendar_por_ocasion(elegante, eau_de_parfum).
recomendar_por_ocasion(verano, eau_fraiche).
recomendar_por_ocasion(invierno, parfum).
recomendar_por_ocasion(oficina, eau_de_toilette).
recomendar_por_ocasion(cita, eau_de_parfum).

% ------------------------------
% Reglas de intensidad segun edad
% ------------------------------
intensidad_por_edad(joven, suave).
intensidad_por_edad(adulto, media).
intensidad_por_edad(maduro, fuerte).

% ------------------------------
% Reglas para sugerir tipo de perfume según duración deseada
% ------------------------------
sugerir_tipo(corta, eau_fraiche).
sugerir_tipo(media, eau_de_toilette).
sugerir_tipo(larga, eau_de_parfum).
sugerir_tipo(muy_larga, extracto_o_parfum).

% ------------------------------
% Recomendacion principal basada en multiples criterios
% ------------------------------

preguntar_olor_preferido(Olor) :-
    write('¿Cuál es tu nota olfativa preferida? (por ejemplo: rosa, limon, madera)'), nl,
    read(Olor).

preguntar_ocasion(Ocasion) :-
    write('¿Para qué ocasión buscas el perfume? (diaria, noche, elegante, verano, invierno, oficina, cita)'), nl,
    read(Ocasion).

preguntar_intensidad(Intensidad) :-
    write('¿Qué intensidad prefieres? (suave, media, fuerte)'), nl,
    read(Intensidad).

preguntar_edad(Edad) :-
    write('¿Qué grupo de edad mejor te representa? (joven, adulto, maduro)'), nl,
    read(Edad).

preguntar_duracion_deseada(Deseada) :-
    write('¿Qué duración prefieres? (muy_corta, corta, moderada, larga, muy_larga)'), nl,
    read(Deseada).

notas_perfume(Olor, [Olor]).

recomendar_perfume :-
    write('Bienvenido al sistema experto de recomendaciones de perfumes.'), nl,

    % Capturar preferencias del usuario
    preguntar_olor_preferido(Olor),
    preguntar_ocasion(Ocasion),
    preguntar_intensidad(Intensidad),
    preguntar_edad(Edad),
    preguntar_duracion_deseada(Deseada),

    % Determinar familia olfativa
    notas_perfume(Olor, Notas),
    es_familia(Familia, Notas),

    % Determinar tipo de perfume
    sugerir_tipo(Deseada, TipoPerfume),

    % Determinar recomendación por ocasión
    recomendar_por_ocasion(Ocasion, TipoPorOcasion),

    % Determinar intensidad por edad
    intensidad_por_edad(Edad, IntensidadEdad),

    % Mostrar recomendación
    nl,
    write('--- Recomendación Personalizada ---'), nl,
    format('Notas dominantes: ~w~n', [Notas]),
    format('Familia olfativa recomendada: ~w~n', [Familia]),
    format('Tipo de perfume por duración deseada: ~w~n', [TipoPerfume]),
    format('Tipo de perfume según ocasión: ~w~n', [TipoPorOcasion]),
    format('Intensidad sugerida según edad: ~w~n', [IntensidadEdad]),
    format('Intensidad preferida por usuario: ~w~n', [Intensidad]), nl,
    write('Gracias por usar el sistema experto.').

listar_perfumes :-
    write('- Chanel No. 5 (floral, elegante)'), nl,
    write('- Dior Sauvage (aromatico, diario)'), nl,
    write('- YSL Black Opium (oriental, noche)'), nl,
    write('- Dolce & Gabbana Light Blue (citrico, verano)'), nl,
    write('- Paco Rabanne 1 Million (amaderado, noche)'), nl,
    write('- Carolina Herrera Good Girl (oriental, cita)'), nl.