         OPERATION_RESTAURANT.

       MOVE 1 TO WrepChoix
       PERFORM WITH TEST AFTER UNTIL WrepChoix = 0
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter un restaurant'
         DISPLAY ' 2 - Consulter les informations d un restaurant'
         DISPLAY ' 3 - Modifier un restaurant'
         DISPLAY ' 4 - Supprimer un restaurant'
         ACCEPT Wchoix
         EVALUATE Wchoix
           WHEN 1
            OPEN I-O frestaurants
            IF fr_stat =35 THEN
             OPEN OUTPUT frestaurants
            END-IF
            PERFORM AJOUTER_RESTAURANT
            CLOSE frestaurants
           WHEN 2
             PERFORM CONSULTER_RESTAURANT
           WHEN 3
             PERFORM MODIFIER_RESTAURANT
           WHEN 4 
             PERFORM SUPPRIMER_RESTAURANT
         END-EVALUATE
         PERFORM WITH TEST AFTER UNTIL WrepChoix = 0 OR WrepChoix = 1
           DISPLAY 'Autre action ? 1:oui, 0:non'
           ACCEPT WrepChoix
         END-PERFORM
       END-PERFORM
       STOP RUN.


      ****************************************************************
       COPY proc_restaurant.
