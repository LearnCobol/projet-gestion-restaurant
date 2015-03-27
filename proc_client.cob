      ********************RECHERCHER_NUM_CLIENT*******************
      *Parcours le fichier client pour rechercher l'identifiant  *
      *dipsonible pour un nouvel enregistrementn permet          *
      * l'auto-incrémentation de l'indentifiant du client        *
      ************************************************************
       RECHERCHER_NUM_CLIENT.
       OPEN INPUT fclients
       IF fc_stat = 41 THEN
         CLOSE fclients
         OPEN I-O fclients 
       END-IF
       MOVE 0 TO Wnum
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ fclients NEXT
         AT END MOVE 1 TO Wfin
         ADD 1 TO Wnum 
         NOT AT END 
         IF fc_id = Wnum + 1 THEN
           MOVE fc_id TO Wnum
         ELSE 
           ADD 1 TO Wnum
           MOVE 1 TO Wfin
         END-IF
         END-READ
       END-PERFORM.
       
      ****************AJOUTER_CLIENT***************************
       AJOUTER_CLIENT.

       DISPLAY '|====================================|'
       DISPLAY '|=========== AJOUT        ===========|'
       DISPLAY '|===========    D''UN      ===========|'
       DISPLAY '|===========       CLIENT ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       OPEN I-O fclients
       IF fc_stat = 35 THEN
         OPEN OUTPUT fclients
       END-IF

       PERFORM WITH TEST AFTER UNTIL Wrep = 0
         DISPLAY 'Donnez les informations du client'
         PERFORM RECHERCHER_NUM_CLIENT
         MOVE Wnum TO fc_id
         DISPLAY 'Nom du client: '
         ACCEPT fc_nom
         DISPLAY 'Prenom du client: '
         ACCEPT fc_prenom
         DISPLAY 'Numéro de téléphone: '
         ACCEPT fc_tel
         DISPLAY 'adresse mail: '
         ACCEPT fc_mail
         DISPLAY 'Adresse du client: '
         ACCEPT fc_rue
         DISPLAY 'ville: '
         ACCEPT fc_ville
         DISPLAY 'Code postal: '
         ACCEPT fc_codeP
         MOVE 0 TO fc_nbReserv
         MOVE 0 TO fc_pctReduc
         WRITE cliTampon
         IF fc_stat = 0 THEN
           DISPLAY "Le client a été enregistré"
         END-IF

         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Souhaitez vous continuer? 0 : non, 1 : oui'
          ACCEPT Wrep
         END-PERFORM
       END-PERFORM
       DISPLAY '-====================================-'
       CLOSE fclients.
      ********************AFFICHER_CLIENT**********************
      *Affiche tous les attributs d'un client                 *
      *********************************************************
       AFFICHER_CLIENT.

       DISPLAY '--------------------------------------'
       DISPLAY ' '

       MULTIPLY 100 BY fc_pctReduc GIVING WpctReduc
       DISPLAY 'Identifiant :', fc_id
       DISPLAY 'Nombre de réservation:'fc_nbReserv,
       DISPLAY 'Pourcentage de réduction : ',WpctReduc,'%'
       DISPLAY 'Nom : ', fc_nom
       DISPLAY 'Prenom : ',fc_prenom
       DISPLAY 'Numéro de téléphone : ',fc_tel
       DISPLAY 'Adresse mail : ',fc_mail
       DISPLAY 'Adresse postale : ',fc_rue
       DISPLAY fc_codeP
       DISPLAY fc_ville. 

      ***********************CONSULTER_CLIENT********************
      *Consulter la liste des clients en fonction d'un nom de la*
      *ville ou directement de l'identifiant                    *
      *********************************************************** 
       CONSULTER_CLIENT.

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       CLIENT ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       OPEN INPUT fclients
       MOVE 0 TO Wchoix
       PERFORM WITH TEST AFTER UNTIL Wchoix <= 4 AND Wchoix > 0
        DISPLAY 'Que souhaitez vous faire ?'
        DISPLAY '1 - voir tous les clients'
        DISPLAY '2 - Faire une recherche à partir dun nom'
        DISPLAY '3 - Faire une recherche à partir dune ville'
        DISPLAY '4 - voir les coordonnées d''un client à partir'
      -  ' de son id'
        DISPLAY ' '
        DISPLAY '-====================================-'
        ACCEPT Wchoix
       END-PERFORM
       EVALUATE Wchoix
         WHEN 1
          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
            READ fclients NEXT
              AT END MOVE 1 TO Wfin
              NOT AT END PERFORM AFFICHER_CLIENT
            END-READ
          END-PERFORM 
         WHEN 2
           MOVE 0 TO Wfin
           DISPLAY ' '
           DISPLAY 'Donnez un nom de client'
           ACCEPT WnomCli
           MOVE WnomCli TO fc_nom
           START fclients, KEY IS = fc_nom
           INVALID KEY
           DISPLAY ' '
           DISPLAY 'Aucun client ne porte ce nom'
           DISPLAY ' '
           NOT INVALID KEY
            PERFORM WITH TEST AFTER UNTIL Wfin = 1
              READ fclients NEXT
                AT END MOVE 1 TO Wfin
                NOT AT END
                IF WnomCli = fc_nom THEN
                  PERFORM AFFICHER_CLIENT
                END-IF
              END-READ
            END-PERFORM
         WHEN 3
           MOVE 0 TO Wfin
           DISPLAY ' '
           DISPLAY 'Donnez la ville que vous souhaitez consulter'
           ACCEPT WvilleCli
           MOVE WvilleCli TO fc_ville
           START fclients, KEY IS = fc_ville
           INVALID KEY 
           DISPLAY ' '
           DISPLAY 'Aucun client n''habite dans cette ville'
           DISPLAY ' '
           NOT INVALID KEY
            PERFORM WITH TEST AFTER UNTIL Wfin = 1
              READ fclients NEXT
                AT END MOVE 1 TO Wfin
                NOT AT END
                IF WvilleCli = fc_ville THEN
                  PERFORM AFFICHER_CLIENT
                END-IF
              END-READ
            END-PERFORM
         WHEN 4
           DISPLAY ' '
           DISPLAY 'Donnez lidentifiant du client'
           ACCEPT fc_id
           READ fclients
           INVALID KEY
            DISPLAY ' '
            DISPLAY 'Aucun client ne possède ' 
      -     'cet identifiant'
            DISPLAY ' '
           NOT INVALID KEY 
            PERFORM AFFICHER_CLIENT
       DISPLAY '-====================================-'
       END-EVALUATE
       CLOSE fclients.

      *****************MODIFIER_CLIENT****************************
      *Permet de modifier toutes les informations d'un client    *
      ************************************************************
      
       MODIFIER_CLIENT.

       DISPLAY '|====================================|'
       DISPLAY '|=========== MODIFICATION ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       CLIENT ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       OPEN I-O fclients
       MOVE 0 TO Wfin
       DISPLAY 'Donnez un nom de client'
       ACCEPT WnomCli
       MOVE WnomCli TO fc_nom
       START fclients, KEY IS = fc_nom
       INVALID KEY 
       DISPLAY 'Aucun client ne porte ce nom'
       NOT INVALID KEY
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ fclients NEXT
        AT END MOVE 1 TO Wfin
        NOT AT END
        IF WnomCli = fc_nom THEN
         DISPLAY 'Identifiant :', fc_id
         DISPLAY 'Nom : ', fc_nom
         DISPLAY 'Prenom : ',fc_prenom
         DISPLAY 'Numéro de téléphone : ',fc_tel
         DISPLAY 'Adresse mail : ',fc_mail
        END-IF
        END-READ
       END-PERFORM
       DISPLAY 'Donnez lidentifiant du client concerné par la modif'
       ACCEPT fc_id
       READ fclients
       INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
       CLOSE fclients
       NOT INVALID KEY
       MOVE SPACE TO WnomCli
       MOVE SPACE TO WprenomCli
       MOVE LOW-VALUE TO WtelCli
       MOVE SPACE TO WrueCli
       MOVE SPACE TO WvilleCli
       MOVE LOW-VALUE TO WcodePCli
       MOVE SPACE TO WmailCli
       MOVE LOW-VALUE TO WnbReservCli
       DISPLAY 'Donnez les informations concernées par la modification'
       DISPLAY 'Nom du client: '
       ACCEPT WnomCli
       DISPLAY 'Prenom du client: '
       ACCEPT WprenomCli
       DISPLAY 'Numéro de téléphone: '
       ACCEPT WtelCli
       DISPLAY 'adresse mail: '
       ACCEPT WmailCli
       DISPLAY 'Adresse du client: '
       ACCEPT WrueCli
       DISPLAY 'ville: '
       ACCEPT WvilleCli
       DISPLAY 'Code postal: '
       ACCEPT WcodePCli
       DISPLAY 'Nombre de réservation: '
       ACCEPT WnbReservCli
       IF WnomCli NOT = SPACE 
         MOVE WnomCli TO fc_nom
       END-IF 
       IF WprenomCli NOT = SPACE
         MOVE WprenomCli TO fc_prenom
       END-IF
       IF WtelCli NOT = 0
         MOVE WtelCli TO fc_tel
       END-IF 
       IF WmailCli NOT = SPACE
         MOVE WmailCli TO fc_mail
       END-IF
       IF WrueCli NOT = SPACE
         MOVE WrueCli TO fc_rue
       END-IF 
       IF WvilleCli NOT = SPACE
         MOVE WvilleCli TO fc_ville
       END-IF
       IF WcodePCli NOT = 0
         MOVE WcodePCli TO fc_codeP
       END-IF
       IF WnbReservCli NOT = 0
         MOVE WnbReservCli TO fc_nbReserv
       END-IF
       REWRITE cliTampon
       IF fc_stat = 0 THEN  
         DISPLAY 'Le client a été modifié'
       ELSE
         DISPLAY 'erreur lors de la modification'
       END-IF
       DISPLAY '-====================================-'
       CLOSE fclients.

      ****************SUPPRIMER_CLIENT******************************
      *Possibilité de supprimer un client uniquement si il n'a pas *
      *fait de réservation                                         *
      **************************************************************
       SUPPRIMER_CLIENT.

       DISPLAY '|====================================|'
       DISPLAY '|=========== SUPPRESSION  ===========|'
       DISPLAY '|===========     DE       ===========|'
       DISPLAY '|===========       CLIENT ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       OPEN I-O fclients
       OPEN INPUT freservations
       MOVE 0 TO Wfin
       DISPLAY 'Donnez un nom de client'
       ACCEPT WnomCli
       MOVE WnomCli TO fc_nom
       START fclients, KEY IS = fc_nom
       INVALID KEY 
       DISPLAY 'Aucun client ne porte ce nom'
       NOT INVALID KEY
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ fclients NEXT
        AT END MOVE 1 TO Wfin
        NOT AT END
        IF WnomCli = fc_nom THEN
         DISPLAY 'Identifiant :', fc_id
         DISPLAY 'Nom : ', fc_nom
         DISPLAY 'Prenom : ',fc_prenom
         DISPLAY 'Numéro de téléphone : ',fc_tel
         DISPLAY 'Adresse mail : ',fc_mail
        END-IF
        END-READ
       END-PERFORM
       DISPLAY 'Donnez lidentifiant du client concerné'
       ACCEPT fc_id
       READ fclients
       INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
       NOT INVALID KEY
       MOVE fc_id TO frs_idCli
       START freservations, KEY IS = frs_idCli
       INVALID KEY
         MOVE 0 TO Wchoix
         PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
           DISPLAY 'Supprimer définitivement le client ? 1/0'
           ACCEPT Wchoix
         END-PERFORM
         IF Wchoix = 1 THEN
           DELETE fclients
           INVALID KEY
             DISPLAY 'erreur lors de la suppression'
           NOT INVALID KEY
             DISPLAY 'le client a été supprimé avec succès'
         ELSE
           DISPLAY 'Le client na pas été supprimé'
         END-IF
       NOT INVALID KEY
          DISPLAY 'Le client ne peut pas être supprimé car il a '
     - 'déjà effectuée une réservation'
       DISPLAY '-====================================-'
       CLOSE fclients
       CLOSE freservations.

      ****************CALCULER_PRCT_REDUC***************************
      *Calcul le nombre de réservation réalisé par chacun des      *
      *en parcourant le fichier client et le fichier réservation   *
      **************************************************************
       CALCULER_PRCT_REDUC.

       OPEN INPUT freservations
       OPEN I-O fclients
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ fclients NEXT
         AT END MOVE 1 TO Wfin
         NOT AT END     
           MOVE 0 TO fc_nbReserv
           MOVE fc_id TO frs_idCli
           MOVE fc_id TO WidCliSauv           
           MOVE 0 TO Wtrouve
           START freservations, KEY IS = frs_idCli
           NOT INVALID KEY 
             PERFORM WITH TEST AFTER UNTIL Wtrouve = 1
               READ freservations NEXT
               AT END MOVE 1 TO Wtrouve
               NOT AT END 
                 IF frs_idCli = WidCliSauv THEN
                     ADD 1 TO fc_NbReserv
                 END-IF
               END-READ
              END-PERFORM
            END-START
          IF fc_nbReserv < 10 THEN
            MOVE 0 TO fc_pctReduc
            ELSE IF fc_nbReserv < 20 THEN
              MOVE 0.05 TO fc_pctReduc
              ELSE IF fc_nbReserv < 30 THEN
                MOVE 0.10 TO fc_pctReduc
                ELSE IF fc_nbReserv < 40 THEN
                  MOVE 0.15 TO fc_pctReduc
                  ELSE IF fc_nbReserv < 50 THEN
                  MOVE 0.20 TO fc_pctReduc
                  ELSE
                  MOVE 0.25 TO fc_pctReduc
                  END-IF
                END-IF
              END-IF
            END-IF
          END-IF
          REWRITE cliTampon
          END-REWRITE
          IF fc_stat NOT = 0 THEN
           DISPLAY ' '
           DISPLAY 'Erreur lors de l''insertion du client numéro',
     - fc_id 
           DISPLAY ' '
          END-IF
       END-PERFORM
       DISPLAY ' '
       DISPLAY 'Les clients ont été mis à jour'
       DISPLAY ' '
       DISPLAY '-====================================-'
       CLOSE freservations
       CLOSE fclients.
           
       
