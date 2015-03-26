       RECHERCHER_ID_UTILISATEUR.
       OPEN INPUT futilisateurs
       IF fu_stat = 41 THEN
         CLOSE futilisateurs
         OPEN I-O futilisateurs 
       END-IF
       MOVE 0 TO Wid
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ futilisateurs NEXT
         AT END MOVE 1 TO Wfin
         ADD 1 TO Wid 
         NOT AT END 
         IF fu_id = Wid + 1 THEN
           MOVE fu_id TO Wid
         ELSE 
           ADD 1 TO Wid
           MOVE 1 TO Wfin
         END-IF
         END-READ
       END-PERFORM.




       AJOUTER_UTILISATEUR.
       OPEN I-O futilisateurs
       DISPLAY '=============================='
       DISPLAY '======== AJOUT       ========='
       DISPLAY '======== D UN        ========='
       DISPLAY '======== UTILISATEUR ========='
       DISPLAY '=============================='

       MOVE 1 TO Wrep
       PERFORM WITH TEST AFTER UNTIL Wrep = 0
        PERFORM RECHERCHER_ID_UTILISATEUR
        MOVE Wid TO fu_id
        DISPLAY 'Donnez les informations de l''utilisateur'
        DISPLAY 'Pseudo de l''utilisateur: '
        ACCEPT Wpseudo
        MOVE Wpseudo TO fu_pseudo
        START futilisateurs, KEY IS = fu_pseudo
        INVALID KEY
         DISPLAY 'Mot de passe de l''utilisateur: ',fu_pseudo
         ACCEPT fu_mdp
         PERFORM WITH TEST AFTER UNTIL Wutil>=1 AND Wutil<=2
          DISPLAY 'Role de l''utilisateur ?'
          DISPLAY ' 1 - Gérant'
          DISPLAY ' 2 - Directeur'
          ACCEPT Wutil
         END-PERFORM
         EVALUATE Wutil
          WHEN 1
           MOVE 'Gérant' TO fu_role
          WHEN 2
           MOVE 'Directeur' TO fu_role
         END-EVALUATE
         WRITE uTampon
         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Souhaitez vous continuer? 0 : non, 1 : oui'
          ACCEPT Wrep
         END-PERFORM
        NOT INVALID KEY
         DISPLAY 'Pseudo déjà utilisé'
         DISPLAY '=============================='
       END-PERFORM
       CLOSE futilisateurs.



       MODIFIER_UTILISATEUR.

       OPEN I-O futilisateurs
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wrep = 0
       DISPLAY 'Donnez le pseudo de l''utilisateur :'
       ACCEPT Wpseudo
       MOVE Wpseudo TO fu_pseudo
       START futilisateurs, KEY IS = fu_pseudo
       INVALID KEY 
       DISPLAY 'Aucun utilisateur n''a ce pseudo'
       NOT INVALID KEY
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ futilisateurs NEXT
        AT END MOVE 1 TO Wfin
        NOT AT END
        IF Wpseudo = fu_pseudo THEN
         DISPLAY '=============================='
         DISPLAY 'ID : ', fu_id
         DISPLAY 'Pseudo : ',fu_pseudo
         DISPLAY 'Mdp : ',fu_mdp
         DISPLAY 'Role : ',fu_role
        END-IF
        END-READ
       END-PERFORM

       READ futilisateurs
       INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
       NOT INVALID KEY
       MOVE SPACE TO Wrole
       MOVE SPACE TO Wpseudo
       MOVE SPACE TO Wmdp
          DISPLAY 'Nouveau pseudo :'
         ACCEPT Wpseudo
          DISPLAY 'Nouveau mdp'
         ACCEPT Wmdp
       DISPLAY 'Donnez les informations concernées par la modification'
       DISPLAY 'Nouveau role de l''utilisateur'     
          PERFORM WITH TEST AFTER UNTIL Wchoix>=1 AND Wchoix<=2
           DISPLAY 'Role de l''utilisateur ?'
           DISPLAY ' 1 - Gérant'
           DISPLAY ' 2 - Directeur'
           ACCEPT Wchoix
          END-PERFORM

          EVALUATE Wchoix
           WHEN 1
            MOVE 'Gérant' TO Wrole
           WHEN 2
            MOVE 'Directeur' TO Wrole
          END-EVALUATE

       END-READ
       IF Wpseudo NOT = SPACE
         MOVE Wpseudo TO fu_pseudo
       END-IF 
       IF Wmdp NOT = SPACE
         MOVE Wmdp TO fu_mdp
       END-IF 
       IF Wrole NOT = SPACE
         MOVE Wrole TO fu_role
       END-IF
       REWRITE uTampon
         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Modifier un autre utilisateur ? 0 : non, 1 : oui'
         ACCEPT Wrep
         END-PERFORM
         END-PERFORM
       CLOSE futilisateurs
       DISPLAY '=============================='.



       SUPPRIMER_UTILISATEUR.

       OPEN I-O futilisateurs
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wrep = 0
       DISPLAY 'Donnez le pseudo de l''utilisateur :'
       ACCEPT Wpseudo
       MOVE Wpseudo TO fu_pseudo
       START futilisateurs, KEY IS = fu_pseudo
       INVALID KEY 
       DISPLAY 'Aucun utilisateur n''a ce pseudo'
       NOT INVALID KEY
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ futilisateurs NEXT
        AT END MOVE 1 TO Wfin
        NOT AT END
        IF Wpseudo = fu_pseudo THEN
         DISPLAY '=============================='
         DISPLAY 'ID : ', fu_id
         DISPLAY 'Pseudo : ',fu_pseudo
         DISPLAY 'Mdp : ',fu_mdp
         DISPLAY 'Role : ',fu_role
        END-IF
        END-READ
       END-PERFORM

       READ futilisateurs
       INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
       NOT INVALID KEY
       MOVE 0 TO Wchoix
       PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
         DISPLAY 'Supprimer définitivement l''utilisateur ? 1/0'
         ACCEPT Wchoix
       END-PERFORM
       IF Wchoix = 1 THEN
         DELETE futilisateurs
         INVALID KEY
         DISPLAY 'erreur lors de la suppression'
         NOT INVALID KEY
         DISPLAY 'L''utilisateur a été supprimé avec succès'
       ELSE
         DISPLAY 'L''utilisateur na pas été supprimé'
       END-IF
       END-READ
       PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Modifier un autre utilisateur ? 0 : non, 1 : oui'
         ACCEPT Wrep
         END-PERFORM
       END-PERFORM
       CLOSE futilisateurs.


       CONSULTER_UTILISATEUR_ROLE.

       OPEN INPUT futilisateurs
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wrep = 0
       DISPLAY 'Choisir le role'

       PERFORM WITH TEST AFTER UNTIL Wrep>=1 AND Wrep<=2
           DISPLAY 'Role de l''utilisateur ?'
           DISPLAY ' 1 - Gérant'
           DISPLAY ' 2 - Directeur'
           ACCEPT Wrep
          END-PERFORM

          EVALUATE Wrep
           WHEN 1
            MOVE 'Gérant' TO Wrole
           WHEN 2
            MOVE 'Directeur' TO Wrole
          END-EVALUATE

       MOVE Wrole TO fu_role
       START futilisateurs, KEY IS = fu_role
       INVALID KEY 
       DISPLAY 'Il n''y a pas d''utilisateur avec ce role'
       NOT INVALID KEY
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ futilisateurs NEXT
        AT END MOVE 1 TO Wfin
        NOT AT END
        IF Wrole = fu_role THEN
         DISPLAY 'Tous les ',fu_role
         DISPLAY '=============================='
         DISPLAY 'ID : ', fu_id
         DISPLAY 'Pseudo : ',fu_pseudo
         DISPLAY 'Mdp : ',fu_mdp
         DISPLAY 'Role : ',fu_role
        END-IF
        END-READ
       END-PERFORM
       PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Consulter autre role utilisateur ? 0 : non, 1 : oui'
         ACCEPT Wrep
        END-PERFORM
       END-PERFORM

       CLOSE futilisateurs
          DISPLAY '=============================='.



       CONSULTER_UTILISATEUR_TOUT.

       OPEN INPUT futilisateurs

          DISPLAY 'Tous les utilisateurs'

          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
           READ futilisateurs NEXT
           AT END
            MOVE 1 TO Wfin
           NOT AT END
       DISPLAY '=============================='
         DISPLAY 'ID : ', fu_id
         DISPLAY 'Pseudo : ',fu_pseudo
         DISPLAY 'Mdp : ',fu_mdp
         DISPLAY 'Role : ',fu_role
          END-PERFORM
          CLOSE futilisateurs

          DISPLAY '=============================='.
