      ******************* AJOUTER_PLAT *********************
      * Ajouter un plat dans le fichier fplats
      * Saisir le nom, choisir le type de plat puis son prix
      ******************************************************
       AJOUTER_PLAT.
       OPEN I-O fplats

       DISPLAY '|====================================|'
       DISPLAY '|=========== AJOUT        ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       PLAT   ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        PERFORM WITH TEST AFTER UNTIL Wrep = 0
         DISPLAY 'Donnez les informations du plat'
         DISPLAY 'Nom du plat: '
         ACCEPT fp_nom
         
         WRITE pTampon END-WRITE
         IF fp_stat = 0 THEN

          PERFORM WITH TEST AFTER UNTIL Wplat>=1 AND Wplat<=3
           DISPLAY 'Type du plat ?'
           DISPLAY ' 1 - Entrée'
           DISPLAY ' 2 - Plat'
           DISPLAY ' 3 - Dessert'
           ACCEPT Wplat
          END-PERFORM

          EVALUATE Wplat
           WHEN 1
            MOVE 'Entrée' TO fp_type
            WHEN 2
            MOVE 'Plat' TO fp_type
           WHEN 3
            MOVE 'Dessert' TO fp_type
          END-EVALUATE

          DISPLAY 'Prix du plat (0.0): '
          ACCEPT fp_prix
          WRITE pTampon END-WRITE
          
          IF fp_stat = 0 THEN
           DISPLAY 'Plat enregistré'
          END-IF
          
          REWRITE pTampon END-REWRITE

          PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
           DISPLAY 'Souhaitez vous continuer? 0 : non, 1 : oui'
           ACCEPT Wrep
          END-PERFORM
         ELSE
          DISPLAY 'Erreur lors de l''enregistrement du plat : le nom'
     -            ' du plat existe déjà'
         END-IF
        END-PERFORM

       DISPLAY '-====================================-'
        CLOSE fplats.

      ****************** MODIFIER_PLAT *********************
      * Modifier un des plats de fplat
      * Si un champ n'a pas besoin d'être resaisi, alors il
      * suffit d'appuyer sur entrée
      * Pour séléctionner le plat, il faut saisir son nom
      * Si le nom du plat saisi n'existe pas, alors un
      * message d'erreur est affiché
      ******************************************************
       MODIFIER_PLAT.
        OPEN I-O fplats

       DISPLAY '|====================================|'
       DISPLAY '|=========== MODIFICATION ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       PLAT   ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        
        MOVE 0 TO Wfin
        PERFORM WITH TEST AFTER UNTIL Wrep = 0

         DISPLAY 'Donnez un nom de plat'
         ACCEPT fp_nom

         READ fplats
         INVALID KEY 
          DISPLAY 'Aucun plat ne porte ce nom'
         NOT INVALID KEY
          DISPLAY '-====================================-'
          DISPLAY 'Nom : ', fp_nom
          DISPLAY 'Type : ',fp_type
          DISPLAY 'Prix : ',fp_prix
          
          MOVE SPACE TO WtypeP
          MOVE LOW-VALUE TO WprixP
          DISPLAY 'Donnez les informations concernées '
     -            'par la modification'
          DISPLAY 'Nouveau type du plat'     
          
          PERFORM WITH TEST AFTER UNTIL Wplat>=1 AND Wplat<=3
           DISPLAY 'Type du plat ?'
           DISPLAY ' 1 - Entrée'
           DISPLAY ' 2 - Plat'
           DISPLAY ' 3 - Dessert'
           ACCEPT Wplat
          END-PERFORM

          EVALUATE Wplat
           WHEN 1
            MOVE 'Entrée' TO WtypeP
           WHEN 2
            MOVE 'Plat' TO WtypeP
           WHEN 3
            MOVE 'Dessert' TO WtypeP
          END-EVALUATE

          DISPLAY 'Prix du plat (0.0): '
          ACCEPT WprixP
         
          IF WnomP NOT = SPACE
           MOVE WnomP TO fp_nom
          END-IF
         
          IF WtypeP NOT = SPACE
           MOVE WtypeP TO fp_type
          END-IF
 
          IF WprixP NOT =  0
           MOVE WprixP TO fp_prix
          END-IF

          REWRITE pTampon
          IF fp_stat = 0 THEN
           DISPLAY 'Modification du plat enregistrée'
          ELSE
           DISPLAY 'Erreur lors de l''enregistrement de la'
      -           ' modification du plat'
          END-IF
          PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
           DISPLAY 'Modifier un autre plat? 0 : non, 1 : oui'
           ACCEPT Wrep
          END-PERFORM
         END-READ
        END-PERFORM
        
       DISPLAY '-====================================-'
        
        CLOSE fplats.

      ***************** SUPPRIMER_PLAT *********************
      * Supprimer un plat
      * Pour séléctionner le plat, il faut saisir son nom
      * Si le nom du plat saisi n'existe pas, alors un
      * message d'erreur est affiché
      * Un plat ne peut pas être supprimé s'il appartient à
      * un menu
      ******************************************************
       SUPPRIMER_PLAT.
 
        OPEN I-O fplats

       DISPLAY '|====================================|'
       DISPLAY '|=========== SUPPRESSION  ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       PLAT   ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       
        MOVE 0 TO Wfin
        DISPLAY 'Donnez un nom de plat'
        ACCEPT fp_nom
       
        READ fplats
        INVALID KEY
         DISPLAY 'Aucun plat ne porte ce nom'
        NOT INVALID KEY
       
         DISPLAY '-====================================-'
         DISPLAY 'Nom : ', fp_nom
         DISPLAY 'Type : ',fp_type
         DISPLAY 'Prix : ',fp_prix
       
         MOVE 0 TO Wchoix
         MOVE 1 TO WinMenu
         OPEN INPUT fmenus
        
         IF fp_type = 'Entrée' THEN
          MOVE fp_nom TO fm_entree
          START fmenus, KEY IS = fm_entree
          INVALID KEY
           MOVE 0 TO WinMenu
          
         ELSE IF fp_type = 'Plat' THEN
          MOVE fp_nom TO fm_plat
          START fmenus, KEY IS = fm_plat
           INVALID KEY
           MOVE 0 TO WinMenu
          
         ELSE IF fp_type = 'Dessert' THEN
          MOVE fp_nom TO fm_dessert
          START fmenus, KEY IS = fm_dessert
          INVALID KEY
           MOVE 0 TO WinMenu
         END-IF
         END-IF
         END-IF
       
         CLOSE fmenus
        
         IF WinMenu = 0 THEN
       
          PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
           DISPLAY 'Supprimer définitivement le plat (1:oui 0:non) ?'
           ACCEPT Wchoix
          END-PERFORM
         
          IF Wchoix = 1 THEN
           DELETE fplats
           INVALID KEY
            DISPLAY 'erreur lors de la suppression'
           NOT INVALID KEY
            DISPLAY 'Le plat a été supprimé avec succès'
          ELSE
           DISPLAY 'Le plat na pas été supprimé'
          END-IF
          
         ELSE
          DISPLAY 'Le plat est utilisé dans un menu. '
     -            'Veuillez supprimer le menu avant de supprimer le '
     -            'plat'
         END-IF
        END-READ

       DISPLAY '-====================================-'
        
        CLOSE fplats.



      **************** CONSULTER_PLAT_BUDGET **************
      * Consulter les plats dont le prix est inférieur à
      * une certaine somme
      * Saisir le budget, la liste des plats (s'il y en a)
      * s'affiche alors
      ******************************************************
       CONSULTER_PLAT_BUDGET.

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       PLAT   ===========|'
       DISPLAY '|===========  PAR BUDGET  ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        OPEN INPUT fplats

        DISPLAY 'Saisir votre budget maximum :'
        ACCEPT Wbudget

        MOVE 0 TO Wfin
        PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ fplats NEXT
         AT END
          MOVE 1 TO Wfin
         NOT AT END
          IF fp_prix <= Wbudget THEN
           DISPLAY '-====================================-'
           DISPLAY fp_nom,' ',fp_type, ' (',fp_prix,' €)'
          END-IF
         END-READ
        END-PERFORM

       DISPLAY '-====================================-'

        CLOSE fplats.

      ***************** CONSULTER_PLAT_TYPE ****************
      * Consulter les plats d'un certain type
      * Séléctionner le type parmis ceux proposés
      ******************************************************
       CONSULTER_PLAT_TYPE.

        OPEN INPUT fplats

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       PLAT   ===========|'
       DISPLAY '|===========  PAR TYPE    ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

    
        MOVE 0 TO Wfin
        PERFORM WITH TEST AFTER UNTIL Wrep = 0
         DISPLAY 'Choisir le type'

         PERFORM WITH TEST AFTER UNTIL Wplat>=1 AND Wplat<=3
          DISPLAY 'Type du plat ?'
          DISPLAY ' 1 - Entrée'
          DISPLAY ' 2 - Plat'
          DISPLAY ' 3 - Dessert'
          ACCEPT Wplat
         END-PERFORM

         EVALUATE Wplat
          WHEN 1
           MOVE 'Entrée' TO WtypeP
          WHEN 2
           MOVE 'Plat' TO WtypeP
          WHEN 3
           MOVE 'Dessert' TO WtypeP
         END-EVALUATE

         MOVE WtypeP TO fp_type
    
         START fplats, KEY IS = fp_type
         INVALID KEY 
          DISPLAY 'Il n''y a pas de plat de ce type'
         NOT INVALID KEY
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
           READ fplats NEXT
            AT END 
             MOVE 1 TO Wfin
            NOT AT END
             IF WtypeP = fp_type THEN
              DISPLAY '-====================================-'
              DISPLAY 'Nom : ', fp_nom
              DISPLAY 'Type : ',fp_type
              DISPLAY 'Prix : ',fp_prix
             END-IF
            END-READ
           END-PERFORM
        
           PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
            DISPLAY 'Consulter un autre type de plat ? 0 : non, 1 : oui'
            ACCEPT Wrep
           END-PERFORM
          END-PERFORM
          
       DISPLAY '-====================================-'

        CLOSE fplats.

      ***************** CONSULTER_PLAT_TOUT ****************
      * Consulter l'ensemble des plats proposés
      ******************************************************
       CONSULTER_PLAT_TOUT.

        OPEN INPUT fplats

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       PLAT   ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '


        DISPLAY 'Tous les plats'

        MOVE 0 TO Wfin
        
        PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ fplats NEXT
         AT END
          MOVE 1 TO Wfin
         NOT AT END
          DISPLAY '-====================================-'
          DISPLAY 'Nom : ', fp_nom
          DISPLAY 'Type : ',fp_type
          DISPLAY 'Prix : ',fp_prix
         END-READ
        END-PERFORM

       DISPLAY '-====================================-'

        CLOSE fplats.
