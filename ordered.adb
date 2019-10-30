package body Ordered with SPARK_Mode is

   function Insert (V : T_Vector; Value : Natural) return Vector is
      I : Natural := 0;
      Pos : Natural := 0;
      Result : Vector := (others => 0); -- Vector resultado con todos sus
                                        -- elementos inicializados a cero

   begin
      -- Si el valor a insertar es mayor que el último elemento
      -- del vector de entrada, se inserta en la última posición
      -- del vector resultado
      if Value > V (V'Last) then
         for I in Result'First .. Result'Last - 1 loop
            Result (I) := V (I);
            pragma Loop_Invariant (for all K in V'First .. I =>
                                     (for all L in K .. I =>
                                        V (K) <= V (L)));
            pragma Loop_Invariant (for all K in Result'First ..  I =>
                                        Result (K) = V (K));
         end loop;
         Result (Result'Last) := Value;
      else
         -- Se recorre el vector de entrada en busca de la posición
         -- en la cual el valor a insertar sea más grande que el valor
         -- anterior pero más pequeño que el posterior.
         while I < V'Last loop
            if Value > V (I) and then Value < V (I + 1) then
               -- Pos alamcena la posición en la
               -- cual debe ir el elemento a insertar
               Pos := I + 1;
               exit;
            end if;
            Result (I) := V (I);
            I := I + 1;
            pragma Loop_Variant (Increases => I);
            pragma Loop_Invariant (I in Pos .. V'Last);
            -- Se asegura que el vector de entrada está ordenado
            pragma Loop_Invariant (for all K in V'First .. I =>
                                     (for all L in K .. I =>
                                        V (K) <= V (L)));
         end loop;
         declare
            J : Natural := Pos;
         begin
            -- Este bucle empieza a iterar a partir de la posición
            -- reservada para el elemento a insertar
            while J < Result'Last loop
               -- En el vector resultado se almacenan los elemntos del vector
               -- de entrada desplazados una posición a la derecha para dejar
               -- libre la posición en la cual se tiene que añadir el nuevo
               -- elemento
               Result (J + 1) := V (J);
               pragma Loop_Variant (Increases => J);
               pragma Loop_Invariant (J in Pos .. Result'Last - 1);
               -- Esta invariante comprueba que los elementos a partir
               -- de Pos se han desplazado a la derecha.
               pragma Loop_Invariant (for all K in Pos .. J =>
                                        Result (K + 1) = V'Loop_Entry (K));
               -- Comprueba el orden de los elementos anteriores a Pos
               pragma Loop_Invariant (for all K in Result'First .. Pos - 1 =>
                                        (for all L in K .. Pos =>
                                           Result (K) <= Result (L)));
               -- Comprueba el orden de los valores posteriores a Pos
               pragma Loop_Invariant (for all K in Pos + 1 .. J =>
                                        (for all L in K .. J =>
                                           Result (K) <= Result (L)));
               J := J + 1;

            end loop;
         end;
         -- Finalmente, se inserta el valor en la posición reservada
         Result (Pos) := Value;
      end if;
      return Result;

   end Insert;

end Ordered;
