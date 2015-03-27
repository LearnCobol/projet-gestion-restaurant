         OPERATION_RESTAURANT.

       DISPLAY '================================'
       DISPLAY '========= MENU         ========='
       DISPLAY '========= GESTION      ========='
       DISPLAY '========= RESTAURANT   ========='
       DISPLAY '================================'

       PERFORM WITH TEST AFTER UNTIL Wmenu = 0
        PERFORM WITH TEST AFTER UNTIL Wmenu = 0 AND Wmenu<=4
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter un restaurant'
         DISPLAY ' 2 - Consulter les informations d un restaurant'
         DISPLAY ' 3 - Modifier un restaurant'
         DISPLAY ' 4 - Supprimer un restaurant'
         DISPLAY ' 0 - Quitter'
         DISPLAY '================================'
         ACCEPT Wmenu
         EVALUATE Wmenu
          WHEN 1
           PERFORM AJOUTER_RESTAURANT
          WHEN 2
           PERFORM CONSULTER_RESTAURANT
          WHEN 3
           PERFORM MODIFIER_RESTAURANT
          WHEN 4 
           PERFORM SUPPRIMER_RESTAURANT
         END-EVALUATE
        END-PERFORM
       END-PERFORM.


      ****************************************************************
       OPERATION_RESTAURANT_UTIL.

       DISPLAY '================================'
       DISPLAY '========= MENU         ========='
       DISPLAY '========= CONSULTATION ========='
       DISPLAY '========= RESTAURANT   ========='
       DISPLAY '================================'


       PERFORM WITH TEST AFTER UNTIL Wmenu = 0
        PERFORM WITH TEST AFTER UNTIL Wmenu>=0 AND Wmenu<=1
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Consulter les informations d''un restaurant'
         DISPLAY ' 0 - Quitter'
         DISPLAY '================================'
         ACCEPT Wmenu
        END-PERFORM
        EVALUATE Wmenu
         WHEN 1
           PERFORM CONSULTER_RESTAURANT
        END-EVALUATE
       END-PERFORM.


      ****************************************************************
       COPY proc_restaurant.
