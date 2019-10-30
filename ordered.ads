
package Ordered with SPARK_Mode is
   subtype T_Index is Natural range 0 .. 5;
   type T_Vector is array (T_Index) of Natural;
   -- El tipo del vector de salida tiene que ser de mayor longitud
   -- que el tipo de vector de entrada.
   subtype Index is Natural range 0 .. 6;
   type Vector is array (Index) of Natural;

   function Insert (V : T_Vector; Value : Natural) return Vector
     with 
       Global  => null,
       Depends => (Insert'Result => (V, Value)),
       Pre     => (V'Length <= Natural'Last - 1
                   and then
                     V'Length > 1
                   and then 
                   -- Se tiene que cumplir que los elementos del vector
                   -- de entrada est�n ordenados
                     (for all K in V'First .. V'Last - 1 =>
                        (for all L in K .. V'Last =>
                             V (K) <= V (L)))),
     Post    => 
   -- Se tiene que cumplir que los elementos del vector de
   -- salida est�n ordenados
       (for all K in Insert'Result'First .. Insert'Result'Last - 1 =>
          (for all L in K .. Insert'Result'Last =>
                 Insert'Result (K) <= Insert'Result (L)))
     and then 
   --Alg�n valor del vector de salida tiene que ser igual
   -- al valor que se deb�a insertar
       ((for some K in Insert'Result'First .. Insert'Result'Last - 1 =>
             Insert'Result (K) = Value)
        -- Si el valor a insertar era mayor que el �ltimo elemento
        -- del vector de entrada, entonces el �ltimo valor del vector
        -- de salida ser� el valor que se ten�a que insertar
        or else
          (if Value > V (V'Last) then
               Insert'Result (Insert'Result'Last) = Value));
       
                            
          
          

end Ordered;
