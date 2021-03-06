       identification division.
       program-id. Tape-Film-DB.
       data division.
       working-storage section.
       01  anzahl                               pic 9(5). 
       01  ix                                   pic 9(4).
       01  sucher                               pic 9(4).
       01  film-db.
               03  film-tabelle occurs 73 times.
                       05  film-name            pic x(20).
                       05  film-jahr            pic 9(4).
                       05  film-beschreibung    pic x(100).
       01  eingabe-zeichen                      pic x.
                       88  eingabe-menu-beenden value "9".
       01  pruefer-beschreibung                 pic x(100).
       01  pruefer-name                         pic x(20).
       01  zaehler                              pic 9.
       procedure division.
       beginn section.
        divide length of film-db by length of film-tabelle giving anzahl
        display "Willkommen in der Filmdatenbank"
        perform until eingabe-menu-beenden
                perform menu-zeigen
                perform menu-eingabe-auswerten
        end-perform
        stop run.

       menu-zeigen section.
        display "Hauptmenue"
        display "Was wollen Sie machen?"
        display "1) Alle "anzahl" Filme anzeigen."
        display "2) Alle "anzahl" Filme neu anlegen. Duplikate"
                &" erlaubt."
        display "3) Filme einzeln anlegen. Duplikate nicht erlaubt."
        display "4) Löschen eines Filmes."
        display "5) Sortieren nach Erscheinungsjahr. (absteigend)"
        display "6) Sortieren nach Namen. (absteigend)"
        display "9) Das Programm beenden."
        move zero to eingabe-zeichen
        accept eingabe-zeichen
        exit.

       menu-eingabe-auswerten section.
        evaluate true
                when eingabe-zeichen = "1" perform filmliste-zeigen
                when eingabe-zeichen = "2" perform film-anlegen
                when eingabe-zeichen = "3" perform film-einzeln-anlegen
                when eingabe-zeichen = "4" perform film-loeschen
                when eingabe-zeichen = "5" perform film-sortieren-jahr
                when eingabe-zeichen = "6" perform film-sortieren-name
                when eingabe-zeichen = "9" set eingabe-menu-beenden 
                        to true
        end-evaluate
        exit.

       filmliste-zeigen section.
        perform varying ix from 1 by 1 until ix > anzahl
                display "Filmnummer: "ix
                display film-name(ix)
                display film-jahr(ix)
                display film-beschreibung(ix)
        end-perform
        exit.
       
       film-anlegen section.
        perform varying ix from 1 by 1 until ix > anzahl
                display "Geben Sie den Namen ein (max. 20 Zeichen)"
                display "Filmnummer: "ix
                accept film-name(ix)
        end-perform

        perform varying ix from 1 by 1 until ix > anzahl
                display "Geben Sie das Jahr ein im Format JJJJ ein."
                display "Filmnummer: "ix
                accept film-jahr(ix)
        end-perform

        perform varying ix from 1 by 1 until ix > anzahl
                display "Geben Sie eine Beschreibung ein(max. 100 Zeich"
                &"en)"
                display "Filmnummer: "ix
                accept film-beschreibung(ix)
        end-perform
        exit.
                        
       film-einzeln-anlegen section.
        move zero to ix
        display "Welchen Film möchten Sie ändern? Nr. eingeben."
        accept ix
        if ix > anzahl or ix <= 0
                display "Maximal erlaubt sind: " anzahl
                display "Bitte eine Zahl eingeben, die größer 0 ist."
                exit
        else
                display "Geben Sie den Filmnamen ein."
                display "Filmnummer:" ix
                move spaces to pruefer-name
                accept pruefer-name
                move zero to sucher
                move zero to zaehler
                perform varying sucher from 1 by 1 until sucher > anzahl
                        inspect film-name(sucher) tallying zaehler 
                        for all pruefer-name
                end-perform
                if zaehler is not zero
                        display "Film ist bereits in der Datenbank"
                        exit
                else
                        perform film-nicht-vorhanden
                end-if
        end-if
        exit.

       film-nicht-vorhanden section.
        move pruefer-name to film-name(ix)
        display "Geben Sie das Erscheiungsjahr ein. JJJJ"
        accept film-jahr(ix)
        display "Geben Sie eine Filmbeschreibung ein."
        accept film-beschreibung(ix)
        exit.
                
       film-loeschen section.
        move zero to ix
        perform until ix > 0 and ix <= anzahl
                display "Welchen Film möchten Sie löschen?"
                accept ix
        end-perform
        move space to film-name(ix)
        move zero to film-jahr(ix)
        move space to film-beschreibung(ix)
        display "Filmnr.: "ix " ist gelöscht."
        exit.
            
       film-sortieren-jahr section.
        sort film-tabelle
        on descending key film-jahr
        exit.

       film-sortieren-name section.
        sort film-tabelle
        on ascending key film-name
        exit.
