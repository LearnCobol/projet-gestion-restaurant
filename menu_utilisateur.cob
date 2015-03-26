       OPERATION_UTILISATEUR.

         MOVE 1 TO Wrep

         PERFORM WITH TEST AFTER UNTIL Wrep = 0
          PERFORM WITH TEST AFTER UNTIL Wrep>=0 AND Wrep<=5
           DISPLAY 'Que souhaitez vous faire ?'
           DISPLAY ' 1 - Ajouter un utilisateur'
           DISPLAY ' 2 - Modifier un utilisateur'
           DISPLAY ' 3 - Supprimer un utilisateur'
           DISPLAY ' 4 - Consulter les utilisateurs pour un role' 
           DISPLAY ' 5 - Consulter tous les utilisateurs'      
           DISPLAY ' 0 - Quitter'
           ACCEPT Wrep
          END-PERFORM

          EVALUATE Wrep
           WHEN 1
            PERFORM AJOUTER_UTILISATEUR
           WHEN 2
            PERFORM MODIFIER_UTILISATEUR
           WHEN 3
            PERFORM SUPPRIMER_UTILISATEUR
           WHEN 4 
            PERFORM CONSULTER_UTILISATEUR_ROLE
           WHEN 5
            PERFORM CONSULTER_UTILISATEUR_TOUT
          END-EVALUATE
         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
           DISPLAY 'Souhaitez vous faire autre chose ? 1:oui, 0:non'
           ACCEPT Wrep
         END-PERFORM
       END-PERFORM.




      ****************************************************************
       COPY proc_utilisateur.
