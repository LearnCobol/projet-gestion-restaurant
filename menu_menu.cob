       OPERATION_MENU.


         PERFORM WITH TEST AFTER UNTIL Wmenu = 0
          PERFORM WITH TEST AFTER UNTIL Wmenu>=0 AND Wmenu<=5
           DISPLAY 'Que souhaitez vous faire ?'
           DISPLAY ' 1 - Ajouter un menu'
           DISPLAY ' 2 - Consulter un menu'
           DISPLAY ' 3 - Modifier un menu'
           DISPLAY ' 4 - Supprimer un menu'
           DISPLAY ' 5 - Consulter les menus pour un budget'
           DISPLAY ' 0 - Quitter'
           ACCEPT Wmenu
          END-PERFORM

          EVALUATE Wmenu
           WHEN 1
            PERFORM AJOUTER_MENU
           WHEN 2
            PERFORM CONSULTER_MENU
           WHEN 3
            PERFORM MODIFIER_MENU
           WHEN 4 
            PERFORM SUPPRIMER_MENU
           WHEN 5
            PERFORM CONSULTER_MENU_BUDGET
          END-EVALUATE

         END-PERFORM.


      ****************************************************************
       OPERATION_MENU_UTIL.

         PERFORM WITH TEST AFTER UNTIL Wmenu = 0
          PERFORM WITH TEST AFTER UNTIL Wmenu>=0 AND Wmenu<=2
           DISPLAY 'Que souhaitez vous faire ?'
           DISPLAY ' 1 - Consulter un menu'
           DISPLAY ' 2 - Consulter les menus pour un budget'
           DISPLAY ' 0 - Quitter'
           ACCEPT Wmenu
          END-PERFORM

          EVALUATE Wmenu
           WHEN 1
            PERFORM CONSULTER_MENU
           WHEN 2
            PERFORM CONSULTER_MENU_BUDGET
          END-EVALUATE

         END-PERFORM.


      ****************************************************************
       COPY proc_menu.
