      *************************************************************
      *OPERATION_UTILISATEUR
      *Menu permettant de choisir son action sur le fichier utilisateurs
      *Accessible seulement par le role Directeur
      *************************************************************
       OPERATION_UTILISATEUR.

       DISPLAY '================================'
       DISPLAY '========= MENU         ========='
       DISPLAY '========= GESTION      ========='
       DISPLAY '========= UTILISATEUR  ========='
       DISPLAY '================================'

       PERFORM WITH TEST AFTER UNTIL Wmenu = 0
        PERFORM WITH TEST AFTER UNTIL Wmenu>=0 AND Wmenu<=5
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY ' 1 - Ajouter un utilisateur'
         DISPLAY ' 2 - Modifier un utilisateur'
         DISPLAY ' 3 - Supprimer un utilisateur'
         DISPLAY ' 4 - Consulter les utilisateurs pour un role' 
         DISPLAY ' 5 - Consulter tous les utilisateurs'      
         DISPLAY ' 0 - Quitter'
         DISPLAY '================================'
         ACCEPT Wmenu
        END-PERFORM
        EVALUATE Wmenu
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
       END-PERFORM.




      ****************************************************************
       COPY proc_utilisateur.
