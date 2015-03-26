         OPERATION_RESERVATION.
 
       PERFORM WITH TEST AFTER UNTIL Wmenu = 0
        PERFORM WITH TEST AFTER UNTIL Wmenu = 0 AND Wmenu<=6
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter une réservation'
         DISPLAY ' 2 - Modifier une réservation'
         DISPLAY ' 3 - Saisir les commande des clients'
         DISPLAY ' 4 - Consulter une réservation'
         DISPLAY ' 5 - Consulter les statistiques de ventes'
         DISPLAY ' 6 - Supprimer une réservation'
         DISPLAY ' 0 - Quitter'
         ACCEPT Wmenu
         EVALUATE Wmenu
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
        END-PERFORM
       END-PERFORM.


      ****************************************************************
       COPY proc_reservation.
