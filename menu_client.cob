         OPERATION_CLIENT.

       PERFORM WITH TEST AFTER UNTIL WrepChoix = 0
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter un client'
         DISPLAY ' 2 - Consulter les clients'
         DISPLAY ' 3 - Modifier un client'
         DISPLAY ' 4 - supprimer un client'
         ACCEPT Wchoix
         EVALUATE Wchoix
           WHEN 1
             PERFORM AJOUTER_CLIENT
           WHEN 2
             PERFORM CONSULTER_CLIENT
           WHEN 3
             PERFORM MODIFIER_CLIENT
           WHEN 4 
             PERFORM SUPPRIMER_CLIENT
         END-EVALUATE
         PERFORM WITH TEST AFTER UNTIL WrepChoix = 0 OR WrepChoix = 1
           DISPLAY 'Souhaitez vous faire autre chose ? 1:oui, 0:non'
           ACCEPT WrepChoix
         END-PERFORM
       END-PERFORM.


      ****************************************************************
       COPY proc_client.
