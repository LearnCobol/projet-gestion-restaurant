         OPERATION_CLIENT.

       PERFORM WITH TEST AFTER UNTIL Wmenu = 0
        PERFORM WITH TEST AFTER UNTIL Wmenu >= 0 AND Wmenu<=5
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter un client'
         DISPLAY ' 2 - Consulter les clients'
         DISPLAY ' 3 - Modifier un client'
         DISPLAY ' 4 - Supprimer un client'
         DISPLAY ' 5 - Calculer pourcentage de réduction'
         DISPLAY ' 0 - Quitter'
         ACCEPT Wmenu
         EVALUATE Wmenu
           WHEN 1
             PERFORM AJOUTER_CLIENT
           WHEN 2
             PERFORM CONSULTER_CLIENT
           WHEN 3
             PERFORM MODIFIER_CLIENT
           WHEN 4 
             PERFORM SUPPRIMER_CLIENT
           WHEN 5 
             PERFORM CALCULER_PRCT_REDUC
         END-EVALUATE
        END-PERFORM
       END-PERFORM.


      ****************************************************************
       COPY proc_client.
