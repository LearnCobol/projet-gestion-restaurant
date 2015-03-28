      *****RECHERCHER NUM RESA****************************************
      *Parcours le fichier réservation pour incrémenter l'identifiant*
      *de la nouvelle réservation à enregistrer                      *
      ****************************************************************
       RECHERCHER_NUM_RESA.
         CLOSE freservations
         OPEN I-O freservations 
       MOVE 0 TO Wnum
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ freservations NEXT
         AT END MOVE 1 TO Wfin
         ADD 1 TO Wnum 
         NOT AT END 
         IF frs_id = Wnum + 1 THEN
           MOVE frs_id TO Wnum
         ELSE 
           ADD 1 TO Wnum
           MOVE 1 TO Wfin
         END-IF
         END-READ
       END-PERFORM.



      **********RECHERCHER CLIENT************************************
      *Rechercher un client à partir de son nom puis taper son      *
      *identifiant parcours le fichier client par nom               *
      ***************************************************************
       RECHERCHER_CLIENT.
       OPEN INPUT fclients

       DISPLAY '|====================================|'
       DISPLAY '|=========== RECHERCHE    ===========|'
       DISPLAY '|===========     D''UN     ===========|'
       DISPLAY '|===========       CLIENT ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       MOVE 0 TO WvaleurOK
       
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
       PERFORM WITH TEST AFTER UNTIL WvaleurOK = 1
         DISPLAY 'Donnez lidentifiant du client pour la réservation:'
         ACCEPT fc_id
         READ fclients
         INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
         NOT INVALID KEY
         MOVE fc_id TO frs_idcli
         MOVE fc_id TO WidCliSauv
         MOVE 1 TO WvaleurOK
       END-PERFORM
       DISPLAY '-====================================-'
       CLOSE fclients.



      **********RECHERCHER RESTAURANT********************************
      *Demande un nom de ville  à l'utilisateur et affiche          *
      *tous les restaurants présent dans cette ville                *
      * L'utilisateur entre ensuite l'indentifiant du restaurant    *
      ***************************************************************
       RECHERCHER_RESTAURANT.
       OPEN INPUT frestaurants

       DISPLAY '|====================================|'
       DISPLAY '|=========== RECHERCHE    ===========|'
       DISPLAY '|===========   D''UN       ===========|'
       DISPLAY '|===========   RESTAURANT ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       MOVE 0 TO Wfin
       MOVE 0 TO WvaleurOK
       
       DISPLAY 'Donnez la ville du restaurant'
       ACCEPT WvilleRst
       MOVE WvilleRst TO fr_ville
       START frestaurants, KEY IS = fr_ville
       INVALID KEY 
       DISPLAY 'Aucun restaurant ne se situe dans cette ville'
       NOT INVALID KEY
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
        READ frestaurants NEXT
        AT END MOVE 1 TO Wfin
        NOT AT END
        IF WvilleRst = fr_ville AND fr_actif = 1 THEN
         DISPLAY 'identifiant: ',fr_id
       DISPLAY 'adresse: ',fr_rue,' ', fr_ville,' ', fr_codeP         
        END-IF
        END-READ
       END-PERFORM
       PERFORM WITH TEST AFTER UNTIL WvaleurOK = 1
         DISPLAY 'Donnez lidentifiant du restaurant concerné:'
         ACCEPT fr_id
         READ frestaurants
         INVALID KEY DISPLAY 'Erreur lors de la saisie de lidentifiant'
         NOT INVALID KEY
         MOVE fr_id TO frs_idrest
         MOVE fr_id TO WidRestSauv
         MOVE 1 TO WvaleurOK         
         MOVE fr_nbPlaces TO WcapaciteRestaurant
       END-PERFORM
       DISPLAY '-====================================-'
       CLOSE frestaurants.





      ****************CALCUL NB PLACES REST **************************
      *Calcul le nombre de place restante dans un restaurant en      *
      *En cherchant toutes les réservations se déroulant sur la      *
      *plage horaire donné dans un restaurant précis,                *
      * Compare le résultat obtenu avec la capacité du restaurant    *
      ****************************************************************
       NOMBRE_PLACE_RESTANTE.       
       MOVE 0 TO WplacesOccupees
       MOVE 0 TO Wfin
       MOVE 0 TO WplacesOccupees
       OPEN INPUT frestaurants              
       MOVE WidRestSauv TO frs_idrest
       MOVE WidRestSauv TO fr_id
       READ frestaurants
         INVALID KEY DISPLAY 'erreur'
         NOT INVALID KEY
              MOVE fr_nbPlaces TO WcapaciteRestaurant                
       CLOSE frestaurants
       START freservations, KEY IS = frs_idrest
       INVALID KEY 
         MOVE 1 TO Wlibre
         MOVE 0 TO WplacesOccupees
         MOVE WcapaciteRestaurant TO WplacesLibres
       NOT INVALID KEY
          MOVE WcapaciteRestaurant TO WplacesLibres
         PERFORM WITH TEST AFTER UNTIL Wfin = 1
           READ freservations NEXT
           AT END MOVE 1 TO Wfin
           NOT AT END 
              IF frs_idrest = WidRestSauv AND frs_date = Wdate  
     - AND frs_heure <= WheureMax AND frs_heure >= WheureMin THEN
              ADD frs_nbPersonnes TO WplacesOccupees
         END-PERFORM
         IF WplacesOccupees < WcapaciteRestaurant THEN
           SUBTRACT WplacesOccupees FROM WplacesLibres
           DISPLAY 'Il reste ',WPlacesLibres,' places'
           MOVE 1 TO Wlibre
         ELSE 
           DISPLAY 'Il ne reste que ',WPlacesLibres,' places dans ce'
      -' restaurant'
         END-IF.

       NOMBRE_RESERVATION_JOUR.
       MOVE 0 TO WnbReservCli
       MOVE 0 TO Wfin
       MOVE WidCliSauv TO frs_idCli
       START freservations, KEY IS = frs_idCli
       NOT INVALID KEY
         PERFORM WITH TEST AFTER UNTIL Wfin = 1
           READ freservations NEXT
           AT END MOVE 1 TO Wfin
           NOT AT END     
             IF frs_date = Wdate AND frs_idCli = WidCliSauv THEN
               ADD 1 TO WnbReservCli
             END-IF
         END-PERFORM.

      **********************NOUVELLE RESERVATION *********************
       AJOUTER_RESA.       
       OPEN I-O freservations

       DISPLAY '|====================================|'
       DISPLAY '|=========== AJOUT        ===========|'
       DISPLAY '|===========  DE          ===========|'
       DISPLAY '|===========  RESERVATION ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       PERFORM WITH TEST AFTER UNTIL Wrep = 0
         MOVE 1 TO Wlibre 
         DISPLAY 'Donnez les informations de la réservation'
         PERFORM RECHERCHER_NUM_RESA
         DISPLAY 'Numéro de la réservation:',Wnum
         MOVE Wnum TO frs_id
         MOVE Wnum TO WidSauv
         PERFORM RECHERCHER_CLIENT
         IF WvaleurOK = 1 THEN
           PERFORM RECHERCHER_RESTAURANT
           IF WvaleurOK = 1 THEN
               DISPLAY 'Veuillez saisir la date de la réservation:'
               PERFORM WITH TEST AFTER UNTIL frs_date_jour <= 31
                 DISPLAY 'jour: (JJ)'
                 ACCEPT frs_date_jour
               END-PERFORM
               PERFORM WITH TEST AFTER UNTIL  frs_date_mois <= 12
                 DISPLAY 'mois: (MM)'
                 ACCEPT frs_date_mois
               END-PERFORM
               PERFORM WITH TEST AFTER UNTIL  frs_date_annee >= 2015
                 DISPLAY 'annee: (AAAA)'
                 ACCEPT frs_date_annee
               END-PERFORM
               MOVE frs_date TO Wdate
               PERFORM NOMBRE_RESERVATION_JOUR
               IF WnbReservCli = 1 THEN
                 DISPLAY 'Le client a déjà effectué 1 réservation '
     -   'pour cette date '
                 MOVE 0 TO Wlibre
               END-IF
               IF Wlibre NOT EQUAL 0 THEN
               DISPLAY 'Veuillez saisir l heure de la réservation'
               PERFORM WITH TEST AFTER UNTIL  frs_heure_heure <= 22  
     -     AND frs_heure_heure >= 12
                 DISPLAY 'heure: (24)'
                 ACCEPT frs_heure_heure             
               END-PERFORM
               PERFORM WITH TEST AFTER UNTIL  frs_heure_minute <= 59
                 DISPLAY 'minute: (59)'
                 ACCEPT frs_heure_minute
               END-PERFORM              
                 MOVE frs_heure TO WheureMin
                 MOVE frs_heure TO WheureMax
                 MOVE frs_heure TO WheureSauv
                 IF WheureMin_minute > 30 THEN
                   MOVE 0 TO WheureMin_minute
                 ELSE
                   MOVE 30 TO WheureMin_minute
                 END-IF
                 IF WheureMax_minute > 30 THEN
                   MOVE 0 TO WheureMax_minute
                 ELSE
                   MOVE 30 TO WheureMax_minute
                 END-IF
                 SUBTRACT 1 FROM WheureMin_heure
                 ADD 2 TO WheureMax_heure
               PERFORM NOMBRE_PLACE_RESTANTE
             MOVE WidSauv TO frs_id
             MOVE WidrestSauv TO frs_idrest
             MOVE WidCliSauv TO frs_idcli
             MOVE Wdate TO frs_date
             MOVE WheureSauv TO frs_heure
             MOVE 0 TO frs_prix
             MOVE 1 TO Wlibre
             PERFORM WITH TEST AFTER UNTIL Wlibre = 0
              DISPLAY 'Nombre de personnes:'
               ACCEPT frs_nbPersonnes 
              IF frs_nbPersonnes <= WPlacesLibres THEN 
              WRITE resaTampon
               IF frs_stat = 0 THEN
                 DISPLAY 'Nouvelle réservation enregistrée'
               ELSE
                  DISPLAY 'Erreur lors de l''enregistrement'
               END-IF
               MOVE 0 TO Wlibre
             ELSE
              DISPLAY 'Erreur, Il ne reste que ',WPlacesLibres,
     - ' places pour cette heure'
              DISPLAY 'Souhaiter vous venir moins nombreux dans ',
     - ' ce restaurant?1 - oui, 0 - non'
              ACCEPT Wlibre
           END-IF
          END-PERFORM
         END-IF
        END-IF 
        END-IF        
         

         PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
          DISPLAY 'Souhaitez vous saisir une nouvelle réservation?' 
      - '0 : non, 1 : oui'
          ACCEPT Wrep
         END-PERFORM
       END-PERFORM
       DISPLAY '-====================================-'
       CLOSE freservations.




      ***********AFFICHER RESERVATION ********************************
      *Affiche tous les attributs d'une réservation avec les détails *
      *du client et du restaurants                                   *
      ****************************************************************     
       AFFICHER_RESA.
       OPEN INPUT fclients

       MOVE frs_idCli TO fc_id
       READ fclients
       INVALID KEY DISPLAY 'Client inexistant'
       NOT INVALID KEY
         DISPLAY 'Client: ',fc_nom,' ', fc_prenom
       CLOSE fclients
       OPEN INPUT frestaurants
       MOVE frs_idrest TO fr_id
       READ frestaurants
       INVALID KEY DISPLAY 'Restaurant inexistant'
       NOT INVALID KEY
         DISPLAY 'numéro:',frs_id
         DISPLAY 'Ville: ',fr_ville, 'Adresse: ',fr_rue
       CLOSE frestaurants
       DISPLAY 'Date de la réservation: ',frs_date_jour,'/'
      -         frs_date_mois,'/',frs_date_annee
       DISPLAY 'Heure de la réservation: ', frs_heure_heure,':'
      -         frs_heure_minute
       DISPLAY 'Nombre de personne: ', frs_nbPersonnes
       DISPLAY 'Prix Payé: ', frs_prix.





      *************CONSULTER RESERVATIONS ***************************
      *Propose de consulter les réservation en fontion de la date,  *
      *du client, du restaurant ou de l'identitifant                *
      ***************************************************************
       CONSULTER_RESA.
       OPEN INPUT freservations

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========  DE          ===========|'
       DISPLAY '|===========  RESERVATION ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       MOVE 0 TO Wchoix
       PERFORM WITH TEST AFTER UNTIL Wchoix <= 4 AND Wchoix > 0
        DISPLAY 'Que souhaitez vous faire ?'
        DISPLAY '1 - Voir toutes les réservations à venir'
        DISPLAY '2 - Faire une recherche à partir dun client'
        DISPLAY '3 - Faire une recherche à partir d un restaurant'
        ACCEPT Wchoix
       END-PERFORM
       EVALUATE Wchoix
         WHEN 1
         DISPLAY 'Veuillez saisir la date du jour:'
         PERFORM WITH TEST AFTER UNTIL Wdate_jour <= 31 AND 
     -  Wdate_jour >= 1
           DISPLAY 'jour: (JJ)'
           ACCEPT Wdate_jour
         END-PERFORM
         PERFORM WITH TEST AFTER UNTIL  Wdate_mois <= 12 AND
     -  Wdate_mois >= 1
           DISPLAY 'mois: (MM)'
           ACCEPT Wdate_mois
         END-PERFORM
         PERFORM WITH TEST AFTER UNTIL  Wdate_annee >= 2015
           DISPLAY 'annee: (AAAA)'
           ACCEPT Wdate_annee
         END-PERFORM
          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
            READ freservations NEXT
              AT END MOVE 1 TO Wfin
              NOT AT END 
               IF frs_date_annee >= Wdate_annee THEN
                 IF frs_date_mois > Wdate_mois THEN
                 PERFORM AFFICHER_RESA
                 ELSE IF frs_date_mois = Wdate_mois 
     -  AND frs_date_jour >= Wdate_jour THEN
                     PERFORM AFFICHER_RESA
                 END-IF
               END-IF
            END-READ
          END-PERFORM 
         WHEN 2
           PERFORM RECHERCHER_CLIENT
           MOVE 0 TO Wfin
           START freservations, KEY IS = frs_idCli
           INVALID KEY DISPLAY 'Aucune réservation pour le client'
           NOT INVALID KEY
              PERFORM WITH TEST AFTER UNTIL Wfin = 1
                READ freservations NEXT
                AT END MOVE 1 TO Wfin       
                NOT AT END 
                  IF frs_idCli = WidCliSauv THEN
                    PERFORM AFFICHER_RESA
                  END-IF
              END-PERFORM
         WHEN 3
           PERFORM RECHERCHER_RESTAURANT
           MOVE 0 TO Wfin
           START freservations, KEY IS = frs_idrest
           INVALID KEY DISPLAY 'Aucune réservation dans ce restaurant'
           NOT INVALID KEY
              PERFORM WITH TEST AFTER UNTIL Wfin = 1
                READ freservations NEXT
                AT END MOVE 1 TO Wfin       
                NOT AT END
                  IF frs_idrest = WidRestSauv THEN 
                    PERFORM AFFICHER_RESA
                  END-IF
              END-PERFORM          
       END-EVALUATE
       DISPLAY '-====================================-'
       CLOSE freservations.







      *************MODIFIER RESERVATION ******************************
      *Permet de modifier la date et l'heure d'une réservation       *
      ****************************************************************
       MODIFIER_RESA.
       OPEN I-O freservations

       DISPLAY '|====================================|'
       DISPLAY '|=========== MODIFICATION ===========|'
       DISPLAY '|===========  DE          ===========|'
       DISPLAY '|===========  RESERVATION ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       MOVE 0 TO Wchoix
       PERFORM WITH TEST AFTER UNTIL Wchoix <= 4 AND Wchoix > 0
         DISPLAY 'Pour la modification, souhaitez vous:'
         DISPLAY '1 - Rechercher une réservation à partir de sa date '
         DISPLAY '2 - Rechercher une réservation à partir d''un ' 
      - 'client'
         DISPLAY '3 - Rechercher une réservation à partir d''un ' 
      - 'restaurant'
         DISPLAY '4 - Rechercher une réservation à partir de son ' 
      - 'identifiant'
         ACCEPT Wchoix
       END-PERFORM
       EVALUATE Wchoix
         WHEN 1
           DISPLAY 'Veuillez saisir la date:'
           PERFORM WITH TEST AFTER UNTIL Wdate_jour <= 31
             DISPLAY 'jour: (JJ)'
             ACCEPT Wdate_jour
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL  Wdate_mois <= 12
             DISPLAY 'mois: (MM)'
             ACCEPT Wdate_mois
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL  Wdate_annee >= 2015
             DISPLAY 'annee: (AAAA)'
             ACCEPT Wdate_annee
           END-PERFORM
           MOVE 0 TO Wfin
            PERFORM WITH TEST AFTER UNTIL Wfin = 1
              READ freservations NEXT
                AT END MOVE 1 TO Wfin
                NOT AT END                
                 DISPLAY Wdate
                 DISPLAY frs_date
                 IF frs_date >= Wdate THEN
                   PERFORM AFFICHER_RESA
                 END-IF
            END-READ
          END-PERFORM 
          WHEN 2
            PERFORM RECHERCHER_CLIENT
            MOVE 0 TO Wfin
            START freservations, KEY IS = frs_idCli
            INVALID KEY DISPLAY 'Aucune réservation pour le client'
            NOT INVALID KEY
               PERFORM WITH TEST AFTER UNTIL Wfin = 1
                 READ freservations NEXT
                 AT END MOVE 1 TO Wfin       
                 NOT AT END 
                   PERFORM AFFICHER_RESA
               END-PERFORM
          WHEN 3
            PERFORM RECHERCHER_RESTAURANT
            MOVE 0 TO Wfin
            START freservations, KEY IS = frs_idrest
            INVALID KEY DISPLAY 'Aucune réservation dans ce restaurant'
            NOT INVALID KEY
               PERFORM WITH TEST AFTER UNTIL Wfin = 1
                 READ freservations NEXT
                 AT END MOVE 1 TO Wfin       
                 NOT AT END 
                   PERFORM AFFICHER_RESA
               END-PERFORM 
          WHEN 4
            DISPLAY " "
       END-EVALUATE
       MOVE 0 TO WvaleurOK
       PERFORM WITH TEST AFTER UNTIL WvaleurOK = 1
         DISPLAY 'Entrez l''identifiant de la réservation'
         ACCEPT frs_id
         READ freservations
           NOT INVALID KEY
             MOVE 1 TO WvaleurOK             
             PERFORM AFFICHER_RESA
       END-PERFORM
       DISPLAY 'Remplissez les informations souhaitées'
       MOVE frs_id TO WidSauv
       MOVE frs_idrest TO WidRestSauv
       MOVE frs_idCli TO WidCliSauv
       PERFORM WITH TEST AFTER UNTIL Wlibre = 1
         DISPLAY 'Veuillez saisir la date de la réservation:'
           MOVE 0 TO Wdate_jour
           MOVE 0 TO Wdate_mois
           MOVE 0 TO Wdate_annee
           MOVE 0 TO WheureSauv_heure
           MOVE 0 TO WheureSauv_minute
           PERFORM WITH TEST AFTER UNTIL Wdate_jour >= 0 AND
     - Wdate_jour <= 31
             DISPLAY 'jour: (jj)'
             ACCEPT Wdate_jour
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL Wdate_mois >= 0 AND 
     -  Wdate_mois <= 12
             DISPLAY 'mois: (MM)'
             ACCEPT Wdate_mois
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL Wdate_annee>= 2015 OR 
     - Wdate_annee = 0
             DISPLAY 'annee: (AAAA)'
             ACCEPT Wdate_annee
           END-PERFORM
           DISPLAY 'Veuillez saisir l''heure de la réservation'
           PERFORM WITH TEST AFTER UNTIL  WheureSauv_heure <= 22 AND 
     -     WheureSauv_heure >= 12 OR WheureSauv_heure = 0
             DISPLAY 'heure: (24)'
             ACCEPT WheureSauv_heure
           END-PERFORM
           PERFORM WITH TEST AFTER UNTIL  WheureSauv_minute <= 59
             DISPLAY 'minute: (59)'
             ACCEPT WheureSauv_minute 
           END-PERFORM
           IF WheureSauv_heure NOT = 0 THEN
             MOVE WheureSauv TO WheureMin
             MOVE WheureSauv TO WheureMax
             IF WheureMin_minute > 30 THEN
               MOVE 0 TO WheureMin_minute
             ELSE
               MOVE 30 TO WheureMin_minute
             END-IF
             IF WheureMax_minute > 30 THEN
               MOVE 0 TO WheureMax_minute
             ELSE
               MOVE 30 TO WheureMax_minute
             END-IF
             SUBTRACT 1 FROM WheureMin_heure
             ADD 2 TO WheureMax_heure
             
           ELSE
             MOVE frs_heure TO WheureMax 
             MOVE frs_heure TO WheureMin
             IF WheureMin_minute > 30 THEN
               MOVE 0 TO WheureMin_minute
             ELSE
               MOVE 30 TO WheureMin_minute
             END-IF
             IF WheureMax_minute > 30 THEN
               MOVE 0 TO WheureMax_minute
             ELSE
               MOVE 30 TO WheureMax_minute
             END-IF
             SUBTRACT 1 FROM WheureMin_heure
             ADD 2 TO WheureMax_heure        
           END-IF
             PERFORM NOMBRE_PLACE_RESTANTE 
         END-PERFORM
         MOVE WidSauv TO frs_id
         MOVE WidrestSauv TO frs_idrest
         MOVE WidCliSauv TO frs_idcli
         IF Wdate_jour NOT = 0 THEN
           MOVE Wdate_jour TO frs_date_jour
         END-IF
         IF Wdate_mois NOT = 0 THEN
           MOVE Wdate_mois TO frs_date_mois
         END-IF
         IF Wdate_annee NOT = 0 THEN
           MOVE Wdate_annee TO frs_date_annee
         END-IF
         IF WheureSauv_heure NOT = 0 THEN
           MOVE WheureSauv_heure TO frs_heure_heure
         END-IF
         IF WheureSauv_minute NOT = 0 THEN
           MOVE WheureSauv_minute TO frs_heure_minute
         END-IF
         MOVE 1 TO Wlibre
         PERFORM WITH TEST AFTER UNTIL Wlibre = 0
           DISPLAY 'Nombre de personnes:'
           ACCEPT WnbPersonnes 
           IF WnbPersonnes <= WPlacesLibres THEN
             IF WnbPersonnes NOT = 0 THEN
                MOVE WnbPersonnes TO frs_nbPersonnes 
             END-IF
             REWRITE resaTampon
             IF frs_stat = 0 THEN
              DISPLAY 'Les modifications ont été enregistrées'
             MOVE 0 TO Wlibre
           ELSE
            SUBTRACT WplacesOccupees FROM WplacesLibres
            DISPLAY 'Erreur, Il ne reste que ',WPlacesLibres,
     - ' places pour cette heure'
             DISPLAY 'Souhaiter vous venir moins nombreux dans ',
     - ' ce restaurant? 1 - oui, 0 - non'
             ACCEPT Wlibre
          END-IF
        END-PERFORM
       DISPLAY '-====================================-'
       CLOSE freservations.





      ***************STATISTIQUES_RESTAURANT************************
      *Affiche le chiffre d'affaire du restaurant pour un mois     *
      *donné, affiche aussi celui de l'année précédente            *
      **************************************************************
       STATISTIQUES_RESTAURANT.
		
        OPEN INPUT frestaurants

       DISPLAY '|====================================|'
       DISPLAY '|=========== STATISTIQUE  ===========|'
       DISPLAY '|===========  DE          ===========|'
       DISPLAY '|===========  RESTAURANT  ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

		
        DISPLAY 'Saisir le nom de la ville :'
        ACCEPT fr_ville
		
        MOVE fr_ville to WvilleRst
        START frestaurants , KEY IS = fr_ville
         INVALID KEY
          DISPLAY 'Aucun restaurant n''est présent dans cette ville'
         NOT INVALID KEY
          MOVE 0 TO Wfin
          MOVE 0 TO Wnbchoix
          PERFORM WITH TEST AFTER UNTIL Wfin = 1 AND WvilleRst=fr_ville
           READ frestaurants NEXT
            AT END
             MOVE 1 TO Wfin
            NOT AT END
             ADD 1 TO Wnbchoix
             DISPLAY '==='
             DISPLAY Wnbchoix,' - Restaurant ',fr_id
             DISPLAY '      ',fr_rue
            END-READ
           END-PERFORM
          END-START
        
         
       IF WnbChoix > 0 THEN
        PERFORM WITH TEST AFTER UNTIL WidRestSauv >= 1
     -  AND WidRestSauv <= WnbChoix
        DISPLAY '==='
        DISPLAY 'Quel restaurant afficher ?'
        ACCEPT WidRestSauv

        DISPLAY '==='
        DISPLAY 'Année :'
        ACCEPT Wannee
        MOVE Wannee TO WanneeAnt
        SUBTRACT 1 FROM WanneeAnt
        DISPLAY 'Année précédente ',WanneeAnt

        DISPLAY '==='
        DISPLAY 'Mois :'
        ACCEPT Wmois

        END-PERFORM

        MOVE 0 TO WplatsAchetes
        MOVE 0 TO WcaMensuel
        MOVE 0 TO WplatsAchetesAnt
        MOVE 0 TO WcaMensuelAnt
        MOVE WidRestSauv TO frs_idrest
        OPEN INPUT freservations
        START freservations , KEY IS = frs_idrest
         INVALID KEY
          DISPLAY 'Il n''y a pas de réservation pour ce restaurant'
         NOT INVALID KEY
          MOVE 0 TO Wfin
          MOVE 0 TO Wnbchoix

          PERFORM WITH TEST AFTER UNTIL Wfin = 1 AND  
     -  WidRestSauv = frs_idrest
           READ freservations NEXT
            AT END
             MOVE 1 TO Wfin
            NOT AT END

             IF frs_date_annee = Wannee AND frs_date_mois = Wmois THEN
              IF frs_prix > 0 THEN
                ADD frs_prix TO WcaMensuel
                ADD frs_nbPersonnes TO WplatsAchetes
              END-IF

             ELSE IF frs_date_annee = WanneeAnt
     -         AND frs_date_mois = Wmois THEN
              IF frs_prix > 0 THEN
                ADD frs_prix TO WcaMensuelAnt
                ADD frs_nbPersonnes TO WplatsAchetesAnt
              END-IF
             END-IF

            END-READ
           END-PERFORM
          END-START

        DISPLAY 'Chiffre d''affaire du mois : ',WcaMensuel,
     -         '(année précédente : ',WcaMensuelAnt,')'
        DISPLAY 'Nombre de plats commandés : ',WplatsAchetes,
     -         '(année précédente : ',WplatsAchetesAnt,')'
       END-IF

       DISPLAY '-====================================-'
        CLOSE freservations
        CLOSE frestaurants.



      *********************SAISIR_COMMANDE*********************
      *Permet de saisir les commandes prise par les clients   *
      *après leur passage au restaurants                      *
      *Prend en compte le pourcentage de réduction dû à la    *
      *fidélité du clients                                    *
      *********************************************************
       SAISIR_COMMANDE.

       OPEN I-O freservations

       DISPLAY '|====================================|'
       DISPLAY '|=========== SAISIE       ===========|'
       DISPLAY '|===========   DE         ===========|'
       DISPLAY '|===========    COMMANDE  ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       MOVE 0 TO Wfin
       DISPLAY 'Donnez l identifiant de la reservation'
       ACCEPT frs_id
       READ freservations
        INVALID KEY
          DISPLAY 'Aucune réservation ne correspond à cet identifiant'
        NOT INVALID KEY
      *   DISPLAY 'Prix :',frs_prix
         IF frs_prix EQUAL 0 THEN
          MOVE 0 TO WNbPers       
          MOVE 0 TO Wfin
          MOVE 0 TO WnbMenus
          MOVE 0 TO WprixTotal
          OPEN INPUT fmenus
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
            READ fmenus NEXT
              AT END MOVE 1 TO Wfin
              NOT AT END 
               ADD 1 TO WnbMenus
               DISPLAY 'Menu numero ',WnbMenus
               DISPLAY fm_nom
            END-READ
          END-PERFORM 
          PERFORM WITH TEST AFTER UNTIL WNbPers = frs_nbPersonnes
           ADD 1 TO WNbPers
           MOVE 0 TO Wok
           PERFORM WITH TEST AFTER UNTIL Wok=1
            DISPLAY ' Entrer le nom du menu'
      -             ' pour la personne ',WNbPers
            ACCEPT fm_nom
            READ fmenus
            INVALID KEY
             DISPLAY 'Nom de menu invalide'
            NOT INVALID KEY 
             MOVE 1 TO Wok
             IF WNbPers=1 THEN
                MOVE fm_nom TO WresMenu
                
             ELSE
               STRING WresMenu "/" fm_nom 
                            DELIMITED BY SPACE INTO WresMenu
             END-IF
                 ADD fm_prix TO WprixTotal
			    
              END-READ  
            END-PERFORM
          END-PERFORM 
          CLOSE fmenus
          MOVE WresMenu TO frs_nomsMenus
          OPEN INPUT fclients
          MOVE frs_idCli TO fc_id
          READ fclients
          NOT INVALID KEY
            MULTIPLY WprixTotal BY fc_pctReduc GIVING WpctReduc
            SUBTRACT WpctReduc FROM WprixTotal
          END-READ
          CLOSE fclients
          MOVE WprixTotal TO frs_prix
          REWRITE resaTampon
         ELSE
	       DISPLAY 'La réservation a déjà été payée'
		   
         END-IF  
         END-READ
       DISPLAY '-====================================-'
       CLOSE freservations.



       
      **********************SUPPRIMER_RESERVATION*********************
      *Supprime la réservation uniquement si elle n'a pas été payée  *
      ****************************************************************   
       SUPPRIMER_RESERVATION.
       OPEN I-O freservations

       DISPLAY '|====================================|'
       DISPLAY '|=========== SUPPRESSION  ===========|'
       DISPLAY '|===========  DE          ===========|'
       DISPLAY '|=========== RESERVATION  ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

       MOVE 0 TO Wfin
       DISPLAY 'Donnez l identifiant de la reservation'
       ACCEPT frs_id
       READ freservations
        INVALID KEY DISPLAY 'Erreur lors de la saisie de l identifiant'
        NOT INVALID KEY
         IF frs_prix = 0 THEN
          MOVE 0 TO Wchoix
          PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
          DISPLAY 'Etes vous sur de vouloir supprimer la reservation ?' 
              DISPLAY '1 : OUI     0 : NON'
           ACCEPT Wchoix
          END-PERFORM
          IF Wchoix = 1 THEN
           DELETE freservations
           INVALID KEY
            DISPLAY 'Erreur lors de la suppression'
           NOT INVALID KEY
            DISPLAY 'Réservation supprimée'
          ELSE
           DISPLAY 'Erreur lors de la suppression'
         ELSE
          DISPLAY 'Impossible de supprimer un reservation déjà payée'  
         END-IF
       DISPLAY '-====================================-'
       CLOSE freservations.
