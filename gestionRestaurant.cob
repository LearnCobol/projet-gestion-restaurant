       IDENTIFICATION DIVISION.
         PROGRAM-ID. gestionRestaurant.


        ENVIRONMENT DIVISION.
         INPUT-OUTPUT SECTION.
          FILE-CONTROL.

          SELECT fmenus ASSIGN TO "datamenus.dat"
          ORGANIZATION indexed
          ACCESS MODE IS dynamic
          RECORD KEY IS fm_nom
          ALTERNATE RECORD KEY IS fm_entree WITH DUPLICATES
          ALTERNATE RECORD KEY IS fm_plat WITH DUPLICATES
          ALTERNATE RECORD KEY IS fm_dessert WITH DUPLICATES
          FILE STATUS IS fm_stat.

          SELECT fplats ASSIGN TO "dataplats.dat"
          ORGANIZATION indexed
          ACCESS MODE IS dynamic
          RECORD KEY IS fp_nom
          ALTERNATE RECORD KEY IS fp_type WITH DUPLICATES
          FILE STATUS IS fp_stat.

          SELECT fclients ASSIGN TO "dataclients.dat"
          ORGANIZATION indexed
          ACCESS dynamic
          RECORD KEY IS fc_id
          ALTERNATE RECORD KEY IS fc_ville WITH DUPLICATES
          ALTERNATE RECORD KEY IS fc_nom WITH DUPLICATES
          FILE STATUS IS fc_stat.

          SELECT frestaurants ASSIGN TO "datarestaurants.dat"
          ORGANIZATION indexed
          ACCESS dynamic
          RECORD KEY IS fr_id
          ALTERNATE RECORD KEY IS fr_ville WITH DUPLICATES
          FILE STATUS IS fr_stat.

          SELECT freservations ASSIGN TO "datareservations.dat"
          ORGANIZATION indexed
          ACCESS dynamic
          RECORD KEY IS frs_id
          ALTERNATE RECORD KEY IS frs_idcli WITH DUPLICATES
          ALTERNATE RECORD KEY IS frs_idrest WITH DUPLICATES
          FILE STATUS IS frs_stat.

          SELECT futilisateurs ASSIGN TO "datautilisateurs.dat"
          ORGANIZATION indexed
          ACCESS MODE IS dynamic
          RECORD KEY IS fu_id
          ALTERNATE RECORD KEY IS fu_pseudo
          ALTERNATE RECORD KEY IS fu_role WITH DUPLICATES
          FILE STATUS IS fu_stat.

        DATA DIVISION.
         FILE SECTION.
          FD fmenus.
           01 mTampon.
           02 fm_nom PIC A(50).
           02 fm_entree PIC A(50).
           02 fm_plat PIC A(50).
           02 fm_dessert PIC A(50).
           02 fm_prix PIC 999V99.

          FD fplats.
           01 pTampon.
           02 fp_nom PIC A(50).
           02 fp_type PIC A(7).
           02 fp_prix PIC 999V99.

          FD fclients.
           01 cliTampon.
           02 fc_id PIC 9(4).
           02 fc_nom PIC A(50).
           02 fc_prenom PIC A(50).
           02 fc_nbReserv PIC 9(3).
           02 fc_pctReduc PIC 99V99.
           02 fc_tel PIC 9(10).
           02 fc_mail PIC X(100).
           02 fc_rue PIC X(100).
           02 fc_ville PIC A(25).
           02 fc_codeP PIC 9(5).
 
          FD frestaurants.
           01 restTampon.
           02 fr_id PIC 9(4).
           02 fr_rue PIC X(100).
           02 fr_ville PIC A(40).
           02 fr_codeP PIC 9(5).
           02 fr_tel PIC 9(10).
           02 fr_nbPlaces PIC 9(8).
           02 fr_sweb PIC X(256).
           02 fr_actif PIC 9.

          FD freservations.
           01 resaTampon.
             02 frs_id PIC 9(10).
             02 frs_idcli PIC 9(4).
             02 frs_idrest PIC 9(4).
             02 frs_date.
               03 frs_date_jour PIC 9(2).
               03 frs_date_mois PIC 9(2).
               03 frs_date_annee PIC 9(4).
             02 frs_heure.
               03 frs_heure_heure PIC 99.
               03 frs_heure_minute PIC 99.
             02 frs_prix PIC 99V99.
             02 frs_nomsMenus PIC X(250).
             02 frs_nbPersonnes PIC 99.

          FD futilisateurs.
           01 uTampon.
             02 fu_id PIC 9(4).
             02 fu_pseudo PIC A(30).
             02 fu_mdp PIC A(20).
             02 fu_role PIC A(10).

         WORKING-STORAGE SECTION.
          77 WmenuP PIC 9(2).

          77 fm_stat PIC 9(2).
          77 Wmenu PIC 9(1).
          77 Wfin PIC 9(1).
          77 WprixCarte PIC 999V99.
          77 Wbudget PIC 999V99.
          77 WnomMenu PIC A(50).
          77 Wtrouve PIC 9.

          77 fp_stat PIC 9(2).
          77 Wplat PIC 9(1).
          77 WnomP PIC A(50).
          77 WtypeP PIC A(7).
          77 Wchoix PIC 9.
          77 Wrep PIC 9.
          77 Wid PIC 9(1).
          77 WprixP PIC 999V99.

          77 fc_stat PIC 99.
          77 Wnum PIC 9(4).
          77 WrepChoix PIC 9.
          77 WnomCli PIC A(50).
          77 WprenomCli PIC A(50).
          77 WtelCli PIC 9(10).
          77 WmailCli PIC X(100).
          77 WrueCli PIC X(100).
          77 WcodePCli PIC 9(5).
          77 WnbReservCli PIC 9(3). 
          77 WvilleCli PIC A(25).
          77 WpctReduc PIC 99.

          77 fr_stat PIC 99.
          77 WnumR PIC 9(4).
          77 WidResto PIC 9(4). 
          77 Wville PIC A(40).
          77 Wrue PIC X(100).
          77 Wcp PIC 9(5).
          77 WnbPlaces PIC 9(8).
          77 WsWeb PIC X(256).
          77 Wactif PIC 9.
          77 Wtel PIC 9(10).
          77 WvilleOK PIC 9.
          77 WNbPers PIC 99.
          77 WnbMenus PIC 99.
          77 Wnb PIC 99.  
          77 WresMenu PIC X(250).
          77 WresMenu2 PIC X(250).
          77 WprixTotal PIC 999V99.
          77 Wok PIC 9.

          77 frs_stat PIC 99.
          77 WvilleRst PIC A(40).
          77 WvaleurOK PIC 9.
          77 Wlibre PIC 9.
          77 WplacesOccupees PIC 9(3).
          77 WcapaciteRestaurant PIC 9(3).
          01 Wdate.
            02 Wdate_jour PIC 99.
            02 Wdate_mois PIC 99.
            02 Wdate_annee PIC 9999.
          01 WheureMin.
            02 WheureMin_heure PIC 99.
            02 WheureMin_minute PIC 99.
          01 WheureMax.
            02 WheureMax_heure PIC 99.
            02 WheureMax_minute PIC 99.
          01 WheureSauv.
            02 WheureSauv_heure PIC 99.
            02 WheureSauv_minute PIC 99.
          77 WidSauv PIC 9(10).
          77 WidCliSauv PIC 9(4).
          77 WidRestSauv PIC 9(4).
          77 WPlacesLibres PIC 9(3).
          77 WnbPersonnes PIC 99.
          77 Wnbchoix PIC 99.
          77 Wmois PIC 9(2).
          77 Wannee PIC 9(4).
          77 WanneeAnt PIC 9(4).
          77 WplatsAchetes PIC 9(4).
          77 WcaMensuel PIC 9999V99.
          77 WplatsAchetesAnt PIC 9(4).
          77 WcaMensuelAnt PIC 9999999V99.

          77 fu_stat PIC 9(2).
          77 Wutil PIC 9(1).
          77 Wpseudo PIC A(30).
          77 Wmdp PIC A(20).
          77 Wrole PIC A(10).
          77 WinMenu PIC 9.

  

        PROCEDURE DIVISION.

         OPEN I-O fmenus
         IF fm_stat = 35 THEN
          OPEN OUTPUT fmenus
         END-IF
         CLOSE fmenus

         OPEN I-O fplats
         IF fp_stat = 35 THEN
          OPEN OUTPUT fplats
         END-IF
         CLOSE fplats

         OPEN I-O fclients
         IF fc_stat = 35 THEN
          OPEN OUTPUT fclients
         END-IF
         CLOSE fclients
         MOVE 1 TO Wmenu

         OPEN I-O frestaurants
         IF fr_stat = 35 THEN
          OPEN OUTPUT frestaurants
         END-IF
         CLOSE frestaurants

         OPEN I-O freservations
         IF frs_stat = 35 THEN
          OPEN OUTPUT freservations
         END-IF
         CLOSE freservations

       OPEN I-O futilisateurs
         IF fu_stat = 35 THEN
          OPEN OUTPUT futilisateurs
         END-IF
         CLOSE futilisateurs


         PERFORM WITH TEST AFTER UNTIL WmenuP = 0
          PERFORM WITH TEST AFTER UNTIL WmenuP>=0 AND WmenuP<=6
           DISPLAY '**************************'
           DISPLAY '***** MENU PRINCIPAL *****'
           DISPLAY '**************************'
           DISPLAY 'Que souhaitez vous faire ?'
           DISPLAY ' 1 - Menu'
           DISPLAY ' 2 - Plat'
           DISPLAY ' 3 - Client'
           DISPLAY ' 4 - Restaurant'
           DISPLAY ' 5 - Reservation'
           DISPLAY ' 6 - Utilisateur'
           DISPLAY ' 0 - Quitter'
           DISPLAY '--------------------------'
           ACCEPT WmenuP
          END-PERFORM

          EVALUATE WmenuP
           WHEN 1
            PERFORM OPERATION_MENU
           WHEN 2
            PERFORM OPERATION_PLAT
           WHEN 3
            PERFORM OPERATION_CLIENT
           WHEN 4 
            PERFORM OPERATION_RESTAURANT
           WHEN 5
            PERFORM OPERATION_RESERVATION
           WHEN 6
            PERFORM OPERATION_UTILISATEUR
          END-EVALUATE

         END-PERFORM

         STOP RUN.


      ****************************************************************
       COPY menu_menu.

      ****************************************************************
       COPY menu_plat.

      ****************************************************************
       COPY menu_client.

      ****************************************************************
       COPY menu_restaurant.

      ****************************************************************
       COPY menu_utilisateur.

      ****************************************************************
       COPY menu_reservation.

      ****************************************************************
