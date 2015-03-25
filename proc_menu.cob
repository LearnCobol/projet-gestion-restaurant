       AJOUTER_MENU.
          DISPLAY '=============================='
          DISPLAY '======== AJOUT       ========='
          DISPLAY '========    D UN     ========='
          DISPLAY '========      MENU   ========='
          DISPLAY '=============================='

          OPEN I-O fmenus

          MOVE 0 TO Wfin

          PERFORM WITH TEST AFTER UNTIL Wfin = 1

           DISPLAY ' '
           DISPLAY 'Saisir le nom du menu menu :'
           ACCEPT fm_nom
           DISPLAY '==='
           DISPLAY ' '

           READ fmenus
            INVALID KEY
             MOVE 1 TO Wfin
            NOT INVALID KEY
             DISPLAY 'Un menu porte déjà ce nom'
           END-READ

          END-PERFORM

          OPEN INPUT fplats
          MOVE 0 TO WprixCarte
          
          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
           DISPLAY 'Nom de lentrée : '     
           ACCEPT fp_nom
           READ fplats
            INVALID KEY
             DISPLAY 'Aucune entrée ne porte ce nom'
            NOT INVALID KEY
             IF fp_type = 'Entrée'
              MOVE fp_nom TO fm_entree
              ADD fp_prix TO WprixCarte
              MOVE 1 TO Wfin
             ELSE
              DISPLAY 'Aucune entrée ne porte ce nom'
           END-READ
          END-PERFORM

          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
           DISPLAY 'Nom du plat : '     
           ACCEPT fp_nom
           READ fplats
            INVALID KEY
             DISPLAY 'Aucun plat ne porte ce nom'
            NOT INVALID KEY
             IF fp_type = 'Plat'
              MOVE fp_nom TO fm_plat
              ADD fp_prix TO WprixCarte
              MOVE 1 TO Wfin
             ELSE
              DISPLAY 'Aucun plat ne porte ce nom'
           END-READ
          END-PERFORM

          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
           DISPLAY 'Nom du dessert : '     
           ACCEPT fp_nom
           READ fplats
            INVALID KEY
             DISPLAY 'Aucun dessert ne porte ce nom'
            NOT INVALID KEY
             IF fp_type = 'Dessert'
              MOVE fp_nom TO fm_dessert
              ADD fp_prix TO WprixCarte
              MOVE 1 TO Wfin
             ELSE
              DISPLAY 'Aucun dessert ne porte ce nom'
           END-READ
          END-PERFORM

          PERFORM WITH TEST AFTER UNTIL fp_prix <= WprixCarte
           DISPLAY 'Prix du menu (tarif à la carte :',WprixCarte,'€)'
           ACCEPT fm_prix

           IF fp_prix > WprixCarte THEN
            DISPLAY 'prix du menu < prix à la carte'
           END-IF
          END-PERFORM

          WRITE mTampon END-WRITE

          CLOSE fplats

          CLOSE fmenus

          DISPLAY '=============================='.

         CONSULTER_MENU.
          DISPLAY '=============================='
          DISPLAY '======== AFFICHAGE   ========='
          DISPLAY '========    D UN     ========='
          DISPLAY '========      MENU   ========='
          DISPLAY '=============================='

          DISPLAY ' '
          DISPLAY 'Saisir le nom du menu à afficher :'
          ACCEPT fm_nom
          DISPLAY '==='
          DISPLAY ' '
          
          OPEN INPUT fmenus

          READ fmenus
           INVALID KEY
             DISPLAY 'Aucun menu ne porte ce nom !'
           NOT INVALID KEY
            DISPLAY 'MENU "',fm_nom,'" (',fm_prix,' €)'
            OPEN INPUT fplats

             MOVE fm_entree TO fp_nom
             READ fplats
               INVALID KEY
                DISPLAY 'Erreur lors de la lecture de lentrée'
               NOT INVALID KEY
                DISPLAY 'Entrée : ',fp_nom
             END-READ

             MOVE fm_plat TO fp_nom
             READ fplats
               INVALID KEY
                DISPLAY 'Erreur lors de la lecture du plat'
               NOT INVALID KEY
                DISPLAY 'Plat : ',fp_nom
             END-READ

             MOVE fm_dessert TO fp_nom
             READ fplats
               INVALID KEY
                DISPLAY 'Erreur lors de la lecture du dessert'
               NOT INVALID KEY
                DISPLAY 'Dessert : ',fp_nom
             END-READ

            CLOSE fplats
            
          END-READ

          CLOSE fmenus

          DISPLAY '=============================='.


         SUPPRIMER_MENU.
          DISPLAY '=============================='
          DISPLAY '======== SUPPRESSION ========='
          DISPLAY '========    D UN     ========='
          DISPLAY '========      MENU   ========='
          DISPLAY '=============================='

          DISPLAY ' '
          DISPLAY 'Saisir le nom du menu à supprimer :'
          ACCEPT fm_nom
          DISPLAY '==='

          DISPLAY '=============================='.

         CONSULTER_MENU_BUDGET.
          DISPLAY '=============================='
          DISPLAY '======== CONSULTER   ========='
          DISPLAY '========    UN       ========='
          DISPLAY '========      MENU   ========='
          DISPLAY '=============================='

          OPEN INPUT fmenus

          DISPLAY 'Saisir votre budget maximum :'
          ACCEPT Wbudget

          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
           READ fmenus NEXT
           AT END
            MOVE 1 TO Wfin
           NOT AT END
            IF fm_prix <= Wbudget THEN
             DISPLAY fm_nom,' (',fm_prix,' €)'
            END-IF
          END-PERFORM
          CLOSE fmenus

          DISPLAY '=============================='.

         MODIFIER_MENU.
         DISPLAY '=============================='
         DISPLAY '========  MODIFIER   ========='
         DISPLAY '========    UN       ========='
         DISPLAY '========      MENU   ========='
         DISPLAY '=============================='
         .
