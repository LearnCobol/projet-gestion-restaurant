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
       

       AJOUTER_CLIENT.
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

         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Souhaitez vous continuer? 0 : non, 1 : oui'
          ACCEPT Wrep
         END-PERFORM
       END-PERFORM
       CLOSE fclients.
       
       AFFICHER_CLIENT.
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

       CONSULTER_CLIENT.
       OPEN INPUT fclients
       MOVE 0 TO Wchoix
       PERFORM WITH TEST AFTER UNTIL Wchoix <= 4 AND Wchoix > 0
        DISPLAY 'Que souhaitez vous faire ?'
        DISPLAY '1 - voir tous les clients'
        DISPLAY '2 - Faire une recherche à partir dun nom'
        DISPLAY '3 - Faire une recherche à partir dune ville'
        DISPLAY '4 - voir les coordonnées d''un client à partir'
      -  'de son id'
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
                  PERFORM AFFICHER_CLIENT
                END-IF
              END-READ
            END-PERFORM
         WHEN 3
           MOVE 0 TO Wfin
           DISPLAY 'Donnez la ville que vous souhaitez consulter'
           ACCEPT WvilleCli
           MOVE WvilleCli TO fc_ville
           START fclients, KEY IS = fc_ville
           INVALID KEY 
           DISPLAY 'Aucun client n habite pas dans cette ville'
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
           DISPLAY 'Donnez lidentifiant du client'
           ACCEPT fc_id
           READ fclients
           INVALID KEY DISPLAY 'Aucun client ne possède' 
      -    'cet identifiant'
           NOT INVALID KEY 
           PERFORM AFFICHER_CLIENT           
       END-EVALUATE
       CLOSE fclients.
      
       MODIFIER_CLIENT.
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
       CLOSE fclients.

       SUPPRIMER_CLIENT.
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
       DISPLAY 'Donnez lidentifiant du client concerné'
       ACCEPT fc_id
       READ fclients
       INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
       NOT INVALID KEY
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
       CLOSE fclients.
