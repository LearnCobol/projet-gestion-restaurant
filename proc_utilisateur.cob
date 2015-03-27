      *************************************************************
      *RECHERCHER_ID_UTILISATEUR
      *Permet de retourner l'ID suivant le dernier (ou ID libre)
      *pour sont affectation à l'ajout d'utilisateur
      *************************************************************
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
        AT END
         MOVE 1 TO Wfin
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



      *************************************************************
      *AJOUTER_UTILISATEUR
      *Ajoute un utilisateur avec un role (Directeur ou gérant)
      *Si un pseudonyme est déjà utilisé, le signal
      *************************************************************
       AJOUTER_UTILISATEUR.

       OPEN I-O futilisateurs

       DISPLAY '|====================================|'
       DISPLAY '|=========== AJOUT        ===========|'
       DISPLAY '|===========  D''UN        ===========|'
       DISPLAY '|===========  UTILISATEUR ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '


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
         DISPLAY 'Utilisateur enregistré'
         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Ajouter un autre utilisateur ? 1 : oui, 0 : non'
          ACCEPT Wrep
         END-PERFORM
        NOT INVALID KEY
         DISPLAY 'Pseudo déjà utilisé'
         DISPLAY '=============================='
        END-START
       END-PERFORM
       CLOSE futilisateurs.


      *************************************************************
      *MODIFIER_UTILISATEUR
      *Permet la modification d'un utilisateur
      *Demande un pseudonyme d'utilisateur, retourne ses informations
      *Prend en compte seulement les champs modifiés et les réécrit
      *************************************************************
       MODIFIER_UTILISATEUR.

       OPEN I-O futilisateurs

       DISPLAY '|====================================|'
       DISPLAY '|=========== MODIFICATION ===========|'
       DISPLAY '|===========  D''UN        ===========|'
       DISPLAY '|===========  UTILISATEUR ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '


       PERFORM WITH TEST AFTER UNTIL Wrep = 0
        DISPLAY 'Donnez le pseudo de l''utilisateur :'
        ACCEPT Wpseudo
        MOVE Wpseudo TO fu_pseudo
        START futilisateurs, KEY IS = fu_pseudo
        INVALID KEY 
         DISPLAY 'Aucun utilisateur n''a ce pseudo'
        NOT INVALID KEY
         READ futilisateurs NEXT
         IF Wpseudo = fu_pseudo THEN
          DISPLAY '================================'
          DISPLAY 'ID : ', fu_id
          DISPLAY 'Pseudo : ',fu_pseudo
          DISPLAY 'Mdp : ',fu_mdp
          DISPLAY 'Role : ',fu_role
         END-IF
         MOVE SPACE TO Wrole
         MOVE SPACE TO Wpseudo
         MOVE SPACE TO Wmdp
         DISPLAY 'Nouveau pseudo :'
         ACCEPT Wpseudo
         DISPLAY 'Nouveau mdp'
         ACCEPT Wmdp
         DISPLAY 'Rentrez seulement les informations concernées par '
     -   'la modification'
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
         IF fu_stat = 0 THEN
          DISPLAY 'Utilisateur modifié'
         ELSE
          DISPLAY fu_stat
         END-IF
        END-START
        PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
         DISPLAY 'Modifier un autre utilisateur ? 1 : oui, 0 : non'
         ACCEPT Wrep
        END-PERFORM
       END-PERFORM
       CLOSE futilisateurs
       DISPLAY '================================'.


      *************************************************************
      *SUPPRIMER_UTILISATEUR
      *Permet la suppression d'un utilisateur
      *Demande un pseudonyme d'utilisateur, retourne ses informations
      *Demande confirmation et supprime l'utilisateur du fichier
      *************************************************************
       SUPPRIMER_UTILISATEUR.

       OPEN I-O futilisateurs

       DISPLAY '|====================================|'
       DISPLAY '|=========== SUPPRESSION  ===========|'
       DISPLAY '|===========  D''UN        ===========|'
       DISPLAY '|===========  UTILISATEUR ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '


       PERFORM WITH TEST AFTER UNTIL Wrep = 0
        DISPLAY 'Donnez le pseudo de l''utilisateur :'
        ACCEPT Wpseudo
        MOVE Wpseudo TO fu_pseudo
        START futilisateurs, KEY IS = fu_pseudo
        INVALID KEY 
         DISPLAY 'Aucun utilisateur n''a ce pseudo'
        NOT INVALID KEY
         READ futilisateurs NEXT
         IF Wpseudo = fu_pseudo THEN
          DISPLAY '================================'
          DISPLAY 'ID : ', fu_id
          DISPLAY 'Pseudo : ',fu_pseudo
          DISPLAY 'Mdp : ',fu_mdp
          DISPLAY 'Role : ',fu_role
         END-IF
         MOVE 0 TO Wchoix
         PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
          DISPLAY 'Supprimer définitivement l''utilisateur ? '
     -    '1 : oui, 0 : non'
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
        END-START
        PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
         DISPLAY 'Modifier un autre utilisateur ? 1 : oui, 0 : non'
         ACCEPT Wrep
        END-PERFORM
       END-PERFORM
       CLOSE futilisateurs.


      *************************************************************
      *CONSULTER_UTILISATEUR_ROLE
      *Permet la consultation de tous les utilisateurs ayant le même role
      *Demande de choisir entre les deux role
      *Lit le fichier par la clé secondaire fu_role
      *Affiche tous les utilisateurs (et leurs infos)
      *************************************************************
       CONSULTER_UTILISATEUR_ROLE.

       OPEN INPUT futilisateurs

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========  D''UN        ===========|'
       DISPLAY '|===========  UTILISATEUR ===========|'
       DISPLAY '|=========== PAR ROLE     ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '


       PERFORM WITH TEST AFTER UNTIL Wrep = 0
        MOVE 0 TO Wfin
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
         DISPLAY '================================'
         DISPLAY 'Tous les ',fu_role
         DISPLAY '================================'
         PERFORM WITH TEST AFTER UNTIL Wfin = 1
          READ futilisateurs NEXT
          AT END
           MOVE 1 TO Wfin
          NOT AT END
           IF Wrole = fu_role THEN
            DISPLAY 'ID : ', fu_id
            DISPLAY 'Pseudo : ',fu_pseudo
            DISPLAY 'Mdp : ',fu_mdp
            DISPLAY 'Role : ',fu_role
            DISPLAY '--------------------------------'
           END-IF
          END-READ
         END-PERFORM
         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Consulter autre role utilisateur ? 1 : oui, 0 : non'
          ACCEPT Wrep
         END-PERFORM
        END-START
       END-PERFORM
       CLOSE futilisateurs
       DISPLAY '================================'.


      *************************************************************
      *CONSULTER_UTILISATEUR_TOUT
      *Permet la consultation de tous les utilisateurs
      *Lit le fichier et affiche tous les utilisateurs
      *************************************************************
       CONSULTER_UTILISATEUR_TOUT.

       OPEN INPUT futilisateurs

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========  DES         ===========|'
       DISPLAY '|=========== UTILISATEURS ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '


       DISPLAY 'Tous les utilisateurs'
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ futilisateurs NEXT
        AT END
         MOVE 1 TO Wfin
        NOT AT END
         DISPLAY '--------------------------------------'
         DISPLAY 'ID : ', fu_id
         DISPLAY 'Pseudo : ',fu_pseudo
         DISPLAY 'Mdp : ',fu_mdp
         DISPLAY 'Role : ',fu_role
        END-READ
       END-PERFORM
       CLOSE futilisateurs
       DISPLAY '================================'.

