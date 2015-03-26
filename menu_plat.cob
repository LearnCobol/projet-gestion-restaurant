         OPERATION_PLAT.

         MOVE 1 TO Wplat

         PERFORM WITH TEST AFTER UNTIL Wplat = 0
          PERFORM WITH TEST AFTER UNTIL Wplat>=0 AND Wplat<=6
           DISPLAY 'Que souhaitez vous faire ?'
           DISPLAY ' 1 - Ajouter un plat'
           DISPLAY ' 2 - Modifier un plat'
           DISPLAY ' 3 - Supprimer un plat'
           DISPLAY ' 4 - Consulter les plats pour un budget'
           DISPLAY ' 5 - Consulter les plats pour un type'        
           DISPLAY ' 6 - Consulter tous les plats'
           DISPLAY ' 0 - Quitter'
           ACCEPT Wplat
          END-PERFORM

          EVALUATE Wplat
           WHEN 1
            PERFORM AJOUTER_PLAT
           WHEN 2
            PERFORM MODIFIER_PLAT
           WHEN 3
            PERFORM SUPPRIMER_PLAT
           WHEN 4 
            PERFORM CONSULTER_PLAT_BUDGET
           WHEN 5
            PERFORM CONSULTER_PLAT_TYPE
           WHEN 6
            PERFORM CONSULTER_PLAT_TOUT
          END-EVALUATE

         END-PERFORM.


      ****************************************************************
       COPY proc_plat.
