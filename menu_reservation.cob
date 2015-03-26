         OPERATION_RESERVATION.
 
       PERFORM WITH TEST AFTER UNTIL WrepChoix = 0
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter une réservation'
         DISPLAY ' 2 - modifier une réservation'
         DISPLAY ' 3 - saisir les commande des clients'
         DISPLAY ' 4 - consulter une réservation'
         DISPLAY ' 5 - Consulter les statistiques de ventes'
         DISPLAY ' 6 - Supprimer une réservation'
         ACCEPT Wchoix
         EVALUATE Wchoix
           WHEN 1
             PERFORM AJOUTER_RESA
           WHEN 2
             PERFORM MODIFIER_RESA
          WHEN 3
             PERFORM SAISIR_COMMANDE
            WHEN 4 
             PERFORM CONSULTER_RESA
           WHEN 5
             PERFORM STATISTIQUES_RESTAURANT
           WHEN 6
             PERFORM SUPPRIMER_RESERVATION
           
         END-EVALUATE
         PERFORM WITH TEST AFTER UNTIL WrepChoix = 0 OR WrepChoix = 1
           DISPLAY 'Souhaitez vous faire autre chose ? 1:oui, 0:non'
           ACCEPT WrepChoix
         END-PERFORM
       END-PERFORM.


      ****************************************************************
       COPY proc_reservation.
