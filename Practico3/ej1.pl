/* 
Ejercicio 1 [Fundamental]
  Se busca colorear un mapa, de forma que no haya dos países vecinos con los mismos colores.
  El mapa se representa por una lista de regiones de la
  forma:
    region(Nombre, Color, ColoresVecinos)
  En la figura: 
    [region(a, A, [B,C,D]), region(b, B, [A,C,E]), ...]
  
  Defina el siguiente predicado:
  colorear(Mapa, Colores) <- Mapa se encuentra coloreado con Colores, de forma tal que no hay dos vecinos iguales.
*/


colorear([Region|Regiones], Colores) :-
  color_region(Region, Colores),
  colorear(Regiones, Colores).
colorear([],_).

color_region(region(_,Color, ColorVecinos), Colores) :-
  select(Color, Colores, Colores1), %Quito de la lista de colores, el color de la region actual
  members(ColorVecinos, Colores1).% todos los colores vecinos tienen que estar en el resultado del select anterior

members([X|Xs],Ys) :-
  member(X,Ys),
  members(Xs,Ys).
members([],_).
  