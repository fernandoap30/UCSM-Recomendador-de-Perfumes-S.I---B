% Familia y sus olores
olor(citrica, limon).
olor(citrica, naranja).
olor(citrica, bergamota).

olor(floral, jazmin).
olor(floral, rosa).
olor(floral, geranio).

olor(amaderada, sandalo).
olor(amaderada, cedro).
olor(amaderada, abedul).

olor(fougere, salvia).
olor(fougere, lavanda).
olor(fougere, galbano).

olor(chipre, bergamota).
olor(chipre, sandalo).
olor(chipre, rosa).

olor(oriental, canuela).
olor(oriental, nuez).
olor(oriental, vainilla).

olor(gourmand, vainilla).
olor(gourmand, chocolate).
olor(gourmand, caramelo).

% Tipo de perfume con concentracion y duracion
tipo(eau_fraiche, '3-5%', '2-3 horas').
tipo(eau_de_toilette, '12-15%', '4-7 horas').
tipo(eau_de_parfum, '17-20%', '8-10 horas').
tipo(extracto_o_parfum, '30-40%', 'hasta 24 horas').

% Perfumes por familia y tipo
perfume(citrica, eau_fraiche, 'Lemon Breeze').
perfume(citrica, eau_de_toilette, 'Citrus Splash').
perfume(citrica, eau_de_parfum, 'Golden Zest').
perfume(citrica, extracto_o_parfum, 'Citrus Intense').

perfume(floral, eau_fraiche, 'Petal Mist').
perfume(floral, eau_de_toilette, 'Rose Charm').
perfume(floral, eau_de_parfum, 'Floral Elegance').
perfume(floral, extracto_o_parfum, 'Jasmine Bloom').

perfume(amaderada, eau_fraiche, 'Wood Whisper').
perfume(amaderada, eau_de_toilette, 'Cedar Vibe').
perfume(amaderada, eau_de_parfum, 'Forest Spirit').
perfume(amaderada, extracto_o_parfum, 'Deep Woods').

perfume(fougere, eau_fraiche, 'Fresh Herb').
perfume(fougere, eau_de_toilette, 'Green Vibe').
perfume(fougere, eau_de_parfum, 'Herbal Essence').
perfume(fougere, extracto_o_parfum, 'Lavender Night').

perfume(chipre, eau_fraiche, 'Soft Chypre').
perfume(chipre, eau_de_toilette, 'Chypre Day').
perfume(chipre, eau_de_parfum, 'Chypre Queen').
perfume(chipre, extracto_o_parfum, 'Chypre Royal').

perfume(oriental, eau_fraiche, 'Spice Light').
perfume(oriental, eau_de_toilette, 'Orient Rush').
perfume(oriental, eau_de_parfum, 'Mystic Orient').
perfume(oriental, extracto_o_parfum, 'Oriental Night').

perfume(gourmand, eau_fraiche, 'Sweet Whisper').
perfume(gourmand, eau_de_toilette, 'Choco Kiss').
perfume(gourmand, eau_de_parfum, 'Candy Love').
perfume(gourmand, extracto_o_parfum, 'Vanilla Dream').


% Reglas basicas para identificar familia segun un olor
familia_por_olor(Olor, Familia) :- olor(Familia, Olor).

% Reglas para contar coincidencias de olores en una familia
coincidencias([], _, 0).
coincidencias([O|Resto], Familia, Total) :-
    olor(Familia, O), !,
    coincidencias(Resto, Familia, Subtotal),
    Total is Subtotal + 1.
coincidencias([_|Resto], Familia, Total) :-
    coincidencias(Resto, Familia, Total).

% Regla para determinar la familia con mas coincidencias

mejor_familia(Gustos, FamiliaRecomendada) :-
    findall(F, olor(F, _), Familias),
    list_to_set(Familias, Unicas),
    mejor_familia_aux(Gustos, Unicas, "", 0, FamiliaRecomendada).

mejor_familia_aux(_, [], Mejor, _, Mejor).
mejor_familia_aux(Gustos, [F|Resto], Actual, Max, Resultado) :-
    coincidencias(Gustos, F, Coin),
    Coin > Max,
    mejor_familia_aux(Gustos, Resto, F, Coin, Resultado).
mejor_familia_aux(Gustos, [_|Resto], Actual, Max, Resultado) :-
    mejor_familia_aux(Gustos, Resto, Actual, Max, Resultado).

% Reglas para tipo por duracion deseada
tipo_por_duracion(corta, eau_fraiche).
tipo_por_duracion(media, eau_de_toilette).
tipo_por_duracion(larga, eau_de_parfum).
tipo_por_duracion(muy_larga, extracto_o_parfum).

% Reglas para obtener propiedades de tipo
concentracion_de_tipo(Tipo, Conc) :- tipo(Tipo, Conc, _).
duracion_de_tipo(Tipo, Durac) :- tipo(Tipo, _, Durac).

% Reglas para recomendar perfume completo
recomendar_perfume(Gustos, PreferenciaDuracion, NombrePerfume) :-
    mejor_familia(Gustos, Familia),
    tipo_por_duracion(PreferenciaDuracion, Tipo),
    perfume(Familia, Tipo, NombrePerfume).

% Reglas auxiliares para mostrar informacion detallada
detalles_perfume(Familia, Tipo) :-
    perfume(Familia, Tipo, Nombre),
    concentracion_de_tipo(Tipo, Conc),
    duracion_de_tipo(Tipo, Durac),
    format('Te recomendamos: ~w~nFamilia: ~w~nTipo: ~w~nConcentracion: ~w~nDuracion: ~w~n',
        [Nombre, Familia, Tipo, Conc, Durac]).

% Reglas de consulta individual
es_perfume_de_familia(Nombre, Familia) :- perfume(Familia, _, Nombre).
es_perfume_de_tipo(Nombre, Tipo) :- perfume(_, Tipo, Nombre).

% Reglas para ver si un perfume combina con un olor
perfume_contiene_olor(Nombre, Olor) :-
    perfume(Familia, _, Nombre),
    olor(Familia, Olor).

% Reglas para mostrar todos los perfumes de una familia
mostrar_perfumes_de_familia(Familia) :-
    findall(Nombre, perfume(Familia, _, Nombre), Lista),
    format('Perfumes de la familia ~w: ~w~n', [Familia, Lista]).

% Reglas de validacion
es_tipo_valido(X) :- tipo(X, _, _).
es_familia_valida(F) :- olor(F, _).

% Reglas para obtener todos los olores que le gustan al usuario
gustos_usuario(Lista) :- write('Ingresa lista de olores que te gustan (como lista Prolog): '), read(Lista).

% Reglas para flujo completo
iniciar_recomendacion :-
    gustos_usuario(Gustos),
    write('Que duracion prefieres? (corta, media, larga, muy_larga): '), read(Duracion),
    recomendar_perfume(Gustos, Duracion, Perfume), !,
    mejor_familia(Gustos, Familia),
    tipo_por_duracion(Duracion, Tipo),
    detalles_perfume(Familia, Tipo).

