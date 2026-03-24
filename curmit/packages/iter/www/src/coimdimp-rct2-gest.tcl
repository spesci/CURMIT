ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdimp"
    @author          Giulio Laurenzi
    @creation-date   00/08/2006

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                       navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimdimp-rct-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    but01 13/06/2023 
    rom39 30/05/2023 Resa standard una modifica fatta per Regione Campania sul numero di giorni.

    rom38 17/05/2023 Su segnalazione di Belluzzo e' stato deciso con Sandro di dare la possibilita' di inserire i campi
    rom38            del rendimento di combustione anche se il campo Controllo del rendimento di combustione viene messo
    rom38            come Non effettuato. La modifica vale per tutti gli enti tranne che per Regione Marche.

    rom37 17/05/2023 Palermo ha cambiato il numero di giorni da 500 a 750, doveva essere temporaneo ma e' diventata stabile la modifica.

    rom36 12/04/2023 Con Sandro si e' deciso di mettere un controllo che impedisca ai manutentori di modificare rcee
    rom36            inseriti prececentemente da altri manutentori. Vale per tutti gli enti

    rom35 03/03/2023 Belluzzo ha chiesto che la depressione nel canale da fumo possa essere indicata anche per i combustibili liquidi.

    rom34 13/02/2023 Basilicata non deve avere il controllo sul patentino per gli impianti con Potenza maggiore
    rom34            di 232 KW se non è presente il terzo responsabile.

    rom33 03/02/2023 Corretto controllo su obbligatorieta' dell'operatore della ditta di manutenzione, sugli enti
    rom33            diversi da Regione Campania il controllo non funzionava piu' correttamente.

    rom32 01/02/2023 Paravan ha richiesto che per Regione Friuli siano sempre attive le funzioni di modifica e stampa degli rcee.
    rom32            Per regione Friuli il flag_pagato va messo sempre a Si.

    rom31 25/01/2023 Su segnalazione di Ucit si e' deciso di permettere il controllo del rendimento sul combustibile sul
    rom31            combustibile ARIA PROPANATA. Con Sandro abbiamo deciso di permetterlo anche ai combustibili GNL e SYNGAS.
    rom31            Si e' deciso che la modificha deve valere per TUTTI gli enti.

    rom30 25/01/2023 Su segnalazione di Ucit messo il campo rend_magg_o_ugua_rend_min obbligatorio se il cont_rend e' previsto.
    rom30            Prima veniva fatto solo per regione Marche, Sandro ha detto di standardizzarlo per tutti gli enti.
    rom30bis         Solo per Regione Fiuli il campo CO fumi secchi (ppm) (co_fumi_secchi_ppm) non deve essere piu' obbligatorio.

    rom29 23/01/2023 Corretto intervento di rom28, non venivano tenute in considerazione tutte le casistiche sul valore
    rom29            di data_controllo.

    rom28 18/01/2023 Salerno ha richiesto che la tariffa sia calcolata non in base alla data in cui ci si trova ma
    rom28            in base alla data dell'rcee (come gia' fatto per Ucit). Sandro ha detto che questo va bene per tutti
    rom28            gli altri enti tranne che Regione Marche.

    rom27 12/01/2023 Settate scadenze per il Comune di Benevento.
    rom27            Sandro ha detto che per Benevento sul secondo generatore deve essere esente.

    ric01 22/12/2022 Aggiunta if per controllo su Cod.Fisc. o P.IVA a seconda della natura giuridica del responsabile.
    ric01            Settato il numero massimo di giorni per Palermo.
    
    rom26 01/08/2022 Modifiche per allineamento Ucit al nuovo cvs, copiate dal vecchio cvs:
    rom26            Le modifiche fatte per i vari enti di UCIT ora vengno tutti messi nell'unica condizione sulla
    rom26            Regione Friuli e sono state rimosse tute le particolarita' del Comune di Trieste.
    rom26            Aggiunto controllo che non permette al Comune di Trieste di inserire RCEE standard sino al 31/12/2020.
    rom26            Aggiunto controllo che non permette al Comune di Pordenone di inserire RCEE standard sino al 31/12/2020.
    rom26            Fino a oggi la tariffa veniva calcolata usando la fascia di potenza valida alla data in cui si
    rom26            inseriva l'RCEE (current_date). Secondo Sandro, invece, per UCIT bisogna prendere la fascia di potenza
    rom26            valida alla data dell'RCEE (data_controllo).
    rom26            UCIT ha richiesto che per gli impianti del caldo non sia possibile inserire RCEE se
    rom26            la potenza utile del singolo generatore e' minore o uguale a 10 Kw.
    rom26            Sandro ha detto che per il Friuli il flag_pagato deve sempre essere Si per i bollini virtuali
    rom26            Avendo Ucit tolto il contributo regionale, l'importo del secondo generatore passa da 24 euro
    rom26            a 25 euro.
    rom26            tolto nic04 perchè si riferisce ad una vecchia normativa non più attuale.

    rom25 05/12/2022 Implementazione per Palermo richiesta con mail "Implementazioni" di Sandro del 01/12/2022, riporto testo:
    rom25            Inserimento di un codice bollino nell'apposito campo del Rapporto di controllo. Tale codice sarà uguale a
    rom25            quello del  campo  progressivo inserimento. Per gli impianti con piu' generatori il codice bollino sarà
    rom25            rilasciato solo sul primo generatore dove è presente il contributo.
    rom25            Tale implementazionzione riguarda tutte le tipologie di RCEE e le stampe. Il numero di bollino potrà essere
    rom25            rilasciato solo al momento dell'inserimento. L'implementazione sara' visibile solo per Palermo.

    rom24 07/10/2022 Settate le scadenze per la citta' metropolitana di Palermo.
    rom24            Gli rcee sul secondo generatore sono esenti su Palermo. Per Palermo il flag_pagato va messo sempre a Si.
    rom24            Con Sandro si e' deciso di fare le if solo per Palermo e non per tutta la Regione Sicilia perche' la
    rom24            citta' metropolitana ha particolarita' proprie.

    rom23 30/11/2022 Corretto errore sul calcolo del campo co_fumi_secchi_ppm, il campo veniva moltiplicato senza
    rom23            usare prima la proc iter_set_double.

    rom22 11/05/2022 La Regione Campania deve avere il costo dell'rcee ridotto della meta' per gli impianti del
    rom22            caldo a biomassa (con Sandro si è detto di considerare i combustibili solidi).

    rom21 25/01/2022 Gestito sulla Regione Basilicata l'esenzione per il secondo generatore.

    rom20 13/01/2022 Su indicazione di Sandro fatto in modo che i manutentori non possano mai cancellare gli RCEE.

    rom19 20/12/2021 Modificato intervento di rom16, Regione Basilicata ha cambiato le scadenze per nuova legge regionale.

    rom18 09/11/2021 Regione Marche: aggiunta combo per unita' di misura dei consumi combustibile sezione D.bis.
    rom18            Di default l'unita' di misura sara' presa dal combustibile del dimp, o in assenza del generatore,
    rom18            o in assenza dall'impianto. In base al combustibile che si seleziona, la pagina viene refreshata
    rom18            dando la possibilita' di scegliere tra le unita' di misura possibili per quel combustibile.
    rom18            Nel momento in cui si inserisce/modufica il dimp, se viene selezionata un'unita' di misura
    rom18            diversa da quella del combustibile (campo um su coimcomb) devo moltiplicare i valori dei consumi
    rom18            per convertire i valori nell'unità di misura principale.

    rom17 03/11/2021 Regione Marche ha richiesto che il combustibile venga salvato direttamente sul dimp e non preso
    rom17            sempre dai generatori. i Manutentori, in fase di inserimento e modifica, potranno mettere un
    rom17            combustibile della tipologia del combustibile del generatore e di default avranno il combustibile
    rom17            del generatore stesso. Per gli amministratori la scelta invece sara' libera.

    rom16 13/05/201  Settate le scadenze per la Regione Basilicata.

    sim78 07/05/2021 Sotto indicazione della Regione ho aumentato la tolleranza sulla CO delle prove fumi da 1% a 5%
    sim78            Ho corretto anche la visualizzazione del messaggio nelle prove fumi aggiuntive.  

    rom15 21/04/2021 Su segnalazione di Salerno Sandro mi ha fatto inserire alcuni controlli:
    rom15            Se il rendimento di combustione non supera il rendimento minimo di legge allora il flag 
    rom15            Rendimento >= rendimento minimo non puo' essere Si e l'impianto non puo' funzionare.
    rom15            L'impianto non puo' funzionare anche se il flag CO fumi secchi e senz'aria <=1.000 ppm v/v e' NO.
    rom15            Se il flag_pagato viene messo No perche' non dovuto allora bisogna inserire anche le Osservazioni.
    rom15            I nuovi controlli non sono validi per regione Marche. I controlli relativi al rendimento di comb.
    rom15            erano gia' presenti solo per Regione Marche, adesso sono stati standardizzati.

    gac14 25/02/2021 Su richiesta di Sandro ho modificato le if per le date scadenza per fare in modo che gli
    gac14            impianti a metano e gpl con potenza utile nominale <= 100 abbiano una scadenza di 4 anni
    gac14            al posto di 2 anni.

    rom14 12/02/2021 Corretto controllo di rom11: in alcuni casi il controllo sulle motivazioni degli installatori
    rom14            non funzionava, per correggere ho dovuto aggiungere il coalesce sulle where del cod_installatore
    rom14            e cod_manutentore.

    rom13 12/01/2021 Le particolarita' della Provincia di Salerno da ora sono sostituite dall'unica condizione su
    rom13            tutta la Regione Campania.

    rom12 18/01/2021 Corretto errore che non permetteva agli installatori di visualizzare i propri strumenti.

    rom11 22/12/2020 Su richiesta di Regione Marche e' stata data la possibilita' agli Installatori di poter inserire
    rom11            gli RCEE se viene scelto come motivo di compilazione: Prima messa in servizio, Sostituzione del
    rom11            generatore e Ristrutturazione dell'impianto.

    sim77 06/11/2020 La gestione del controllo Effettuato/Non effettuato presente per la Regione Marche deve diventare
    sim77            standard su tutti gli enti.
    sim77            In fase di test ho visto che se non passava i controlli la options del controllo fumi perdeva le
    sim77            particolarità che dipendevano dal tipo combustibile. Corretto.
    sim77            Se Regione Campania, se combustibile liquido o solido e se potenza dell'impianto > 100 allora la
    sim77            tariffa deve essere dimezzata. 

    sim76 30/09/2020 Su richiesta della Regione Marche è stato cambiato il messaggio di errore
    sim76            in caso di impianto non attivo. Va bene per tutti gli enti.
    
    rom10 01/07/2020 Modificato controllo per il campo o2, il suo valore non puo' superare 21 perche' altrimenti
    rom10            il programma va in errore a causa di una divisione che viene fatta su quel campo.

    rom09 05/06/2020 Per la Provincia di Salerno il costo deve essere di 16 Euro se sto inserendo un Rcee sul
    rom09            secondo generatore con la stessa data di controllo del primo generatore.

    rom08 15/05/2020 Salerno ha chiesto di rimodificare la data limite giorni, modificato intervento di san16.

    san16 03/03/2020 Modificata data limite giorni

    sim75 07/02/2020 Tutti gli enti devono avere la data prossima manutenzione obbligatoria
    
    sim74 30/01/2020 La Regione Marche non deve avere il controllo sul patentino per gli impianti con Potenza maggiore
    sim74            di 232 KW se non è presente il terzo responsabile.

    sim73 14/01/2020 Gestito scadenze Provincia di Salerno

    rom07 30/07/2019 Spostata la db_transaction per il calcolo del n_prot dopo tutti i controlli, altrimenti il 
    rom07            n_prot veniva incrementato anche se non passavao tutti i controlli.

    gac13 22/11/2019 Se non ho inserito tutti  i campi obbligatori posso entrare in sola visualizzazione

    sim72 20/11/2019 Corretto visualizzazione del campo pot_ter_nom_tot_max. Ora visualizza la somma della potenza
    sim72            utile dei generatori attivi

    sim71 11/10/2019 Gestito sulla regione marche l'esenzione per il secondo generatore

    sim70 29/05/2019 Ora Barletta vuole il controllo a 60 giorni

    rom06 10/06/2019 Dopo il collaudo con Regione Marche si e' deciso che:
    rom06            1-Il controllo sulla mancanza delle DFM non deve essere bloccante e che il messaggio di errore
    rom06            va cambiato.
    rom06            2-Va cambiato il messaggio sull'incongrueza della DFM e il messaggio va mostrato solo se l'RCEE e'
    rom06            stato inserito oltre la data di controllo indicata nella dfm
    
    gac12 10/05/2019 Aggiunta if, else e contenuto di else alla query che estrae il campo data_dfm_per_calcolo
    gac12            perche in caso di dati sporchi (es. frequenza=ANNUALE) il programma andava in errore aspettandosi
    gac12            un campo numerico.

    rom05 16/04/2019 Su richiesta di Sandro e della Regione metto bloccante il controllo fatto da gac11 se mancano le DFM

    gac11 21/12/2018 Aggiunto warning: se data rcee e data prossima manutenzione sono maggiori del mese minimo
    gac11            indicato nella dfm metto un controllo non bloccante: se non ci sono dfm esce Mancano dfm
    gac11            altrimenti Incongruenza con dfm

    gac10 10/12/2018 Per regione Marche, una volta inserito un rapporto se ci sono più generatori passo direttamente
    gac10            all'inserimento del prossimo generatore, compilando i campi in automatico come il dimp
    gac10            precedente fino alla sezione E.

    gac09 07/12/2018 Sandro mi ha detto che rct_modulo_termico non deve essere il progressivo prova fumi, ma
    gac09            il numero del generatore preso in considerazione, corretto anche un'errore in fase di cancellazione
    
    rom04 21/02/2019 Correzione errore presente su Taranto sulla data_per_calcolo_scadenza e sulla data_controllo

    sim69 07/12/2018 Anche per la provincia di Trieste il calcolo del costo deve essere fatto sulla potenza del
    sim69            generatore e non sulla potenza dell'impianto

    gac08 05/12/2018 Aggiunto campi in sola visualizzazione per Regione Marche.

    gac07 07/11/2018 Aggiunto controlli su cod_tprc, aggiunto campi nuovi flag_clima_invernale e flag_prod_acqua_calda
    gac07            e flag_pagato.
    gac07            Per regione marche la data di scadenza deve essere l'ultimo giorno del mese.
    gac07            Aggiunto altri controlli ai campi della sezione controllo rendimento di combustione
    gac07            impostato vari campi della sezione E in sola visualizzazione per regione marche.
    
    sim68 07/11/2018 Il comune Triestre paga in caso di secondo generatore una tariffa ridotta di 9.85 euro.

    rom03 23/10/2018 Corretto sim64 in modo che per Trieste e Pordenone non venga fatto il controllo sul CF

    sim67 26/09/2018 Annullate le modifiche sim54-sim53-sim52. Erano state portate su Taranto ma poi si era tornati
    sim67            indietro

    sim66 19/06/2018 Prima per vedere se un combustibile era solido c'era un if sui codici combustibile cablati.
    sim66            Ora ho lasciato la if sui codici "storici", ma faccio anche una select sul tipo combustibile

    gac06 22/08/2018 Aggiunto campi Analizzatori (cod_strumento_01) e Deprimometro (cod_strumento_02)
    
    gac05 11/07/2018 Sandro segnalava che il cod_tprc (tipo_controllo) non veniva salvato correttamente, il 
    gac05            problema era che veniva settato di default 'CADALLE' quindi anche se a db il tipo controllo
    gac05            veniva salvato correttamente quando si entrava in V si vedeva sempre 'CADALLE'

    rom04 08/06/2018 Aggiunti i campi co_fumi_secchi_ppm e barra_ann

    gac04 07/06/2018 Aggiunti campi elettricità

    gac03 10/05/2018 Modificato controllo Bacharach, aggiunto default 1 al modilo termico su richiesta di Sandro
    gac03            e aggiunto campo portata_termica_effettiva

    Mrom03 09/05/2018 La Regione Marche può mettere il controllo fumi non effettuato

    gac02 07/05/2018 Aggiunti nuovi campi bacharach2, bacharach3, portata_comb, rispetta_indice_bacharach, co_fumi_secchi,
    gac02            rend_magg_o_ugua_rend_min

    gac01 27/04/2018 Aggiunta obbligatorietà dei campi stagione_risc, stagione_risc2, consumo_annuo e consumo_annuo2.
    gac01            Aggiunti campi acquisti, acquisti2, scorta_o_lett_iniz, scorta_o_lett_iniz2, scorta_o_lett_fin 
    gac01            e scorta_o_lett_fin2.
    gac01            Aggiunta variabile unità di misura che viene valorrazza a seconda del tipo di combustibile 
    gac01            Aggiunto calcolo per il consumo annuo se il campo stesso viene lasciato vuoto

    sim58 18/04/2018 Gestito per la Regione Marche l'inserimento della tipologia controllo e la gestione della
    sim58            eventuale esenzione

    gab02 12/04/2018 Gestione del Multiportafoglio: in tutte le url di chiamata ai web service del portale passo 
    gab02            il nome dell'ente portafoglio.

    sim65 19/06/2018 Nel caso in cui non sia attivo il portafoglio, il campo del contributo regionale non esiste quindi
    sim65            non va utilizzato nel calcolo dell'importo totale del RCEE

    sim64 08/06/2018 Anche su Provincia di Trieste e Pordenone non va fatto il controllo sul codice fiscale

    sim63 21/05/2018 Il riferimento pagamento deve essere in readonly se è attivo il portafoglio

    sim62 21/05/2018 Ucit fa pagare il contributo regionale anche sulle prime installazioni

    sim61 17/05/2018 Riviste le scadenze di UCIT. Se combustibile gassoso e pot < 35 4 anni. 
    sim61            Per tutti gli altri gassosi 2 anno.
    sim61            Per gli altri combustibili, se pot < 35 2 anni altrimenti sempre un anno.    

    sim60 15/05/2018 I coimmovi non devono tener conto solo del costo del bollino ma anche del contributo regionale

    sim59 08/05/2018 Ucit può usare il portafoglio solo per controlli dal 1 Maggio 2018 in poi

    sim58 07/05/2018 Ucit in caso di secondo generatore paga una tariffa ridotta di 24 euro.

    gac01 06/03/2018 Se attivo il portafoglio, in fase di modifica, non va aggiornato il costo del rct.

    rom02 23/02/2018 Il comune di Trieste deve calcolare le scadenze come fa già Udine.

    sim57 22/02/2018 Portato a 90 il limite dei giorni per il comune di Trieste.

    sim56 20/02/2018 La provincia di Trieste deve avere le stesse scadenze della provincia di Udine e Gorizia

    rom01 26/01/2018 Gestita la possibilità di inserire più prove fumi per dichiarazione del caldo.

    sim55 12/12/2017 Ucit faceva il controllo sul bollino già utilizzato solo se si era in inserimento (e non
    sim55            in modifica) e solo per i manutentori.
    sim55            Ora verrà fatto sempre in ogni caso.

    sim54 29/11/2017 Riporto qui le modifiche richieste da Ferri di Taranto rispetto sim53:
    sim54            la differenza di giorni non va fatta sulla data scadeza ma sulla data scadenza 
    sim54            del mese successivo.
    sim54            Inoltre la data scadenza se inserita su impianti con potenza <35 e inseriti da manutentori
    sim54            va calcolata in questa maniera:
    sim54            1) impianto sprovvisto di data scadenza o data scadenza anteriore a 120 gg + i 30gg FM non 
    sim54            si permette l'inserimento.(gia' fatto per sim53)
    sim54            2) Cambio generatore : la data scadenza viene ricalcolata dalla data RCEE
    sim54            3) NUOVO IMPIANTO :  se data installazione generatore coincide con la data RCEE si accetta 
    sim54            e la scadenza è a 2 anni dalla data del controllo, se diversa viene rimandata all'ente(vedi caso 1)
    sim54            4) rinnovo normale : la nuova data scadenza ricalcolata a partire da quella precedente e non 
    sim54            dalla data del controllo 

    sim53 17/11/2017 Riporto qui l'analisi scritta da Sandro. La sim52 è sbagliata e la vado a commentare:
    sim53            Se la data dell'RCEE e la data di scadenza dell' RCEE è compreso tra 1 e  <=60 gg 
    sim53            supplemento di 10 Euro alla tariffa normale e scadenza normale
    sim53            Se la data dell'RCEE e la data di scadenza dell' RCEE è tra i 61 e 120 gg 
    sim53            supplemento di 20 Euro  alla tariffa normale e scadenza normale.
    sim53            Se data scadenza e data RCEE > 121 gg Blocco dell'inserimento.
    sim53            Dal 1 novembre 2017 sarà possibile protrarre tale scadenza pagando un supplemento. 
    sim53            Nello specifico le ipotesi sono due:
    sim53            a. Dal primo giorno successivo alla data utile per la presentazione del  R.C.E.E.  
    sim53            al 60 gg sarà applicato un supplemento di 10,00 euro.;
    sim53            b. Dal 61 al 120 gg sarà applicato un supplemento di 20,00 euro
    sim53            c. Successivamente non sarà possibile sanare la posizione.
    sim53            Sostituzione del generatore
    sim53            se la data del RCCE del nuovo e la data dell'ultima manutenzione Maggiore dell'anno 
    sim53            importo normale e scadenza normale
    sim53            Se la data del RCEE del nuovo e  la data dell'ultima manutenzione minore dell'anno 
    sim53            importo = importo/2 Euro e ricalcolo della scadenza ai 2 anni dal nuovo RCEE
    sim53            Chiesto chiarimento a Sandro che mi ha confermato che in entrambi i casi la scadenza
    sim53            va calcolata a 2 anni da quando viene fatto il nuovo RCEE (quindi non va fatto nulla)

    sim52 13/11/2017 Per Taranto sugli impianti con potenza minore di 35, se la data del controllo
    sim52            corrisponde alla installazione del nuovo generatore, la dichiarazione è esente 
    sim52            Sempre sugli impianti  con potenza minore di 35, se sono passati più di 30 giorni 
    sim52            dalla data del controllo va pagato di un supplemento di 10 euro.
    sim52            Dopo 90 giorni il supplemento è di 20 euro.
    
    san15 31/10/2017 I Comuni di Jesi, Senigallia e Fano devono poter inserire solo i tipi pagamento
    san15            BO-Bollino Prepagato e ND-PAGAMENTO NON DOVUTO.
    
    sim51 18/09/2017 Per Ancona va fatto un controllo anche sulla lunghezza del bollino che deve essere
    sim51            uguale a 7
    
    sim50 08/09/2017 Per Ucit il calcolo deve essere fatto sulla potenza del generatore e non sulla
    sim50            potenza dell'impianto

    sim49 29/08/2017 Corretto errore causato dal formato di data_insta

    sim48 24/07/2017 Per Provincia di Udine,Gorizia e Pordenone  i manutentori possono scegliere come 
    sim48            tipo pagamento solo il Bollino Prepagato oppure vuoto

    sim47 21/06/2017 Prima di fare il controllo sul bollino obligatorio devo verificare
    sim47            se rcee è esente

    san14 18/06/2017 I Comuni di Jesi, Senigallia e Fano non devono pagare sul secondo generatore
    san14            Inoltre i manutentori possono scegliere come tipo pagamento solo il Bollino Prepagato
    san14            Aggiunto anche il controllo sul campo locale e dpr del generatore. 
	
    san13 14/06/2017 Provincia e Comune di Ancona non devono pagare sul secondo generatore

    san12 10/06/2017 Per Provincia e Comune di Ancona i manutentori possono scegliere come tipo
    san12            pagamento solo il Bollino Prepagato

    san11 01/06/2017 Per ancona non va fatto il controllo sul codice fiscale se pima del 15 maggio 2017

    sim46 01/06/2017 Per Fano,Jesi e Senigallia il controllo sul bollino non deve tener conto del primo
    sim46            carattere perchè si riferisce ad una lettera estranea alla matricola

    sim45 31/05/2017 Anche per Fano,Jesi e Senigallia il controllo se un bollino
    sim45            e' gia' usato va fatto anche sull'istanza collegata.

    san10 30/05/2017 Il comune di Carrara non usa il patentino quindi facciamo in modo che sia
    san10            sempre considerato come t in modo da saltare i controlli.

    sim44 24/05/2017 Rivisto i controlli sul bollino nei casi standard che van bene anche  per
    sim44            Provincia e Comune di Ancona. Ora non inserisce più una attività in sospeso
    sim44            ma visualizza direttamente l'errore.

    san09 19/05/2017 Modifiche fatte per Fano,Jesi e Senigallia per modificare i default delle combo

    san08 17/05/2017 Per il comune di Carrara non va fatto il controllo sul CF

    sim43 26/04/2017 Anche per Taranto, se si sta facendo l'inserimento
    sim43            di un rcee su un impianto che ha già un rcee nello stesso giorno su un
    sim43            altro generatore del medesimo impianto, la tariffa deve essere 0.

    sim42 12/04/2017 Anche per provincia e comune di Ancona, il controllo se un bollino
    sim42            e' gia' usato, va fatto anche sull'istanza collegata.
    sim42            Ho anche uniformato gli if del comune con quelli della provincia di Ancona

    gab01 31/03/2017 La provincia di Barletta vuole che il secodo generatore deve pagare una bollino
    gab01            di 15 Euro.

    san07 20/03/2017 Personalizzati controlli su pdr e pod per Provincia di Barletta.

    sim41 10/03/2017 Anche CCARRARA e PMS possono inserire manualmente il costo del bollino (anche manutentori)

    sim40 06/03/2017 Per Ancona la Data Prossima Manutenzione deve essere obbligatoria

    sim39 27/02/2017 Tolto per Comune di Carrara il controllo sui 45 giorni

    sim38 27/02/2017 Ancona ha il campo pdr obbligatorio nel caso in cui il combustibile è metano

    sim36 15/02/2017 Corretto errore su refresh presente per Calabria

    sim35 14/02/2017 Tolto per Provincia di Barletta il controllo sui 45 giorni

    sim34 09/02/2017 Rivisto le scadenze della Toscana

    sim33 07/02/2017 Corretto errore su cancellazione

    sim32 02/02/2017 Messo il calcolo del n_prot in una db_transaction per evitare doppioni

    sim31 02/02/2017 Solo PFI può inserire manualmente il costo del bollino (anche manutentori)
    sim31            perchè devono recuperare il pregresso

    sim30 23/01/2017 Per firenze il tiraggio deve essere obbligatorio. 
    sim30            Anche il campo tipo_a_c è obbligatorio

    sim29 20/01/2017 Massa può mettere il controllo fumi non effettuato

    sim28 19/01/2017 Gestito scadenze Regione Toscana.

    sim27 17/11/2016 Gestito la potenza in base al flag_tipo_impianto

    sim26 22/12/2016 Quando si fa il calcolo degli 8 anni per la tariffa è necessario utilizzare
    sim26            la data del controllo e non la data odierna. 
    sim26            Manteniamo la data odierna nel calcolo solo in fase di on_request della pagina

    sim25 13/12/2016 Livorno deve porter inserire un rcee senza bollino per un impianto
    sim25            che ha gia' un rcee nello stesso giorno su un altro generatore del medesimo impianto

    sim24 12/12/2016 Corretto errore su on_change del flag_status

    sim23 10/11/2016 Per gli enti della Regione Calabria, se si sta facendo l'inserimento 
    sim23            di un rcee su un impianto che ha già un rcee nello stesso giorno su un 
    sim23            altro generatore del medesimo impianto, la tariffa deve essere 0.

    sim22 24/10/2016 Gestito le scadenze della provincia di Barletta come le scadenze della 
    sim22            Regione Marche.

    sim21 20/10/2016 Anche Reggio calabria non ha il controllo sui 45 giorni quindi correggo
    sim21            quanto fatto in precedenza per la sim14.
    
    mis01 17/10/2016 Messo * in campi obbligatori

    sim20 17/10/2016 Messo controllo su Pod e Pdr anche per la Regione Calabria e PRC

    nic09 15/10/2016 Corretto errore capitato a causa della modifica degli impianti vecchi
    
    nic08 14/10/2016 Per qualche giorno, la Regione Calabria vuole togliere il controllo di
    nic08            obbligatorieta' della targa.

    sim19 04/10/2016 Per la Regione Calabria e per Reggio calabria se l'impianto non e'
    sim19            funzionante la tariffa è 0. Per evitare che i manutentori prima mettino
    sim19            funzionante no e poi lo cambino in si per evitare di pagare, metto il
    sim19            flag_status non modificabile.

    sim18 03/10/2016 Se il combustibile e' COMBUSTIBILE SOLIDO, LEGNA, NON NOTO o ALTRO
    sim18            la prova dei fumi non e' mai obbligatoria.

    sim17 03/10/2016 Aggiunta gestione scadenze di Massa

    sim16 30/09/2016 Corretto controllo su Intestatario per Taranto

    sim15 29/09/2016 Aggiunta la gestione della data scadenza per Taranto.

    sim14 12/09/2016 Sandro ha detto di togliere il controllo sui 45 giorni per gli enti della
    sim14            Regione Calabria escluso Reggio Calabria (sono clienti diversi).

    sim13 07/09/2016 Se il parmetro flag_gest_targa e' attivo,
    sim13            verifico che la targa sia valorizzata.

    san06 31/08/2016 Se altri dati valgono 0, li considero nulli.

    sim12 29/08/2016 Se il riferimento del bollino vale 0, bisogna considerarlo nullo.

    sim11 29/08/2016 Come richiesto da Sandro, faccio in modo che in fase di inserimento il
    sim11            rendimento combustione minimo di legge venga calcolato in automatico.

    sim10 01/07/2016 Aggiunta la gestione della data scadenza per la Regione Calabria

    sim09 29/06/2016 Se il manutentore non ha il patentino, non puo' inserire impianti con
    sim09            potenza maggiore di 232 KW. 
    sim09            Il controllo va fatto sulla potenza gestita dal parametro
    sim09            coimtgen(flag_potenza)

    sim08 27/06/2016 Se flag_tariffa_impianti_vecchi eq "t" e il combustibile e' Gas o Metano
    sim08            devo verificare se l'impianto e' vecchio e quindi usare un'altra tariffa.

    san05 07/06/2016 Personalizzati controlli su pdr e pod per Provincia di Taranto.

    san04 11/05/2016 Aggiunta e gestita data_prox_manut.

    sim07 13/04/2016 Aggiunto controllo personalizzato per il comune di Pesaro che  
    sim07            effettua il controllo sul bollino rilasciato al manutentore con la sola
    sim07            parte numerica escludendo le prime 5 lettere (es.CMPSA000512)

    sim06 24/03/2016 Aggiunto controllo bloccante sul bollino anche per Caserta

    san03 26/02/2016 Aggiunti controlli su pdr e pod per Provincia di Livorno.

    sim05 11/03/2016 Se è attivo il portafoglio va abilitato solo il bollettino virtuale e il
    sim05            costo deve essere non modificabile.

    nic07 12/02/2016 Livorno ha chiesto che fino al 30/06/2016 sia possibile inserire RCT
    nic07            rilasciati dal 01/01/2016 al 29/02/2016. Per il resto e' invariato.

    nic06 12/02/2016 Gestito parametro coimtgen(flag_potenza) per utilizzo potenza nominale
    nic06            al focolare oppure utile.

    sim04 12/02/2016 Per Livorno controllo che il bollino sia pagato.

    sim03 12/02/2016 Livorno ha chiesto che fino al 31/03/2016 sia possibile inserire RCT
    sim03            piu' vecchi di 90 giorni.
    sim03            Dopo questa data deve essere di 31 giorni. 

    san01 22/01/2016 Non si controlla il codice fiscale se nato all'estero

    sim02 24/09/2015 Gestita data scadenza per provincia e comune di Pesaro e Urbino

    sim01 21/11/2014 Quando si sceglie col cerca un nuovo responsabile deve venire aggiornato 
    sim01            in automatico anche il suo codice fiscale.

    nic05 12/09/2014 Come chiesto da Chiara Paravan di UCIT, il controllo se un bollino
    nic05            e' gia' usato, va fatto anche sull'istanza collegata.

    nic04 21/07/2014 Come chiesto da Chiara Paravan di UCIT e come gia' fatto sul modello F,
    nic04            se sto inserendo un impianto > 350, ci sono n generatori attivi e c'e'
    nic04            gia' un modello con data controllo negli ultimi 4 mesi, va impostato il
    nic04            costo a 26,22 euro.

    nic03 24/05/2014 Devo esporre ed aggiornare le potenze del generatore e non dell'impianto

    nic02 23/05/2014 Se presente più di un generatore, l'utente deve scegliere a quale si
    nic02            riferisce

    nic01 17/03/2014 Comune di Rimini: se è attivo il parametro flag_gest_coimmode, deve
    nic01            comparire un menù a tendina con l'elenco dei modelli relativi al
    nic01            costruttore selezionato (tale menù a tendina deve essere rigenerato
    nic01            quando si cambia la scelta del costruttore).
    nic01            Ho dovuto aggiungere la gestione dei campi __refreshing_p e changed_field.
} {
    {cod_dimp             ""}
    {last_cod_dimp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {flag_no_link        "F"}
    {url_gage             ""}
    {cod_opma             ""}
    {data_ins             ""}
    {cod_impianto_est_new ""}
    {gen_prog             ""}
    {flag_modello_h       ""}
    {flag_tracciato       ""}
    {tabella              ""}
    {cod_dimp_ins         ""}
    {transaz_eff          ""}
    {flag_tipo_impianto   "R"}
    {cod_tprc             ""}
    {is_warning_p         "f"}
    {cod_dimp_precedente  ""}
    {is_only_view         "f"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

ad_return_if_another_copy_is_running

set ente_portafoglio [db_get_database];#gab02

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

#modifica del 120913
if {$funzione eq "I"} {
    db_1row query "select stato as stato_imp from coimaimp where cod_impianto = :cod_impianto"    
    if {$stato_imp ne "A" } {
#sim76        iter_return_complaint "
#sim76        Funzione impossibile per impianti annullati/Non attivi/Rottamati"  
	iter_return_complaint "Sarà possibile trasmettere RCEE e altri moduli solo dopo la riattivazione/validazione dell'impianto da parte dell'ente";#sim76
	ad_script_abort
    }
}
#fine modifica
set cod_manutentore "";#gac06
if {$funzione ne "I"} {

    db_1row query "select stato_dich
                        , gen_prog -- nic02
                     from coimdimp
                    where cod_dimp = :cod_dimp"    
    if {$stato_dich eq "A" || $stato_dich eq "X" || $stato_dich eq "R"} {
	set funzione "V"
	set menu 0
    } else {
	set menu 1
    }
} else {
    set menu 1
}

iter_get_coimtgen;#rom32

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom32 Aggiunta if e il suo contenuto
    set menu 1
    set is_only_view "f"
}

if {$is_only_view} {#gac13 aggiunta if e suo contenuto
    set menu 0
    set funzione V
}

set flag_errore_data_controllo "f"
if {[exists_and_not_null tabella]} {
    if {![exists_and_not_null cod_dimp]} {
	set cod_dimp $cod_dimp_ins
    }
    db_1row query "select data_controllo, stato_dich  from coimdimp where cod_dimp = :cod_dimp"    
    if {$data_controllo < "2008-08-01"} {
	iter_return_complaint "
        Funzione possibile solo per dichiarazioni con data controllo successiva all '01/08/2008'."  
	ad_script_abort
    }
    if {![exists_and_not_null gen_prog]} {#nic02
        iter_return_complaint "Storno impossibile. Generatore mancante ";#nic02
        ad_script_abort;#nic02
    };#nic02
    set stn "_stn"
    set funzione_stn " "
    if {[db_0or1row query "select 1 from coimanom where cod_cimp_dimp = :cod_dimp limit 1"] == 1} {
	iter_return_complaint "Presenti anomalie. Funzione di storno impossibile"
    }		
    if {[db_0or1row query "select 1 from coimdimp_stn where cod_dimp = :cod_dimp"]==0} {
	set funzione "I"
	set cod_dimp_ins $cod_dimp
    }
    if {$stato_dich != ""} {
	if {$funzione == "I"} {
	    iter_return_complaint "Dichiarazione sostitutiva non inseribile per dichiarazioni gia oggetto di storno"
	} else {
	    set funzione "V"
	}   
    }		
} else {
    set stn " "
    set funzione_stn " "
    set tabella ""
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

set cod_manu_cancella [iter_check_uten_manu $id_utente];#rom20
set flag_cancella t;#rom20
if {![string equal $cod_manu_cancella ""]} {#rom20 Aggiunta if e suo contenuto
    set flag_cancella f
}

#set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_ma [string range $id_utente 0 1]

db_1row query "select id_settore
                    , id_ruolo
                 from coimuten
                where id_utente = :id_utente"

#rom32 spostato in alto iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)         
set sigla_prov       $coimtgen(sigla_prov)
set cod_comu         $coimtgen(cod_comu)
set gg_scad_pag_mh   $coimtgen(gg_scad_pag_mh)
set flag_agg_sogg    $coimtgen(flag_agg_sogg)
set flag_dt_scad     $coimtgen(flag_dt_scad)
set flag_gg_modif_mh $coimtgen(flag_gg_modif_mh)
set flag_gg_modif_rv $coimtgen(flag_gg_modif_rv)
set flag_gest_targa  $coimtgen(flag_gest_targa);#sim13
#gac01set coimtgen(regione) "MARCHE1"
set msg_rcee "";#gac07
set msg_osservazioni_cont_rend "";#gac07
set err_rcee "";#gac07
set warning_cont_rend "";#gac07
set warning_co_corretto "";#gac07
set warning_co_corretto_prfumi "";#gac07
set warning_dfm "";#gac11

if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#nic06 Aggiunta if ed il suo contenuto
    set nome_col_aimp_potenza potenza_utile
    set error_nome_col_potenza "potenza";#sim09
} else {
    set nome_col_aimp_potenza potenza
    set error_nome_col_potenza "pot_focolare_nom";#sim09
}


set controllo_tariffa {#sim08
    
    set cod_listino 0
    set flag_impianto_vecchio 0

    if {[string equal $data_controllo ""]} {#sim58 in caso di refresh del tipo controllo con la data controllo non inserita, il programma andava in errore
	set flag_errore_data_controllo "t"
    }

    #sim69 aggiunto $coimtgen(ente) eq "PTS"
    #rom26if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO" || $coimtgen(ente) eq "PPN" || $coimtgen(ente) eq "PTS"} {}#sim50
    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom26 aggiunta if ma non il contenuto
	db_1row q "select pot_focolare_nom as potenza_chk_gen
                     from coimgend 
                    where cod_impianto = :cod_impianto 
                      and gen_prog     = :gen_prog"
       
	set cod_potenza_old [db_string q "select cod_potenza
                                            from coimpote
                                           where potenza_min       <= :potenza_chk_gen
                                             and potenza_max       >= :potenza_chk_gen
                                             and flag_tipo_impianto = :flag_tipo_impianto"]
	if {$flag_errore_data_controllo eq "f" && ($data_controllo ne "" || [iter_check_date $data_controllo] != 0)} {#rom26 Agginte if, else e il loro contenuto
	    if {[iter_check_date $data_controllo] != 0} {
		set data_controllo_tariffa_ucit [iter_check_date $data_controllo]
	    } else {
                    set data_controllo_tariffa_ucit $data_controllo
	    }
        } else {
            set data_controllo_tariffa_ucit [iter_set_sysdate]
        }

        if {[db_0or1row sel_tari_ucit ""] == 0} {#rom26 Aggiunta if e il suo contenuto
            set tariffa ""
            set flag_tariffa_impianti_vecchi ""
            set anni_fine_tariffa_base       ""
                set tariffa_impianti_vecchi      ""
        }

    } else {#rom26 aggiunta else ma non il suo contenuto
	
        if {$coimtgen(ente) ne "MARCHE"} {#rom28 Aggiunte if, else e il loro contenuto

            if {$flag_errore_data_controllo eq "f" && ($data_controllo ne "" || [iter_check_date $data_controllo] != 0)} {
		if {[iter_check_date $data_controllo] != 0} {
		    set data_controllo_tariffa [iter_check_date $data_controllo]
		} else {
		    set data_controllo_tariffa $data_controllo
		}
            } else {
		
                set data_controllo_tariffa [iter_set_sysdate]
		
            }
	    
        } else {
	    
            set data_controllo_tariffa [iter_set_sysdate]
	    
        }

	if {[db_0or1row sel_tari ""] == 0} {
	    set tariffa ""
	    set flag_tariffa_impianti_vecchi "";#sim08
	    set anni_fine_tariffa_base       "";#sim08
	    set tariffa_impianti_vecchi      "";#sim08
	}

    };#rom26

    #il controllo sugli anni va fatto solo se l'apposito flag e' true e solo per GAS e METANO
    if {$flag_tariffa_impianti_vecchi eq "t" && ($combustibile eq "4" || $combustibile eq "5")} {#sim08: aggiunta if e suo contenuto

	#nic09 set data_insta_controllo [db_string q "select coalesce(:data_insta::date,'1900-01-01')"]    

	#sim24 aggiuntocondizione su __refreshing_p
	if {[form is_request $form_name] || 
            [string equal $__refreshing_p "1"]} {#nic09: aggiunta in emergenza if e suo contenuto
	    #In questo punto data_insta e' in formato dd/mm/yyyy)
	    if {$data_insta eq ""} {
		set data_insta_controllo "1900-01-01"
	    } else {
		set data_insta_controllo [iter_check_date $data_insta]
		set data_insta_controllo "[string range $data_insta_controllo 0 3]-[string range $data_insta_controllo 4 5]-[string range $data_insta_controllo 6 7]"
	    }
	} else {
	    
	    #sim49 in alcuni casi entra nel formato dd/mm/yyyy quindi per sicurezza ho messo questo if
	    if {[iter_check_date $data_insta] != 0} {#sim49 if e suo contenuto
		set data_insta_controllo [iter_check_date $data_insta]
                set data_insta_controllo [db_string q "select coalesce(:data_insta_controllo::date,'1900-01-01')"]

	    } else {#sim49

		#In questo punto data_insta e' in formato yyyymmdd)
		set data_insta_controllo [db_string q "select coalesce(:data_insta::date,'1900-01-01')"]    
     	    };#sim49

	}

	ns_log notice "coimdimp-rctl-gest;data_insta_controllo:$data_insta_controllo"
	
	if {$flag_errore_data_controllo eq "f" && $data_controllo ne ""} {;#sim26
	    set oggi $data_controllo;#sim26
	} else {;#sim26
	    set oggi         [iter_set_sysdate]
	};#sim26

	#sim26 set dt_controllo [clock format [clock scan "$oggi - $anni_fine_tariffa_base years"] -format "%Y%m%d"]
	set dt_controllo [clock format [clock scan "$oggi - $anni_fine_tariffa_base years"] -format "%Y-%m-%d"];#sim26
	if {$data_insta_controllo < $dt_controllo} {
	    set tariffa               $tariffa_impianti_vecchi
	    set flag_impianto_vecchio 1
	}
    }
    
    if {[info exist __refreshing_p] && [string equal $__refreshing_p "1"]} {;#sim36
        set data_controllo_sec_gen [iter_check_date $data_controllo]
		set data_controllo_sec_gen "[string range $data_controllo_sec_gen 0 3]-[string range $data_controllo_sec_gen 4 5]-[string range $data_controllo_sec_gen 6 7]"
    } else {
        set data_controllo_sec_gen $data_controllo
    }

    #sim23 verifico se già esiste un rcee sull'impianto con la stessa data controllo ma su un generatore diverso.
    if {$flag_errore_data_controllo eq "f" && [db_0or1row q "select 1
                         from coimdimp
                        where cod_impianto   = :cod_impianto
                         --sim36 and data_controllo = :data_controllo
                          and data_controllo = :data_controllo_sec_gen --sim36
                          and gen_prog      != :gen_prog
                          and (costo        != 0   
                               or flag_status = 'N') --condizione per non sbiancare il costo in fase di modifica del rcee inserito per primo
                        limit 1"]} {;#sim23 if e else e loro contenuto
	set rcee_su_secondo_gen "t"
    } else {
	set rcee_su_secondo_gen "f"
    }
    
    #rom13if {$coimtgen(ente) ne "PSA"} {}#rom09 aggiunta if ma non suo contenuto
    if {$coimtgen(regione) ne "CAMPANIA"} {#rom13 aggiunta if ma non contenuto
	set rcee_su_nuovo_gen "f";#sim53
    };#rom09
    


    #sim67 aggiunto condizione && 1==0 per non far mai entrare nell'if. 
    #sim67 Modifica fatta per Taranto ma poi eravamo tornati indietro
    if {$potenza_old < 35 && $coimtgen(ente) eq "PTA" && 1==0} {#sim53 if e suo contenuto

	#verifico se esiste una generatore con data uguale alla data controllo	
	if {[db_0or1row q "select 1 
                             from coimgend 
                            where cod_impianto   = :cod_impianto
                              and gen_prog       = :gen_prog
                              and data_installaz = coalesce(:data_controllo,current_date)"]} {

	    set data_per_calcolo_scadenza $data_controllo;#sim54
	
	    #ricavo la data controllo dell'ultimo rcee di un generatore disattivo dello stesso impianto
	    db_0or1row q "select max(d.data_controllo) as data_ultimo_controllo 
                           from coimdimp d
                              , coimgend g
                          where d.cod_impianto   = :cod_impianto
                            and d.gen_prog       < :gen_prog
                            and g.gen_prog       = d.gen_prog
                            and d.cod_impianto   = g.cod_impianto
                            and g.flag_attivo    = 'N'
                            and d.flag_tracciato = 'R1'"

	    if {$data_ultimo_controllo ne ""} {
		set giorni_dal_controllo [db_string a "select date_part('day', :data_controllo::timestamp - coalesce(:data_ultimo_controllo::timestamp,current_timestamp))"]

		if {$giorni_dal_controllo <= 365} {
		    set tariffa [expr [iter_check_num $tariffa 2] * 0.5]
		    set tariffa [iter_edit_num $tariffa 2]
		}
 
	    }
	}	 
	
	if {$funzione eq "I"} {
	    set data_inserimento_dimp [db_string q "select current_date"]
	} else {
	    set data_inserimento_dimp $data_ins
	}

	db_0or1row q "select max(d.data_scadenza) as data_ultima_scadenza 
                           from coimdimp d
                              , coimgend g
                          where d.cod_impianto   = :cod_impianto
                            and d.gen_prog      <= :gen_prog
                            and g.gen_prog       = d.gen_prog
                            and d.cod_impianto   = g.cod_impianto
                            and cod_dimp        != coalesce(:cod_dimp,'') --sim54
                            and d.flag_tracciato = 'R1'"

	if {![exists_and_not_null data_per_calcolo_scadenza]} {#sim54 if e suo contenuto
	    set data_per_calcolo_scadenza $data_ultima_scadenza
	}

	if {$data_ultima_scadenza eq "" } {#sim54 if e suo contenuto
	    set giorni_dalla_scadenza 0
	} else {#sim54
	    #la data scadenza deve essere la fine del mese successivo
	    set data_ultima_scadenza [db_string a "select (:data_ultima_scadenza::date + interval '2 month')::date"];#sim54
	    set data_ultima_scadenza [db_string a "select (:data_ultima_scadenza::date -  interval '[string range $data_ultima_scadenza 8 10] day')::date"];#sim54

	    set giorni_dalla_scadenza [db_string a "select date_part('day', :data_inserimento_dimp::timestamp - coalesce(:data_ultima_scadenza::timestamp,current_timestamp))"]
	
	};#sim54

	if {$giorni_dalla_scadenza > 1 && $giorni_dalla_scadenza < 61} {
	    set tariffa [expr [iter_check_num $tariffa 2] + 10.00]
	    set tariffa [iter_edit_num $tariffa 2]
	}
	
	if {$giorni_dalla_scadenza > 60 && $giorni_dalla_scadenza < 120} {
	    set tariffa [expr [iter_check_num $tariffa 2] + 20.00]
	    set tariffa [iter_edit_num $tariffa 2]
	}   

    }

#sim53    set rcee_su_nuovo_gen "f";#sim52
  
#sim53    if {$potenza_old < 35 && $coimtgen(ente) eq "PTA"} {#sim52 if e suo contenuto

#sim53	if {$funzione eq "I"} {
#sim53	    set data_inserimento_dimp [db_string q "select current_date"]
#sim53	} else {

#sim53	    set data_inserimento_dimp $data_ins
#sim53	}

#sim53	set giorni_dal_controllo [db_string a "select date_part('day', :data_inserimento_dimp::timestamp - coalesce(:data_controllo::timestamp,current_timestamp))"]
       
#sim53	if {$giorni_dal_controllo > 30 && $giorni_dal_controllo < 90} {
#sim53	    set tariffa [expr [iter_check_num $tariffa 2] + 10.00]
#sim53	    set tariffa [iter_edit_num $tariffa 2]
#sim53	}

#sim53	if {$giorni_dal_controllo > 90} {

#sim53	    set tariffa [expr [iter_check_num $tariffa 2] + 20.00]
#sim53            set tariffa [iter_edit_num $tariffa 2]
#sim53	}
	
#sim53	#concordato con Sandro che basta che ci sia un generatore non attivo senza fare vincoli sulla data di rottamazione.
#sim53	#resta indispensabile che la data di installazione del nuovo impianto sia uguale alla data del controllo.
#sim53	if {[db_0or1row q "select 1 
#sim53                             from coimgend 
#sim53                            where cod_impianto   = :cod_impianto
#sim53                              and gen_prog       = :gen_prog
#sim53                              and data_installaz = coalesce(:data_controllo,current_date)"] &&
#sim53	    [db_0or1row q "select 1
#sim53                             from coimgend
#sim53                            where cod_impianto    = :cod_impianto
#sim53                              and gen_prog       != :gen_prog
#sim53                              and flag_attivo='N' limit 1"]} {
#sim53	    set rcee_su_nuovo_gen "t"
#sim53       }
#sim53    }

    if {($coimtgen(regione) eq "CAMPANIA")} {#sim77  if e suo contenuto

	set tipo_comb_per_tariffa [db_string q "select tipo from coimcomb where cod_combustibile=:combustibile"]

	if {$potenza_old > 100 && ($tipo_comb_per_tariffa eq "L" || $tipo_comb_per_tariffa eq "S")} {
	    set tariffa [expr [iter_check_num $tariffa 2] / 2.00]
	    set tariffa [iter_edit_num $tariffa 2]
	} else {#rom22 Aggiunta if e il suo contenuto	    
	    if {$tipo_comb_per_tariffa eq "S"} {
		set tariffa [expr [iter_check_num $tariffa 2] / 2.00]
		set tariffa [iter_edit_num $tariffa 2]
	    }
	}

    }

    #sim23 aggiunto condizione su rcee_su_secondo_gen
    if {($coimtgen(regione) eq "CALABRIA") && ($flag_status eq "N" || $rcee_su_secondo_gen eq "t") } {#sim19 if else e loro contenuto
	set tariffa 0
	set esente "t"
    } elseif {($coimtgen(ente) eq "PBT") && ($rcee_su_secondo_gen eq "t")} {;#gab01 aggiunta elseif e contenuto
	set tariffa 15
	set esente "f"
    } elseif { ($coimtgen(ente) eq "PTA" || $coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PAN" ||  $coimtgen(ente) eq "CANCONA" ||  $coimtgen(ente) eq "CFANO" ||  $coimtgen(ente) eq "CJESI" ||  $coimtgen(ente) eq "CSENIGALLIA" || $coimtgen(regione) eq "BASILICATA" || $coimtgen(ente) eq "PPA")  && $rcee_su_secondo_gen eq "t"} {;#sim43 #san13 #san14 #sim71 #rom21
	set tariffa 0
        set esente "t"
    } elseif {$coimtgen(regione) eq "MARCHE" && $cod_tprc ne ""} {#sim58

	db_0or1row q "select esente
                        from coimtprc
                       where cod_tprc = :cod_tprc"


	#rom26{} elseif {($coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO" || $coimtgen(ente) eq "PPN" || $coimtgen(ente) eq "PTS")  && ($rcee_su_secondo_gen eq "t")} {}#sim58
    } elseif {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && ($rcee_su_secondo_gen eq "t")} {#rom26 aggiunta elseif ma non il contenuto
	
	#rom26  set tariffa 24
        set tariffa 25;#sim23
        set esente "f"
	
#rom26    } elseif {($coimtgen(ente) eq "CTRIESTE") && ($rcee_su_secondo_gen eq "t")} {;#sim68

        #rom26 Il Comune di Trieste  e' andato sotto UCIT.
        #rom26set tariffa 9,85
        #rom26set esente "f"
	
    } elseif {$coimtgen(ente) eq "CPORDENONE" && $tariffa eq "0,00"} {#rom26 if e suo contenuto
        #il comune di Pordenone prima del 30/06/2021 aveva tariffa a 0 ed era esente. Per questa ragione devo continuare a gestirlo
        set esente "t"
    } elseif {$coimtgen(ente) eq "CBENEVENTO"  && $rcee_su_secondo_gen eq "t"} {#rom27 Aggiunta elseif e suo contenuto

	set tariffa 0
	set esente "t"	
	
    } elseif {$coimtgen(regione) eq "CAMPANIA" && $rcee_su_secondo_gen eq "t"} {#rom09 aggiunta elseif e suo contenuto

	set tariffa 16
	set esente "f"

    } else {
	set esente "f"
    }

    if {[string trim [element::get_value $form_name flag_pagato]] eq "N" || [string trim [element::get_value $form_name flag_pagato]] eq "C"} {
	set esente "t"
    }
    
    if {$esente eq "t"} {
	set tariffa 0
    }

    
#sim53    if {$rcee_su_nuovo_gen eq "t"} {;#sim52
#sim53	set tariffa 0
#sim53	set esente "t"
#sim53    }

}

set link_gest [export_url_vars cod_dimp last_cod_dimp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp url_gage flag_no_link cod_opma data_ins tabella cod_dimp_ins]

# valorizzo pack_dir che sara' utilizzata sull'adp per fare i link.
set pack_key  [iter_package_key]
set pack_dir  [apm_package_url_from_key $pack_key]
append pack_dir "src"

set msg_limite ""

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set warning_portata "";#gac03
set um ""

if {$transaz_eff == "T"} {
    set report "Transazione effettuata con successo"
    set report1 "Attenzione - La tue dichiarazioni verranno accettate anche se il credito disponibile sul tuo Portafoglio manutentore non &egrave; al momento sufficiente. Ti verra&grave; quindi contabilizzato un debito che dovrai rifondere alla prima ricarica del tuo Portafoglio. In questa occasione ti sar&agrave; detratta automaticamente la quota negativa accumulata."
} else {
    set report ""
    set report1 ""
}

set frase_inserimento_ciclo "";#gac10
if {$coimtgen(regione) eq "MARCHE" && $cod_dimp_precedente ne "" && $funzione eq "I"} {#gac10 if e suo contenuto
    set gen_prog_est [db_string q "select gen_prog_est
                                     from coimgend 
                                    where gen_prog = :gen_prog 
                                      and cod_impianto = :cod_impianto" -default ""]
    set frase_inserimento_ciclo "Inserimento generatore n° $gen_prog_est"
}


# imposto la proc per i link e per il dettaglio impianto
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp  {} $flag_tracciato]
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina
set link_list_script {[export_url_vars tariffa_reg nome_funz_caller nome_funz cod_impianto url_list_aimp url_aimp last_cod_dimp caller tabella cod_dimp_ins]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set link_gest_dimp $link_gest
set link_list_dimp $link_list

set link_anom "[export_url_vars cod_impianto gen_prog last_cod_cimp nome_funz_caller extra_par caller url_aimp url_list_aimp flag_cimp flag_inco extra_par_inco cod_inco]&nome_funz=[iter_get_nomefunz coimanom-list]&cod_cimp_dimp=$cod_dimp&flag_origine=MH"

if {$coimtgen(ente) eq "PPD"} {
    set link_d_anom ""
} {
    set link_d_anom "[export_url_vars cod_impianto gen_prog last_cod_cimp nome_funz_caller extra_par caller url_aimp url_list_aimp flag_cimp flag_inco extra_par_inco cod_inco]&nome_funz=[iter_get_nomefunz coim_d_anom-list]&cod_cimp_dimp=$cod_dimp&flag_origine=MH"
}

set ast "<font color=red>*</font>";#--- mis01
set sw_iterprfi [string match "*iterprfi_pu*" [db_get_database]];#--mis01 =1trovato 0=nontrovato

set ast_PFI ""
set ast_CANCONA "";#sim40


if {$coimtgen(ente)    eq "PFI"} {;#sim30 if else e loro contenuto
    set ast_PFI "<font color=red>*</font>"
} elseif {$coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN"} {;#sim40 #sim42
    set ast_CANCONA "<font color=red>*</font>"
}

set pot_ter_nom_tot_max [db_string q "select iter_edit_num(sum(pot_utile_nom),2) from coimgend where cod_impianto = :cod_impianto and flag_attivo  = 'S'" -default ""];#sim72

#gac07
#sim72 set pot_ter_nom_tot_max [db_string q "select iter_edit_num(potenza,2) from coimaimp where cod_impianto = :cod_impianto" -default ""]

# agg dob cind
db_1row sel_mod_gend "select flag_mod_gend,flag_cind from coimtgen"

set titolo "RCEE Tipo 1"
switch $funzione {
    M {set button_label "Conferma Modifica"
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
	set page_title   "Cancellazione $titolo"}
    I {set button_label "Conferma Inserimento"
	set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"}
}

db_1row sel_tgen_portafoglio "select flag_portafoglio from coimtgen"
set flag_combo_tipibol $flag_portafoglio;#sim05
if {[exists_and_not_null tabella]} {
    set flag_portafoglio "F"
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimdimp"
set focus_field  "";#nic01
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set disabled_flag_pagato_fld $disabled_fld
set onsubmit_cmd ""
switch $funzione {
    "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
	set disabled_flag_pagato_fld \{\}
    }
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
    }
}

if {$funzione_stn eq "I"} {
    set readonly_key \{\}
    set readonly_fld \{\}
    set disabled_fld \{\}
    set disabled_flag_pagato_fld \{\}
}
if {$coimtgen(regione) eq "MARCHE" && $cod_dimp_precedente ne ""} {
    set readonly_fld_dimp "readonly"
    set disabled_fld_dimp "disabled"
} else {
    set readonly_fld_dimp $readonly_fld
    set disabled_fld_dimp $disabled_fld
}

if {$coimtgen(regione) eq "MARCHE"} {
    set readonly_cont_rend $disabled_fld
} else {
    set readonly_cont_rend $readonly_key
}

#onChange "document.coimdimp.__refreshing_p.value='1';document.coimdimp.submit.click()"
form create $form_name \
    -html    $onsubmit_cmd 
set onchange_manu "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_manutentore';document.$form_name.submit.click()"
element create $form_name cognome_manu \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld_dimp {} class form_element $onchange_manu" \
    -optional

element create $form_name nome_manu \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name cognome_opma \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 200 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name nome_opma \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld_dimp {} class form_element" \
    -optional

set cod_manu [iter_check_uten_manu $id_utente]

if {($funzione == "I" || $funzione == "M") && [string equal $cod_manu ""]} { 
    if {$flag_portafoglio == "T"} {
	set cerca_manu [iter_search $form_name [ad_conn package_url]/src/coimmanu-list [list dummy cod_manutentore f_cognome cognome_manu dummy nome_manu dummy saldo_manu dummy cod_portafoglio]]
    } else {
	set cerca_manu [iter_search $form_name [ad_conn package_url]/src/coimmanu-list [list dummy cod_manutentore f_cognome cognome_manu dummy nome_manu]]
    }
} else {
    set cerca_manu ""
}

if {[string range $id_utente 0 1] == "AM"} {
    set cod_manu $id_utente
}

if {$funzione == "I" || $funzione == "M"} { 
    set fstato 0
    set cerca_opma [iter_search $form_name [ad_conn package_url]/src/coimopma-list [list cod_manutentore cod_manutentore dummy cod_opmanu_new f_cognome nome_opma f_nome cognome_opma] &fstato=$fstato]
 
} else {
    set cerca_opma ""
}

element create $form_name cognome_resp \
    -label   "Cod responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name nome_resp \
    -label   "Cod responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name cod_fiscale_resp \
    -label   "Cod fiscale responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 16 maxlength 16 readonly {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    #sim01: aggiunto dummy perchè se valorizzo il filtro del codice fiscale la pagina 
    #       di filtro soggetti segnala che sono stati compilati troppi filtri.
    #       Aggiunto cod_fiscale_resp per valorizzare tale campo quando si seleziona il sogg.
    set cerca_resp [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_responsabile f_cognome cognome_resp f_nome nome_resp dummy cod_fiscale_resp]]
} else {
    set cerca_resp ""
}

if {$coimtgen(regione) eq "MARCHE"} {
    #regione marche non può cambiare i soggetti dal RCEE. deve farlo sempre dalla schermata della scheda 1.6 Soggetti che operano sull'impianto
    set cerca_resp ""
}

element create $form_name cognome_prop \
    -label   "Cod proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_prop \
    -label   "Cod proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name pot_ter_nom_tot_max \
    -label "pot_ter_nom_tot_max" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 disabled {} class form_element" \
    -optional

set cons_annuo ""
set cons_annuo "<font color=green><small>Se vuoto verrà calcolata la diff. tra Scorta o lettura finale - Scorta o lettura iniziale</small></font>"
element create $form_name consumo_annuo \
    -label   "Consumo annuo" \
    -widget   text \
    -datatype text \
    -html    "size 12 $readonly_fld_dimp {} class form_element " \
    -optional 

element create $form_name consumo_annuo2 \
    -label   "Consumo annuo" \
    -widget   text \
    -datatype text \
    -html    "size 12 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name stagione_risc \
    -label   "stagione_risc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name stagione_risc2 \
    -label   "stagione_risc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld_dimp {} class form_element" \
    -optional

#gac01 aggiunto campi acquisti, acquisti2, scorta_o_lett_iniz, scorta_o_lett_iniz2, scorta_o_lett_fin e scorta_o_lett_fin2
element create $form_name acquisti \
    -label   "Acquisti" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name scorta_o_lett_iniz \
    -label   "Scorta o lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name scorta_o_lett_fin \
    -label   "Scorta o lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name acquisti2 \
    -label   "Acquisti" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name scorta_o_lett_iniz2 \
    -label   "Scorta o lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name scorta_o_lett_fin2 \
    -label   "Scorta o lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld_dimp {} class form_element" \
    -optional

#gac04 aggiunto campi elettricità
element create $form_name elet_esercizio_1 \
    -label   "Esercizio" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_esercizio_2 \
    -label   "Esercizio" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_esercizio_3 \
    -label   "Esercizio" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_esercizio_4 \
    -label   "Esercizio" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_lettura_iniziale \
    -label   "Lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_lettura_iniziale_2 \
    -label   "Lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_lettura_finale \
    -label   "Lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_lettura_finale_2 \
    -label   "Lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_consumo_totale \
    -label   "Consumo totale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name elet_consumo_totale_2 \
    -label   "Consumo totale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_dimp {} class form_element" \
    -optional

# agg dob cind
element create $form_name cod_cind \
    -label   "campagna" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcind cod_cind descrizione]

if {$flag_mod_gend == "S"} {
    if {$coimtgen(regione) eq "MARCHE"} {#gac07 qui sotto parte per regione marche
	element create $form_name matricola \
	    -label   "Matricola" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 35 readonly {} class form_element" \
	    -optional

	if {$coimtgen(flag_gest_coimmode) eq "F"} {#nic01
	    element create $form_name modello \
		-label   "Modello" \
		-widget   text \
		-datatype text \
		-html    "size 15 maxlength 40 readonly {} class form_element" \
		-optional
	    
	    element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01
	    
	    set html_per_costruttore "";#nic01
	} else {;#nic01
	    element create $form_name modello  -widget hidden -datatype text -optional;#nic01
	    
	    element create $form_name cod_mode \
		    -label   "modello" \
		    -widget   select \
		    -datatype text \
		    -html    "readonly {} class form_element" \
		    -optional \
		    -options "";#nic01

	    set html_per_costruttore "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='costruttore';document.$form_name.submit.click()";#nic01
	};#nic01
	
	element create $form_name descr_cost \
	    -label   "costruttore" \
	    -widget   text \
	    -datatype text \
	    -html    "readonly {} class form_element $html_per_costruttore" \
	    -optional \
	    
	element create $form_name costruttore -widget hidden -datatype text -optional;#gac08
        #modifica sandro del 08-05-13  
	set l_of_l  [db_list_of_lists query "select descr_comb, cod_combustibile from coimcomb where cod_combustibile <> '0'"]
	set cod_com  [linsert $l_of_l 0 [list "" ""]]

	element create $form_name descr_comb \
	    -label   "combustibile" \
	    -widget   text \
	    -datatype text \
	    -html    "readonly {} class form_element" \
	    -optional \

	element create $form_name combustibile -widget hidden -datatype text -optional;#gac08
	# fine
	
	if {$funzione in [list "V" "D" "M"]} {#rom17 Aggiunta if e suo contenuto
	    if {[db_0or1row q "select d.cod_combustibile as value_tipo_comb
                                    , c.tipo             as tipo_comb_per_manu
                                 from coimcomb c
                                    , coimdimp d
                                where c.cod_combustibile = d.cod_combustibile
                                  and d.cod_dimp         = :cod_dimp"]} {
		set where_tipo_comb "and cod_combustibile = :value_tipo_comb"
	    } else {
		#Caso per i dimp che non hanno il combustibile salvato
		db_1row q "select c.cod_combustibile as value_tipo_comb
                                , c.tipo             as tipo_comb_per_manu
                             from coimcomb c
                                , coimgend g
                            where c.cod_combustibile = g.cod_combustibile
                              and g.cod_impianto = :cod_impianto
                              and g.gen_prog = :gen_prog"

		set where_tipo_comb "and tipo = :tipo_comb_gen"
	    }		
	}

	if {$funzione eq "I"} {
	    if {[db_0or1row q "select c.cod_combustibile as value_tipo_comb
                                    , c.tipo             as tipo_comb_per_manu
                                 from coimcomb c
                                    , coimgend g
                                where c.cod_combustibile = g.cod_combustibile
                                  and g.cod_impianto     = :cod_impianto
                                 and g.gen_prog         = :gen_prog"]} {
		
		set where_tipo_comb "and tipo = :tipo_comb_gend"
	    } elseif {[db_0or1row q "select c.cod_combustibile as value_tipo_comb
                                          , c.tipo             as tipo_comb_per_manu
                                       from coimcomb c
                                          , coimaimp a
                                      where c.cod_combustibile = a.cod_combustibile
                                        and a.cod_impianto     = :cod_impianto"]} {
		set where_tipo_comb "and tipo = :tipo_comb_aimp"
	    } else {
		set where_tipo_comb ""
	    }
	}
	
	if {![string equal [iter_check_uten_manu $id_utente] ""]} {#rom17 Aggiunte if, else e loro contenuto
	    # Se sono un manutentore la scelta del combustibile deve essere
	    # limitata alla tipoogia del combustibile del generatore/dimp.
	    set where_tipo_comb "and tipo = :tipo_comb_per_manu"
	} else {
	    # Per gli amministratori la scelta del combustibile va lasciata libera.
	    set where_tipo_comb ""
	}

		set l_of_l  [db_list_of_lists query "
                               select descr_comb
                                    , cod_combustibile
                                 from coimcomb
                                where cod_combustibile not in ('0','2','7','88','20')
                                      $where_tipo_comb "];#rom17
	set cod_comb_dimp  [linsert $l_of_l 0 [list "" ""]];#rom17

	set html_change_comb_dimp "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='combustibile_dimp';document.$form_name.submit.click()";#rom18

	#rom17
	element create $form_name combustibile_dimp \
	    -label "combustibile" \
	    -widget select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element $html_change_comb_dimp" \
	    -optional \
	    -options $cod_comb_dimp \
	    -value $value_tipo_comb
	
	set l_of_ls_um [db_list_of_lists q "
            select c.um
                 , c.um
              from coimcomb c
             where c.cod_combustibile = :value_tipo_comb
             union all
            select f.um_secondaria
                 , f.um_secondaria
              from coimcomb_fatt_conv f
             where f.cod_combustibile = :value_tipo_comb"]
	    
	set l_of_ls_um  [linsert $l_of_ls_um 0 [list "" ""]]
	
	set html_change_un_ms "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='unita_misura_consumi';document.$form_name.submit.click()";#rom18
	set vl_um_cns [db_string q "select um from coimcomb where cod_combustibile = :value_tipo_comb" -default ""];#rom18

	#rom18
	element create $form_name unita_misura_consumi \
	    -label "Unità di misura" \
	    -widget select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element $html_change_un_ms" \
	    -optional \
	    -options $l_of_ls_um \
	    -value $vl_um_cns
	
	element create $form_name tiraggio_gen \
	    -label   "tipo tiraggio" \
	    -widget   text \
	    -datatype text \
	    -html    "readonly {} class form_element" \
	    -optional \

	element create $form_name tiraggio -widget hidden -datatype text -optional;#gac08
	
	element create $form_name tipo_a_c_gen \
	    -label   "Tipo aperto/chiuso" \
	    -widget   text \
	    -datatype text \
	    -html    "readonly {} class form_element" \
	    -optional

	element create $form_name tipo_a_c -widget hidden -datatype text -optional;#gac08

	element create $form_name data_insta \
	    -label   "Data installazione" \
	    -widget   inform \
	    -datatype text \
	    -html    "size 15 maxlength 100 readonly {} class form_element" \
	    -optional

	element create $form_name destinazione \
	    -label   "cod_utgi" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional \
	    -options [iter_selbox_from_table_obblig coimutgi cod_utgi descr_utgi cod_utgi] 

	element create $form_name data_costruz_gen \
	    -label   "Data costruzione generatore" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 readonly {} class form_element" \
	    -optional

	element create $form_name marc_effic_energ \
	    -label   "Marcatura efficienza energetica" \
	    -widget   text \
	    -datatype text \
	    -html    "size 4 maxlength 10 readonly {} class form_element" \
	    -optional

	element create $form_name pot_focolare_nom \
	    -label   "potenza_focolare" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 readonly {} class form_element" \
	    -optional

	element create $form_name potenza \
	    -label   "Potenza" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 maxlength 10 readonly {} class form_element" \
	    -optional

    } else {#gac07 qui sotto parte standard
	element create $form_name matricola \
	    -label   "Matricola" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 35 $readonly_fld {} class form_element" \
	    -optional
	
	if {$coimtgen(flag_gest_coimmode) eq "F"} {#nic01
	    element create $form_name modello \
		-label   "Modello" \
		-widget   text \
		-datatype text \
		-html    "size 15 maxlength 40 $readonly_fld {} class form_element" \
		-optional
	    
	    element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01
	    
	    set html_per_costruttore "";#nic01
	} else {;#nic01
	    element create $form_name modello  -widget hidden -datatype text -optional;#nic01
	    
	    element create $form_name cod_mode \
		    -label   "modello" \
		    -widget   select \
		    -datatype text \
		    -html    "$disabled_fld {} class form_element" \
		    -optional \
		    -options "";#nic01
	    
	    set html_per_costruttore "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='costruttore';document.$form_name.submit.click()";#nic01
	};#nic01

	element create $form_name costruttore \
	    -label   "costruttore" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element $html_per_costruttore" \
	    -optional \
	    -options [iter_selbox_from_table coimcost cod_cost descr_cost]

	#modifica sandro del 08-05-13  
	set l_of_l  [db_list_of_lists query "select descr_comb, cod_combustibile from coimcomb where cod_combustibile <> '0'"]
	set cod_com  [linsert $l_of_l 0 [list "" ""]]

	element create $form_name combustibile \
	    -label   "combustibile" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional \
	    -options $cod_com
	# fine

	element create $form_name tiraggio \
	    -label   "tipo tiraggio" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional \
	    -options {{{} {}} {Forzato F} {Naturale N}}

	element create $form_name tipo_a_c \
	    -label   "Tipo aperto/chiuso" \
	    -widget   select \
	    -options  {{Aperta A} {Stagna C} {{} {}}} \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional

	element create $form_name data_insta \
	    -label   "Data installazione" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
	    -optional

	element create $form_name destinazione \
	    -label   "cod_utgi" \
	    -widget   select \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element" \
	    -optional \
	    -options [iter_selbox_from_table_obblig coimutgi cod_utgi descr_utgi cod_utgi] 

	element create $form_name data_costruz_gen \
	    -label   "Data costruzione generatore" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 $readonly_fld {} class form_element" \
	    -optional

	element create $form_name marc_effic_energ \
	    -label   "Marcatura efficienza energetica" \
	    -widget   text \
	    -datatype text \
	    -html    "size 4 maxlength 10 $readonly_fld {} class form_element" \
	    -optional

	element create $form_name pot_focolare_nom \
	    -label   "potenza_focolare" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 $readonly_fld {} class form_element" \
	    -optional

	element create $form_name potenza \
	    -label   "Potenza" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	    -optional

	element create $form_name combustibile_dimp    -widget hidden -datatype text -optional;#rom17
	element create $form_name unita_misura_consumi -widget hidden -datatype text -optional;#rom18
	
    };#gac07 fine if coimtgen

    if {$coimtgen(regione) eq "MARCHE"} {
	element create $form_name flag_clima_invernale_gen \
	    -label   "flag_clima_invernale" \
	    -widget   text \
	    -datatype text \
	    -html    "size 4 maxlength 4 readonly {} class form_element " \
	    -optional
	
	element create $form_name flag_prod_acqua_calda_gen \
	    -label   "flag_prod_acqua_calda" \
	    -widget   text \
	    -datatype text \
	    -html    "size 4 maxlength 4 readonly {} class form_element " \
	    -optional
	element create $form_name flag_clima_invernale  -widget hidden -datatype text -optional;#gac07
	element create $form_name flag_prod_acqua_calda  -widget hidden -datatype text -optional;#gac07
	
    } else {
	element create $form_name flag_clima_invernale  -widget hidden -datatype text -optional;#gac07
        element create $form_name flag_prod_acqua_calda  -widget hidden -datatype text -optional;#gac07
    }

    element create $form_name volimetria_risc \
	-label   "Volimetria riscaldata" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld {} class form_element" \
	-optional
	
#    element create $form_name locale \
#	-label   "Locale" \
#	-widget   select \
#	-options {{{} {}} {Tecnico T} {Esterno E} {Interno I}} \
#	-datatype text \
#	-html    "$disabled_fld {} class form_element" \
#	-optional

} else {
    if {$coimtgen(regione) eq "MARCHE"} {#gac07 qui non entra ma nel caso dovesse essere modificato flag_mod_gend deve entrare qui dentro
	element create $form_name costruttore \
	    -label   "Costruttore" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 100 readonly {} class form_element" \
	    -optional

	element create $form_name modello \
	    -label   "Modello" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 100 readonly {} class form_element" \
	    -optional

	element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01
	
	element create $form_name matricola \
	    -label   "Matricola" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 100 readonly {} class form_element" \
	    -optional
	
	element create $form_name combustibile \
	    -label   "Combustibile" \
	    -widget   text \
	    -datatype text \
	    -html    "size 15 maxlength 100 readonly {} class form_element" \
	    -optional
    
	element create $form_name tiraggio \
	    -label   "Tiraggio" \
	    -widget   text \
	    -datatype text \
	    -html    "readonly {} class form_element" \
	    -optional
	
	element create $form_name tipo_a_c \
	    -label   "Tipo A/C" \
	    -widget   text \
	    -datatype text \
	    -html    "readonly {} class form_element" \
	    -optional
	
	element create $form_name data_insta \
	    -label   "Data installazione" \
	    -widget   inform \
	    -datatype text \
	    -html    "size 15 maxlength 100 readonly {} class form_element" \
	    -optional
	
	element create $form_name destinazione \
	    -label   "Destinazione" \
	    -widget   text \
	    -datatype text \
	    -html    "size 40 maxlength 100 readonly {} class form_element" \
	    -optional
	
    
#    element create $form_name locale \
#	-label   "Locale" \
#	-widget   select \
#	-options {{{} {}} {Tecnico T} {Esterno E} {Interno I}} \
#	-datatype text \
#	-html    "disabled {} class form_element" \
#	-optional
    
	element create $form_name data_costruz_gen \
	    -label   "Data costruzione generatore" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 readonly {} class form_element" \
	    -optional
	
	element create $form_name marc_effic_energ \
	    -label   "Marcatura efficienza energetica" \
	    -widget   text \
	    -datatype text \
	    -html    "size 4 readonly {} class form_element" \
	    -optional
	
	element create $form_name pot_focolare_nom \
	    -label   "potenza_focolare" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10  readonly {} class form_element" \
	    -optional
	
	element create $form_name potenza \
	    -label   "Potenza" \
	    -widget   text \
	    -datatype text \
	    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	    -optional
	
    } else {#gac07 qui sotto parte standard

	element create $form_name costruttore \
	-label   "Costruttore" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional

    element create $form_name modello \
	-label   "Modello" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional

    element create $form_name cod_mode -widget hidden -datatype text -optional;#nic01
    
    element create $form_name matricola \
	-label   "Matricola" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional

    element create $form_name combustibile \
	-label   "Combustibile" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional
    
    element create $form_name tiraggio \
	-label   "Tiraggio" \
	-widget   select \
	-options  {{Naturale N} {Forzato F} {{} {}}} \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional
	
    element create $form_name tipo_a_c \
	-label   "Tipo A/C" \
	-widget   select \
	-options  {{Aperto A} {Chiuso C} {{} {}}} \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional
    
    element create $form_name data_insta \
	-label   "Data installazione" \
	-widget   text \
	-datatype text \
	-html    "size 15 maxlength 100 readonly {} class form_element" \
	-optional
    
    element create $form_name destinazione \
	-label   "Destinazione" \
	-widget   text \
	-datatype text \
	-html    "size 40 maxlength 100 readonly {} class form_element" \
	-optional
    
    
#    element create $form_name locale \
#	-label   "Locale" \
#	-widget   select \
#	-options {{{} {}} {Tecnico T} {Esterno E} {Interno I}} \
#	-datatype text \
#	-html    "disabled {} class form_element" \
#	-optional
    
    element create $form_name data_costruz_gen \
	-label   "Data costruzione generatore" \
	-widget   text \
	-datatype text \
	-html    "size 10 readonly {} class form_element" \
	-optional
    
    element create $form_name marc_effic_energ \
	-label   "Marcatura efficienza energetica" \
	-widget   text \
	-datatype text \
	-html    "size 4 readonly {} class form_element" \
	-optional
    
    element create $form_name pot_focolare_nom \
	-label   "potenza_focolare" \
	-widget   text \
	-datatype text \
	-html    "size 10  readonly {} class form_element" \
	-optional
    
    element create $form_name potenza \
	-label   "Potenza" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional
    };#gac07 fine coimtgen

    element create $form_name volimetria_risc \
	-label   "Volimetria riscaldata" \
	-widget   text \
	-datatype text \
	-html    "size 10 $readonly_fld_dimp {} class form_element" \
	-optional

}

if {$funzione == "I" || $funzione == "M"} {
    set cerca_prop [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_proprietario f_cognome cognome_prop f_nome nome_prop]]

} else {
    set cerca_prop ""
}

element create $form_name cognome_occu \
    -label   "Cod occupante" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_occu \
    -label   "Cod occupante" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    set cerca_occu [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_occupante f_cognome cognome_occu f_nome nome_occu]]
} else {
    set cerca_occu ""
}

#intestatario
set readonly_inte $readonly_fld
if {($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
} {#Nicola 20/08/2014
    set readonly_inte "readonly";#Nicola 20/08/2014
};#Nicola 20/08/2014

set readonly_costo $readonly_fld;#sim05
if {$flag_combo_tipibol eq "T"} {;#sim05 if e suo contenuto
    set readonly_costo "readonly"
}

element create $form_name cognome_contr \
    -label   "Cod intestatario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_inte {} class form_element" \
    -optional

element create $form_name nome_contr \
    -label   "Cod intestatario" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_inte {} class form_element" \
    -optional

if {$funzione == "I" || $funzione == "M"} {
    set cerca_contr [iter_search $form_name [ad_conn package_url]/src/coimcitt-filter [list dummy cod_int_contr f_cognome cognome_contr f_nome nome_contr]]
    if {$readonly_inte eq "readonly"} {#Nicola 20/08/2014
	set cerca_contr "";#Nicola 20/08/2014
    };#Nicola 20/08/2014
} else {
    set cerca_contr ""
}

db_1row sel_anom_count2 ""

if {$funzione == "I" || $funzione == "V" || $funzione == "D"
    || ( $funzione == "M" && $conta_anom_2 == 0)} {
    set vis_desc_contr "f"

    set disabled_fld_status $disabled_fld;#sim19
    if {$coimtgen(regione) eq "CALABRIA"} {;#sim19 if else e loro contenuto
	set html_change_flag_status "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='flag_status';document.$form_name.submit.click()"

	if {$funzione == "M" && $id_ruolo eq "manutentore"} {
	    set disabled_fld_status "disabled"
	}

    } else {
	set html_change_flag_status ""
    }
	
    #sim01 aggiunto html_change_flag_status e messo disabled_fld_status al posto di disabled_fld
    element create $form_name flag_status \
	-label   "status" \
	-widget   select \
	-options  {{{} {}} {S&igrave; P} {No N}} \
	-datatype text \
	-html    "$disabled_fld_status {} class form_element $html_change_flag_status" \
	-optional
} else {
    set vis_desc_contr "t"
    element create $form_name flag_stat \
	-label   "flag_stat" \
	-widget   text \
	-datatype text \
	-html    "size 10 readonly {} class form_element" \
	-optional 

    element set_properties $form_name flag_stat -value "Negativo"
    element create $form_name flag_status -widget hidden -datatype text -optional
}

element create $form_name garanzia \
    -label   "Garanzia" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name conformita \
    -label   "Conformit&agrave;" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name lib_impianto \
    -label   "Libretto impianto" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name lib_uso_man \
    -label   "Libretto uso/manut." \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name inst_in_out \
    -label   "Idoneita dei locali" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {ES. E} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name idoneita_locale \
    -label   "Idoneit&agrave; del locale" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. E} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_dur_acqua \
    -label   "Durezza totale dell'acqua" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_tratt_in_risc \
    -label   "Trattamento in riscaldamento" \
    -widget   select \
    -options  {{NonRichiesto R} {Assente A} {Filtrazione F}  {Addolcimento D} {Cond.Chimico C} {Filtr.+Addolc. K} {Filtr.+Cond.Ch. J} {Cond.Ch.+Addolc. W} {Filt.+Cond.Ch.+Addolc. T} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_tratt_in_acs \
    -label   "Trattamento in acs" \
    -widget   select \
    -options  {{NonRichiesto R} {Assente A} {Filtrazione F}  {Addolcimento D} {Cond.Chimico C} {Filtr.+Addolc. K} {Filtr.+Cond.Ch. J} {Cond.Ch.+Addolc. W} {Filt.+Cond.Ch.+Addolc. T} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_install_interna \
    -label   "Installazione Interna" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_install_esterna \
    -label   "Installazione Interna" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional


element create $form_name ap_vent_ostruz \
    -label   "Apertura ventilazione areaz. ostruita" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional


element create $form_name ap_ventilaz \
    -label   "Dimensioni aperture" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional


element create $form_name rct_canale_fumo_idoneo  \
    -label   "canale_fumo_idoneo " \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_sistema_reg_temp_amb \
    -label   "sistema_reg_temp_ambi" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_assenza_per_comb \
    -label   "rct_assenza_per_comb" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

element create $form_name rct_idonea_tenuta \
    -label   "rct_idonea_tenuta" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional

if {$coimtgen(regione) ne "MARCHE"} {
    element create $form_name rct_gruppo_termico \
	-label   "Gruppo Termico" \
	-widget   select \
	-options  {{"Singolo" S} {"Modulare" M} {"Tubo/Nastro" T}  {"Aria calda" A} {{} {}}} \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional
} else {
#	-options  {{"Gruppo termico singolo" GTS} {"Gruppo termico modulare" GTM1} {"Tubo/Nastro radiante" TNR}  {"Generatore di aria calda" GAC} {{} {}}} 
    element create $form_name desc_grup_term \
	-label   "Gruppo Termico" \
	-widget   text \
	-datatype text \
	-html    "readonly {} class form_element" \
	-optional

    element create $form_name rct_gruppo_termico -widget hidden -datatype text -optional;#gac08
    
}

element create $form_name disp_comando \
    -label   "Dispositivi di comando" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name disp_sic_manom \
    -label   "Dispositivi di sicurezza non manomessi" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name rct_valv_sicurezza \
    -label   "rct_valv_sicurezza" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_scambiatore_lato_fumi \
    -label   "rct_scambiatore_lato_fumi" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_riflussi_comb \
    -label   "rct_riflussi_comb" \
    -widget   select \
    -options  {{No N} {S&igrave; S} {N.C. C}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_uni_10389 \
    -label   "rct_uni_10389" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rct_lib_uso_man_comp \
    -label   "lib_uso_man_comp" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld_dimp {} class form_element" \
    -optional
#------------------da togliere
element create $form_name scar_ca_si \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name sezioni \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create $form_name conservazione \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name lunghezza \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name curve \
    -label   "Scarico camino singolo" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name scar_parete \
    -label   "Scarico a parete" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name riflussi_locale \
    -label   "Riflussi nel locale" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name assenza_perdite \
    -label   "Assenza perdite" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name pulizia_ugelli \
    -label   "Pulizia ugelli" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name antivento \
    -label   "Antivento" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name scambiatore \
    -label   "Scambiatore" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name accens_reg \
    -label   "Accensione regolare" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional


element create $form_name ass_perdite \
    -label   "Assenza perdite" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name valvola_sicur \
    -label   "Valvoal di sicurezza" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name vaso_esp \
    -label   "Vaso espansore" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional



element create $form_name organi_integri \
    -label   "Organi integri" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name circ_aria \
    -label   "Circolazione aria" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name guarn_accop \
    -label   "Guarnizione di accoppiamento integra" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name assenza_fughe \
    -label   "Assenza di fughe" \
    -widget   select \
    -options  {{Pos P} {Neg N} {N.A. A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name coibentazione \
    -label   "Coibentazione" \
    -widget   select \
    -options  {{Pos P} {Neg N} {N.A. A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name eff_evac_fum \
    -label   "Efficenza evacuazione fumi" \
    -widget   select \
    -options  {{Pos P} {Neg N} {N.A. A} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

#da togliere fine
#Mrom03 aggiunta condizione $coimtgen(regione) ne "MARCHE"
#sim29 aggiunto if per massa
#sim77 if {$id_ruolo eq "manutentore"
#sim77 &&  $coimtgen(ente) ne "PPO"
#sim77 &&  $coimtgen(ente) ne "PPU"
#sim77 &&  $coimtgen(ente) ne "CPESARO"
#sim77 &&  $coimtgen(ente) ne "PFI"
#sim77 &&  $coimtgen(ente) ne "PMS"
#sim77 &&  $coimtgen(regione) ne "MARCHE"
#sim77 && ![string match "*iterprfi_pu*" [db_get_database]]
#sim77 } {
#sim77     element create $form_name cont_rend \
#sim77 	-label   "Controllo rendimento" \
#sim77 	-widget   select \
#sim77 	-options  {{Effettuato S}} \
#sim77 	-datatype text \
#sim77 	-html    "$readonly_cont_rend {} class form_element" \
#sim77 	-optional

#sim77 } else {
#sim77     if {$coimtgen(regione) eq "MARCHE"} {
	set onchange_cont_rend "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cont_rend';document.$form_name.submit.click()"
	element create $form_name cont_rend \
	    -label   "Controllo rendimento" \
	    -widget   select \
	    -options  {{{Non effettuato} N} {Effettuato S}} \
	    -datatype text \
	    -html    "$disabled_fld {} class form_element $onchange_cont_rend" \
	    -optional 
	
#sim77     } else {
#sim77         element create $form_name cont_rend \
#sim77 	    -label   "Controllo rendimento" \
#sim77 	    -widget   select \
#sim77 	    -options  {{{Non effettuato} N} {Effettuato S} {{} {}}} \
#sim77 	    -datatype text \
#sim77 	    -html    "$disabled_fld {} class form_element" \
#sim77 	    -optional
#sim77     }
#sim77 }

element create $form_name pot_focolare_mis \
    -label   "Potenza focolare misurata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name portata_comb_mis \
    -label   "Portata combustibile misurata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name pendenza \
    -label   "Portata combustibile misurata" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional
element create $form_name temp_fumi \
    -label   "Temperatura fumi" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name temp_ambi \
    -label   "Temperatura ambiente" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

element create $form_name o2 \
    -label   "o2" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name co2 \
    -label   "co2" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name bacharach \
    -label   "Bacharach" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
    -optional

#gac03 aggiunto campo portata_termica_effettiva
element create $form_name portata_termica_effettiva \
    -label   "Portata termica effettiva" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 12 $readonly_fld {} class form_element" \
    -optional
if {$funzione == "V"} {#rom04
    set barra_ann "/"
} else {
     set barra_ann ""
}

#gac02 aggiunto bacharach2 e bacharach3 portata_comb, rispetta_indice_bacharach, co_fumi_secchi, rend_magg_o_ugua_rend_min
element create $form_name bacharach2 \
    -label   "Bacharach" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name bacharach3 \
    -label   "Bacharach" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name portata_comb \
    -label   "Portata combustibile" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 12 $readonly_fld {} class form_element" \
    -optional

#gac06 aggiunto strumenti
if {$coimtgen(regione) eq "MARCHE"} {#gac06 aggiunta if e else e loro contenuto
    #rom12set cod_manutentore [db_string q "select cod_manutentore from coimaimp where cod_impianto = :cod_impianto" -default ""]
    if {![string equal $cod_manu ""]} {#rom12 if, else e loro contenuto
	set cod_manutentore_stru $cod_manu
    } else {
	set cod_manutentore_stru [db_string q "select cod_manutentore 
                                                 from coimmanu 
                                                where cod_manutentore = :cod_manutentore" -default ""]
    }
    #but01 aggiunto la condizione  is_active_p = 't'
  
    element create $form_name cod_strumento_01 \
	-label   "cod. strumento 1" \
	-widget   select \
	-options [iter_selbox_from_table_wherec coimstru_manu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '0' and is_active_p = 'f'"] \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional 
    
    element create $form_name cod_strumento_02 \
	-label   "cod. strumento 2" \
	-widget   select \
	-options [iter_selbox_from_table_wherec coimstru_manu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '1' and is_active_p = 'f'"] \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional 


} else {#gac06
    element create $form_name cod_strumento_01 -widget hidden -datatype text -optional
    element create $form_name cod_strumento_02 -widget hidden -datatype text -optional
};#gac06

element create $form_name rispetta_indice_bacharach \
    -label   "Rispeta l'indice di Bacharach" \
    -widget   select \
    -options  {{{} {}} {S&igrave; S} {No N}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name co_fumi_secchi \
    -label   "CO fumi secchi e senz'aria" \
    -widget   select \
    -options  {{{} {}} {S&igrave; S} {No N}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name rend_magg_o_ugua_rend_min \
    -label   "Rendimento maggiore o uguale a rend minimo" \
    -widget   select \
    -options  {{{} {}} {S&igrave; S} {No N}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name co \
    -label   "co" \
    -widget   text \
    -datatype text \
    -html    "size 6 maxlength 14 $readonly_fld {} class form_element" \
    -optional
#rom04
element create $form_name co_fumi_secchi_ppm \
    -label   "co_fumi_secchi_ppm" \
    -widget   text \
    -datatype text \
    -html    "size 6 maxlength 14 $readonly_fld {} class form_element" \
    -optional


element create $form_name rend_combust \
    -label   "Rendimento combustibile" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name rct_rend_min_legge \
    -label   "Rendimento combustibile minimo" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name rct_modulo_termico \
    -label   "Modulo termico" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
    -optional

if {$coimtgen(ente) eq "CFANO"
||  $coimtgen(ente) eq "CJESI"
||  $coimtgen(ente) eq "CSENIGALLIA" 
} {;#san09 if e suo contenuto 
element create  $form_name  rct_check_list_1 \
    -label   "check list 1" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_2 \
    -label   "check list 2" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_3 \
    -label   "check list 3" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_4 \
    -label   "check list 4" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
} else {;#san09
element create  $form_name  rct_check_list_1 \
    -label   "check list 1" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_2 \
    -label   "check list 2" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_3 \
    -label   "check list 3" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
element create  $form_name  rct_check_list_4 \
    -label   "check list 4" \
    -widget   select \
    -options  {{No N} {Sì S}  {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
};#san09

element create $form_name osservazioni \
    -label   "Osservazioni" \
    -widget   textarea \
    -datatype text \
    -html    "cols 150 rows 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name raccomandazioni \
    -label   "Raccomandazioni" \
    -widget   textarea \
    -datatype text \
    -html    "cols 150 rows 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name prescrizioni \
    -label   "Prescrizioni" \
    -widget   textarea \
    -datatype text \
    -html    "cols 150 rows 6 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_utile_inter \
    -label   "Data utile intervento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_controllo \
    -label   "Data controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_key {} class form_element" \
    -optional
#gac07 aggiunto per regione marche
if {$coimtgen(regione) eq "MARCHE"} {
    element create $form_name data_ultima_manu \
	-label   "data_ultima_manu" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional
} else {
    element create $form_name data_ultima_manu -widget hidden -datatype text -optional
}

set readonly_n_prot "readonly"
if {$coimtgen(ente) eq "PPD"} {#Nicola 06/11/2014
    set readonly_n_prot $readonly_fld;#Nicola 06/11/2014
};#Nicola 06/11/2014

element create $form_name n_prot \
    -label   "Num. protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 20 $readonly_n_prot {} class form_element" \
    -optional

element create $form_name data_prot \
    -label   "Data protocollo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name saldo_manu \
    -label   "saldo_manu" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element" \
    -optional

element create $form_name cod_portafoglio \
    -label   "saldo_manu" \
    -widget   text \
    -datatype text \
    -html    "size 25 maxlength 25 readonly {} class form_element" \
    -optional

element create $form_name delega_resp \
    -label   "Delega responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 50 $readonly_fld {} class form_element" \
    -optional

element create $form_name delega_manut \
    -label   "Delega manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 50 $readonly_fld {} class form_element" \
    -optional

if {$flag_portafoglio == "T"} {#sim63 if else e loro contenuto
    set readonly_riferimento_pag "readonly"
} else {
    set readonly_riferimento_pag $readonly_fld
}

#sim63 messo readonly_riferimento_pag al posto di riferimento_flg
element create $form_name riferimento_pag \
    -label   "Rif. n bollino" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_riferimento_pag {} class form_element" \
    -optional

element create $form_name costo \
    -label   "Costo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_costo {} class form_element" \
    -optional

element create $form_name data_prox_manut \
    -label   "Data prossima Manutenzione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional;#san04

if {$flag_portafoglio == "T"} {

    #    if {$funzione == "I"
    #	&& [db_0or1row sel_old_dimp ""] == 0} {
    #	element create $form_name tariffa_reg \
				   #	    -label   "Tipo costo" \
				   #	    -widget   select \
				   #	    -datatype text \
				   #	    -html    {onChange "document.coimdimp.__refreshing_p.value='1';document.coimdimp.submit.click()"} \
				   #	    -optional \
				   #	    -options { {{Contributo Regionale} 7} {{Prima accensione} 8}}
    #    } else {
    element create $form_name tariffa_reg \
	-label   "Tipo costo" \
	-widget   select \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options { {{Contributo Regionale} 7} {{Prima accensione} 8}}
    #    }
    element create $form_name importo_tariffa \
	-label   "Costo" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 readonly {} class form_element" \
	-optional
}

set l_of_l [db_list_of_lists sel_lol "select descrizione, cod_tipo_pag from coimtp_pag order by ordinamento"]
set options_cod_tp_pag [linsert $l_of_l 0 [list "" ""]]

#rom26if {$coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO" || $coimtgen(ente) eq "PPN") && $id_ruolo ==  "manutentore"} {};#san12 #san14 #sim48
if {($coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" || $coimtgen(ente) in [list "CANCONA" "PAN" "CJESI" "CSENIGALLIA" "CFANO"])
    && $id_ruolo ==  "manutentore"} {#rom26 aggiunta if ma non il contenuto
    set options_cod_tp_pag [db_list_of_lists sel_lol "select descrizione
                                                           , cod_tipo_pag 
                                                        from coimtp_pag 
                                                       where cod_tipo_pag = 'BO' order by ordinamento"]   
  
    if {($coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA" || $coimtgen(ente) eq "CFANO")} {;#san15 if e suo contenuto
	set options_cod_tp_pag [db_list_of_lists sel_lol "select descrizione
                                                           , cod_tipo_pag
                                                        from coimtp_pag
                                                       where cod_tipo_pag in('BO', 'ND') order by ordinamento"]         
    }

    #rom26if {($coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO" || $coimtgen(ente) eq "PPN")} {}#sim48
    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom26 aggiunta if ma non contenuto
	set options_cod_tp_pag [linsert $options_cod_tp_pag 0 [list "" ""]]
    }

}

if {$flag_combo_tipibol eq "T"} {#sim05 if e suo contenuto
    set options_cod_tp_pag [db_list_of_lists sel_lol "select descrizione, cod_tipo_pag from coimtp_pag where cod_tipo_pag = 'LM'"]
}

if {$coimtgen(regione) ne "MARCHE"} {
element create $form_name tipologia_costo \
    -label   "Tipo pagamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_cod_tp_pag

} else {
    element create $form_name tipologia_costo -widget hidden -datatype text -optional
    element set_properties $form_name tipologia_costo  -value "LM"
}

#modificato flag_pagato per regione marche
#if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunta if e suo contenuto
set onchange_flag_pagato "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='flag_pagato';document.$form_name.submit.click()"
if {$coimtgen(ente) eq "PPA"} {#rom24 Aggiunte if, else e loro contenuto
    set options_fl_pagato [list "{} {}" "S&igrave; S"]
    # {{{} {}} {S&igrave; S}}
} elseif {$flag_combo_tipibol eq "T" && $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom32 Aggiunta elseif e il suo contenuto
    set options_fl_pagato [list "S&igrave; S"]
} else {
    set options_fl_pagato [list "{} {}" "S&igrave; S" "{No, perchè non dovuto} N" "{No, per rifiuto del responsabile d'impianto a corrispondere il contributo} C"]
    #{{{} {}} {S&igrave; S} {"No, perchè non dovuto" N} {"No, per rifiuto del responsabile d'impianto a corrispondere il contributo" C}}
}
element create $form_name flag_pagato \
    -label   "Pagato" \
    -widget   select \
    -options  $options_fl_pagato\
    -datatype text \
    -html    "$disabled_flag_pagato_fld {} class form_element $onchange_flag_pagato" \
    -optional
#} else {
#element create $form_name flag_pagato \
#    -label   "Pagato" \
#    -widget   select \
#    -options  {{No N} {S&igrave; S}} \
#    -datatype text \
#    -html    "$disabled_fld {} class form_element" \
#    -optional
#}    

if {$id_ruolo ==  "manutentore"} {
    set data_scad_pagamento_readonly "readonly"
} else {
    set data_scad_pagamento_readonly $readonly_fld
}

element create $form_name data_scad_pagamento \
    -label   "Data scadenza pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $data_scad_pagamento_readonly {} class form_element" \
    -optional


element create $form_name scar_can_fu \
    -label   "scarico canna fumaria ramificata" \
    -widget   select \
    -options  {{S&igrave; S} {No N} {N.C. C} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tiraggio_fumi \
    -label   "Depressione canale da Fumo (Pa)" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name ora_inizio \
    -label   "Ora inizio" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
    -optional

element create $form_name ora_fine \
    -label   "Ora fine" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
    -optional

if {$id_ruolo ==  "manutentore"} {
    set data_scadenza_autocert_readonly "readonly"
} else {
    set data_scadenza_autocert_readonly $readonly_fld
}

element create $form_name data_scadenza_autocert \
    -label   "Data scad. autocert." \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $data_scadenza_autocert_readonly {} class form_element" \
    -optional

element create $form_name num_autocert \
    -label   "Numero autocertificazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_arrivo_ente \
    -label   "Data di arrivo all'ente" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional


element create $form_name prog_anom_max \
    -widget   hidden \
    -datatype text \
    -optional

element create $form_name tabella \
    -widget   hidden \
    -datatype text \
    -optional

element create $form_name cod_dimp_ins \
    -widget   hidden \
    -datatype text \
    -optional

set conta 0
multirow create multiple_form conta

while {$conta < 5} {
    incr conta

    multirow append multiple_form $conta

    element create $form_name prog_anom.$conta \
	-widget   hidden \
	-datatype text \
	-optional

    element create $form_name cod_anom.$conta \
	-label    "anomalia" \
	-widget   select \
	-datatype text \
	-html     "$disabled_fld {} class form_element" \
	-optional \
	-options [iter_selbox_from_table_wherec coimtano cod_tano "cod_tano||' - '||descr_breve" "" "where (flag_modello = 'S'
                                                                                                   or flag_modello is null)
                                                                                         and (data_fine_valid > current_date
                                                                                          or data_fine_valid is null)"]

    element create $form_name data_ut_int.$conta \
	-label    "data utile intervento" \
	-widget   text \
	-datatype text \
	-html     "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional 
}

if {$gen_prog eq ""} { #rom01 if, else e loro contenuto
    set num_prove_fumi [db_string query "select coalesce(num_prove_fumi,1)
                                           from coimgend
                                          where cod_impianto = :cod_impianto
                                            and flag_attivo  = 'S'
                                          limit 1" -default 1 ];#rom01
} else {
set num_prove_fumi [db_string query "select coalesce(num_prove_fumi,1)
                                       from coimgend 
                                      where cod_impianto = :cod_impianto 
                                        and gen_prog     = :gen_prog " -default 1];#rom01
};#rom01
set conta_prfumi 0;#rom01

multirow create multiple_form_prfumi conta_prfumi barra barra2;#rom01

while {$conta_prfumi < ($num_prove_fumi -1)} {;#rom01
    incr conta_prfumi
    if {$conta_prfumi > 9} {
	break
    }

    multirow append multiple_form_prfumi $conta_prfumi ""
    
   element create $form_name tiraggio_fumi.$conta_prfumi \
	-label   "Depressione canale da Fumo (Pa)" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name temp_fumi.$conta_prfumi \
	-label   "Temperatura fumi" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name temp_ambi.$conta_prfumi \
	-label   "Temperatura ambiente" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name o2.$conta_prfumi \
	-label   "o2" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name co2.$conta_prfumi \
	-label   "co2" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name bacharach.$conta_prfumi \
	-label   "Bacharach" \
	-widget   text \
	-datatype text \
	-html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name bacharach2.$conta_prfumi \
        -label   "Bacharach" \
        -widget   text \
        -datatype text \
	-html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
        -optional

    element create $form_name bacharach3.$conta_prfumi \
        -label   "Bacharach" \
        -widget   text \
        -datatype text \
        -html    "size 2 maxlength 2 $readonly_fld {} class form_element" \
	-optional

    element create $form_name portata_termica_effettiva.$conta_prfumi \
        -label   "Portata termica effettiva" \
        -widget   text \
        -datatype text \
        -html    "size 8 maxlength 12 $readonly_fld {} class form_element" \
        -optional


    element create $form_name portata_comb.$conta_prfumi \
        -label   "Portata combustibile" \
        -widget   text \
        -datatype text \
        -html    "size 8 maxlength 12 $readonly_fld {} class form_element" \
        -optional

    element create $form_name co.$conta_prfumi \
	-label   "co" \
	-widget   text \
	-datatype text \
	-html    "size 6 maxlength 14 $readonly_fld {} class form_element" \
	-optional
    #rom04
    element create $form_name co_fumi_secchi_ppm.$conta_prfumi \
        -label   "co_fumi_secchi_ppm" \
        -widget   text \
        -datatype text \
	-html    "size 6 maxlength 14 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name rend_combust.$conta_prfumi \
	-label   "Rendimento combustibile" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name rct_rend_min_legge.$conta_prfumi \
	-label   "Rendimento combustibile minimo" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
	-optional
    
element create $form_name rct_modulo_termico.$conta_prfumi \
	-label   "Modulo termico" \
	-widget   text \
	-datatype text \
	-html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
	-optional

    element create $form_name warning_co_corretto.$conta_prfumi \
	-label   "" \
	-widget   inform \
	-datatype text \
	-html    "$readonly_fld  {} class form_element" \
	-optional

}

if {$coimtgen(regione) eq "MARCHE"} {#sim58 if else e suo contenuto
    
    set disabled_fld_cod_tprc \{\}
    if {$funzione == "M" && $id_ruolo eq "manutentore"} {
            set disabled_fld_status "disabled"
    }

    set options_cod_tprc [db_list_of_lists sel_lol "select descr_tprc
                                                         , cod_tprc
                                                      from coimtprc"]
    append options_cod_tprc " [list \"\"]"
        
    set html_change_cod_tprc "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_tprc';document.$form_name.submit.click()"

    element create $form_name cod_tprc \
	-label   "Tipo controllo" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld_cod_tprc {} class form_element $html_change_cod_tprc" \
	-optional \
	-options  $options_cod_tprc

} else {
    element create $form_name cod_tprc -widget hidden -datatype text -optional
}

element create $form_name flag_tracciato   -widget hidden -datatype text -optional
element create $form_name list_anom_old    -widget hidden -datatype text -optional
element create $form_name cod_opma         -widget hidden -datatype text -optional
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name data_ins         -widget hidden -datatype text -optional
element create $form_name cod_dimp         -widget hidden -datatype text -optional
element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
#nic01 element create $form_name submitbut -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit";#nic01
element create $form_name last_cod_dimp    -widget hidden -datatype text -optional
element create $form_name cod_responsabile -widget hidden -datatype text -optional
element create $form_name cod_manutentore  -widget hidden -datatype text -optional
element create $form_name cod_opmanu_new   -widget hidden -datatype text -optional
element create $form_name cod_proprietario -widget hidden -datatype text -optional
element create $form_name cod_occupante    -widget hidden -datatype text -optional
element create $form_name url_list_aimp    -widget hidden -datatype text -optional
element create $form_name url_aimp         -widget hidden -datatype text -optional
element create $form_name url_gage         -widget hidden -datatype text -optional
element create $form_name flag_no_link     -widget hidden -datatype text -optional
element create $form_name flag_modifica    -widget hidden -datatype text -optional
element create $form_name cod_int_contr    -widget hidden -datatype text -optional
element create $form_name gen_prog         -widget hidden -datatype text -optional
element create $form_name flag_modello_h   -widget hidden -datatype text -optional
element create $form_name nome_funz_new    -widget hidden -datatype text -optional
element create $form_name nome_funz_gest   -widget hidden -datatype text -optional
element create $form_name flag_ins_prop    -widget hidden -datatype text -optional
element create $form_name flag_ins_occu    -widget hidden -datatype text -optional
element create $form_name __refreshing_p   -widget hidden -datatype text -optional
element create $form_name changed_field    -widget hidden -datatype text -optional;#nic01
element create $form_name locale           -widget hidden -datatype text -optional;#sim17
element create $form_name esente           -widget hidden -datatype text -optional;#sim19
element create $form_name is_warning_p     -widget hidden -datatype text -optional;#gac07
#element create $form_name warning_portata   -widget hidden -datatype text -optional
element set_properties $form_name is_warning_p      -value $is_warning_p;#gac07

element create $form_name warning_portata \
    -label   "" \
    -widget   inform \
    -datatype text \
    -html    "$readonly_fld {} class form_element" \
    -optional 

    element create $form_name warning_cont_rend \
	-label   "" \
	-widget   inform \
	-datatype text \
	-html    "$readonly_fld  {} class form_element" \
	-optional 

#gac07 aggiunto err_rcee perchè gli errori non devono piu essere mostrati sotto data controllo
if {$coimtgen(regione) eq "MARCHE"} {
    element create $form_name msg_rcee \
	-label   "" \
	-widget   inform \
	-datatype text \
	-html    "$readonly_fld  {} class form_element" \
	-optional
    
    element create $form_name err_rcee \
	-label   "" \
	-widget   inform \
	-datatype text \
	-html    "$readonly_fld  {} class form_element" \
	-optional

    
    element create $form_name warning_co_corretto \
	-label   "" \
	-widget   inform \
	-datatype text \
	-html    "$readonly_fld  {} class form_element" \
	-optional

    element create $form_name warning_dfm \
	-label   "" \
	-widget   inform \
	-datatype text \
	-html    "$readonly_fld  {} class form_element" \
	-optional
    
} else {
    element create $form_name err_rcee     -widget hidden -datatype text -optional;#gac07
    element create $form_name msg_rcee     -widget hidden -datatype text -optional;#gac07
#    element create $form_name warning_cont_rend -widget hidden -datatype text -optional;#gac07
    element create $form_name warning_co_corretto -widget hidden -datatype text -optional;#gac07
    element create $form_name warning_dfm -widget hidden -datatype text -optional;#gac11
}

set cod_manu [iter_check_uten_manu $id_utente]

if {[string range $id_utente 0 1] == "AM"} {
    set cod_manu $id_utente
}



if {$flag_portafoglio == "T"
    && ![string equal $cod_manu ""]} {
    #ricavo il portafoglio manutentore
    set url "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio"
    
    set data [iter_httpget_wallet $url]
    array set result $data
    #    ns_return 200 text/html "$result(page)"
    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
    if {$risultato == "OK"} {
	set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
	set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
	set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
    } else {
	set saldo ""
	set conto_manu ""
    }

    element set_properties $form_name saldo_manu  -value $saldo
    element set_properties $form_name cod_portafoglio  -value $conto_manu
} else {
    set saldo ""
}

set current_date [iter_set_sysdate]

if {$funzione != "I"
    &&  [db_0or1row sel_dimp_esito ""] != 0
} {
    switch $flag_status {
	"P" {set esit "Positivo"}
	"N" {set esit "<font color=red><b>Negativo</b></font>"}
	default {set esit ""}
    }
    set esito "Esito controllo: $esit"   
} else {
    set esito ""

}

set misura_co "(&\#037;)(ppm)"

set url_dimp        [list [ad_conn url]?[export_ns_set_vars url]]
set url_dimp        [export_url_vars url_dimp]    


element set_properties $form_name pot_ter_nom_tot_max -value $pot_ter_nom_tot_max;#gac07

if {$funzione != "I"} {
    # leggo riga
    if {[db_0or1row sel_dimp ""] == 0} {
	iter_return_complaint "Record non trovato"
    }

    set cod_potenza_old $cod_potenza;#sim08
    set potenza_old  [db_string q "select $nome_col_aimp_potenza 
                                     from coimaimp
                                    where cod_impianto=:cod_impianto"];#sim52 e sim53

} else {
    # valorizzo il default dei soggetti
    if {[db_0or1row sel_aimp_old ""] == 0} {
	iter_return_complaint "Impianto non trovato"
    }
}


#qui gacalin


set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
element set_properties $form_name nome_funz_new   -value $nome_funz_new
set nome_funz_gest [iter_get_nomefunz coimcitt-gest]
element set_properties $form_name nome_funz_gest  -value $nome_funz_gest

set flag_ins_prop "S"
set flag_modello_h "T"
element set_properties $form_name flag_modello_h  -value $flag_modello_h
element set_properties $form_name flag_ins_prop  -value $flag_ins_prop


if {$funzione == "I" || $funzione == "M"} {
    #link inserimento occupante
    # Questo non va perche' mancano i campi localita, ..., cod_comune.
    #set link_ins_occu [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occ nome nome_occ nome_funz nome_funz_new localita localita descr_via descr_via descr_topo descr_topo numero numero cap cap provincia provincia cod_comune cod_comune dummy cod_citt_occ] "Inserisci Sogg."]
    # Questo link funziona
    set link_ins_occu [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occu nome nome_occu nome_funz nome_funz_new dummy cod_occupante flag_ins_prop flag_ins_prop dummy flag_modello_h] "Inserisci Sogg."]

    #link inserimento proprietario
    set link_ins_prop [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_prop nome nome_prop nome_funz nome_funz_new dummy cod_proprietario flag_ins_prop flag_ins_prop dummy flag_modello_h] "Inserisci Sogg."]

    set link_gest_resp [iter_link_ins $form_name coimcitt-gest [list cod_cittadino cod_responsabile nome_funz nome_funz_gest flag_modello_h] "Gest."]
    set um "" ;#gac01
} else {
    set link_ins_occu ""
    set link_ins_prop ""
    set link_gest_resp ""
}


if {[form is_request $form_name]} {
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp    
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name last_cod_dimp    -value $last_cod_dimp
    element set_properties $form_name url_gage         -value $url_gage
    element set_properties $form_name flag_no_link     -value $flag_no_link
    element set_properties $form_name cod_opma         -value $cod_opma   
    element set_properties $form_name data_ins         -value $data_ins
    element set_properties $form_name gen_prog         -value $gen_prog;#nic02
    element set_properties $form_name flag_tracciato   -value $flag_tracciato
    element set_properties $form_name __refreshing_p   -value 0;#nic01
    element set_properties $form_name changed_field    -value "";#nic01

    element set_properties $form_name cod_tprc         -value $cod_tprc;#gac05 "CADALLE";#sim58
    element set_properties $form_name msg_rcee         -value "";#gac07 ATTENZIONE: confermando l'inserimento del REE applicherai anche il relativo segno identificativo."
    element set_properties $form_name err_rcee          -value "";#gac07
    element set_properties $form_name warning_cont_rend -value "";#gac07
    element set_properties $form_name warning_dfm       -value "";#gac11
    
    if {$cod_tprc eq "CADALLE"} {#gac05
	set flag_pagato S
    } else {
	set flag_pagato N
    }
    
    

    if {$funzione == "I"} {#nic02: aggiunto tutto questo blocco (copiato da coimdimp-f-gest)
	# gen_prog non e' mai valorizzato ad eccezione del caso in cui
	# non sia stata effettuata la scelta del generatore tramite
	# il programma coimcimp-gend-list qui sotto richiamato.
	if {[exists_and_not_null tabella]} {
	    set gen_prog [db_string query "select gen_prog from coimdimp where cod_dimp = :cod_dimp_ins"]
     	}

	# agg dob cind
	set cod_cind [db_string query "select max(cod_cind) from coimcind where stato = '1'" -default ""]  

    	if {[string equal $gen_prog ""]} {
	    # se esiste un solo generatore attivo, predispongo l'inserimento
	    # del rapporto di verifica relativo a tale generatore
     	    set ctr_gend 0
      	    db_foreach sel_gend_list "" {
      		incr ctr_gend
     	    }
	    # se ho un solo generatore ho gia' reperito gen_prog con la query
	    # se ne ho piu' di uno, invece richiamo coimdimp-gend-list
	    # per scegliere su quale generatore si vuole inserire il R.V.
	    # se non ho nessun generatore non posso inserire il R.V.
	    if {$ctr_gend == 1} {
		# gen_prog e' gia' stato valorizzato con sel_gend_list
    	    } else {
    		if {$ctr_gend > 1} {
		    # richiamo il programma che permette di scegliere gen_prog
		    set link_gend "flag_tracciato=R1&[export_url_vars cod_impianto last_cod_cimp nome_funz nome_funz_caller tabella cod_dimp extra_par caller url_aimp url_list_aimp]"
     		    ad_returnredirect [ad_conn package_url]src/coimdimp-gend-list?$link_gend
     		    ad_script_abort
		} else {
     		    iter_return_complaint "Non trovato nessun generatore attivo: inserirlo"
     		}
     	    }
     	}

        if {$coimtgen(regione) in [list "FRIULI-VENEZIA GIULIA"]} {#rom26 Aggiunta if e il suo contenuto
            if {[db_0or1row q "select 1
                                 from coimgend
                                where cod_impianto  = :cod_impianto
                                  and gen_prog      = :gen_prog
                                  and pot_utile_nom <= 10"]} {
                iter_return_complaint "Funzione impossibile per i generatori con potenza utile minore o uguale a 10 Kw."
                ad_script_abort
            }
        }

    };#nic02 (fine del blocco copiato da coimdimp-f-gest)


    #nic02 if {$funzione == "I"} {
    #nic02     set where_gen " and flag_attivo = 'S' limit 1"
    #nic02 } else {
    #nic02     set where_gen " and a.gen_prog = :gen_prog"
    #nic02 }

    if {$flag_mod_gend == "S"} {
	set sel_gend [db_map sel_gend_mod]
    } else {
	set sel_gend [db_map sel_gend_no_mod]
    }

    
    if {[db_0or1row sel_generatore $sel_gend] == 0} {
	set gend_zero        0
	set costruttore      ""
	set modello          ""
        set cod_mode         "";#nic01
	set matricola        ""
	set combustibile     ""
	set data_insta       ""
	set tiraggio         ""
	set destinazione     ""
	set tipo_a_c         ""
	set gen_prog         ""
        set locale           ""
        set data_costruz_gen ""
        set marc_effic_energ ""
        set volimetria_risc  ""
        set consumo_annuo    ""
	set consumo_annuo2   ""
	set stagione_risc    ""
	set stagione_risc2   ""
	set acquisti         "";#gac01
	set scorta_o_lett_iniz "";#gac01
        set scorta_o_lett_fin  "";#gac01
	set acquisti2        "";#gac01
        set scorta_o_lett_iniz2 "";#gac01
        set scorta_o_lett_fin2  "";#gac01
        set pot_focolare_nom ""
	set um               "";#gac01
	set elet_esercizio_1         "";#gac04
	set elet_esercizio_2         "";#gac04
	set elet_esercizio_3         "";#gac04
	set elet_esercizio_4         "";#gac04
	set elet_lettura_iniziale    "";#gac04
	set elet_lettura_finale      "";#gac04
	set elet_consumo_totale      "";#gac04
	set elet_lettura_iniziale_2  "";#gac04
	set elet_lettura_finale_2    "";#gac04
	set elet_consumo_totale_2    "";#gac04
	set flag_clima_invernale     "";#gac05
	set flag_prod_acqua_calda    "";#gac05
	set desc_grup_term           "";#gac08
	set descr_comb               "";#gac08
	set tipo_a_c_gen             "";#gac08
	set tiraggio_gen             "";#gac08
	set descr_cost               "";#gac08
	
    } else {
	element set_properties $form_name modello          -value $modello
	element set_properties $form_name matricola        -value $matricola

	if {$coimtgen(regione) eq "MARCHE"} {#gac08 aggiunta if else e contenuto di if
	    element set_properties $form_name descr_comb     -value $descr_comb
	    element set_properties $form_name desc_grup_term -value $desc_grup_term
	    element set_properties $form_name tiraggio_gen   -value $tiraggio_gen
	    element set_properties $form_name tipo_a_c_gen   -value $tipo_a_c_gen
	    element set_properties $form_name descr_cost     -value $descr_cost
	    element set_properties $form_name costruttore    -value $costruttore
            element set_properties $form_name combustibile   -value $combustibile
            element set_properties $form_name tiraggio         -value $tiraggio
	    element set_properties $form_name tipo_a_c         -value $tipo_a_c
	    element set_properties $form_name flag_clima_invernale_gen -value $flag_clima_invernale_gen
	    element set_properties $form_name flag_prod_acqua_calda_gen -value $flag_prod_acqua_calda_gen
	    element set_properties $form_name flag_clima_invernale -value $flag_clima_invernale
	    element set_properties $form_name flag_prod_acqua_calda -value $flag_prod_acqua_calda
	} else {#gac08
	    element set_properties $form_name combustibile     -value $combustibile
	    element set_properties $form_name tiraggio         -value $tiraggio
	    element set_properties $form_name tipo_a_c         -value $tipo_a_c
	    element set_properties $form_name costruttore      -value $costruttore
	    element set_properties $form_name flag_clima_invernale -value $flag_clima_invernale
	    element set_properties $form_name flag_prod_acqua_calda -value $flag_prod_acqua_calda
	};#gac08

	element set_properties $form_name data_insta       -value $data_insta
	element set_properties $form_name destinazione     -value $destinazione
	element set_properties $form_name gen_prog         -value $gen_prog       
        element set_properties $form_name locale           -value $locale
        element set_properties $form_name data_costruz_gen -value $data_costruz_gen
        element set_properties $form_name marc_effic_energ -value $marc_effic_energ
        element set_properties $form_name volimetria_risc  -value $volimetria_risc
        #Sandro ha detto di lasciare sempre vuoto il consumo annuo e farlo compilare dall'utente
	#sim element set_properties $form_name consumo_annuo    -value $consumo_annuo
	element set_properties $form_name pot_focolare_nom -value $pot_focolare_nom


	if {$tipo_combustibile ne "L"} {
	    element set_properties $form_name rct_assenza_per_comb -value "C"
	    element set_properties $form_name rct_assenza_per_comb -after_html "<br>*Verificare le perdite di combustibile nel tratto<br> visibile delle tubazioni di adduzione"
	}
	
	if {$tipo_combustibile ne "G"} {
	    element set_properties $form_name rct_idonea_tenuta -value "C"
	}

        # Imposto ora le options di cod_mode perchè solo adesso ho a disposiz. la var. costruttore
	if {![string is space $costruttore]} {
	    element set_properties $form_name cod_mode     -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $costruttore]'" cod_mode descr_mode];#nic01
	}
        element set_properties $form_name cod_mode         -value $cod_mode;#nic01
    }

    if {$combustibile eq "12" || 
	$combustibile eq "6"  ||
	$combustibile eq "0"  ||
	$combustibile eq "2"} {#mis01                         
	set conbustibile_solido "S"
    } else {
	set conbustibile_solido "N"
    }

    set descr_combustibile [db_string query "select descr_comb from coimcomb where cod_combustibile = :combustibile" -default ""];#--- mis01 estratta descrizione e modificata condizione sotto (origine && $cobustibile=="GASOLIO")
    set tipo_comb [db_string query "select tipo from coimcomb where cod_combustibile = :combustibile" -default ""]

    #gac01 aggiunta variabile unità di misura che viene valorrizzata a seconda del tipo di combustibile
    set um [db_string q "select um from coimcomb where cod_combustibile = :combustibile" -default ""]
   
    #ns_log notice "bubu1|$data_insta|"
    #ns_return 200 text/html "$tiraggio, $data_insta" ; return
    if {$funzione == "I"} {
	# valorizzo alcuni default
	
	#Calcolo, se possibile, il valore del rendimento minimo per il generatore in questione
	set rendimento_minimo "";#sim11
	set rendimento_min_notice "<font color=green>Rend.to min. calcolato<br>automaticamente</font>";#sim11
	
	with_catch msg_errore {;#sim11: aggiunta witch_catch e suo contenuto (non togliere il ; prima di questo commento, altrimenti va in errore
	    set rendimento_minimo [iter_calc_rend $cod_impianto $gen_prog]
	} {
	    set rendimento_min_notice $msg_errore
	}
	
	#gac09 rct_modulo_termico deve essere il numero del generatore e non un progressivo prova fumi
	db_0or1row q "select gen_prog_est 
                        from coimgend g
                       where cod_impianto = :cod_impianto 
                         and gen_prog = :gen_prog"

	element set_properties $form_name rct_modulo_termico -value 1;#gac03
#        element set_properties $form_name rct_modulo_termico -value $gen_prog_est;#gac09
	element set_properties $form_name rct_rend_min_legge -value $rendimento_minimo;#sim11 
	element::set_error     $form_name rct_rend_min_legge $rendimento_min_notice;#sim1
	
	set conta_prfumi 0;#rom01
	
	while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
	    incr conta_prfumi
	    if {$conta_prfumi > 9} {
		break
	    }
	    set conta_moduli [expr $conta_prfumi + 1]
	    element set_properties $form_name rct_rend_min_legge.$conta_prfumi -value $rendimento_minimo
	    element::set_error     $form_name rct_rend_min_legge.$conta_prfumi $rendimento_min_notice
	    element set_properties $form_name rct_modulo_termico.$conta_prfumi -value $conta_moduli;#gac03
#            element set_properties $form_name rct_modulo_termico.$conta_prfumi -value $gen_prog_est;#gac09	    
	}
	
	
	#sim19 spostato qui il flag_status
	# di default esito_verifica Positivo
	set flag_status "P"
	element set_properties $form_name flag_status      -value $flag_status
	

	# valorizzo data controllo con data_prevista del controllo
	# se richiamato da coimgage-gest
	if {[db_0or1row sel_gage ""] == 0} {
	    if {![string is space $cod_opma]} {
		iter_return_complaint "Controllo manutentore non trovato"
	    } else {
		set data_prevista ""
	    }
	}
	set data_controllo $data_prevista

	# valorizzo il default dei soggetti
	if {[db_0or1row sel_aimp_old ""] == 0} {
	    iter_return_complaint "Impianto non trovato"
	}

	set potenza_old_edit [iter_edit_num $potenza_old 2]
	# valorizzo la tariffa di default in base alla potenza dell'impianto

	# imposto il codice listino a 0 perche' per ora il listino destinato ai costi 
        # e' il listino con codice 0 (zero) se in futuro ci sara' una diversificazione
        # sara' da creare una function o una procedura che renda dinamico il codice_listino
	set cod_listino 0

	# agg dob cind
	set cod_cind [db_string query "select max(cod_cind) from coimcind where stato = '1'" -default ""]  

	eval $controllo_tariffa;#sim08

	if {$flag_portafoglio == "T"} {
	    if {[db_0or1row sel_tari_contributo ""] == 0} {
		#san05 set importo_tariffa ""
		set importo_tariffa "0";#san05
		set tariffa_reg ""
	    } else {
		set tariffa_reg "7"
	    }
	}

	set cod_manu [iter_check_uten_manu $id_utente]
	if {[string range $id_utente 0 1] == "AM"} {
	    set cod_manu $id_utente
	}

	if {$flag_portafoglio == "T"
	    && ![string equal $cod_manutentore_old ""]} {
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio"
	    } else {
		set url "lotto/balance?iter_code=$cod_manutentore_old&ente_portafoglio=$ente_portafoglio"
	    }	    
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #	        ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]

		db_1row sel_limiti_tgen "select flag_limite_portaf, valore_limite_portaf from coimtgen"
		if {$flag_limite_portaf == "S"} {
		    if {[iter_check_num $saldo 2] < $valore_limite_portaf} {
			set msg_limite "Attenzione - Il credito residuo disponibile sul tuo Portafoglio sta per terminare. Prima di completare l'inserimento delle dichiarazioni controlla l'importo necessario per il contributo. Se il credito residuo risulta insufficiente la dichiarazione non verr&agrave; accettata."
		    }
		}
	    } else {
		set saldo ""
		set conto_manu ""
	    }

	    element set_properties $form_name saldo_manu  -value $saldo
	    element set_properties $form_name cod_portafoglio  -value $conto_manu
	} else {
	    set saldo ""
	}

	if {$coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]]} {
	    set tipologia_costo ""
	    set flag_pagato ""
	    set costo 0
	} else {
	    set tipologia_costo "BO"
	    set flag_pagato ""
	}

	element set_properties $form_name data_controllo   -value $data_controllo
#	element set_properties $form_name data_ultima_manu -value $data_ultima_manu
	element set_properties $form_name cod_manutentore  -value $cod_manutentore_old
	element set_properties $form_name cognome_manu     -value $cognome_manu_old
	element set_properties $form_name nome_manu        -value $nome_manu_old
	element set_properties $form_name cod_responsabile -value $cod_responsabile_old
	element set_properties $form_name cognome_resp     -value $cognome_resp_old
	element set_properties $form_name nome_resp        -value $nome_resp_old
	element set_properties $form_name cod_proprietario -value $cod_proprietario_old
	element set_properties $form_name cognome_prop     -value $cognome_prop_old
	element set_properties $form_name nome_prop        -value $nome_prop_old
	element set_properties $form_name cod_occupante    -value $cod_occupante_old
	element set_properties $form_name cognome_occu     -value $cognome_occu_old
	element set_properties $form_name nome_occu        -value $nome_occu_old
	element set_properties $form_name cod_fiscale_resp -value $cod_fiscale_resp_old
        element set_properties $form_name cod_int_contr    -value $cod_int_contr_old
        element set_properties $form_name nome_contr       -value $nome_contr_old
        element set_properties $form_name cognome_contr    -value $cognome_contr_old
	element set_properties $form_name locale           -value $locale;#sim17

	if {$coimtgen(regione) eq "MARCHE"} {#rom12 if e contenuto
	    if {![string equal $cod_manu ""]} {
		set cod_manutentore_stru $cod_manu
	    } else {

		set cod_manutentore_stru [db_string q "select cod_manutentore 
                                                         from coimmanu
                                                        where cod_manutentore = :cod_manutentore_old" -default ""]
	    }

	   
		element set_properties $form_name cod_strumento_01 -options [iter_selbox_from_table_wherec coimstru_manu  coimmanu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '0' and is_active_p = 'f'"] 
		
		element set_properties $form_name cod_strumento_02 -options [iter_selbox_from_table_wherec coimstru_manu  coimmanu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '1' and is_active_p = 'f'"]
	}
	
	
	if {$flag_portafoglio == "T"} {
	    element set_properties $form_name importo_tariffa   -value $importo_tariffa
	    element set_properties $form_name tariffa_reg       -value $tariffa_reg
	}

	element set_properties $form_name costo            -value $tariffa

#rom26	if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {#nic04: aggiunta questa if ed il suo contenuto (copiandola da coimdimp-f-gest di Udine)
#rom26	    db_1row query "select potenza from coimaimp where cod_impianto = :cod_impianto"
#rom26	    db_1row query "select count(*) as num_gend_attivi from coimgend where cod_impianto = :cod_impianto and flag_attivo = 'S'"
#rom26	    set dt_recente [db_string query "select to_char(current_date - interval '4 months', 'yyyymmdd')"]
#rom26	    db_1row query "select count(*) as num_dich_recenti from coimdimp where cod_impianto = :cod_impianto and data_controllo > :dt_recente"
#rom26	    ns_log Notice "coimdimp-rct-gest 1.1;potenza:$potenza|num_gend_attivi:$num_gend_attivi|num_dich_recedenti:$num_dich_recenti|cod_impianto:$cod_impianto|dt_recente:$dt_recente|"
#rom26	    if {$potenza > 350 && $num_gend_attivi > 1 && $num_dich_recenti > 1} {
#rom26		set costo "26,22"
#rom26		element set_properties $form_name costo    -value $costo
#rom26	    }
#rom26	};#nic04

	element set_properties $form_name tipologia_costo  -value $tipologia_costo

	if {$flag_combo_tipibol eq "T" && $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && $flag_pagato ne "N"} {#rom26 aggiunta if e suo contenuto
            element set_properties $form_name flag_pagato      -options {{S&igrave; S}}
        } else {#rom26 aggiunta else ma non il contenuto
	    element set_properties $form_name flag_pagato      -value $flag_pagato
	}
#nic03	element set_properties $form_name potenza          -value $potenza_old_edit
        element set_properties $form_name potenza          -value $pot_utile_nom;#nic03
 	element set_properties $form_name cod_int_contr    -value $cod_int_contr_old
	element set_properties $form_name tabella          -value $tabella
	element set_properties $form_name cod_dimp_ins     -value $cod_dimp_ins
	# agg dob cind
	element set_properties $form_name cod_cind         -value $cod_cind

	db_1row sel_tgen_cont "select flag_default_contr_fumi from coimtgen"
	if {$flag_default_contr_fumi == "S"} {
	    element set_properties $form_name cont_rend    -value "S"
	    set cont_rend "S";#mis01
	} else {
	    element set_properties $form_name cont_rend    -value "N"
	    set cont_rend "N";#mis01
	}

	set conta 0
	while {$conta < 5} {
	    incr conta
	    element set_properties $form_name prog_anom.$conta -value $conta
	}

	if {$coimtgen(regione) eq "MARCHE"} {#gac02
	    set cod_tprc "";#gac02
	    element set_properties $form_name cod_tprc -value $cod_tprc;#gac02
	}

	set flag_pagato_dimp "";#gac02
	element set_properties $form_name flag_pagato -value $flag_pagato_dimp

	
    } else {

	# leggo riga
	set cod_docu_distinta ""
	if {[db_0or1row sel_dimp ""] == 0} {
	    iter_return_complaint "Record non trovato"
	}

	# leggo aimp per dati progettista
	#	if {[db_0or1row sel_aimp ""] == 0} {
	#	    iter_return_complaint "Impianto non trovato"
	#	}

	# la query seguente e' temporanea e puo' essere tolta
	#db_1row query "select cod_fiscale as cod_fiscale_resp from coimcitt where cod_cittadino = :cod_responsabile "


	if {[iter_check_date $data_controllo] < "20080801"} {
	    set message "<td><table border=2 cellspacing=0 cellpadding=2 bordercolor=red><tr><td nowrap>Importo non dovuto data controllo antecedente 01/08/2008</td></tr></table></td>"
	} else {
	    set message "<td>&nbsp;</td>"
	}

 	set cod_manu [iter_check_uten_manu $id_utente]
	if {[string equal $cod_manu ""]} {
	    set cod_manu $cod_manutentore
	}
	if {[string range $id_utente 0 1] == "AM"} {
	    set cod_manu $id_utente
	}
	if {$flag_portafoglio == "T"
	    && ![string equal $cod_manu ""]} {
	    #ricavo il portafoglio manutentore
	    set url "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio"
	    
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #    ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
	    } else {
		set saldo ""
		set conto_manu ""
	    }

	    element set_properties $form_name saldo_manu  -value $saldo
	    element set_properties $form_name cod_portafoglio  -value $conto_manu
	} else {
	    set saldo ""
	}
	
	set data_scad_mod [clock format [clock scan "$data_ins $flag_gg_modif_mh day"] -f %Y%m%d]

	set cod_man [iter_check_uten_manu $id_utente]
	#rom32 Aggiunta condizione su Regione Friuli
	if {(![string equal $cod_man ""] || $id_settore == "regione") &&
	$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {
	    if {$data_scad_mod < $current_date || ![string equal $cod_docu_distinta ""]} {
		set flag_modifica "F"
	    } else {
		set flag_modifica "T"
	    }
	} else {
	    set flag_modifica "T"
	}

	if {![string equal $cod_man ""] &&
	    [db_0or1row q "select 1
                             from coimdimp
                            where cod_dimp         = :cod_dimp
                              and cod_manutentore != :cod_man"]} {#rom36 Aggiunta if e il suo contenuto
	    set flag_modifica "F"
	}
	
	if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunta if, else e contenuto di else 
	    if {$flag_co_perc == "t"} {
		set co [expr $co / 10000.0000]
		set misura_co "(&\#037;)"
		set co [iter_edit_num $co 4]
	    } else {
		set misura_co "(ppm)"
		set co [iter_edit_num $co 0]
	    }
	} else {#gac07 
	    if {$flag_co_perc == "t"} {
		set co [expr $co / 10000.00]
		set misura_co "(&\#037;)"
		set co [iter_edit_num $co 2]
	    } else {
		set misura_co "(ppm)"
		set co [iter_edit_num $co 2]
	    }
	}
	
	if {$funzione == "M"} {
	    set misura_co "(&\#037;)(ppm)"
	}

	element set_properties $form_name flag_status      -value $flag_status

	if {($coimtgen(regione) eq "CALABRIA") && $flag_status eq "N"} {#mis01 if else e loro contenuto
	    set esente "t"
	} else {
	    set esente "f"
	}
	
	element set_properties $form_name cod_dimp         -value $cod_dimp
	element set_properties $form_name cod_impianto     -value $cod_impianto
	element set_properties $form_name data_controllo   -value $data_controllo
	element set_properties $form_name data_ultima_manu -value $data_ultima_manu;#gac07
	element set_properties $form_name cod_manutentore  -value $cod_manutentore
	element set_properties $form_name cod_opmanu_new   -value $cod_opmanu_new
	element set_properties $form_name cod_responsabile -value $cod_responsabile
	element set_properties $form_name garanzia         -value $garanzia
	element set_properties $form_name conformita       -value $conformita
	element set_properties $form_name lib_impianto     -value $lib_impianto
	element set_properties $form_name lib_uso_man      -value $lib_uso_man
	element set_properties $form_name rct_lib_uso_man_comp    -value $rct_lib_uso_man_comp
	element set_properties $form_name inst_in_out      -value $inst_in_out
	element set_properties $form_name idoneita_locale  -value $idoneita_locale
	element set_properties $form_name ap_ventilaz      -value $ap_ventilaz
	element set_properties $form_name ap_vent_ostruz   -value $ap_vent_ostruz
	element set_properties $form_name pendenza         -value $pendenza
	element set_properties $form_name sezioni          -value $sezioni
	element set_properties $form_name curve            -value $curve
	element set_properties $form_name lunghezza        -value $lunghezza
	element set_properties $form_name conservazione    -value $conservazione
	element set_properties $form_name scar_ca_si       -value $scar_ca_si
	element set_properties $form_name scar_parete      -value $scar_parete
	element set_properties $form_name riflussi_locale  -value $riflussi_locale
	element set_properties $form_name assenza_perdite  -value $assenza_perdite
	element set_properties $form_name pulizia_ugelli   -value $pulizia_ugelli
	element set_properties $form_name antivento        -value $antivento
	element set_properties $form_name scambiatore      -value $scambiatore
	element set_properties $form_name accens_reg       -value $accens_reg
	element set_properties $form_name disp_comando     -value $disp_comando
	element set_properties $form_name ass_perdite      -value $ass_perdite
	element set_properties $form_name valvola_sicur    -value $valvola_sicur
	element set_properties $form_name vaso_esp         -value $vaso_esp
	element set_properties $form_name disp_sic_manom   -value $disp_sic_manom
	element set_properties $form_name organi_integri   -value $organi_integri
	element set_properties $form_name circ_aria        -value $circ_aria
	element set_properties $form_name guarn_accop      -value $guarn_accop
	element set_properties $form_name assenza_fughe    -value $assenza_fughe
	element set_properties $form_name coibentazione    -value $coibentazione
	element set_properties $form_name eff_evac_fum     -value $eff_evac_fum
	element set_properties $form_name cont_rend        -value $cont_rend
	element set_properties $form_name pot_focolare_mis -value $pot_focolare_mis
	element set_properties $form_name portata_comb_mis -value $portata_comb_mis
	element set_properties $form_name temp_fumi        -value $temp_fumi
	element set_properties $form_name temp_ambi        -value $temp_ambi
	element set_properties $form_name o2               -value $o2
	element set_properties $form_name co2              -value $co2
	element set_properties $form_name bacharach        -value $bacharach
        element set_properties $form_name bacharach2       -value $bacharach2                         ;#gac02
        element set_properties $form_name bacharach3       -value $bacharach3                         ;#gac02
	element set_properties $form_name portata_comb     -value $portata_comb                       ;#gac02
        element set_properties $form_name rispetta_indice_bacharach -value $rispetta_indice_bacharach ;#gac02
        element set_properties $form_name co_fumi_secchi   -value $co_fumi_secchi                     ;#gac02
        element set_properties $form_name rend_magg_o_ugua_rend_min -value $rend_magg_o_ugua_rend_min ;#gac02
	element set_properties $form_name portata_termica_effettiva -value $portata_termica_effettiva ;#gac03
	element set_properties $form_name co               -value $co
        element set_properties $form_name co_fumi_secchi_ppm  -value $co_fumi_secchi_ppm
	element set_properties $form_name rend_combust     -value $rend_combust
	element set_properties $form_name osservazioni     -value $osservazioni
	element set_properties $form_name raccomandazioni  -value $raccomandazioni
	element set_properties $form_name prescrizioni     -value $prescrizioni
	element set_properties $form_name data_utile_inter -value $data_utile_inter
	element set_properties $form_name n_prot           -value $n_prot
	element set_properties $form_name data_prot        -value $data_prot
	element set_properties $form_name delega_resp      -value $delega_resp
	element set_properties $form_name delega_manut     -value $delega_manut
	element set_properties $form_name cognome_manu     -value $cognome_manu
	element set_properties $form_name cognome_opma     -value $cognome_opma
	element set_properties $form_name cognome_resp     -value $cognome_resp
	element set_properties $form_name nome_manu        -value $nome_manu
	element set_properties $form_name nome_opma        -value $nome_opma
	element set_properties $form_name nome_resp        -value $nome_resp
	element set_properties $form_name cod_fiscale_resp -value $cod_fiscale_resp
	element set_properties $form_name cod_proprietario -value $cod_proprietario
	element set_properties $form_name cod_occupante    -value $cod_occupante
	element set_properties $form_name cognome_prop     -value $cognome_prop
	element set_properties $form_name cognome_occu     -value $cognome_occu
	element set_properties $form_name nome_prop        -value $nome_prop
	element set_properties $form_name nome_occu        -value $nome_occu
	if {$flag_portafoglio == "T"} {
	    element set_properties $form_name importo_tariffa -value $importo_tariffa
	    element set_properties $form_name tariffa_reg     -value $tariffa_reg
	}
	element set_properties $form_name costo            -value $costo
	element set_properties $form_name tipologia_costo  -value $tipologia_costo
	element set_properties $form_name riferimento_pag  -value $riferimento_pag
	element set_properties $form_name data_scad_pagamento -value $data_scad
	#if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunta if e suo contenuto
	if {$flag_combo_tipibol eq "T" && $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom32 aggiunta if e suo contenuto
	    element set_properties $form_name flag_pagato      -options {{S&igrave; S}}
	     element set_properties $form_name flag_pagato -value "S"
        } else {#rom32 aggiunta else ma non il contenuto

	    element set_properties $form_name flag_pagato      -value $flag_pagato_dimp
	};#rom32
	#} else {
	#    element set_properties $form_name flag_pagato      -value $flag_pagato
	#}
	element set_properties $form_name potenza          -value $potenza
	element set_properties $form_name cod_int_contr    -value $cod_int_contr
	element set_properties $form_name nome_contr       -value $nome_contr
	element set_properties $form_name cognome_contr    -value $cognome_contr
	element set_properties $form_name scar_can_fu      -value $scar_can_fu  
	element set_properties $form_name tiraggio_fumi    -value $tiraggio_fumi     
	element set_properties $form_name ora_inizio       -value $ora_inizio   
	element set_properties $form_name ora_fine         -value $ora_fine     
	element set_properties $form_name data_scadenza_autocert  -value $data_scadenza_autocert
	element set_properties $form_name num_autocert     -value $num_autocert 
	element set_properties $form_name volimetria_risc  -value $volimetria_risc 
	element set_properties $form_name consumo_annuo    -value $consumo_annuo
	element set_properties $form_name consumo_annuo2   -value $consumo_annuo2
	element set_properties $form_name stagione_risc    -value $stagione_risc
	element set_properties $form_name stagione_risc2   -value $stagione_risc2
	element set_properties $form_name acquisti         -value $acquisti ;#gac01
	element set_properties $form_name scorta_o_lett_iniz -value $scorta_o_lett_iniz ;#gac01
        element set_properties $form_name scorta_o_lett_fin  -value $scorta_o_lett_fin  ;#gac01
	element set_properties $form_name acquisti2         -value $acquisti2 ;#gac01
        element set_properties $form_name scorta_o_lett_iniz2 -value $scorta_o_lett_iniz2 ;#gac01
        element set_properties $form_name scorta_o_lett_fin2  -value $scorta_o_lett_fin2  ;#gac01
	element set_properties $form_name data_arrivo_ente -value $data_arrivo_ente
	element set_properties $form_name tabella          -value $tabella
	element set_properties $form_name cod_dimp_ins     -value $cod_dimp_ins
	element set_properties $form_name rct_dur_acqua    -value $rct_dur_acqua
	element set_properties $form_name rct_tratt_in_risc         -value $rct_tratt_in_risc
	element set_properties $form_name rct_tratt_in_acs          -value $rct_tratt_in_acs
	element set_properties $form_name rct_install_interna       -value $rct_install_interna
	element set_properties $form_name rct_install_esterna       -value  $rct_install_esterna
	element set_properties $form_name rct_canale_fumo_idoneo    -value $rct_canale_fumo_idoneo
	element set_properties $form_name rct_sistema_reg_temp_amb  -value $rct_sistema_reg_temp_amb
	element set_properties $form_name rct_assenza_per_comb      -value $rct_assenza_per_comb
	element set_properties $form_name rct_idonea_tenuta         -value $rct_idonea_tenuta
	element set_properties $form_name rct_valv_sicurezza        -value $rct_valv_sicurezza
	element set_properties $form_name rct_scambiatore_lato_fumi -value $rct_scambiatore_lato_fumi
	element set_properties $form_name rct_riflussi_comb   -value $rct_riflussi_comb
	element set_properties $form_name rct_uni_10389       -value $rct_uni_10389
	element set_properties $form_name rct_rend_min_legge  -value $rct_rend_min_legge	
	element set_properties $form_name rct_modulo_termico  -value $rct_modulo_termico
	element set_properties $form_name rct_check_list_1    -value $rct_check_list_1
	element set_properties $form_name rct_check_list_2    -value $rct_check_list_2
	element set_properties $form_name rct_check_list_3    -value $rct_check_list_3
	element set_properties $form_name rct_check_list_4    -value $rct_check_list_4
	element set_properties $form_name rct_gruppo_termico  -value $rct_gruppo_termico
	element set_properties $form_name data_prox_manut     -value $data_prox_manut;#san04

	if {$flag_combo_tipibol eq "T" && $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" && $flag_pagato ne "N"} {#rom32 aggiunta if e suo contenuto
	    element set_properties $form_name flag_pagato      -options {{S&igrave; S}}
	    element set_properties $form_name flag_pagato      -value "S"
	}

        element set_properties $form_name locale              -value $locale;#sim17
	element set_properties $form_name cod_tprc            -value $cod_tprc;#sim58
	element set_properties $form_name elet_esercizio_1        -value $elet_esercizio_1        ;#gac04
	element set_properties $form_name elet_esercizio_2        -value $elet_esercizio_2        ;#gac04
	element set_properties $form_name elet_esercizio_3        -value $elet_esercizio_3        ;#gac04
	element set_properties $form_name elet_esercizio_4        -value $elet_esercizio_4        ;#gac04
	element set_properties $form_name elet_lettura_iniziale   -value $elet_lettura_iniziale   ;#gac04
	element set_properties $form_name elet_lettura_finale     -value $elet_lettura_finale     ;#gac04
	element set_properties $form_name elet_consumo_totale     -value $elet_consumo_totale     ;#gac04
	element set_properties $form_name elet_lettura_iniziale_2 -value $elet_lettura_iniziale_2 ;#gac04
	element set_properties $form_name elet_lettura_finale_2   -value $elet_lettura_finale_2   ;#gac04
	element set_properties $form_name elet_consumo_totale_2   -value $elet_consumo_totale_2   ;#gac04
	element set_properties $form_name combustibile_dimp       -value $combustibile_dimp       ;#rom17
	element set_properties $form_name unita_misura_consumi    -value $unita_misura_consumi    ;#rom18
	element set_properties $form_name cod_strumento_01        -value $cod_strumento_01        ;#gac06
        element set_properties $form_name cod_strumento_02        -value $cod_strumento_02        ;#gac06
		
	if {$coimtgen(regione) eq "MARCHE"} {#rom12 if e contenuto
	    element set_properties $form_name cod_strumento_01 -options [iter_selbox_from_table_wherec coimstru_manu  cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore' and tipo_strum = '0' and is_active_p ='f'"] 
		
	    element set_properties $form_name cod_strumento_02 -options [iter_selbox_from_table_wherec coimstru_manu
									 cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore' and tipo_strum = '1' and is_active_p ='f'"]

	}
	
	#gac07 aggiunta if e suo contenuto, devo fare il calcolo del valore corretto dei fumi secchi,
	#gac07 che non deve discostarsi di +- 1% dal co corretto calcolato ; controllo non bloccante 
	#sim78 come indicato dalla Regione la tolleranza passa da 1% a 5%
	if {$coimtgen(regione) eq "MARCHE"} {
	    #rom10 aggiunta condizione su o2 < di 21 
	    if {$co_fumi_secchi_ppm  ne "" && $o2 ne "" && $o2 < "21.00"} {
 		set co_corretto [expr (21 / (21 - [iter_check_num $o2 2])) * [iter_check_num $co_fumi_secchi_ppm 2]]
 		#sim78 set co_perc_inf [expr $co_corretto - ($co_corretto * 1 / 100)]
 		#sim78 set co_perc_sup [expr $co_corretto + ($co_corretto * 1 / 100)]
		set co_perc_inf [expr $co_corretto - ($co_corretto * 5 / 100)];#sim78
 		set co_perc_sup [expr $co_corretto + ($co_corretto * 5 / 100)];#sim78

 		if {[iter_check_num $co 2] < $co_perc_inf || [iter_check_num $co 2] > $co_perc_sup} {
 		    element set_properties $form_name warning_co_corretto -value "<font color=blue><b>Attenzione: Valori di CO fumi secchi e CO corretto incoerenti</b></font>"
 		} else {
 		    element set_properties $form_name warning_co_corretto -value ""
 		}
 	    }
	}
	

	
    
	# agg dob cind
	element set_properties $form_name cod_cind            -value $cod_cind

	set nome_utente_ins ""
        set data_ins_edit ""
	if {$utente_ins ne ""} {
	    db_1row sel_utente_ins ""
	}
	if {$data_ins ne ""} {
	    db_1row sel_edit_data "select iter_edit_data(:data_ins) as data_ins_edit"
	}
	
	set conta     0
	set prog_anom 0
	set list_anom_old [list]
	db_foreach sel_anom "" {
	    incr conta
	    lappend list_anom_old $cod_tanom
	    element set_properties $form_name prog_anom.$conta   -value $prog_anom
	    element set_properties $form_name cod_anom.$conta    -value $cod_tanom
	    element set_properties $form_name data_ut_int.$conta -value $dat_utile_inter
	}
	element set_properties $form_name prog_anom_max -value $prog_anom
	element set_properties $form_name list_anom_old -value $list_anom_old
	element set_properties $form_name flag_modifica -value $flag_modifica

	if {$pot_focolare_nom ne ""} {
	    set potenza_da_calc [iter_check_num $pot_focolare_nom 2];#gac07 modificato potenza con pot_focolare_nom
	    set pot_utile_nom_perc [expr $potenza_da_calc * 10.00/100.00]
	    set pot_utile_nom_calc [expr $potenza_da_calc + $pot_utile_nom_perc]
	} else {
	    set potenza_da_calc    0
	    set pot_utile_nom_perc 0
	    set pot_utile_nom_calc 0
	}
	set conta_prfumi 0;#rom01
	db_foreach a "select iter_edit_num(tiraggio, 2) as tiraggio_fumi
                           , iter_edit_num(temp_fumi, 2) as temp_fumi
                           , iter_edit_num(temp_ambi, 2) as temp_ambi
                           , iter_edit_num(o2, 2) as o2      
                           , iter_edit_num(co2, 2) as co2     
                           , iter_edit_num(bacharach, 0) as bacharach
                           , co
                           , iter_edit_num(co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm --rom04       
                           , iter_edit_num(rend_combust, 2) as rend_combust
                           , iter_edit_num(rct_rend_min_legge, 2) as rct_rend_min_legge
                           , rct_modulo_termico
                           , iter_edit_num(bacharach2, 0) as bacharach2      --gac02
                           , iter_edit_num(bacharach3, 0) as bacharach3      --gac02
                           , iter_edit_num(portata_comb, 2) as portata_comb  --gac02
                           , iter_edit_num(portata_termica_effettiva, 2) as portata_termica_effettiva_prfumi --gac03
                        from coimdimp_prfumi
                       where cod_dimp = :cod_dimp
        " {#rom1
	  
	    incr conta_prfumi

	    element set_properties $form_name tiraggio_fumi.$conta_prfumi      -value $tiraggio_fumi
     	    element set_properties $form_name temp_fumi.$conta_prfumi          -value $temp_fumi
	    element set_properties $form_name temp_ambi.$conta_prfumi          -value $temp_ambi
	    element set_properties $form_name o2.$conta_prfumi                 -value $o2
	    element set_properties $form_name co2.$conta_prfumi                -value $co2
	    element set_properties $form_name bacharach.$conta_prfumi          -value $bacharach
	    element set_properties $form_name bacharach2.$conta_prfumi         -value $bacharach2   ;#gac02
	    element set_properties $form_name bacharach3.$conta_prfumi         -value $bacharach3   ;#gac02
	    element set_properties $form_name portata_comb.$conta_prfumi       -value $portata_comb ;#gac02
	    element set_properties $form_name portata_termica_effettiva.$conta_prfumi -value $portata_termica_effettiva_prfumi ;#gac03

	    if {$portata_comb eq "" && $barra_ann ne ""} {#gac07 aggiunta if per far comparire una barra / quando il campo non è compilato
		multirow set multiple_form_prfumi $conta_prfumi barra "t"
	    } else {
		multirow set multiple_form_prfumi $conta_prfumi barra "f"
	    }

	    if {$portata_termica_effettiva_prfumi eq "" && $barra_ann ne ""} {#gac07 aggiunta if per far comparire una barra / quando il campo non è compilato
		multirow set multiple_form_prfumi $conta_prfumi barra2 "t"
	    } else {
		multirow set multiple_form_prfumi $conta_prfumi barra2 "f"
	    }
	    
	    
	    set portata_termica_effettiva_num [iter_check_num $portata_termica_effettiva_prfumi 2]
	    
	    if {($portata_termica_effettiva_num > $pot_utile_nom_calc) && $portata_termica_effettiva ne ""} {
		
		element set_properties $form_name warning_portata  -value "<font color=blue><b>Scostamento della potenza max. al focolare superiore al 10%. Regolare il generatore prima di effettuare la misura del rendimento di combustione.</b></font>"
		
	    } else {
		element set_properties $form_name warning_portata  -value ""
	    }
	    
	    if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		if {$flag_co_perc == "t"} {
		    set co [expr $co / 10000.0000]
		    set co [iter_edit_num $co 4]
		} else {
		    set co [iter_edit_num $co 0]
		}
	    } else {
                if {$flag_co_perc == "t"} {
		    set co [expr $co / 10000.00]
		    set co [iter_edit_num $co 2]
		} else {
		    set co [iter_edit_num $co 2]
		}
	    }


	    element set_properties $form_name co.$conta_prfumi                 -value $co
            element set_properties $form_name co_fumi_secchi_ppm.$conta_prfumi -value $co_fumi_secchi_ppm
	    element set_properties $form_name rend_combust.$conta_prfumi       -value $rend_combust
	    element set_properties $form_name rct_rend_min_legge.$conta_prfumi -value $rct_rend_min_legge
	    element set_properties $form_name rct_modulo_termico.$conta_prfumi -value $rct_modulo_termico
	    
	    if {$coimtgen(regione) eq "MARCHE"} {
		#gac0 aggiunta if e suo contenuto per calcolare il valore corretto dei fumi secchi che non deve
		#discostarsi di  +- 1% dal valore di co calcolato; controllo non bloccante
		#rom10 aggiunta condizione su o2 < di 21
		#sim78 come indicato dalla Regione la tolleranza passa da 1% a 5%
 		if {$co_fumi_secchi_ppm ne "" && $o2 ne "" && $o2 < "21.00"} {
 		    set co_corretto_prfumi [expr (21 / (21 - [iter_check_num $o2 2])) * [iter_check_num $co_fumi_secchi_ppm 2]]
 		    #sim78 set co_perc_inf_prfumi [expr $co_corretto_prfumi - ($co_corretto_prfumi * 1 / 100)]
 		    #sim78 set co_perc_sup_prfumi [expr $co_corretto_prfumi + ($co_corretto_prfumi * 1 / 100)]
		    set co_perc_inf_prfumi [expr $co_corretto_prfumi - ($co_corretto_prfumi * 5 / 100)];#sim78
 		    set co_perc_sup_prfumi [expr $co_corretto_prfumi + ($co_corretto_prfumi * 5 / 100)];#sim78
		    ns_log notice "Gac: co:[iter_check_num $co 2]|||inf:$co_perc_inf_prfumi|||sup:$co_perc_sup_prfumi|||corr:$co_corretto_prfumi"
 		    if {[iter_check_num $co 2] < $co_perc_inf_prfumi || [iter_check_num $co 2] > $co_perc_sup_prfumi} {
 			element set_properties $form_name warning_co_corretto.$conta_prfumi -value "<font color=blue><b>Attenzione: Valori di CO fumi secchi e CO corretto incoerenti</b></font>"
 		    } else {
 			element set_properties $form_name warning_co_corretto.$conta_prfumi -value ""
 		    }
 		}
	    }
	}

	# valorizzo comunque prog_anom delle righe di anom eventualmente
	# non ancora inserite
	while {$conta < 5} {
	    incr conta
	    incr prog_anom
	    element set_properties $form_name prog_anom.$conta -value $prog_anom
	}
    }

    if {$funzione ne "I" } {
	set portata_termica_effettiva_num [iter_check_num $portata_termica_effettiva 2]
	if {($portata_termica_effettiva_num > $pot_utile_nom_calc) && $portata_termica_effettiva ne ""} {
	   
	    element set_properties $form_name warning_portata  -value "<font color=blue><b>Scostamento della potenza max. al focolare superiore al 10%. Regolare il generatore prima di effettuare la misura del rendimento di combustione.</b></font>"
	}	
    } else {
	element set_properties $form_name warning_portata  -value ""
    }

#sim77    if {$coimtgen(regione) eq "MARCHE"} {#gac08

	#gac08 se il combustibile non è uno di quelli riportati cont_ren deve essere Non effettuato
    #rom31 Aggiunti combustibili ARIA PROPANATA, GNL e SYNGAS
    #rom31 Riscritta la if usando il comando in per abbreviare la condizione
    #rom31if {!($descr_comb eq "METANO" || $descr_comb eq "PROPANO" || $descr_comb eq "GPL" || $descr_comb eq "BUTANO" || $descr_comb eq "GASOLIO" || $descr_comb eq "OLIO")} {}#gac08
    if {!($descr_comb in [list "METANO" "PROPANO" "GPL" "BUTANO" "GASOLIO" "OLIO" "ARIA PROPANATA" "GNL" "SYNGAS"])} {#rom31 Aggiunta la if ma non il suo contenuto
	
	element set_properties $form_name cont_rend -options {{{Non effettuato} N}}
	element set_properties $form_name cont_rend -html    {readonly {} class form_element}
	set cont_rend "N";#sim77
	
    }

	#gac07 aggiunto di default NC se controllo rendimento è "non effettuato"
	if {$cont_rend eq "N"} {#gac07
	    set rct_uni_10389 "C"
	    element set_properties $form_name rct_uni_10389 -value $rct_uni_10389
	    element set_properties $form_name rct_rend_min_legge -value ""
	    element::set_error     $form_name rct_rend_min_legge ""
	    element set_properties $form_name rct_modulo_termico -value ""
	    
	    set conta_prfumi 0;#rom01
	    
	    while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
		incr conta_prfumi
		if {$conta_prfumi > 9} {
		    break
		}
		set conta_moduli [expr $conta_prfumi + 1]
		element set_properties $form_name rct_rend_min_legge.$conta_prfumi -value ""
		element::set_error     $form_name rct_rend_min_legge.$conta_prfumi ""
		element set_properties $form_name rct_modulo_termico.$conta_prfumi -value ""
		
	    }
	}
#sim77    }

    #gac10 Per regione Marche se ho più generatori compilo in automatico i campi come nel dimp precedente
    #gac10 fino alla sezione E.
    if {$coimtgen(regione) eq "MARCHE" && $funzione eq "I" && $cod_dimp_precedente ne ""} {#gac10 aggiunta if e suo contenuto
        if {[db_0or1row sel_dimp_old_gen ""] == 0} {
	    iter_return_complaint "Record non trovato"
	}

	element set_properties $form_name cod_manutentore  -value $cod_manutentore_precedente_dimp;#rom12
	element set_properties $form_name cod_strumento_01        -value $cod_strumento_01_precedente_dimp;#rom12
        element set_properties $form_name cod_strumento_02        -value $cod_strumento_02_precedente_dimp;#rom12
    
	element set_properties $form_name cod_strumento_01 -options [iter_selbox_from_table_wherec coimstru_manu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_precedente_dimp' and tipo_strum = '0' and is_active_p = 'f'"];#rom12
		
	element set_properties $form_name cod_strumento_02 -options [iter_selbox_from_table_wherec coimstru_manu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_precedente_dimp' and tipo_strum = '1' and is_active_p = 'f'"];#rom12

	#ricalcolo il saldo inizio

	if {$flag_portafoglio == "T"
	    && ![string equal $cod_manutentore_precedente_dimp ""]} {#rom12 if e suo contenuto
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio"
	    } else {
		set url "lotto/balance?iter_code=$cod_manutentore_precedente_dimp&ente_portafoglio=$ente_portafoglio"
	    }	    
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #	        ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo_precedente_dimp [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu_precedente_dimp [string range $parte_2 [expr [string first " " $parte_2] + 1] end]

		db_1row sel_limiti_tgen "select flag_limite_portaf, valore_limite_portaf from coimtgen"
		if {$flag_limite_portaf == "S"} {
		    if {[iter_check_num $saldo_precedente_dimp 2] < $valore_limite_portaf} {
			set msg_limite "Attenzione - Il credito residuo disponibile sul tuo Portafoglio sta per terminare. Prima di completare l'inserimento delle dichiarazioni controlla l'importo necessario per il contributo. Se il credito residuo risulta insufficiente la dichiarazione non verr&agrave; accettata."
		    } else {
			set msg_limite ""
		    }
		}  
	    } else {
		set saldo_precedente_dimp ""
		set conto_manu_precedente_dimp ""
	    }

	    element set_properties $form_name saldo_manu  -value $saldo_precedente_dimp
	    element set_properties $form_name cod_portafoglio  -value $conto_manu_precedente_dimp
	} 
	
	#ricalcolo il saldo fine
	
	element set_properties $form_name cognome_manu     -value $cognome_manu_precedente_dimp
	element set_properties $form_name cognome_opma     -value $cognome_opma_precedente_dimp
	element set_properties $form_name cognome_resp     -value $cognome_resp_precedente_dimp
	element set_properties $form_name nome_manu        -value $nome_manu_precedente_dimp
	element set_properties $form_name nome_opma        -value $nome_opma_precedente_dimp
	element set_properties $form_name cod_opmanu_new   -value $cod_opmanu_new_precedente_dimp
	element set_properties $form_name nome_resp        -value $nome_resp_precedente_dimp
	element set_properties $form_name cod_fiscale_resp -value $cod_fiscale_resp_precedente_dimp
	element set_properties $form_name conformita       -value $conformita_precedente_dimp
	element set_properties $form_name lib_impianto     -value $lib_impianto_precedente_dimp
	element set_properties $form_name lib_uso_man      -value $lib_uso_man_precedente_dimp
	element set_properties $form_name rct_lib_uso_man_comp -value $rct_lib_uso_man_comp_precedente_dimp
	element set_properties $form_name rct_dur_acqua    -value $rct_dur_acqua_precedente_dimp
	element set_properties $form_name rct_tratt_in_risc -value $rct_tratt_in_risc_precedente_dimp
	element set_properties $form_name rct_tratt_in_acs  -value $rct_tratt_in_acs_precedente_dimp
	element set_properties $form_name rct_install_interna -value $rct_install_interna_precedente_dimp
	element set_properties $form_name idoneita_locale  -value $idoneita_locale_precedente_dimp
	element set_properties $form_name ap_ventilaz      -value $ap_ventilaz_precedente_dimp
	element set_properties $form_name ap_vent_ostruz   -value $ap_vent_ostruz_precedente_dimp
	element set_properties $form_name rct_canale_fumo_idoneo   -value $rct_canale_fumo_idoneo_precedente_dimp
	element set_properties $form_name rct_sistema_reg_temp_amb -value $rct_sistema_reg_temp_amb_precedente_dimp
	element set_properties $form_name rct_assenza_per_comb     -value $rct_assenza_per_comb_precedente_dimp
	element set_properties $form_name rct_idonea_tenuta        -value $rct_idonea_tenuta_precedente_dimp
	element set_properties $form_name volimetria_risc -value $volimetria_risc_precedente_dimp
	element set_properties $form_name consumo_annuo   -value $consumo_annuo_precedente_dimp
	element set_properties $form_name consumo_annuo2  -value $consumo_annuo2_precedente_dimp
	element set_properties $form_name stagione_risc   -value $stagione_risc_precedente_dimp
	element set_properties $form_name stagione_risc2  -value $stagione_risc2_precedente_dimp
	element set_properties $form_name acquisti        -value $acquisti_precedente_dimp
	element set_properties $form_name scorta_o_lett_iniz -value $scorta_o_lett_iniz_precedente_dimp
        element set_properties $form_name scorta_o_lett_fin  -value $scorta_o_lett_fin_precedente_dimp
	element set_properties $form_name acquisti2          -value $acquisti2_precedente_dimp
        element set_properties $form_name scorta_o_lett_iniz2 -value $scorta_o_lett_iniz2_precedente_dimp
        element set_properties $form_name scorta_o_lett_fin2  -value $scorta_o_lett_fin2_precedente_dimp
	element set_properties $form_name elet_esercizio_1        -value $elet_esercizio_1_precedente_dimp
	element set_properties $form_name elet_esercizio_2        -value $elet_esercizio_2_precedente_dimp
	element set_properties $form_name elet_esercizio_3        -value $elet_esercizio_3_precedente_dimp
	element set_properties $form_name elet_esercizio_4        -value $elet_esercizio_4_precedente_dimp
	element set_properties $form_name elet_lettura_iniziale   -value $elet_lettura_iniziale_precedente_dimp
	element set_properties $form_name elet_lettura_finale     -value $elet_lettura_finale_precedente_dimp
	element set_properties $form_name elet_consumo_totale     -value $elet_consumo_totale_precedente_dimp
	element set_properties $form_name elet_lettura_iniziale_2 -value $elet_lettura_iniziale_2_precedente_dimp
	element set_properties $form_name elet_lettura_finale_2   -value $elet_lettura_finale_2_precedente_dimp
	element set_properties $form_name elet_consumo_totale_2   -value $elet_consumo_totale_2_precedente_dimp
        element set_properties $form_name data_controllo          -value $data_controllo_precedente_dimp
	element set_properties $form_name data_ultima_manu        -value $data_ultima_manu_precedente_dimp
	element set_properties $form_name data_prox_manut         -value $data_prox_manut_precedente_dimp
	element set_properties $form_name ora_inizio              -value $ora_inizio_precedente_dimp
	element set_properties $form_name ora_fine                -value $ora_fine_precedente_dimp
	
	element create $form_name cod_dimp_precedente -widget hidden -datatype text -optional
	element set_properties $form_name cod_dimp_precedente     -value $cod_dimp_precedente
    }

    #gac11 Per regione marche se non esistono dfm mostro il messaggio non bloccante: "Manca la DFM", se esistono le DFM
    #gac11 e la data_controllo e data_prox_manut sono maggiori della data calcolata dalla data dichiarazione con i mesi
    #gac01 indicati nella dfm mostro il messaggio non bloccante "Incongruenza con le DFM"
    if {$coimtgen(regione) eq "MARCHE" && $funzione ne "I"} {#gac11 aggiunta if e suo contenuto
	if {![db_0or1row q "select 1 
                              from coimdope_aimp a
                                 , coimdope_gend b
                             where a.cod_impianto = :cod_impianto
                               and a.cod_dope_aimp = b.cod_dope_aimp 
                               and b.gen_prog     = :gen_prog
                             limit 1"]} {
	    #rom05set warning_dfm "<font color=red>Manca la DFM</font>"
	} else {
	    #come frequenza va presa la prima dell'ultima DFM inserita
	    if {![db_0or1row q "select a.data_dich
                                     , b.frequenza
                                  from coimdope_aimp a
                                     , coimdope_gend b 
                                 where a.cod_impianto  = :cod_impianto 
                                   and a.cod_dope_aimp = b.cod_dope_aimp 
                                   and b.gen_prog = :gen_prog 
                              order by a.data_dich desc,a.cod_dope_aimp 
                                 limit 1"]} {
		set data_dich ""
		set frequenza ""

	    } else {
		if {[string is digit $frequenza]} {#gac12 aggiunta if perche in caso di dati sporchi andava in errore la query
		    set data_controllo_per_frequenza [iter_check_date $data_controllo]
		    #ricavo la data dell'ultimo RCEE (se presente)
		    db_0or1row q "select max(data_controllo) as data_controllo_ultimo_rcee 
                                    from coimdimp 
                                   where cod_impianto = :cod_impianto
                                     and flag_tracciato='R1'
                                     and cod_dimp != :cod_dimp
                                     and data_controllo <= :data_controllo_per_frequenza"

		    if {$data_controllo_ultimo_rcee ne ""} {
			set data_dfm_per_calcolo  [db_string q "select (:data_controllo_ultimo_rcee::date + interval '$frequenza month')::date" -default ""]
		    } else {
			set data_dfm_per_calcolo ""
		    }
		} else {
		    set data_dfm_per_calcolo ""
		}

		if {$data_dfm_per_calcolo ne "" && [ah::check_date -input_date $data_controllo -ansi] > $data_dfm_per_calcolo && [ah::check_date -input_date $data_prox_manut -ansi] > $data_dfm_per_calcolo} {
		    set data_controllo_ultimo_rcee_pretty [db_string q "select iter_edit_data(:data_controllo_ultimo_rcee)"]
		    #set warning_dfm "<font color=red>Incongruenza con la DFM, controllo eseguito il $data_controllo_ultimo_rcee_pretty</font>"
		}
	    }
	}	
	element set_properties $form_name warning_dfm       -value $warning_dfm
    }

    if {$coimtgen(regione) eq "MARCHE"} {
	#rom31 Aggiunti i combustibili ARIA PROPANATA, GNL e SYNGAS
	#rom31 Riscritta if utilizzando il comando in per la variabile descr_comb
	#rom31if {$cont_rend eq "N" && ($descr_comb eq "METANO" || $descr_comb eq "PROPANO" || $descr_comb eq "GPL" || $descr_comb eq "BUTANO" || $descr_comb eq "GASOLIO" || $descr_comb eq "OLIO")} {}#gac07 if e contenuto
	if {$cont_rend eq "N" && ($descr_comb in [list "METANO" "PROPANO" "GPL" "BUTANO" "GASOLIO" "OLIO" "ARIA PROPANATA" "GNL" "SYNGAS"])} {#rom31 Aggiunta if ma non il suo contenuto
	    if {$osservazioni eq ""} {
		set msg_osservazioni_cont_rend "<font color=blue>| Indicare nelle osservazioni il perchè del mancato controllo, come previsto dalla norma UNI 10389</font>"
		
	    }
	}
    }

};#fine form is_request

if {[form is_valid $form_name]} {
    if {$coimtgen(regione) eq "MARCHE" && $funzione eq "I" && $cod_dimp_precedente ne ""} {#gac10 aggiunta if e suo contenuto
        if {[db_0or1row sel_dimp_old_gen ""] == 0} {
	    iter_return_complaint "Record non trovato"
	}
	element set_properties $form_name cognome_manu     -value $cognome_manu_precedente_dimp
	element set_properties $form_name cognome_opma     -value $cognome_opma_precedente_dimp
	element set_properties $form_name cognome_resp     -value $cognome_resp_precedente_dimp
	element set_properties $form_name nome_manu        -value $nome_manu_precedente_dimp
	element set_properties $form_name nome_opma        -value $nome_opma_precedente_dimp
	element set_properties $form_name cod_opmanu_new   -value $cod_opmanu_new_precedente_dimp
	element set_properties $form_name nome_resp        -value $nome_resp_precedente_dimp
	element set_properties $form_name cod_fiscale_resp -value $cod_fiscale_resp_precedente_dimp
	element set_properties $form_name conformita       -value $conformita_precedente_dimp
	element set_properties $form_name lib_impianto     -value $lib_impianto_precedente_dimp
	element set_properties $form_name lib_uso_man      -value $lib_uso_man_precedente_dimp
	element set_properties $form_name rct_lib_uso_man_comp -value $rct_lib_uso_man_comp_precedente_dimp
	element set_properties $form_name rct_dur_acqua    -value $rct_dur_acqua_precedente_dimp
	element set_properties $form_name rct_tratt_in_risc -value $rct_tratt_in_risc_precedente_dimp
	element set_properties $form_name rct_tratt_in_acs  -value $rct_tratt_in_acs_precedente_dimp
	element set_properties $form_name rct_install_interna -value $rct_install_interna_precedente_dimp
	element set_properties $form_name idoneita_locale  -value $idoneita_locale_precedente_dimp
	element set_properties $form_name ap_ventilaz      -value $ap_ventilaz_precedente_dimp
	element set_properties $form_name ap_vent_ostruz   -value $ap_vent_ostruz_precedente_dimp
	element set_properties $form_name rct_canale_fumo_idoneo   -value $rct_canale_fumo_idoneo_precedente_dimp
	element set_properties $form_name rct_sistema_reg_temp_amb -value $rct_sistema_reg_temp_amb_precedente_dimp
	element set_properties $form_name rct_assenza_per_comb     -value $rct_assenza_per_comb_precedente_dimp
	element set_properties $form_name rct_idonea_tenuta        -value $rct_idonea_tenuta_precedente_dimp
	element set_properties $form_name volimetria_risc -value $volimetria_risc_precedente_dimp
	element set_properties $form_name consumo_annuo   -value $consumo_annuo_precedente_dimp
	element set_properties $form_name consumo_annuo2  -value $consumo_annuo2_precedente_dimp
	element set_properties $form_name stagione_risc   -value $stagione_risc_precedente_dimp
	element set_properties $form_name stagione_risc2  -value $stagione_risc2_precedente_dimp
	element set_properties $form_name acquisti        -value $acquisti_precedente_dimp
	element set_properties $form_name scorta_o_lett_iniz -value $scorta_o_lett_iniz_precedente_dimp
        element set_properties $form_name scorta_o_lett_fin  -value $scorta_o_lett_fin_precedente_dimp
	element set_properties $form_name acquisti2          -value $acquisti2_precedente_dimp
        element set_properties $form_name scorta_o_lett_iniz2 -value $scorta_o_lett_iniz2_precedente_dimp
        element set_properties $form_name scorta_o_lett_fin2  -value $scorta_o_lett_fin2_precedente_dimp
	element set_properties $form_name elet_esercizio_1        -value $elet_esercizio_1_precedente_dimp
	element set_properties $form_name elet_esercizio_2        -value $elet_esercizio_2_precedente_dimp
	element set_properties $form_name elet_esercizio_3        -value $elet_esercizio_3_precedente_dimp
	element set_properties $form_name elet_esercizio_4        -value $elet_esercizio_4_precedente_dimp
	element set_properties $form_name elet_lettura_iniziale   -value $elet_lettura_iniziale_precedente_dimp
	element set_properties $form_name elet_lettura_finale     -value $elet_lettura_finale_precedente_dimp
	element set_properties $form_name elet_consumo_totale     -value $elet_consumo_totale_precedente_dimp
	element set_properties $form_name elet_lettura_iniziale_2 -value $elet_lettura_iniziale_2_precedente_dimp
	element set_properties $form_name elet_lettura_finale_2   -value $elet_lettura_finale_2_precedente_dimp
	element set_properties $form_name elet_consumo_totale_2   -value $elet_consumo_totale_2_precedente_dimp
        element set_properties $form_name data_controllo          -value $data_controllo_precedente_dimp
	element set_properties $form_name data_ultima_manu        -value $data_ultima_manu_precedente_dimp
	element set_properties $form_name data_prox_manut         -value $data_prox_manut_precedente_dimp
	element set_properties $form_name ora_inizio              -value $ora_inizio_precedente_dimp
	element set_properties $form_name ora_fine                -value $ora_fine_precedente_dimp
	element create $form_name cod_dimp_precedente -widget hidden -datatype text -optional
	element set_properties $form_name cod_dimp_precedente     -value $cod_dimp_precedente
    }
    # form valido dal punto di vista del templating system
    set __refreshing_p   [element::get_value $form_name __refreshing_p];#nic01
    set changed_field    [element::get_value $form_name changed_field];#nic01
    set cod_dimp         [string trim [element::get_value $form_name cod_dimp]]
    set cod_impianto     [string trim [element::get_value $form_name cod_impianto]]
    set data_controllo   [string trim [element::get_value $form_name data_controllo]]
    set data_ultima_manu [string trim [element::get_value $form_name data_ultima_manu]];#gac07
    set cod_manutentore  [string trim [element::get_value $form_name cod_manutentore]]
    set cod_opmanu_new                [element::get_value $form_name cod_opmanu_new]
    set cod_responsabile [string trim [element::get_value $form_name cod_responsabile]]
    set cod_occupante    [string trim [element::get_value $form_name cod_occupante]]
    set cod_proprietario [string trim [element::get_value $form_name cod_proprietario]]
    set flag_status      [string trim [element::get_value $form_name flag_status]]
    set garanzia         [string trim [element::get_value $form_name garanzia]]
    set conformita       [string trim [element::get_value $form_name conformita]]
    set lib_impianto     [string trim [element::get_value $form_name lib_impianto]]
    set lib_uso_man      [string trim [element::get_value $form_name lib_uso_man]]
    set inst_in_out      [string trim [element::get_value $form_name inst_in_out]]
    set idoneita_locale  [string trim [element::get_value $form_name idoneita_locale]]
    set ap_ventilaz      [string trim [element::get_value $form_name ap_ventilaz]]
    set ap_vent_ostruz   [string trim [element::get_value $form_name ap_vent_ostruz]]
    set pendenza         [string trim [element::get_value $form_name pendenza]]
    set sezioni          [string trim [element::get_value $form_name sezioni]]
    set curve            [string trim [element::get_value $form_name curve]]
    set lunghezza        [string trim [element::get_value $form_name lunghezza]]
    set conservazione    [string trim [element::get_value $form_name conservazione]]
    set scar_ca_si       [string trim [element::get_value $form_name scar_ca_si]]
    set scar_parete      [string trim [element::get_value $form_name scar_parete]]
    set riflussi_locale  [string trim [element::get_value $form_name riflussi_locale]]
    set assenza_perdite  [string trim [element::get_value $form_name assenza_perdite]]
    set pulizia_ugelli   [string trim [element::get_value $form_name pulizia_ugelli]]
    set antivento        [string trim [element::get_value $form_name antivento]]
    set scambiatore      [string trim [element::get_value $form_name scambiatore]]
    set accens_reg       [string trim [element::get_value $form_name accens_reg]]
    set disp_comando     [string trim [element::get_value $form_name disp_comando]]
    set ass_perdite      [string trim [element::get_value $form_name ass_perdite]]
    set valvola_sicur    [string trim [element::get_value $form_name valvola_sicur]]
    set vaso_esp         [string trim [element::get_value $form_name vaso_esp]]
    set disp_sic_manom   [string trim [element::get_value $form_name disp_sic_manom]]
    set organi_integri   [string trim [element::get_value $form_name organi_integri]]
    set circ_aria        [string trim [element::get_value $form_name circ_aria]]
    set guarn_accop      [string trim [element::get_value $form_name guarn_accop]]
    set assenza_fughe    [string trim [element::get_value $form_name assenza_fughe]]
    set coibentazione    [string trim [element::get_value $form_name coibentazione]]
    set eff_evac_fum     [string trim [element::get_value $form_name eff_evac_fum]]
    set cont_rend        [string trim [element::get_value $form_name cont_rend]]
    set pot_focolare_mis [string trim [element::get_value $form_name pot_focolare_mis]]
    set portata_comb_mis [string trim [element::get_value $form_name portata_comb_mis]]
    set temp_fumi        [string trim [element::get_value $form_name temp_fumi]]
    set temp_ambi        [string trim [element::get_value $form_name temp_ambi]]
    set o2               [string trim [element::get_value $form_name o2]]
    set co2              [string trim [element::get_value $form_name co2]]
    set bacharach        [string trim [element::get_value $form_name bacharach]]
    set bacharach2       [string trim [element::get_value $form_name bacharach2]]           ;#gac02
    set bacharach3       [string trim [element::get_value $form_name bacharach3]]           ;#gac02
    set portata_comb     [string trim [element::get_value $form_name portata_comb]]         ;#gac02
    set rispetta_indice_bacharach [string trim [element::get_value $form_name rispetta_indice_bacharach]];#gac02
    set co_fumi_secchi   [string trim [element::get_value $form_name co_fumi_secchi]]       ;#gac02
    set rend_magg_o_ugua_rend_min [string trim [element::get_value $form_name rend_magg_o_ugua_rend_min]];#gac02
    set combustibile_dimp    [string trim [element::get_value $form_name combustibile_dimp]]   ;#rom17
    set unita_misura_consumi [string trim [element::get_value $form_name unita_misura_consumi]];#rom18

    if {$coimtgen(regione) eq "MARCHE"} {#rom12 if e contenuto
	if {![string equal $cod_manu ""]} {
	    set cod_manutentore_stru $cod_manu
	} else {
	    
	    set cod_manutentore_stru [db_string q "select cod_manutentore 
                                                         from coimmanu
                                                        where cod_manutentore = :cod_manutentore" -default ""]
	}
	
	element set_properties $form_name cod_strumento_01 -options [iter_selbox_from_table_wherec coimstru_manu  coimmanu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '0' and is_active_p ='f'"];#but01 
	
	element set_properties $form_name cod_strumento_02 -options [iter_selbox_from_table_wherec coimstru_manu coimmanu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '1' and is_active_p ='f'"];#but01
    }

    set cod_strumento_01 [string trim [element::get_value $form_name cod_strumento_01]];#gac06
    set cod_strumento_02 [string trim [element::get_value $form_name cod_strumento_02]];#gac06
    set portata_termica_effettiva [string trim [element::get_value $form_name portata_termica_effettiva]];#gac03
    set co               [string trim [element::get_value $form_name co]]
    set co_fumi_secchi_ppm [string trim [element::get_value $form_name co_fumi_secchi_ppm]];#rom04
    set rend_combust     [string trim [element::get_value $form_name rend_combust]]
    set osservazioni     [string trim [element::get_value $form_name osservazioni]]
    set raccomandazioni  [string trim [element::get_value $form_name raccomandazioni]]
    set prescrizioni     [string trim [element::get_value $form_name prescrizioni]]
    set data_utile_inter [string trim [element::get_value $form_name data_utile_inter]]
    set n_prot           [string trim [element::get_value $form_name n_prot]]
    set data_prot        [string trim [element::get_value $form_name data_prot]]
    set delega_resp      [string trim [element::get_value $form_name delega_resp]]
    set delega_manut     [string trim [element::get_value $form_name delega_manut]]
    set cognome_manu     [string trim [element::get_value $form_name cognome_manu]]
    regsub -all "!" $cognome_manu "'" cognome_manu
    set cognome_opma     [element::get_value $form_name cognome_opma]
    set cognome_resp     [string trim [element::get_value $form_name cognome_resp]]
    set nome_manu        [string trim [element::get_value $form_name nome_manu]]
    set nome_opma                     [element::get_value $form_name nome_opma]
    set nome_resp        [string trim [element::get_value $form_name nome_resp]]
    set cod_fiscale_resp [string trim [element::get_value $form_name cod_fiscale_resp]]
    set cognome_occu     [string trim [element::get_value $form_name cognome_occu]]
    set cognome_prop     [string trim [element::get_value $form_name cognome_prop]]
    set nome_occu        [string trim [element::get_value $form_name nome_occu]]
    set nome_prop        [string trim [element::get_value $form_name nome_prop]]
    set esente           [string trim [element::get_value $form_name esente]];#sim19
    set cod_tprc         [string trim [element::get_value $form_name cod_tprc]];#sim58
    set is_warning_p     [string trim [element::get_value $form_name is_warning_p]];#gac07
    set warning_dfm      [string trim [element::get_value $form_name warning_dfm]];#rom05


    set conta_prfumi 0;#rom01
    while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
	incr conta_prfumi
	if {$conta_prfumi > 9} {
                break
	}

	set tiraggio_fumi_prfumi($conta_prfumi)      [string trim [element::get_value $form_name tiraggio_fumi.$conta_prfumi]]
	set temp_fumi_prfumi($conta_prfumi)          [string trim [element::get_value $form_name temp_fumi.$conta_prfumi]]
	set temp_ambi_prfumi($conta_prfumi)          [string trim [element::get_value $form_name temp_ambi.$conta_prfumi]]
	set o2_prfumi($conta_prfumi)                 [string trim [element::get_value $form_name o2.$conta_prfumi]]
	set co2_prfumi($conta_prfumi)                [string trim [element::get_value $form_name co2.$conta_prfumi]]
	set bacharach_prfumi($conta_prfumi)          [string trim [element::get_value $form_name bacharach.$conta_prfumi]]
	set co_prfumi($conta_prfumi)                 [string trim [element::get_value $form_name co.$conta_prfumi]]
        set co_fumi_secchi_ppm_prfumi($conta_prfumi) [string trim [element::get_value $form_name co_fumi_secchi_ppm.$conta_prfumi]]
	set rend_combust_prfumi($conta_prfumi)       [string trim [element::get_value $form_name rend_combust.$conta_prfumi]]
	set rct_rend_min_legge_prfumi($conta_prfumi) [string trim [element::get_value $form_name rct_rend_min_legge.$conta_prfumi]]
	set rct_modulo_termico_prfumi($conta_prfumi) [string trim [element::get_value $form_name rct_modulo_termico.$conta_prfumi]]
	set bacharach2_prfumi($conta_prfumi)         [string trim [element::get_value $form_name bacharach2.$conta_prfumi]]  ;#gac02
	set bacharach3_prfumi($conta_prfumi)         [string trim [element::get_value $form_name bacharach3.$conta_prfumi]]  ;#gac02
	set portata_comb_prfumi($conta_prfumi)       [string trim [element::get_value $form_name portata_comb.$conta_prfumi]];#gac02
	set portata_termica_effettiva_prfumi($conta_prfumi) [string trim [element::get_value $form_name portata_termica_effettiva.$conta_prfumi]];#gac03
    }

    # agg dob cind
    set cod_cind         [element::get_value $form_name cod_cind]
    if {$flag_portafoglio == "T"} {
	set importo_tariffa  [string trim [element::get_value $form_name importo_tariffa]]
	set tariffa_reg      [string trim [element::get_value $form_name tariffa_reg]]
	set cod_manu [iter_check_uten_manu $id_utente]
	if {[string range $id_utente 0 1] == "AM"} {
	    set cod_manu $id_utente
	}
	if {![string equal $cod_manutentore ""]} {
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio"
	    } else {
		#ricavo il portafoglio manutentore
		set url "lotto/balance?iter_code=$cod_manutentore&ente_portafoglio=$ente_portafoglio"
	    }
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #    ns_return 200 text/html "$result(page)"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
		
		db_1row sel_limiti_tgen "select flag_limite_portaf, valore_limite_portaf from coimtgen"
		if {$flag_limite_portaf == "S"} {
		    if {[iter_check_num $saldo 2] < $valore_limite_portaf} {
			set msg_limite "Attenzione - Il credito residuo disponibile sul tuo Portafoglio sta per terminare. Prima di completare l'inserimento delle dichiarazioni controlla l'importo necessario per il contributo regionale. Se il credito residuo risulta insufficiente la dichiarazione non verr&agrave; accettata."
		    }
		}
	    }
	}
    }

    set costo             [string trim [element::get_value $form_name costo]]
    set tipologia_costo   [string trim [element::get_value $form_name tipologia_costo]]

    if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunta if per regione marche perche loro vogliono che non venga selezionato in automatico
	if {$tipologia_costo == "BO"} {
	    element::set_value $form_name flag_pagato "S"
	}
    }

    if {$coimtgen(regione) eq "MARCHE"} {

	set cod_tprc_attuale [element::get_value $form_name cod_tprc]
	if {[db_0or1row q "select 1 from coimtprc where cod_tprc=:cod_tprc_attuale and esente='f'"]} {#sim
	    element set_properties $form_name flag_pagato -options {{"" ""} {S&igrave; S} {"No, per rifiuto del responsabile d'impianto a corrispondere il contributo" C}}

	    if {$cod_tprc_attuale eq "REGINAD"} {
		element set_properties $form_name flag_pagato -options {{"" ""} {S&igrave; S} {"No, perchè non dovuto" N} {"No, per rifiuto del responsabile d'impianto a corrispondere il contributo" C}}
	    }

	    
	} else {
	    element set_properties $form_name flag_pagato -options {{"" ""} {"No, perchè non dovuto" N}}
	}
    } elseif {$coimtgen(ente) eq "PPA"} {#rom24 Aggiunta elseif e contenuto
	element set_properties $form_name flag_pagato -options {{"" ""} {S&igrave; S}}
    } elseif {$flag_combo_tipibol eq "T" && $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom32 aggiunta elseif e suo contenuto
	element set_properties $form_name flag_pagato -options {{S&igrave; S}}
	element set_properties $form_name flag_pagato -value "S"
    } else {
	element set_properties $form_name flag_pagato -options {{"" ""} {S&igrave; S} {"No, perchè non dovuto" N} {"No, per rifiuto del responsabile d'impianto a corrispondere il contributo" C}}
    }

    
    set flag_pagato       [string trim [element::get_value $form_name flag_pagato]]

    if {$funzione eq "M"} {#rom06 aggiuta if e suo contenuto
	set flag_pagato [db_string q "select flag_pagato from coimdimp where cod_dimp=:cod_dimp"]
    }
    
    set riferimento_pag   [string trim [element::get_value $form_name riferimento_pag]]
    set data_scad_pagamento [string trim [element::get_value $form_name data_scad_pagamento]]
    set potenza           [string trim [element::get_value $form_name potenza]]
    set prog_anom_max     [string trim [element::get_value $form_name prog_anom_max]]
    set list_anom_old     [string trim [element::get_value $form_name list_anom_old]]
    set flag_modifica     [string trim [element::get_value $form_name flag_modifica]]
    set cod_int_contr     [string trim [element::get_value $form_name cod_int_contr]]
    set cognome_contr     [string trim [element::get_value $form_name cognome_contr]]
    set nome_contr        [string trim [element::get_value $form_name nome_contr]]
    set gen_prog          [string trim [element::get_value $form_name gen_prog]]
    set flag_tracciato    [string trim [element::get_value $form_name flag_tracciato]]
    set scar_can_fu       [string trim [element::get_value $form_name scar_can_fu]]
    set tiraggio_fumi     [string trim [element::get_value $form_name tiraggio_fumi]]
    set ora_inizio        [string trim [element::get_value $form_name ora_inizio]]
    set ora_fine          [string trim [element::get_value $form_name ora_fine]]
    set data_scadenza_autocert    [string trim [element::get_value $form_name data_scadenza_autocert]]
    set num_autocert      [string trim [element::get_value $form_name num_autocert]]
    set volimetria_risc   [string trim [element::get_value $form_name volimetria_risc]]
    set consumo_annuo     [string trim [element::get_value $form_name consumo_annuo]]
    set consumo_annuo2    [string trim [element::get_value $form_name consumo_annuo2]]
    set data_arrivo_ente  [element::get_value $form_name data_arrivo_ente]
    set stagione_risc     [element::get_value $form_name stagione_risc]
    set stagione_risc2    [element::get_value $form_name stagione_risc2]
    set acquisti          [string trim [element::get_value $form_name acquisti]] ;#gac01
    set scorta_o_lett_iniz [string trim [element::get_value $form_name scorta_o_lett_iniz]];#gac01
    set scorta_o_lett_fin  [string trim [element::get_value $form_name scorta_o_lett_fin]];#gac01
    set acquisti2          [string trim [element::get_value $form_name acquisti2]] ;#gac01
    set scorta_o_lett_iniz2 [string trim [element::get_value $form_name scorta_o_lett_iniz2]];#gac01
    set scorta_o_lett_fin2  [string trim [element::get_value $form_name scorta_o_lett_fin2]];#gac01
    set tabella           [string trim [element::get_value $form_name tabella]]
    set cod_dimp_ins      [string trim [element::get_value $form_name cod_dimp_ins]]
    set rct_dur_acqua            [string trim [element::get_value $form_name rct_dur_acqua]]
    set rct_tratt_in_risc        [string trim [element::get_value $form_name rct_tratt_in_risc]]
    set rct_tratt_in_acs         [string trim [element::get_value $form_name rct_tratt_in_acs]]
    set rct_install_interna      [string trim [element::get_value $form_name rct_install_interna]]
    set rct_install_esterna      [string trim [element::get_value $form_name rct_install_esterna]]
    set rct_canale_fumo_idoneo   [string trim [element::get_value $form_name rct_canale_fumo_idoneo]]
    set rct_sistema_reg_temp_amb [string trim [element::get_value $form_name rct_sistema_reg_temp_amb]]
    set rct_assenza_per_comb     [string trim [element::get_value $form_name rct_assenza_per_comb]]
    set rct_idonea_tenuta         [string trim [element::get_value $form_name rct_idonea_tenuta]]
    set rct_valv_sicurezza        [string trim [element::get_value $form_name rct_valv_sicurezza]]
    set rct_scambiatore_lato_fumi [string trim [element::get_value $form_name rct_scambiatore_lato_fumi]]
    set rct_riflussi_comb         [string trim [element::get_value $form_name rct_riflussi_comb]]
    set rct_uni_10389             [string trim [element::get_value $form_name rct_uni_10389]]
    set rct_rend_min_legge        [string trim [element::get_value $form_name rct_rend_min_legge]]
    set rct_modulo_termico        [string trim [element::get_value $form_name rct_modulo_termico]]
    set rct_check_list_1          [string trim [element::get_value $form_name rct_check_list_1]]
    set rct_check_list_2          [string trim [element::get_value $form_name rct_check_list_2]]
    set rct_check_list_3          [string trim [element::get_value $form_name rct_check_list_3]]
    set rct_check_list_4          [string trim [element::get_value $form_name rct_check_list_4]]
    set rct_gruppo_termico        [string trim [element::get_value $form_name rct_gruppo_termico]]
    set rct_lib_uso_man_comp      [string trim [element::get_value $form_name rct_lib_uso_man_comp]]
    set data_prox_manut           [string trim [element::get_value $form_name data_prox_manut]];#san04
    set locale                    [element::get_value $form_name locale];#sim17
    set elet_esercizio_1        [string trim [element::get_value $form_name elet_esercizio_1       ]];#gac04
    set elet_esercizio_2        [string trim [element::get_value $form_name elet_esercizio_2       ]];#gac04
    set elet_esercizio_3        [string trim [element::get_value $form_name elet_esercizio_3       ]];#gac04
    set elet_esercizio_4        [string trim [element::get_value $form_name elet_esercizio_4       ]];#gac04
    set elet_lettura_iniziale   [string trim [element::get_value $form_name elet_lettura_iniziale  ]];#gac04
    set elet_lettura_finale     [string trim [element::get_value $form_name elet_lettura_finale    ]];#gac04
    set elet_consumo_totale     [string trim [element::get_value $form_name elet_consumo_totale    ]];#gac04
    set elet_lettura_iniziale_2 [string trim [element::get_value $form_name elet_lettura_iniziale_2]];#gac04
    set elet_lettura_finale_2   [string trim [element::get_value $form_name elet_lettura_finale_2  ]];#gac04
    set elet_consumo_totale_2   [string trim [element::get_value $form_name elet_consumo_totale_2  ]];#gac04

    if {$flag_mod_gend == "S"} {
	set modello          [element::get_value $form_name modello]
	set matricola        [element::get_value $form_name matricola]
	set tipo_a_c         [element::get_value $form_name tipo_a_c]
	set costruttore      [element::get_value $form_name costruttore]
	set tiraggio         [element::get_value $form_name tiraggio]
	set combustibile     [element::get_value $form_name combustibile]
	set destinazione     [element::get_value $form_name destinazione]
	set data_insta       [element::get_value $form_name data_insta]
	set locale           [element::get_value $form_name locale]
	set data_costruz_gen [element::get_value $form_name data_costruz_gen]
	set marc_effic_energ [element::get_value $form_name marc_effic_energ]
	set volimetria_risc  [element::get_value $form_name volimetria_risc]
	set consumo_annuo    [element::get_value $form_name consumo_annuo]
	set consumo_annuo2   [element::get_value $form_name consumo_annuo2]
	set stagione_risc    [element::get_value $form_name stagione_risc]
	set stagione_risc2   [element::get_value $form_name stagione_risc2]
	set acquisti         [element::get_value $form_name acquisti] ;#gac01
	set scorta_o_lett_iniz [element::get_value $form_name scorta_o_lett_iniz] ;#gac01
	set scorta_o_lett_fin  [element::get_value $form_name scorta_o_lett_fin] ;#gac01
	set acquisti2          [element::get_value $form_name acquisti2] ;#gac01
        set scorta_o_lett_iniz2 [element::get_value $form_name scorta_o_lett_iniz2] ;#gac01
        set scorta_o_lett_fin2  [element::get_value $form_name scorta_o_lett_fin2] ;#gac01
	set potenza          [element::get_value $form_name potenza]
	set elet_esercizio_1        [element::get_value $form_name elet_esercizio_1       ];#gac04
	set elet_esercizio_2        [element::get_value $form_name elet_esercizio_2       ];#gac04
	set elet_esercizio_3        [element::get_value $form_name elet_esercizio_3       ];#gac04
	set elet_esercizio_4        [element::get_value $form_name elet_esercizio_4       ];#gac04
	set elet_lettura_iniziale   [element::get_value $form_name elet_lettura_iniziale  ];#gac04
	set elet_lettura_finale     [element::get_value $form_name elet_lettura_finale    ];#gac04
	set elet_consumo_totale     [element::get_value $form_name elet_consumo_totale    ];#gac04
	set elet_lettura_iniziale_2 [element::get_value $form_name elet_lettura_iniziale_2];#gac04
	set elet_lettura_finale_2   [element::get_value $form_name elet_lettura_finale_2  ];#gac04
	set elet_consumo_totale_2   [element::get_value $form_name elet_consumo_totale_2  ];#gac04
	set flag_clima_invernale    [element::get_value $form_name flag_clima_invernale   ];#gac05
	set flag_prod_acqua_calda   [element::get_value $form_name flag_prod_acqua_calda  ];#gac05
	if {$coimtgen(regione) eq "MARCHE"} {#gac08
	    set descr_cost              [element::get_value $form_name descr_cost];#gac08
	    set descr_comb              [element::get_value $form_name descr_comb];#gac08
	    set tiraggio_gen            [element::get_value $form_name tiraggio_gen];#gac08
	    set tipo_a_c_gen            [element::get_value $form_name tipo_a_c_gen];#gac08
	    set desc_grup_term          [element::get_value $form_name desc_grup_term];#gac08
	    set flag_clima_invernale_gen [element::get_value $form_name flag_clima_invernale_gen];#gac08
	    set flag_prod_acqua_calda_gen   [element::get_value $form_name flag_prod_acqua_calda_gen];#gac08
	} 	
	#ns_return 200 text/html "bubu4|$combustibile|$data_insta|" ; return

        #Imposto ora le options di cod_mode perchè solo adesso ho a disposizione la var. costruttore
	if {![string is space $costruttore]} {
	    element set_properties $form_name cod_mode -options [iter_selbox_from_table "coimmode where cod_cost = '[db_quote $costruttore]'" cod_mode descr_mode];#nic01
	}
        set cod_mode         [element::get_value $form_name cod_mode];#nic01
    } else {
	#Nicola 23/06/2014: se $flag_mod_gend == "N" devo valoriz. la var. tiraggio
	#altrimenti il pgm va in errore perche' in tal caso non viene letta la var. tiraggio
	#Andava in errore su iterprfi-dev (ho trovato la soluzione nel sorgente
	#coimdimp-g-gest personalizzato)
        if {[string equal $gen_prog ""]} {
            db_1row query "select min(gen_prog) as gen_prog
                             from coimgend
                            where flag_attivo = 'S'
                              and cod_impianto = :cod_impianto"
	    if {$gen_prog eq ""} {
                set gen_prog 1
            }
        }
	if {![db_0or1row query "select a.tiraggio
                                     , c.descr_comb as combustibile
                                     , a.tipo_foco  as tipo_a_c -- 14/10/2014 per CBARLETTA
                                   --  C'era su PFI ma finche' non va in errore non lo uso
                                   --, a.cod_combustibile
                                  from coimgend a
                            inner join coimaimp b on b.cod_impianto     = a.cod_impianto
                             left join coimcomb c on c.cod_combustibile = b.cod_combustibile
                                 where a.cod_impianto = :cod_impianto
                                   and a.gen_prog     = :gen_prog"]
	} {
	    set tiraggio     ""
	    set combustibile ""
	}
    }

    #sim66 aggiunto condizione su tipo combustibile
    if {$combustibile eq "12" || 
	$combustibile eq "6"  ||
	$combustibile eq "0"  ||
	$combustibile eq "2"  ||
        [db_0or1row q "select 1 from coimcomb where cod_combustibile=:combustibile and tipo='S' limit 1"]
     } {#sim24                         
	set conbustibile_solido "S"
    } else {
	set conbustibile_solido "N"
    }

    set pot_focolare_nom [element::get_value $form_name pot_focolare_nom]
    element set_properties $form_name garanzia         -value $garanzia
    element set_properties $form_name conformita       -value $conformita
    element set_properties $form_name lib_impianto     -value $lib_impianto
    element set_properties $form_name lib_uso_man      -value $lib_uso_man
    element set_properties $form_name inst_in_out      -value $inst_in_out
    element set_properties $form_name idoneita_locale  -value $idoneita_locale
    element set_properties $form_name ap_ventilaz      -value $ap_ventilaz
    element set_properties $form_name ap_vent_ostruz   -value $ap_vent_ostruz
    element set_properties $form_name pendenza         -value $pendenza
    element set_properties $form_name sezioni          -value $sezioni
    element set_properties $form_name curve            -value $curve
    element set_properties $form_name lunghezza        -value $lunghezza
    element set_properties $form_name conservazione    -value $conservazione
    element set_properties $form_name scar_ca_si       -value $scar_ca_si
    element set_properties $form_name scar_can_fu      -value $scar_can_fu
    element set_properties $form_name scar_parete      -value $scar_parete
    element set_properties $form_name riflussi_locale  -value $riflussi_locale
    element set_properties $form_name assenza_perdite  -value $assenza_perdite
    element set_properties $form_name pulizia_ugelli   -value $pulizia_ugelli
    element set_properties $form_name antivento        -value $antivento
    element set_properties $form_name scambiatore      -value $scambiatore
    element set_properties $form_name accens_reg       -value $accens_reg
    element set_properties $form_name disp_comando     -value $disp_comando
    element set_properties $form_name ass_perdite      -value $ass_perdite
    element set_properties $form_name valvola_sicur    -value $valvola_sicur
    element set_properties $form_name vaso_esp         -value $vaso_esp
    element set_properties $form_name disp_sic_manom   -value $disp_sic_manom
    element set_properties $form_name organi_integri   -value $organi_integri
    element set_properties $form_name circ_aria        -value $circ_aria
    element set_properties $form_name guarn_accop      -value $guarn_accop
    element set_properties $form_name assenza_fughe    -value $assenza_fughe
    element set_properties $form_name coibentazione    -value $coibentazione
    element set_properties $form_name eff_evac_fum     -value $eff_evac_fum
    element set_properties $form_name cont_rend        -value $cont_rend
    element set_properties $form_name rct_dur_acqua             -value $rct_dur_acqua
    element set_properties $form_name rct_tratt_in_risc         -value $rct_tratt_in_risc
    element set_properties $form_name rct_tratt_in_acs          -value $rct_tratt_in_acs
    element set_properties $form_name rct_install_interna       -value $rct_install_interna
    element set_properties $form_name rct_install_esterna       -value $rct_install_esterna
    element set_properties $form_name rct_canale_fumo_idoneo    -value $rct_canale_fumo_idoneo
    element set_properties $form_name rct_sistema_reg_temp_amb  -value $rct_sistema_reg_temp_amb
    element set_properties $form_name rct_assenza_per_comb      -value $rct_assenza_per_comb
    element set_properties $form_name rct_idonea_tenuta         -value $rct_idonea_tenuta
    element set_properties $form_name rct_valv_sicurezza        -value $rct_valv_sicurezza
    element set_properties $form_name rct_scambiatore_lato_fumi -value $rct_scambiatore_lato_fumi
    element set_properties $form_name rct_riflussi_comb         -value $rct_riflussi_comb
    element set_properties $form_name rct_uni_10389             -value $rct_uni_10389
    element set_properties $form_name rct_rend_min_legge        -value $rct_rend_min_legge
    element set_properties $form_name rct_modulo_termico        -value $rct_modulo_termico
    element set_properties $form_name rct_check_list_1          -value $rct_check_list_1
    element set_properties $form_name rct_check_list_2          -value $rct_check_list_2
    element set_properties $form_name rct_check_list_3          -value $rct_check_list_3
    element set_properties $form_name rct_check_list_4          -value $rct_check_list_4
    element set_properties $form_name rct_gruppo_termico        -value $rct_gruppo_termico
    element set_properties $form_name rct_lib_uso_man_comp      -value $rct_lib_uso_man_comp
    element set_properties $form_name data_prox_manut           -value $data_prox_manut;#san04
    element set_properties $form_name cod_tprc                  -value $cod_tprc;#sim59
    element set_properties $form_name combustibile_dimp         -value $combustibile_dimp;#rom17
    set l_of_ls_um [db_list_of_lists q "
            select c.um
                 , c.um
              from coimcomb c
             where c.cod_combustibile = :combustibile_dimp
             union all
            select f.um_secondaria
                 , f.um_secondaria
              from coimcomb_fatt_conv f
             where f.cod_combustibile = :combustibile_dimp"]
	    
    set l_of_ls_um  [linsert $l_of_ls_um 0 [list "" ""]]

    element set_properties $form_name unita_misura_consumi  -options $l_of_ls_um;#rom18
    set vl_um_cns [db_string q "select um from coimcomb where cod_combustibile = :combustibile_dimp" -default ""];#rom18
    element set_properties $form_name unita_misura_consumi      -value $vl_um_cns;#rom18

    set conta 0
    while {$conta < 5} {
	incr conta
	set prog_anom($conta)   [element::get_value $form_name prog_anom.$conta]
	set cod_anom($conta)    [element::get_value $form_name cod_anom.$conta]
	set data_ut_int($conta) [element::get_value $form_name data_ut_int.$conta]
    }


    if {[string equal $__refreshing_p "1"]} {;#nic01
	
        if {$changed_field eq "costruttore"} {;#nic01
            set focus_field "$form_name.cod_mode";#nic01
        };#nic01
	#sim58 aggiunto condizione su $changed_field eq "cod_tprc"
	if {$changed_field eq "flag_status" || $changed_field eq "cod_tprc" || $changed_field eq "flag_pagato"} {;#sim19 if e suo contenuto
	    set focus_field "$form_name.costo"
	    eval $controllo_tariffa
	    ns_log notice "simone4 $tariffa $flag_status"
	    element set_properties $form_name costo            -value $tariffa
	    element set_properties $form_name esente           -value $esente
	}
 #but01 aggiunto la condizione is_active_p ='t'
	if {$coimtgen(regione) eq "MARCHE"} {#rom12 if e contenuto
	    set cod_manutentore_stru [db_string q "select cod_manutentore 
                                                     from coimmanu
                                                    where cod_manutentore = :cod_manutentore" -default ""]
	
	element set_properties $form_name cod_strumento_01 -options [iter_selbox_from_table_wherec coimstru_manu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '0' and is_active_p ='f'"] 
	
	element set_properties $form_name cod_strumento_02 -options [iter_selbox_from_table_wherec coimstru_manu cod_strumento "marca_strum||' - '||modello_strum||' - '||matr_strum" "tipo_strum" "where cod_manutentore = '$cod_manutentore_stru' and tipo_strum = '1' and is_active_p ='f'"]
	
	}
    
	if {$changed_field eq "cont_rend" && $cont_rend eq "N"} {#gac07
	    
	    element set_properties $form_name rct_rend_min_legge -value ""
	    element::set_error     $form_name rct_rend_min_legge ""
	    element set_properties $form_name rct_modulo_termico -value ""


	    set conta_prfumi 0;#rom01

	    while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
		incr conta_prfumi
		if {$conta_prfumi > 9} {
		    break
		}
		element set_properties $form_name rct_rend_min_legge.$conta_prfumi -value ""
		element::set_error     $form_name rct_rend_min_legge.$conta_prfumi ""
		element set_properties $form_name rct_modulo_termico.$conta_prfumi -value ""

	    }
	    

	}

	if {$changed_field eq "combustibile_dimp"} {#rom18 Aggiunta if e suo contenuto
	    
	    #Se cambia il combustibile devo rileggermi le unita' di misura secondarie per poter calcolare i consumi
	    set l_of_ls_um [db_list_of_lists q "
            select c.um
                 , c.um
              from coimcomb c
             where c.cod_combustibile = :combustibile_dimp
             union all
            select f.um_secondaria
                 , f.um_secondaria
              from coimcomb_fatt_conv f
             where f.cod_combustibile = :combustibile_dimp"]
	    
	    set l_of_ls_um  [linsert $l_of_ls_um 0 [list "" ""]]
    
	    element set_properties $form_name unita_misura_consumi -options $l_of_ls_um;#rom18
	    set vl_um_cns [db_string q "select um from coimcomb where cod_combustibile = :combustibile_dimp" -default ""];#rom18
	    element set_properties $form_name unita_misura_consumi      -value $vl_um_cns;#rom18
	    set focus_field "$form_name.combustibile_dimp"
	}
	
	if {$changed_field eq "unita_misura_consumi"} {#rom18 Aggiunta if e suo contenuto
	    #$combustibile_dimp-$unita_misura_consumi
	    if {[db_0or1row q "select 1
                                 from coimcomb
                                where cod_combustibile = :combustibile_dimp
                                  and um              != :unita_misura_consumi"]} {
		element::set_error $form_name unita_misura_consumi "Il consumo inserito verr&agrave; trasformato nell'unit&agrave; di misura prevista in Curmit."

	    }
	    
	    set focus_field "$form_name.unita_misura_consumi"
	}
	
        element set_properties $form_name __refreshing_p -value 0;#nic01
        element set_properties $form_name changed_field  -value "";#nic01
	set tipo_comb [db_string q "select tipo from coimcomb where cod_combustibile = :combustibile" -default ""]

        ad_return_template;#nic01
        return;#nic01
    };#nic01

    
    set error_num 0


    #if {$flag_portafoglio == "T" && $funzione == "I"} {
    #	if {[string equal $__refreshing_p 0] || [string equal $__refreshing_p ""]} {
    #	} else {
    #	    set error_num 1
    #	    if {$tariffa_reg == "8"} {
    #		set importo_tariffa "0,00"
    #	    } else {
    #		if {[db_0or1row sel_tari_contributo ""] == 0} {
    #		    set importo_tariffa ""
    #		}
    #	    }
    #	    element set_properties $form_name importo_tariffa   -value $importo_tariffa
    #	    set __refreshing_p "0"
    #	    element set_properties $form_name __refreshing_p   -value $__refreshing_p
    #	}
    #}    
    # gen_prog e num_bollo non sono piu' usati, valorizzati sempre a null

    set num_bollo ""

    # controlli standard su numeri e date, per Ins ed Upd
    set flag_errore_data_controllo "f"

    if {$riferimento_pag eq "0"} {#sim12: aggiunta if e suo contenuto
	set riferimento_pag ""
    }

    if {$flag_gest_targa eq "T"} {#sim13: aggiunta if e suo contenuto
	
	if {![db_0or1row query "
            select targa
              from coimaimp
             where cod_impianto        = :cod_impianto
               and coalesce(targa,'') != ''"]
	} {
	    #nic08 
	    element::set_error $form_name num_autocert "Inserire la targa dell'impianto nei dati generali"
	    #nic08 
	    incr error_num
	}
    }

    if {$flag_portafoglio == "T"} {
	if {![string equal $importo_tariffa ""]} {
	    set importo_tariffa [iter_check_num $importo_tariffa 2]
	    if {$importo_tariffa == "Error"} {
		element::set_error $form_name importo_tariffa "Deve essere numerico, max 2 dec"
		incr error_num
	    } else {
		if {[iter_set_double $importo_tariffa] >=  [expr pow(10,7)]
		    ||  [iter_set_double $importo_tariffa] <= -[expr pow(10,7)]} {
		    element::set_error $form_name importo_tariffa "Deve essere inferiore di 10.000.000"
		    incr error_num
		}
	    }
	} else {
	    set importo_tariffa "0"
	}	
    }

    set sw_costo_null "f"
    if {![string equal $costo ""]} {
	set costo [iter_check_num $costo 2]
	if {$costo == "Error"} {
	    element::set_error $form_name costo "Deve essere numerico, max 2 dec"
	    incr error_num
	} else {
	    if {[iter_set_double $costo] >=  [expr pow(10,7)] || [iter_set_double $costo] <= -[expr pow(10,7)]} {
		element::set_error $form_name costo "Deve essere inferiore di 10.000.000"
		incr error_num
	    } else {
		if {$costo == 0} {
		    set sw_costo_null "t"
		}
	    }
	}
    } else {
	set sw_costo_null "t"
    }
    
#rom07    if {$funzione == "I" && $coimtgen(ente) ne "PPD"} {
#rom07
#rom07	db_transaction {;#sim32
#rom07
#rom07	    set dml_upd_tppt [db_map upd_tppt]
#rom07	    db_dml dml_upd_tppt $dml_upd_tppt
#rom07	    set n_prot [db_string query "select descr || '/' || progressivo from coimtppt where cod_tppt = 'UC'"]
#rom07	    
#rom07	}
#rom07	#sim32 set n_prot [db_string query "select descr || '/' || progressivo + 1 from coimtppt where cod_tppt = 'UC'"]
#rom07	set data_prot [db_string query "select iter_edit_data(current_date)"]
#rom07    }
    
    if {$funzione == "I" || $funzione == "M"} {
        set sw_pot_focolare_nom_ok ""

	# dob cind
	if {$flag_cind == "S" && $cod_cind == "" && $funzione == "I"} {
	    element::set_error $form_name cod_cind "Inserire campagna di riferimento"
	    incr error_num	    
	}
        #routine generica per controllo codice manutentore
        set check_cod_manu {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_manu ""
            set ctr_manu         0
            if {[string equal $chk_inp_cognome ""]} {
                set eq_cognome "is null"
	    } else {
		set eq_cognome "= upper(:chk_inp_cognome)"
	    }
	    if {[string equal $chk_inp_nome ""]} {
		set eq_nome    "is null"
	    } else {
		set eq_nome    "= upper(:chk_inp_nome)"
	    }
	    
	    db_foreach sel_manu "" {
		incr ctr_manu
		if {$cod_manutentore == $chk_inp_cod_manu} {
		    set chk_out_cod_manu $cod_manutentore
		    set chk_out_rc       1
		}
	    }
            switch $ctr_manu {
		0 { set chk_out_msg "Soggetto non trovato"}
		1 { set chk_out_cod_manu $cod_manutentore
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
		}
	    }
	}

        set check_cod_opma {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_opma ""
            set ctr_opma         0
            if {[string equal $chk_inp_cognome ""]} {
                set eq_cognome "is null"
	    } else {
		set eq_cognome "= upper(:chk_inp_cognome)"
	    }
	    if {[string equal $chk_inp_nome ""]} {
		set eq_nome    "is null"
	    } else {
		set eq_nome    "= upper(:chk_inp_nome)"
	    }
	    db_foreach sel_opma "" {
		incr ctr_opma
		if {$cod_opma == $chk_inp_cod_opma} {
		    set chk_out_cod_opma $cod_opma
		    set chk_out_rc       1
		}
	    }
	    switch $ctr_opma {
		0 { set chk_out_msg "Soggetto non trovato"}
		1 { set chk_out_cod_opma $cod_opma
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
		}
	    }
	}
    	
        if {[string equal $cognome_manu ""] && [string equal $nome_manu ""]} {
	    element::set_error $form_name cognome_manu "Inserire il manutentore"
            incr error_num
	} else {
	    if {[string equal $cognome_manu ""] && [string equal $nome_manu ""]} {
		set cod_manutentore ""
	    } else {
		set chk_inp_cod_manu $cod_manutentore
		set chk_inp_cognome  $cognome_manu
		set chk_inp_nome     $nome_manu
		eval $check_cod_manu
		set cod_manutentore  $chk_out_cod_manu
		if {$chk_out_rc == 0} {
		    element::set_error $form_name cognome_manu $chk_out_msg
		    incr error_num
		}
	    }
	}
    	
	#cod_opma obbligatorio   	
	if {$cod_opmanu_new eq ""} {
	    
	    if {$coimtgen(regione) eq "CAMPANIA" && $id_utente_ma eq "MA"} {#rom33 Aggiunta if e contenuto
		element::set_error $form_name cognome_opma "Devi utilizzare il Cerca"
                incr error_num
	    } else {#rom33 Aggiunta else ma non il suo contenuto
		# La provincia di Livorno ha chiesto il 23/07/2014 che l'operatore non sia obblig.
		# La provincia di Venezia l'ha chiesto il 04/08/2014
		# La provincia di Caserta l'ha chiesto il 04/08/2014
		# Publies (PPO e iterprfi_pu) l'ha chiesto il 01/09/2014
		# Barletta l'ha chiesto il 01/02/2017
		# Salerno ha il tecnico obbligatorio solo per i manutentori e non per l'ente
		# rom13 sostituito $coimtgen(ente) eq "PSA" con $coimtgen(regione) eq "CAMPANIA"
		#rom36 tolta condizione su Regione Campania, ho fatto if a parte qua sopra
		if {$coimtgen(ente) ne "PLI"
		    &&  $coimtgen(ente) ne "PVE"
		    &&  $coimtgen(ente) ne "PCE"
		    &&  $coimtgen(ente) ne "PPO"
		    &&  ![string match "*iterprfi_pu*" [db_get_database]]
		    &&  $coimtgen(ente) ne "PPD"
		    &&  $coimtgen(ente) ne "PBT"
		    &&  $coimtgen(ente) ne "CCARRARA"
                    &&  $coimtgen(regione) ne "CAMPANIA"
		} {
		    element::set_error $form_name cognome_opma "Devi utilizzare il Cerca"
		    incr error_num
		}
		#![string equal $cognome_opma ""] && ![string equal $nome_opma ""]
		# set cod_opma ""
	    };#rom33
	} else {
	    set chk_inp_cod_opma $cod_opma
	    set chk_inp_cognome  $cognome_opma
	    set chk_inp_nome     $nome_opma
	    eval $check_cod_opma
	    set cod_opma  $chk_out_cod_opma
	    if {$chk_out_rc == 0} {
		element::set_error $form_name cognome_opma $chk_out_msg
		incr error_num
	    }
	}
	
        #routine generica per controllo codice soggetto
        set check_cod_citt {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_citt ""
            set ctr_citt         0
            if {[string equal $chk_inp_cognome ""]} {
                set eq_cognome "is null"
	    } else {
                set eq_cognome "= upper(:chk_inp_cognome)"
	    }
            if {[string equal $chk_inp_nome ""]} {
                set eq_nome    "is null"
	    } else {
                set eq_nome    "= upper(:chk_inp_nome)"
	    }
            db_foreach sel_citt "" {
                incr ctr_citt
                if {$cod_cittadino == $chk_inp_cod_citt} {
		    set chk_out_cod_citt $cod_cittadino
                    set chk_out_rc       1
		}
	    }
            switch $ctr_citt {
 		0 { set chk_out_msg "Soggetto non trovato"}
	 	1 { set chk_out_cod_citt $cod_cittadino
		    set chk_out_rc       1 }
		default {
                    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
 		}
	    }
 	}
	
        if {[string equal $cognome_resp ""] &&  [string equal $nome_resp ""]} {
            set cod_responsabile ""
	} else {
	    set chk_inp_cod_citt $cod_responsabile
	    set chk_inp_cognome  $cognome_resp
	    set chk_inp_nome     $nome_resp
	    eval $check_cod_citt
            set cod_responsabile $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_resp $chk_out_msg
                incr error_num
	    }
	}

        if {[string equal $cognome_prop ""] && [string equal $nome_prop ""]} {
            set cod_proprietario ""
	} else {
	    set chk_inp_cod_citt $cod_proprietario
	    set chk_inp_cognome  $cognome_prop
	    set chk_inp_nome     $nome_prop
	    eval $check_cod_citt
            set cod_proprietario $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_prop $chk_out_msg
                incr error_num
	    }
	}
	
        if {[string equal $cognome_occu ""] && [string equal $nome_occu ""]} {
            set cod_occupante ""
	} else {
	    set chk_inp_cod_citt $cod_occupante
	    set chk_inp_cognome  $cognome_occu
	    set chk_inp_nome     $nome_occu
	    eval $check_cod_citt
            set cod_occupante    $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_occu $chk_out_msg
                incr error_num
	    }
	}
	
        if {[string equal $cognome_contr ""] && [string equal $nome_contr ""]} {
            set cod_int_contr ""
	} else {
	    set chk_inp_cod_citt $cod_int_contr
	    set chk_inp_cognome  $cognome_contr
	    set chk_inp_nome     $nome_contr
	    eval $check_cod_citt
            set cod_int_contr    $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_contr $chk_out_msg
                incr error_num
	    }
	}
	
	if {![string equal $volimetria_risc ""]} {
	    set volimetria_risc [iter_check_num $volimetria_risc 2]
            if {$volimetria_risc == "Error"} {
                element::set_error $form_name volimetrica_risc "Volumetria stanza misurata deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num 
	    }
	}
	
	if {![string equal $consumo_annuo ""]} {
	    set consumo_annuo [iter_check_num $consumo_annuo 2]
            if {$consumo_annuo == "Error"} {
                element::set_error $form_name consumo_annuo "Consumo annuo deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num	    
	    }
	}
	
	if {![string equal $consumo_annuo2 ""]} {
	    set consumo_annuo2 [iter_check_num $consumo_annuo2 2]
	    if {$consumo_annuo2 == "Error"} {
		element::set_error $form_name consumo_annuo2 "Consumo annuo deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num	    
	    }
	}
	
	set sw_data_controllo_ok "f"
        if {[string equal $data_controllo ""]} {
	    set flag_errore_data_controllo "t"
            element::set_error $form_name data_controllo "Inserire Data controllo"
            incr error_num
        } else {
            set data_controllo [iter_check_date $data_controllo]
            if {$data_controllo == 0} {
		set flag_errore_data_controllo "t"
                element::set_error $form_name data_controllo "Data controllo deve essere una data"
                incr error_num
            } else {
		if {$data_controllo > $current_date} {
		    set flag_errore_data_controllo "t"
		    element::set_error $form_name data_controllo "Data controllo deve essere inferiore alla data odierna"
		    incr error_num
		}

		#rom26if {$data_controllo < "20180501" && 
		#    $flag_portafoglio == "T"     &&
                #    ($coimtgen(ente) eq "PUD" || 
                #    $coimtgen(ente) eq "PGO" || 
                #    $coimtgen(ente) eq "PTS" || 
                #    $coimtgen(ente) eq "PPN")} {}#sim59 if e suo contenuto
                if {$data_controllo < "20180501" &&
                    $flag_portafoglio == "T"     &&
                    $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom26 agiunta if ma non contenuto
		    set flag_errore_data_controllo "t"
		    if {$coimtgen(regione) eq "MARCHE"} {#gac07
			element::set_error $form_name err_rcee "Non è possibile inserire con il bollino virtuale gli RCEE effettuati nel periodo precedente al 01 Maggio 2018."
		    } else {
			element::set_error $form_name data_controllo "Non è possibile inserire con il bollino virtuale gli RCEE effettuati nel periodo precedente al 01 Maggio 2018."
		    }
		    incr error_num
		}	
		set comune_impianto [db_string sel_aimp_comu ""];#rom26
                if {$coimtgen(ente) eq "PUD" && $comune_impianto eq "140" && $data_controllo < "20210101"} {#rom26 if e suo contenuto
		    
                    set flag_errore_data_controllo "t"
                    element::set_error $form_name data_controllo "Non è possibile inserire con il bollino virtuale gli RCEE del comune di Udine antecedenti alla data del 01/01/2021. Utilizzare la fuzione \"RCEE senza bollino virtuale\""
                    incr error_num
                }
		
                if {$coimtgen(ente) eq "CTRIESTE" && $data_controllo < "20210101"} {#rom26 aggiunta if e contenuto
                    #Il comune di Trieste deve inserire con i bollini fino al 31/12/2020
                    set flag_errore_data_controllo "t"
                    element::set_error $form_name data_controllo "Gli RCEE effettuati nel Comune di Trieste nel periodo precedente al 01 Gennaio 2021 vanno inseriti con la funzione RCEE senza bollino virtuale"
                    incr error_num
                }
		
                if {$coimtgen(ente) eq "CPORDENONE" && $data_controllo < "20210101"} {#sim23 aggiunta if e contenuto
                    #Il comune di Pordenone deve inserire il pregresso (fino al 31/12/2020) senza usare il portafoglio
                    set flag_errore_data_controllo "t"
                    element::set_error $form_name data_controllo "Gli RCEE effettuati nel Comune di Pordenone nel periodo precedente al 01 Gennaio 2021 vanno inseriti con la funzione RCEE senza bollino virtuale"
                    incr error_num
                }

            }
	    
	}
	if {$coimtgen(regione) eq "MARCHE"} {
	    if {[string equal $data_ultima_manu ""]} {#gac07 aggiunta if else e loro contenuto
		set flag_errore_data_ultima_manu "t"
		element::set_error $form_name data_ultima_manu "Inserire Data ultima manutenzione ordinaria effettuata"
		incr error_num
	    } else {
		set data_ultima_manu [iter_check_date $data_ultima_manu]
		if {$data_ultima_manu == 0} {
		    element::set_error $form_name data_ultima_manu "Data ultima manutenzione ordinaria effettuata deve essere uan data"
		    incr error_num
		} else {#gac07 aggiunto else e suo contenuto
		    if {$coimtgen(regione) eq "MARCHE"} {#gac07
			if {$data_ultima_manu > $data_controllo} {
			    element::set_error $form_name data_ultima_manu "Data ultima manutenzione ordinaria effettuata  deve essere inferiore alla data controllo"
			    incr error_num
			}
		    }
		}
	    }
	}
	#san08 aggiunto or su CCARRARA
	#sim64 aggiunto or su PTS e PPN
	#rom03 corretto or su PTS e PPN
	#rom26if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO" || $coimtgen(ente) eq "CCARRARA" || $coimtgen(ente) eq "PPN" || $coimtgen(ente) eq "PTS"} {}
        if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" || $coimtgen(ente) eq "CCARRARA"} {#rom26 aggiunta if ma non contenuto
	    # Per Udine e Gorizia e carrara non va fatto il controllo sul codice fiscale
	} elseif {($coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CANCONA")  && $data_controllo < "20170516"} {;#san11
            # Per ancona non va fatto il controllo sul codice fiscale se pima del 15 maggio 2017
        } else {
	    # Caso Standard
	    if {$flag_errore_data_controllo == "f" && $data_controllo >= "20090801"} {
		if {[db_0or1row query "select natura_giuridica as natura_r, cod_fiscale as fisc_r, cod_piva as piva_r, stato_nas from coimcitt where cod_cittadino = :cod_responsabile"]} {
		    set fisc_r [string trim $fisc_r]

		    if {$natura_r eq "F"} {#ric01 aggiunta if ma non il contenuto , else e contenuto
			if {$stato_nas eq "1"} {#san01
			    #sim Salerno non vuole il controllo sul CF. Personalizzazione da tenere
			    #rom13 sostiuito $coimtgen(ente) ne "PSA" con $cpoimtgen(regione) ne "CAMPANIA"
			    if {$fisc_r eq "" && $coimtgen(regione) ne "CAMPANIA"} {
			    element::set_error $form_name cognome_resp "Il responsabile non ha il Codice Fiscale: dato obbligatorio"
				incr error_num
			    }
			};#san01
		    } else {
			if {$piva_r eq "" && $coimtgen(regione) ne "CAMPANIA"} {
                            element::set_error $form_name cognome_resp "Il responsabile non ha la partita IVA: e' obbligatoria per i modelli con data controllo superiore al 31 Luglio 2009"
                            incr error_num
                        };#ric01
		    }
		}
	    }
	}
	
	if {$funzione eq "I"} {
	    set data_per_calcolo_scadenza "";#sim54
	    if {$id_utente_ma eq "MA" && $flag_errore_data_controllo eq "f"} {
		# set oggi50 [db_string query "select :data_controllo::date + 50" -default ""]
		# set oggi50 [clock format [clock scan "$ggad" -base [clock scan $data_controllo]] -f "%Y%m%d"]
		#sim14 aggiunto || su CALABRIA
		#sim21 tolto && $coimtgen(ente) ne "PRC" su la || della calabria
		#sim35 aggiunto || su Barletta
		#sim39 affiunto || su comune di Carrara
		set num_gg_post_data_controllo_per_messaggio 45

		#sim54 aggiunto condizione potenza_old < 35
		#sim67 aggiunto condizione && 1==0
		if {$potenza_old < 35 && $coimtgen(ente) eq "PTA" && 1==0} {#sim53
		    set num_gg_post_data_scadenza_per_messaggio 120
		    
		    db_0or1row q "select max(d.data_scadenza) as data_ultima_scadenza 
                           from coimdimp d
                              , coimgend g
                          where d.cod_impianto   = :cod_impianto
                            and d.gen_prog      <= :gen_prog
                            and g.gen_prog       = d.gen_prog
                            and d.cod_impianto   = g.cod_impianto
                            and d.flag_tracciato = 'R1'"

		    
		    if {$data_ultima_scadenza ne ""} {#sim54
			set data_per_calcolo_scadenza $data_ultima_scadenza;#sim54

			#la data scadenza deve essere la fine del mese successivo
			set data_ultima_scadenza [db_string a "select (:data_ultima_scadenza::date + interval '2 month')::date"];#sim54
			set data_ultima_scadenza [db_string a "select (:data_ultima_scadenza::date -  interval '[string range $data_ultima_scadenza 8 10] day')::date"];#sim54   
			
			set giorni_dalla_scadenza [db_string a "select date_part('day', current_timestamp - coalesce(:data_ultima_scadenza::timestamp,current_timestamp))"]
		    db_1row sel_edit_data "select iter_edit_data(:data_ultima_scadenza) as data_ultima_scadenza_edit"

			if {$giorni_dalla_scadenza >= $num_gg_post_data_scadenza_per_messaggio} {
			    element::set_error $form_name num_autocert "Non è possibile inserire rapporti di controllo tecnico oltre i $num_gg_post_data_scadenza_per_messaggio giorni dalla data di scadenza dell'ultima dichiarazione ($data_ultima_scadenza_edit)"
			    incr error_num
			}
						
		    } else {#sim54 else e suo contenuto
		
			if {![db_0or1row q "select 1
                                              from coimgend
                                             where cod_impianto   = :cod_impianto
                                               and gen_prog       = :gen_prog
                                               and data_installaz = :data_controllo"]} {
			    element::set_error $form_name num_autocert "Non è possibile inserire il rapporto di controllo tecnico per una incongruenza di date. Per procedere rivolgersi all'ente."
			    incr error_num
			    
			}
			
			set data_per_calcolo_scadenza  ""
		    }
		}

#sim70 tolto               ||  $coimtgen(ente) eq "PBT"

                if {$coimtgen(ente)    eq "PFI"
		||  $coimtgen(ente)    eq "PPO"
		||  [string match "*iterprfi_pu*" [db_get_database]]
		||  $coimtgen(ente)    eq "CRIMINI"
                ||  $coimtgen(ente)    eq "CBARLETTA"
                ||  $coimtgen(regione) eq "MARCHE"
                ||  $coimtgen(ente) eq "PTA"
		||  $coimtgen(regione) eq "CALABRIA"
                ||  $coimtgen(ente) eq "CCARRARA"
		} {#Sandro 24/07/2014
		    set oggi50 [clock format [clock scan "$data_controllo +2000 days"] -format "%Y%m%d"];#Sandro 24/07/2014

		} elseif {$coimtgen(ente) eq "PBT"} {#sim70 if e suo contenuto
		    set oggi50 [clock format [clock scan "$data_controllo +60 days"] -format "%Y%m%d"]
		    set num_gg_post_data_controllo_per_messaggio 60

		} elseif {$coimtgen(regione) eq "CAMPANIA"} {#san16 if e suo contenuto
		    #rom08set oggi50 [clock format [clock scan "$data_controllo +180 days"] -format "%Y%m%d"]
		    #rom08set num_gg_post_data_controllo_per_messaggio 180
		    #rom39set oggi50 [clock format [clock scan "$data_controllo +900 days"] -format "%Y%m%d"];#rom08
		    #rom39set num_gg_post_data_controllo_per_messaggio 900;#rom08
		    set oggi50 [clock format [clock scan "$data_controllo + 1200 days"] -format "%Y%m%d"];#rom39
		    set num_gg_post_data_controllo_per_messaggio 1200;#rom39

		} elseif {$coimtgen(ente) eq "PLI"} {#Sandro 28/07/2014
		    
		    if {$current_date <= 20160331} {#sim03 Aggiunta if e suo comtenuto
			set num_gg_post_data_controllo_per_messaggio 90
		    } else {
			set num_gg_post_data_controllo_per_messaggio 31
		    }
		    set oggi50 [clock format [clock scan "$data_controllo + $num_gg_post_data_controllo_per_messaggio  days"] -format "%Y%m%d"];#sim03
		    #sim03 set oggi50 [clock format [clock scan "$data_controllo +60   days"] -format "%Y%m%d"];#Sandro 28/07/2014
		    #sim03 set num_gg_post_data_controllo_per_messaggio 60
		} elseif {$coimtgen(ente) eq "CTRIESTE"} {#sim57
		    set num_gg_post_data_controllo_per_messaggio 90
	
		    set oggi50 [clock format [clock scan "$data_controllo + $num_gg_post_data_controllo_per_messaggio  days"] -format "%Y%m%d"]
		    
		} elseif {$coimtgen(ente) eq "PPA"} {#ric01 Aggiunta elseif e contenuto
		    #rom37set num_gg_post_data_controllo_per_messaggio 500
		    set num_gg_post_data_controllo_per_messaggio 750;#rom37
		    set oggi50 [clock format [clock scan "$data_controllo + $num_gg_post_data_controllo_per_messaggio  days"] -format "%Y%m%d"]
		} else {#Sandro 24/07/2014
		    set oggi50 [clock format [clock scan "$data_controllo +50   days"] -format "%Y%m%d"]
		};#Sandro 24/07/2014
		if {$current_date > $oggi50} {
		    if {$coimtgen(ente) eq "PLI"
		    &&  $current_date   <= "20160630"
		    } {#nic07
			if {$data_controllo < "20160101" || $data_controllo > "20160229"} {#nic07: aggiunta if ed il suo contenuto
                            # Qui entra se la data_controllo e' piu' vecchia di 31 gg e
                            # non e' compresa tra il 01/01/2016 ed il 29/02/2016.
                            element::set_error $form_name num_autocert "Non è possibile inserire rapporti di controllo tecnico oltre i $num_gg_post_data_controllo_per_messaggio giorni dalla data di effettuazione del controllo (ad eccezione dei rapporti di controllo tecnico rilasciati dal 01/01/2016 al 29/02/2016)"
                            incr error_num
                        }
                    } else {#nic07
                        # caso standard
			element::set_error $form_name num_autocert "Non è possibile inserire rapporti di controllo tecnico oltre i $num_gg_post_data_controllo_per_messaggio giorni dalla data di effettuazione del controllo"
			incr error_num
		    };#nic07
		}
	    }
	}

	# Nel caso di due impianti differenti con stesso indirizzo che
	# vengono inseriti come un solo impianto e che di conseguenza
	# ci troviamo con un impianto con potenza < 35 kW e due generatori,
	# permettiamo l'inserimento di piu' modelli h nella stessa data
	if {[string equal $data_controllo ""]} {
	    set where_gen_prog " and gen_prog is null"
	} else {
	    set where_gen_prog " and gen_prog = :gen_prog"
	}
	
	if {$flag_errore_data_controllo == "f"} {
	    if {$funzione == "I"
	    &&  [db_0or1row sel_dimp_check_data_controllo ""] != 0
	    } {
		set flag_errore_data_controllo "t"
		element::set_error $form_name data_controllo "Esiste gi&agrave; un mod. con questa data"
		incr error_num
	    } else {
		set sw_data_controllo_ok "t"
	    }
	}
	
	if {[string equal $gen_prog ""]} {
	    # set gen_prog 1
            db_1row query "select min(gen_prog) as gen_prog
                             from coimgend
                            where flag_attivo = 'S'
                              and cod_impianto = :cod_impianto"
            if {$gen_prog eq ""} {
                set gen_prog 1
            }

      	}
	#ns_log notice "bubu3|$data_insta|"
	#sandro 080512
	#	if {$flag_mod_gend == "S"} {
	#	    if {$data_insta == ""} {
	#		db_0or1row sel_data_insta_gen "select coalesce(iter_edit_data(data_installaz), '01/01/1900') as data_insta from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_prog"
	#	    }
	#	}
	#fine sandro

	#Nicola 23/06/2014: se $flag_mod_gend == "N" devo valoriz. la var. data_insta
	#altrimenti il pgm va in errore perche' in tal caso non viene letta la var. data_insta
	#Andava in errore su iterprfi-dev (ho trovato la soluzione nel sorgente
	#coimdimp-g-gest personalizzato)
	if {$flag_mod_gend == "N"} {
	    if {![db_0or1row query "select data_installaz as data_insta
                                      from coimgend
                                     where cod_impianto = :cod_impianto
                                       and gen_prog = :gen_prog"]
	    } {
		set data_insta ""
	    } else {
		set data_insta [string range $data_insta 0 3][string range $data_insta 5 6][string range $data_insta 8 9]
		set data_insta [iter_edit_date $data_insta]
	    }
	}

	set err_insta 0
	if {$data_insta ne ""} {
	    set data_insta_contr [iter_check_date $data_insta]
	    if {$data_insta_contr == 0} {
		set err_insta 1
	    }
	} else {
	    set err_insta 1
	}

	if {$flag_portafoglio == "T"} {
	    if {$sw_data_controllo_ok == "t" && $err_insta == 0} {
		if {$data_controllo < "20080801"} {
		    set importo_tariffa "0.00"
		    set tariffa_reg ""
		} else {
		    set dat_inst_gend [iter_check_date $data_insta]
		    if {![string equal $dat_inst_gend ""]} {
			set data_insta_check [db_string sel_dat "select to_char(add_months(:dat_inst_gend, '1'), 'yyyymmdd')"]
			if {$data_controllo <= $data_insta_check} {
                            #rom26if {$coimtgen(ente) ne "PUD" &&
                            #   $coimtgen(ente) ne "PGO" &&
                            #   $coimtgen(ente) ne "PPN" &&
                            #   $coimtgen(ente) ne "PTS"} {}#sim62 aggiunto if
                            if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom26 aggiunta if ma non il contenuto
				set importo_tariffa "0.00"
				set tariffa_reg "8"
			    }
			}
		    }
		}
	    }
	}
	#ns_log notice " mariano  $data_insta"

	if  {[string equal $sw_data_controllo_ok "t"] && $err_insta == 0} {
	    #set anno_insta [expr [string range $data_insta 6 9] + 1]
	    #set data_insta_contr [string range $data_insta 0 5]$anno_insta
            #set data_insta_contr [iter_check_date $data_insta_contr]
	    set dat_inst_gend [iter_check_date $data_insta]
	    #set data_insta_contr [db_string query "select :dat_inst_gend::date + 365" -default ""]
	    
	    #	    if {$data_controllo > $data_insta_contr
	    #			&& [string equal $riferimento_pag ""]
	    #	    } {
            db_1row sel_tgen_boll "select flag_bollino_obb from coimtgen"
	    #san13 aggiunto condizione su esente
	    eval $controllo_tariffa;#sim47

	    if {$tipologia_costo == "BO"
		&& [string equal $riferimento_pag ""]
		&& $flag_bollino_obb == "T"
                && $esente eq "f"} {
		element::set_error $form_name riferimento_pag "Inserire n. bollino"
		incr error_num
	    }
	    #	    }
	}
	
        if {$coimtgen(ente) eq "PLI"
        && [string equal $riferimento_pag ""] && $flag_errore_data_controllo eq "f"
        } {

            if {![db_0or1row q "select 1
                                  from coimdimp
                                 where cod_impianto   = :cod_impianto
                                   and data_controllo = :data_controllo
                                   and gen_prog      != :gen_prog"]} {;#sim25
		element::set_error $form_name riferimento_pag "Bollino obbligatorio"
		incr error_num
	    };#sim25
        }

        if {![string equal $pot_focolare_mis ""]} {
            set pot_focolare_mis [iter_check_num $pot_focolare_mis 2]
            if {$pot_focolare_mis == "Error"} {
                element::set_error $form_name pot_focolare_mis "Potenza focolare misurata deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
		if {$pot_focolare_mis == "0,00"} {
		    element::set_error $form_name pot_focolare_mis "La potenza deve essere maggiore di 0,00"
		    incr error_num
		}
                if {[iter_set_double $pot_focolare_mis] >=  [expr pow(10,4)]
		    ||  [iter_set_double $pot_focolare_mis] <= -[expr pow(10,4)]} {
                    element::set_error $form_name pot_focolare_mis "Potenza focolare misurata deve essere inferiore di 10.000"
                    incr error_num
                }
            }
        }
	
	#sandro 230513
	if {[string equal $tiraggio "N"]
	    && [string equal $assenza_perdite  "S"]} {
	    element::set_error $form_name assenza_perdite "Incongruenza con il tiraggio"
	    incr error_num
	    
	}
	
	if {[string equal $tiraggio "F"]
	    && [string equal $riflussi_locale  "S"]} {
	    element::set_error $form_name riflussi_locale "Incongruenza con il tiraggio"
	    incr error_num
	    
	}
	#sandro fine

        if {![string equal $portata_comb_mis ""]} {
            set portata_comb_mis [iter_check_num $portata_comb_mis 2]
            if {$portata_comb_mis == "Error"} {
                element::set_error $form_name portata_comb_mis "Portata combustibile misurata deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $portata_comb_mis] >=  [expr pow(10,4)]
		    ||  [iter_set_double $portata_comb_mis] <= -[expr pow(10,4)]} {
                    element::set_error $form_name portata_comb_mis "Portata combustibile misurata deve essere inferiore di 10.000"
                    incr error_num
                }
            }
        }

	#gac07 aggiunto controllo sui campi flag_clima_invernale e flag_prod_acqua_calda
	if {$coimtgen(regione) eq "MARCHE"} {
	    if {[string equal $flag_clima_invernale ""]} {
		element::set_error $form_name flag_clima_invernale_gen "Inserire"
		incr error_num
	    }
	    if {[string equal $flag_prod_acqua_calda ""]} {
		element::set_error $form_name flag_prod_acqua_calda_gen "Inserire"
		incr error_num
	    }
	}

	#sim24 Spostato in alto perchè altrimenti andava in errore la modifica fatta da Missora nell'adp in caso di refresh
	#if {$combustibile eq "12" || 
	#    $combustibile eq "6"  ||
	#    $combustibile eq "0"  ||
	#    $combustibile eq "2"} {#sim18 if else e loro contenuto
	#    set conbustibile_solido "S"
	#} else {
	#    set conbustibile_solido "N"
	#}

	if {![db_0or1row q "select tipo as tipo_comb
                                 , descr_comb
                              from coimcomb
                             where cod_combustibile = :combustibile"]} {
	    set tipo_comb  ""
	    set descr_comb ""
	};#gac07
	
	if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom35 Aggiunta if e il contenuto

	    if {![string equal $tiraggio_fumi ""] && (![string equal $tiraggio "N"] || !($tipo_comb in [list "G" "L"]))} {
		element::set_error $form_name tiraggio_fumi "Attenzione: la depressione nel canale da fumo va indicata solo per generatori a tiraggio naturale alimentati a gas o liquidi."
		incr error_num
		
	    }
	} else {#rom35 Aggiunta else ma non il suo contenuto
	    
	    if {![string equal $tiraggio_fumi ""] && (![string equal $tiraggio "N"] || $tipo_comb ne "G")} {#gac07 aggiunta if e contenuto
		element::set_error $form_name tiraggio_fumi "Attenzione: la depressione nel canale da fumo va indicata solo per generatori a tiraggio naturale alimentati a gas"
		incr error_num
		
	    }
	};#rom35	
		
	# se il flag prova di combustione e' valorizzato a SI, obbligo 
        # l'inserimento dei valori numerici riguardanti il controllo dei 
        # fumi. per ora il bacharach non lo rendo obligatorio essendo un 
        # valore riferito agli impianti a combustibile liquido.
	#gac07    && $co <1000 
	#rom31 Aggiunti i combustibili ARIA PROPANATA, GNL e SYNGAS
	#rom31 Riscritta if utilizzando il comando in per i valori della variabile descr_comb
	#rom31if {$cont_rend == "S"
	#rom31&& ($descr_comb eq "METANO" || $descr_comb eq "PROPANO" || $descr_comb eq "GPL" || $descr_comb eq "BUTANO" || $descr_comb eq "GASOLIO" || $descr_comb eq "OLIO")
	#rom31} {}
	if {$cont_rend == "S"
	    && ($descr_comb in [list "METANO" "PROPANO" "GPL" "BUTANO" "GASOLIO" "OLIO" "ARIA PROPANATA" "GNL" "SYNGAS"])} {#rom31 Aggiunta if ma non il suo contenuto
	    #san06: aggiunta || "0"
	    if {[string equal $temp_fumi ""] || [string equal $temp_fumi "0"]} {
		element::set_error $form_name temp_fumi "Inserire"
		incr error_num
	    }
	    
	    #san06: aggiunta || "0"
	    if {[string equal $temp_ambi ""] || [string equal $temp_ambi "0"]} {
		element::set_error $form_name temp_ambi "Inserire"
		incr error_num
	    }
	    
	    #san06: aggiunta || "0"
	    if {[string equal $o2 ""] || [string equal $o2 "0"]} {
		element::set_error $form_name o2 "Inserire"
		incr error_num		
	    }
	    
	    if {[string equal $co2 ""]} {
		element::set_error $form_name co2 "Inserire"
		incr error_num		
	    }
	    
	    #san06: aggiunta || "0"
	    if {[string equal $rend_combust ""] || [string equal $rend_combust "0"]} {
		element::set_error $form_name rend_combust "Inserire"
		incr error_num		
	    }
	    
	    #san06: aggiunta || "0"
	    if {[string equal $rct_rend_min_legge ""] || [string equal $rct_rend_min_legge "0"]} {
		element::set_error $form_name rct_rend_min_legge "Inserire"
		incr error_num		
	    }
	    
	    if {[info exist gend_zero] && $gend_zero == 0} {
		set tipo_a_c         ""
	    }
	    
	    #modifica assurda per dpr 74 Tiraggio solo per GAS METANO
	    #ns_return 200 text/html "$combustibile"
	    if {$tipo_comb == "G"} {#gac07 modificata if che deve valere per tutti i combustibili gassosi e non solo metano (prima tipo_combustibile == "5")
		if {[info exist tiraggio] && [string equal $tiraggio "N"] &&
		    [info exist tipo_a_c] && [string equal $tipo_a_c "A"]} {
		    if {[string equal $tiraggio_fumi ""]} {
			element::set_error $form_name tiraggio_fumi "Inserire"
			incr error_num
		    }
		}
	    }	    
	    
	    if {[string equal $tiraggio_fumi ""] && $tipo_comb eq "G" && $tiraggio eq "N"} {#gac07 aggiunta if e suo contenuto
		element::set_error $form_name tiraggio_fumi "Inserire"
		incr error_num
	    }
	    
	    if {[string equal $co ""]} {
		element::set_error $form_name co "Inserire"
		incr error_num
	    }
	    if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom30bis Aggiunta if ma non il suo contenuto
		if {[string equal $co_fumi_secchi_ppm ""]} {#rom04 if e contenuto 
		    element::set_error $form_name co_fumi_secchi_ppm "Inserire"
		    incr error_num
		}
	    };#rom30bis	    
	    if {$co_fumi_secchi eq ""} {
		element::set_error $form_name co_fumi_secchi "Inserire"
		incr error_num
	    }

   
	    #gac07 if e suo contenuto
	    if {$coimtgen(regione) eq "MARCHE" && [iter_check_num $o2 2] ne "Error" && [iter_check_num $co_fumi_secchi_ppm 2] ne "Error"} {
	#rom15 Standardizzati i controlli.	
	#rom15	if {[iter_check_num $rend_combust 2] > [iter_check_num $rct_rend_min_legge 2] && $rend_magg_o_ugua_rend_min eq "N"} {#gac07
	#rom15	    element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
	#rom15	    incr error_num
	#rom15	}
		
	#rom15	if {[iter_check_num $rend_combust 2] < [iter_check_num $rct_rend_min_legge 2] && $rend_magg_o_ugua_rend_min eq "S"} {#gac07
	#rom15	    element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
	#rom15	    incr error_num
	#rom15	}
		#rom10 aggiunta condizione su o2 < di 21
		#sim78 come indicato dalla Regione la tolleranza passa da 1% a 5%
		if {$co_fumi_secchi_ppm  ne "" && $o2 ne "" && $o2 < "21.00"} {
 		    set co_corretto [expr (21 / (21 - [iter_check_num $o2 2])) * [iter_check_num $co_fumi_secchi_ppm 2]]
 		    #sim78 set co_perc_inf [expr $co_corretto - ($co_corretto * 1 / 100)]
 		    #sim78 set co_perc_sup [expr $co_corretto + ($co_corretto * 1 / 100)]
		    set co_perc_inf [expr $co_corretto - ($co_corretto * 5 / 100)];#sim78
 		    set co_perc_sup [expr $co_corretto + ($co_corretto * 5 / 100)];#sim78
		    
 		    if {[iter_check_num $co 2] < $co_perc_inf || [iter_check_num $co 2] > $co_perc_sup} {
 			element set_properties $form_name warning_co_corretto -value "<font color=blue><b>Attenzione: Valori di CO fumi secchi e CO corretto incoerenti</b></font>"
 		    } else {
 			element set_properties $form_name warning_co_corretto -value ""
 		    }
 		}
 	    }
 	}

	
	#rom15 Standardizzati controlli su Rendimento di Combustione.
	if {[iter_check_num $rend_combust 2] > [iter_check_num $rct_rend_min_legge 2] && $rend_magg_o_ugua_rend_min eq "N"} {#rom15
	    element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
	    incr error_num
	}
	if {[iter_check_num $rend_combust 2] < [iter_check_num $rct_rend_min_legge 2] && $rend_magg_o_ugua_rend_min eq "S"} {#rom15
                    element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
                    incr error_num
	}

	set impianto_puo_funzionare t;#rom15 
	if {$coimtgen(regione) ne "MARCHE"} {#rom15 aggiunta if e contenuto
	    if {[string equal $co_fumi_secchi "N"] || [string equal $rend_magg_o_ugua_rend_min "N"]} {
	    
		# Se i fumi secchi non superano la soglia minima
		# allora l'impianto non puo' funzionare.
		set impianto_puo_funzionare f
		
	    }
	    if {[string equal $flag_status "P"] && !$impianto_puo_funzionare} {
		
		element::set_error $form_name flag_status "ATTENZIONE!! l'impianto non pu&ograve; funzionare se:<br>
                                                       <li>Il rendimento non supera la % minima di legge.</li>
                                                       <li>CO fumi secchi e senz'aria non &egrave; <= 1.000 ppm v/v.</li>"
		incr error_num
	    }
	}


#	if {$rispetta_indice_bacharach eq ""} {
#	    element::set_error $form_name rispetta_indice_bacharach "Inserire"
#	    incr error_num
#	}
	
	if {$coimtgen(regione) eq "MARCHE"} {#gac01 aggiunta if e suo contenuto
	    if {$cod_strumento_01 eq "" && $cont_rend eq "S"} {#gac01
		element::set_error $form_name cod_strumento_01 "Inserire"
		incr error_num
	    };#gac0
	    #rom30if {$rend_magg_o_ugua_rend_min eq "" && $cont_rend eq "S"} {
		#rom30element::set_error $form_name rend_magg_o_ugua_rend_min "Inserire"
		#rom30incr error_num
	    #rom30}

	};#gac01

	if {$rend_magg_o_ugua_rend_min eq "" && $cont_rend eq "S"} {#rom30 Messo il controllo per tutti
	    element::set_error $form_name rend_magg_o_ugua_rend_min "Inserire"
	    incr error_num
	}


	if {[iter_check_num $co 2] > "1000" && $co_fumi_secchi eq "S"} {
	    element::set_error $form_name co_fumi_secchi "Scelta incongruente con i valori inseriti."
	    incr error_num
	} elseif {[iter_check_num $co 2] < "1000" && $co_fumi_secchi eq "N"} {
	    element::set_error $form_name co_fumi_secchi "Scelta incongruente con i valori inseriti."
	    incr error_num
	}

#	if {$bacharach > "2" && $rispetta_indice_bacharach eq "S"} {
#	    element::set_error $form_name rispetta_indice_bacharach "Impossibile valorizzare a Sì.<br>Il valore di \"Bacharach\" è maggiore di 2"
#	    incr error_num
#	}

	if {$coimtgen(regione) eq "MARCHE"} {
	    if {$bacharach eq "" && $bacharach2 eq "" && $bacharach3 eq "" && ($descr_comb eq "GASOLIO" || $descr_comb eq "OLIO") && $cont_rend eq "S"} {#gac07 aggiunta if e suo contenuto
		element::set_error $form_name bacharach "Inserire"
		incr error_num
	    } elseif {$descr_comb ne "GASOLIO" && $descr_comb ne "OLIO"} {
		if {$bacharach ne "" || $bacharach2 ne "" || $bacharach3 ne "" } {

		    element::set_error $form_name bacharach "Non inserire"
		    incr error_num
		}
	    }
	    
	    if {$descr_comb == "GASOLIO"} {#gac07 aggiunta if elseif e contenuto
		if {$bacharach <= "2" && $bacharach2 <= "2" && $rispetta_indice_bacharach eq "N"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach <= "2" && $bacharach3 <= "2" && $rispetta_indice_bacharach eq "N"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach2 <= "2" && $bacharach3 <= "2" && $rispetta_indice_bacharach eq "N"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach > "2" && $bacharach2 > "2" && $rispetta_indice_bacharach eq "S"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach > "2" && $bacharach3 > "2" && $rispetta_indice_bacharach eq "S"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach2 > "2" && $bacharach3 > "2" && $rispetta_indice_bacharach eq "S"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		}
	    } elseif {$descr_comb == "OLIO"} {#gac07
		if {$bacharach <= "6" && $bacharach2 <= "6" && $rispetta_indice_bacharach eq "N"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach <= "6" && $bacharach3 <= "6" && $rispetta_indice_bacharach eq "N"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach2 <= "6" && $bacharach3 <= "6" && $rispetta_indice_bacharach eq "N"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach > "6" && $bacharach2 > "6" && $rispetta_indice_bacharach eq "S"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach > "6" && $bacharach3 > "6" && $rispetta_indice_bacharach eq "S"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		} elseif {$bacharach2 > "6" && $bacharach3 > "6" && $rispetta_indice_bacharach eq "S"} {
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		}
	    }
	    
	    if {$descr_comb eq "GASOLIO" || $descr_comb eq "OLIO" } {
		if {$rispetta_indice_bacharach eq "" && $cont_rend eq "S"} {#gac07
		    element::set_error $form_name rispetta_indice_bacharach "Inserire"
		    incr error_num
		}
	    }
	    
	    if {$rispetta_indice_bacharach eq "N" && $rct_uni_10389 eq "S"} {#gac07
		element::set_error $form_name rct_uni_10389 "Scelta incongruente con i valori inseriti."
		incr error_num
	    }
	    if {$bacharach eq "" && $bacharach2 eq "" && $bacharach3 eq "" && $rispetta_indice_bacharach ne ""} {#gac07
		element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		incr error_num
	    }
	    
	    if {$rct_uni_10389 eq "S" && $co_fumi_secchi eq "N"} {#gac07
		element::set_error $form_name rct_uni_10389 "Scelta incongruente con i valori inseriti."
		incr error_num
	    }
	    
	    
	    if {$rend_magg_o_ugua_rend_min eq "N" && $rct_uni_10389 eq "S"} {#gac07
		element::set_error $form_name rct_uni_10389 "Scelta incongruente con i valori inseriti."
		incr error_num
	    }

	    if {$descr_comb eq "GASOLIO"} {
		if {$rct_uni_10389 eq "N" && $rispetta_indice_bacharach eq "S" && $co_fumi_secchi eq "S" && $rend_magg_o_ugua_rend_min eq "S"} {#gac07
		    element::set_error $form_name rct_uni_10389 "Scelta incongruente con i valori inseriti."
		    incr error_num
		}
	    } else {
		if {$rct_uni_10389 eq "N" && $co_fumi_secchi eq "S" && $rend_magg_o_ugua_rend_min eq "S"} {#gac07
		    element::set_error $form_name rct_uni_10389 "Scelta incongruente con i valori inseriti."
		    incr error_num
		}
	    }
	    
	}
	#rom01 ripeto i controlli per le prove aggiuntive
	set conta_prfumi 0
	while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
            incr conta_prfumi
            if {$conta_prfumi > 9} {
                break
            }
	    
	    if {![string equal $tiraggio_fumi_prfumi($conta_prfumi) ""] && $tipo_comb ne "G"} {#gac07 if e suo contenuto
		element::set_error $form_name tiraggio_fumi.$conta_prfumi "Attenzione: la depressione nel canale da fumo va indicata solo per generatori alimentati a gas"
		incr error_num
	    }
	    
	    
	    # se il flag prova di combustione e' valorizzato a SI, obbligo 
	    # l'inserimento dei valori numerici riguardanti il controllo dei 
	    # fumi. per ora il bacharach non lo rendo obligatorio essendo un 
	    # valore riferito agli impianti a combustibile liquido.
	    #gac07 && $co_prfumi($conta_prfumi) <1000
	    #rom31 Aggiunti combustibili ARIA PROPANATA, GNL e SYNGAS
	    #rom31 Riscritta if utilizzando il comando in per i valori della variabile descr_comb
	    #rom31if {$cont_rend == "S" && ($descr_comb eq "METANO" || $descr_comb eq "PROPANO" || $descr_comb eq "GPL" || $descr_comb eq "BUTANO" || $descr_comb eq "GASOLIO" || $descr_comb eq "OLIO")
	    #rom31} {}
	    if {$cont_rend == "S" && ($descr_comb in [list "METANO" "PROPANO" "GPL" "BUTANO" "GASOLIO" "OLIO" "ARIA PROPANATA" "GNL" "SYNGAS"])} {#rom31 Aggiunta if ma non il suo contenuto
	    
		if {[string equal $temp_fumi_prfumi($conta_prfumi) ""] || [string equal $temp_fumi_prfumi($conta_prfumi) "0"]} {
		    element::set_error $form_name temp_fumi.$conta_prfumi "Inserire"
		    incr error_num
		}
		
		if {[string equal $temp_ambi_prfumi($conta_prfumi) ""] || [string equal $temp_ambi_prfumi($conta_prfumi) "0"]} {
		    element::set_error $form_name temp_ambi.$conta_prfumi "Inserire"
		    incr error_num
		}
		
		if {[string equal $o2_prfumi($conta_prfumi) ""] || [string equal $o2_prfumi($conta_prfumi) "0"]} {
		    element::set_error $form_name o2.$conta_prfumi "Inserire"
		    incr error_num		
		}
		
		if {[string equal $co2_prfumi($conta_prfumi) ""]} {
		    element::set_error $form_name co2.$conta_prfumi "Inserire"
		    incr error_num		
		}

		if {[string equal $rend_combust_prfumi($conta_prfumi) ""] || [string equal $rend_combust_prfumi($conta_prfumi) "0"]} {
		    element::set_error $form_name rend_combust.$conta_prfumi "Inserire"
		    incr error_num		
		}
		
		if {[string equal $rct_rend_min_legge_prfumi($conta_prfumi) ""] || [string equal $rct_rend_min_legge_prfumi($conta_prfumi) "0"]} {
		    element::set_error $form_name rct_rend_min_legge.$conta_prfumi "Inserire"
		    incr error_num		
		}
		
#		if {$bacharach_prfumi($conta_prfumi) > 2 && $rispetta_indice_bacharach eq "S"} {
#                    element::set_error $form_name rispetta_indice_bacharach "Bacharach è maggiore di 2"
#                    incr error_num
#               }

#		if {$bacharach2_prfumi($conta_prfumi) > 2 && $rispetta_indice_bacharach eq "S"} {
#		    element::set_error $form_name rispetta_indice_bacharach "Bacharach è maggiore di 2"
#		    incr error_num
#		}
#		if {$bacharach3_prfumi($conta_prfumi) > 3 && $rispetta_indice_bacharach eq "S"} {
#                   element::set_error $form_name rispetta_indice_bacharach "Bacharach è maggiore di 3"
#                    incr error_num
#                }

		if {$coimtgen(regione) eq "MARCHE"} {
		    if {$cont_rend == "S" && $bacharach_prfumi($conta_prfumi) eq "" && $bacharach2_prfumi($conta_prfumi)  eq "" && $bacharach3_prfumi($conta_prfumi) eq "" && $flag_mod_gend eq "N" && ($descr_combustibile eq "GASOLIO" || $descr_combustibile eq "OLIO")} {
			element::set_error $form_name bacharach.$conta_prfumi "Inserire"
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) ne "" || $bacharach2_prfumi($conta_prfumi) ne "" || $bacharach3_prfumi($conta_prfumi) ne ""} {
			element::set_error $form_name bacharach.$conta_prfumi "Non inserire"
			incr error_num
		    }
		}
		
		if {[info exist gend_zero] && $gend_zero == 0} {
		    set tipo_a_c         ""
		}
		
		if {$tipo_comb == "G"} {#gac07 modificata if perche deve valere per tutti i tipi gassosi e non solo per il metano
		    if {[info exist tiraggio] && [string equal $tiraggio "N"] &&
			[info exist tipo_a_c] && [string equal $tipo_a_c "A"]} {
			if {[string equal $tiraggio_fumi_prfumi($conta_prfumi) ""]} {
			    element::set_error $form_name tiraggio_fumi.$conta_prfumi "Inserire"
			    incr error_num
			}
		    }
		}
		
		if {[string equal $tiraggio_fumi_prfumi($conta_prfumi) ""] && $tipo_comb eq "G" && $tiraggio eq "N"} {#gac07 if e contenuto
		    element::set_error $form_name tiraggio_fumi.$conta_prfumi "Inserire"
		    incr error_num
		}
		
		
		if {[string equal $co_prfumi($conta_prfumi) ""]} {
		    element::set_error $form_name co.$conta_prfumi "Inserire"
		    incr error_num
		}
		if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom30bis Aggiunta if ma non il suo contenuto
		    if {[string equal $co_fumi_secchi_ppm_prfumi($conta_prfumi) ""]} {
			element::set_error $form_name co_fumi_secchi_ppm.$conta_prfumi "Inserire"
			incr error_num
		    }
		};#rom30bis
 		if {[iter_check_num $co_prfumi($conta_prfumi) 2] > "1000" && $co_fumi_secchi eq "S"} {
		    element::set_error $form_name co_fumi_secchi "Scelta incongruente con i valori inseriti."
		    incr error_num
		}  elseif {[iter_check_num $co_prfumi($conta_prfumi) 2] < "1000" && $co_fumi_secchi eq "N"} {
		    element::set_error $form_name co_fumi_secchi "Scelta incongruente con i valori inseriti."
		    incr error_num
		}

		
 		if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunta if e suo contenuto
		    #rom15if {[iter_check_num $rend_combust_prfumi($conta_prfumi) 2] > [iter_check_num $rct_rend_min_legge_prfumi($conta_prfumi) 2] && $rend_magg_o_ugua_rend_min eq "N"} {#gac07
		    #rom15element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
		    #rom15incr error_num
		    #rom15}
		    
		    #rom15if {[iter_check_num $rend_combust_prfumi($conta_prfumi) 2] < [iter_check_num $rct_rend_min_legge_prfumi($conta_prfumi) 2] && $rend_magg_o_ugua_rend_min eq "S"} {#gac07
		    #rom15element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
		    #rom15incr error_num
		    #rom15}

		    #sim78 come indicato dalla Regione la tolleranza passa da 1% a 5%
 		    if {$co_fumi_secchi_ppm_prfumi($conta_prfumi)  ne "" && $o2_prfumi($conta_prfumi) ne ""} {
 			set co_corretto_prfumi [expr (21 / (21 - [iter_check_num $o2_prfumi($conta_prfumi) 2])) * [iter_check_num $co_fumi_secchi_ppm_prfumi($conta_prfumi) 2]]
 			#sim78 set co_perc_inf_prfumi [expr $co_corretto_prfumi - ($co_corretto_prfumi * 1 / 100)]
 			#sim78 set co_perc_sup_prfumi [expr $co_corretto_prfumi + ($co_corretto_prfumi * 1 / 100)]
			set co_perc_inf_prfumi [expr $co_corretto_prfumi - ($co_corretto_prfumi * 5 / 100)];#sim78
			set co_perc_sup_prfumi [expr $co_corretto_prfumi + ($co_corretto_prfumi * 5 / 100)];#sim78
						
 			if {[iter_check_num $co_prfumi($conta_prfumi) 2] < $co_perc_inf_prfumi || [iter_check_num $co_prfumi($conta_prfumi) 2] > $co_perc_sup_prfumi} {
 			    element set_properties $form_name warning_co_corretto.$conta_prfumi -value "<font color=blue><b>Attenzione: Valori di CO fumi secchi e CO corretto incoerenti</b></font>"
 			}  else {#sim78 aggiunta sua else e suo contenuto
			    element set_properties $form_name warning_co_corretto.$conta_prfumi -value ""
			}
			
 		    }
 		}
	    }
	    
	    if {$coimtgen(regione) eq "MARCHE"} {
		if {$descr_comb == "GASOLIO"} {#gac07 aggiunta if else if e contenuto
		    if {$bacharach_prfumi($conta_prfumi) <= "2" && $bacharach2_prfumi($conta_prfumi) <= "2" && $rispetta_indice_bacharach eq "N"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) <= "2" && $bacharach3_prfumi($conta_prfumi) <= "2" && $rispetta_indice_bacharach eq "N"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach2_prfumi($conta_prfumi) <= "2" && $bacharach3_prfumi($conta_prfumi) <= "2" && $rispetta_indice_bacharach eq "N"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) > "2" && $bacharach2_prfumi($conta_prfumi) > "2" && $rispetta_indice_bacharach eq "S"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) > "2" && $bacharach3_prfumi($conta_prfumi) > "2" && $rispetta_indice_bacharach eq "S"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach2_prfumi($conta_prfumi) > "2" && $bacharach3_prfumi($conta_prfumi) > "2" && $rispetta_indice_bacharach eq "S"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    }
		} elseif {$descr_comb == "OLIO"} {#gac07
		    if {$bacharach_prfumi($conta_prfumi) <= "6" && $bacharach2_prfumi($conta_prfumi) <= "6" && $rispetta_indice_bacharach eq "N"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) <= "6" && $bacharach3_prfumi($conta_prfumi) <= "6" && $rispetta_indice_bacharach eq "N"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach2_prfumi($conta_prfumi) <= "6" && $bacharach3_prfumi($conta_prfumi) <= "6" && $rispetta_indice_bacharach eq "N"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) > "6" && $bacharach2_prfumi($conta_prfumi) > "6" && $rispetta_indice_bacharach eq "S"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach_prfumi($conta_prfumi) > "6" && $bacharach3_prfumi($conta_prfumi) > "6" && $rispetta_indice_bacharach eq "S"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    } elseif {$bacharach2_prfumi($conta_prfumi) > "6" && $bacharach3_prfumi($conta_prfumi) > "6" && $rispetta_indice_bacharach eq "S"} {
			element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
			incr error_num
		    }
		}
		if {$bacharach_prfumi($conta_prfumi) eq "" && $bacharach2_prfumi($conta_prfumi) eq "" && $bacharach3_prfumi($conta_prfumi) eq "" && $rispetta_indice_bacharach ne ""} {#gac07
		    element::set_error $form_name rispetta_indice_bacharach "Scelta incongruente con i valori inseriti."
		    incr error_num
		}
		
	    }
	}
    
	if {![string equal $rct_dur_acqua ""]} {
	    set rct_dur_acqua [iter_check_num $rct_dur_acqua 2]
	    if {$rct_dur_acqua == "Error"} {
		element::set_error $form_name rct_dur_acqua "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
            } else {
                if {[iter_set_double $rct_dur_acqua] >=  [expr pow(10,8)]
	        ||  [iter_set_double $rct_dur_acqua] <= -[expr pow(10,8)]
		} {
                    element::set_error $form_name rct_dur_acqua "Deve essere inferiore di 100.000.000"
                    incr error_num
		}
	    }
	}

	if {![string equal $temp_fumi ""]} {
	    set temp_fumi [iter_check_num $temp_fumi 2]
	    if {$temp_fumi == "Error"} {
		element::set_error $form_name temp_fumi "Temperatura fumi deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $temp_fumi] >=  [expr pow(10,4)]
		    ||  [iter_set_double $temp_fumi] <= -[expr pow(10,4)]} {
		    element::set_error $form_name temp_fumi "Temperatura fumi deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}
	
	if {![string equal $temp_ambi ""]} {
	    set temp_ambi [iter_check_num $temp_ambi 2]
	    if {$temp_ambi == "Error"} {
		element::set_error $form_name temp_ambi "Temperatura ambiente deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $temp_ambi] >=  [expr pow(10,4)]
		    ||  [iter_set_double $temp_ambi] <= -[expr pow(10,4)]} {
		    element::set_error $form_name temp_ambi "Temperatura ambiente deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}
	
	#rom01 ripeto i controlli per le prove aggiuntive
        set conta_prfumi 0
        while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
            incr conta_prfumi
            if {$conta_prfumi > 9} {
                break
            }
	
	    if {![string equal $temp_fumi_prfumi($conta_prfumi) ""]} {
		set temp_fumi_prfumi($conta_prfumi) [iter_check_num $temp_fumi_prfumi($conta_prfumi) 2]
		if {$temp_fumi_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name temp_fumi.$conta_prfumi "Temperatura fumi deve essere numerico e pu&ograve; avere al massimo 2 decimali" 
		    incr error_num
		} else {
		    if {[iter_set_double $temp_fumi_prfumi($conta_prfumi)] >=  [expr pow(10,4)]
			||  [iter_set_double $temp_fumi_prfumi($conta_prfumi)] <= -[expr pow(10,4)]} {
			element::set_error $form_name temp_fumi.$conta_prfumi "Temperatura fumi deve essere inferiore di 10.000"
			incr error_num
		    }
		}
	    }
	    if {![string equal $temp_ambi_prfumi($conta_prfumi) ""]} {
		set temp_ambi_prfumi($conta_prfumi) [iter_check_num $temp_ambi_prfumi($conta_prfumi) 2]
		if {$temp_ambi_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name temp_ambi.$conta_prfumi "Temperatura ambiente deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		    incr error_num
		} else {
		    if {[iter_set_double $temp_ambi_prfumi($conta_prfumi)] >=  [expr pow(10,4)]
			||  [iter_set_double $temp_ambi_prfumi($conta_prfumi)] <= -[expr pow(10,4)]} {
			element::set_error $form_name temp_ambi.$conta_prfumi "Temperatura ambiente deve essere inferiore di 10.000"
			incr error_num
		    }
		}
	    }
	} ;#rom01

	
	if {$flag_mod_gend == "S"} {
	    if {![string equal $data_insta ""]} {
		set data_insta [iter_check_date $data_insta]
		if {$data_insta == 0} {
		    element::set_error $form_name data_insta "Data installazione errata"
		    incr error_num
		}
	    } else {
		element::set_error $form_name data_insta "Data installazione mancante"
		incr error_num
	    }
	    if {![string equal $data_costruz_gen ""]} {
		set data_costruz_gen [iter_check_date $data_costruz_gen]
		if {$data_costruz_gen == 0} {
		    element::set_error $form_name data_costruz_gen "Data costr. deve essere una data"
		    incr error_num
		}
	    }
#	    if {$costruttore == ""} {
#		element::set_error $form_name costruttore "Costruttore obbligatorio"
#		incr error_num
#	    }

            if {$coimtgen(flag_gest_coimmode) eq "F"} {;#nic01
		if {$modello == ""} {
		    element::set_error $form_name modello "Modello obbligatorio"
		    incr error_num
		}
            } else {;#nic01
                if {$cod_mode eq ""} {;#nic01
                    element::set_error $form_name cod_mode "Modello obbligatorio";#nic01
                    incr error_num;#nic01
                } else {;#nic01
                    # Devo comunque valorizzare la colonna coimgend.modello
                    if {![db_0or1row query "select descr_mode as modello
                                              from coimmode
                                             where cod_mode = :cod_mode"]
                    } {#nic01
                        element::set_error $form_name cod_mode "Modello non trovato in anagrafica";#nic01
                        incr error_num;#nic01
                    };#nic01
                };#nic01
            };#nic01

	    if {$matricola == ""} {
		element::set_error $form_name matricola "Matricola obbligatoria"
		incr error_num
	    }
#	    if {$combustibile == ""} {
#		element::set_error $form_name combustibile "Combustibile obbligatorio"
#		incr error_num
#	    }

	    if {$coimtgen(ente)    eq "PFI"} {;##sim30

		if {$tiraggio == ""} {;#sim30
		    element::set_error $form_name tiraggio "Tiraggio obbligatorio"
		    incr error_num
		}

		if {$tipo_a_c  == ""} {;#sim30
		    element::set_error $form_name tipo_a_c "Tipo obbligatorio"
		    incr error_num
		}
	    }

	} else {
	    # serena
	    ns_log notice "SERENA|$flag_mod_gend|$combustibile|$bacharach|"
	    set descr_combustibile [db_string query "select descr_comb from coimcomb where cod_combustibile = :combustibile" -default ""];#--- mis01 estratta descrizione e modificata condizione sotto (origine && $cobustibile=="GASOLIO")
	    if {$flag_mod_gend == "N" && $descr_combustibile eq "GASOLIO"} {
		if {$bacharach eq ""} {
		    element::set_error $form_name bacharach "Campo obbligatorio"
		    incr error_num
		}
	    }
	}
    	
	if {[string equal $pot_focolare_nom ""]} {
	    element::set_error $form_name pot_focolare_nom "Inserire potenza"
	    incr error_num	    
	} else {
	    set pot_focolare_nom [iter_check_num $pot_focolare_nom 2]
	    if {[string equal $pot_focolare_nom "0.00"]} {
		element::set_error $form_name pot_focolare_nom "Deve essere diverso da 0,00"
		incr error_num
	    } elseif {$pot_focolare_nom == "Error"} {
		element::set_error $form_name pot_focolare_nom "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num	    
	    } else {
		set sw_pot_focolare_nom_ok "t"
	    }
	}
        	
        if {![string equal $o2 ""]} {
	    set o2 [iter_check_num $o2 2]
	    if {$o2 == "Error"} {
		element::set_error $form_name o2 "O<sub><small>2</small></sub> deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		#rom10 modificata prima condizione: o2 non puo' essere > di 21
		#rom10 prima era > [expr pow(10,2)]
		if {[iter_set_double $o2] >= "21.00"  
		    ||  [iter_set_double $o2] < -[expr pow(10,2)]} {
		    element::set_error $form_name o2 "O<sub><small>2</small></sub> deve essere inferiore a 21"
		    incr error_num
		}
	    }
	}

	if {![string equal $co2 ""]} {
	    set co2 [iter_check_num $co2 2]
	    if {$co2 == "Error"} {
		element::set_error $form_name co2 "co<sub><small>2</small></sub> deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $co2] >  [expr pow(10,2)]
		    ||  [iter_set_double $co2] < -[expr pow(10,2)]} {
		    element::set_error $form_name co2 "co<sub><small>2</small></sub> deve essere inferiore di 100"
		    incr error_num
		}
	    }
	}
	#gac03 aggiunta if e suo contenuto
	if {![string equal $portata_termica_effettiva ""]} {
	    set portata_termica_effettiva [iter_check_num $portata_termica_effettiva 2]
	    if {$portata_termica_effettiva == "Error"} {
                element::set_error $form_name portata_termica_effettiva "Portata termica effettiva deve essere numerico"
                incr error_num
	    } else {
                if {[iter_set_double $portata_termica_effettiva] >  [expr pow(10,4)]
                    ||  [iter_set_double $portata_termica_effettiva] < -[expr pow(10,4)]} {
                    element::set_error $form_name portata_termica_effettiva "Portata termica effettiva deve essere inferiore di 10.000"
                    incr error_num
                }
            }
	}


	#gac03 calcolo per il warning
	if {$potenza eq ""} {
	    set potenza_da_calc "0"
	} else {
	    set potenza_da_calc [iter_check_num $potenza 2]
	}

	set portata_termica_effettiva_num [iter_check_num $portata_termica_effettiva 2]
	set pot_utile_nom_perc [expr $potenza_da_calc * 10.00/100.00]
	set pot_utile_nom_calc [expr $potenza_da_calc + $pot_utile_nom_perc]
	if {($portata_termica_effettiva_num > $pot_utile_nom_calc) && $portata_termica_effettiva ne ""} {
	    set msg_scostamento 1
	    element set_properties $form_name warning_portata  -value "<font color=blue><b>Scostamento della potenza max. al focolare superiore al 10%. Regolare il generatore prima di effettuare la misura del rendimento di combustione.</b></font>"

	} else {
	    set msg_scostamento 0
	     element set_properties $form_name warning_portata  -value ""
	}
	
	if {![string equal $bacharach ""]} {
	    set bacharach [iter_check_num $bacharach 0]
	    if {$bacharach == "Error"} {
		element::set_error $form_name bacharach "Bacharach deve essere numerico"
		incr error_num
	    } else {
		if {[iter_set_double $bacharach] >=  [expr pow(10,4)]
		    ||  [iter_set_double $bacharach] <= -[expr pow(10,4)]} {
		    set $bacharach3 "Error"
		    element::set_error $form_name bacharach "Bacharach deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}

	if {![string equal $bacharach2 ""]} {
	    set bacharach2 [iter_check_num $bacharach2 0]
	    if {$bacharach2 == "Error"} {
		element::set_error $form_name bacharach "Bacharach deve essere numerico"
		incr error_num
	    } else {
		if {[iter_set_double $bacharach2] >=  [expr pow(10,4)]
		    ||  [iter_set_double $bacharach2] <= -[expr pow(10,4)]} {
		    element::set_error $form_name bacharach "Bacharach deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}
	if {![string equal $bacharach3 ""]} {
	    set bacharach3 [iter_check_num $bacharach3 0]
	    if {$bacharach3 == "Error"} {
		element::set_error $form_name bacharach "Bacharach deve essere numerico"
		incr error_num
	    } else {
		if {[iter_set_double $bacharach3] >=  [expr pow(10,4)]
		    ||  [iter_set_double $bacharach3] <= -[expr pow(10,4)]} {
		    element::set_error $form_name bacharach "Bacharach deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	}
	if {![string equal $portata_comb ""]} {
            set portata_comb [iter_check_num $portata_comb 2]
            if {$portata_comb == "Error"} {
                element::set_error $form_name portata_comb "Portata combustibile deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $portata_comb] >=  [expr pow(10,4)]
                    ||  [iter_set_double $portata_comb] <= -[expr pow(10,4)]} {
                    element::set_error $form_name portata_comb "Portata combustibile deve essere inferiore di 10.000"
                    incr error_num
                }
            }
        }
    
	set flag_co_perc "f"
	if {![string equal $co ""]} {
            if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		set co [iter_check_num $co 4]
	    } else {
		set co [iter_check_num $co 2]
	    }
	    if {$co == "Error"} {
		if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunto if else e contenuto di else 
		    element::set_error $form_name co "co deve essere numerico e pu&ograve; avere al massimo 4 decimali"
		} else {
		    element::set_error $form_name co "co deve essere numerico e pu&ograve; avere al massimo 2decimali"
		}
		incr error_num
	    } else {
		if {[iter_set_double $co] >=  [expr pow(10,7)]
		    ||  [iter_set_double $co] <= -[expr pow(10,7)]} {
		    element::set_error $form_name co "co deve essere inferiore di 1.000.000"
		    incr error_num
		} else {
		    if {[iter_set_double $co] < 1} {
			set co [expr $co * 10000]
			set flag_co_perc "t"
		    }
		}
	    }
	}

	set flag_co_perc "f"
	if {![string equal $co_fumi_secchi_ppm ""]} {#rom04 if e contenuto
	    if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		set co_fumi_secchi_ppm [iter_check_num $co_fumi_secchi_ppm 2]
	    } else {
		set co_fumi_secchi_ppm [iter_check_num $co_fumi_secchi_ppm 4]
	    }
	    if {$co_fumi_secchi_ppm == "Error"} {
		if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		    element::set_error $form_name co_fumi_secchi_ppm "CO fumi secchi ppm deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		} else {
		    element::set_error $form_name co_fumi_secchi_ppm "CO fumi secchi ppm deve essere numerico e pu&ograve; avere al massimo 4 decimali"
		}
		incr error_num
	    } else {
		if {[iter_set_double $co_fumi_secchi_ppm] >=  [expr pow(10,7)]
		    ||  [iter_set_double $co_fumi_secchi_ppm] <= -[expr pow(10,7)]} {
		    element::set_error $form_name co_fumi_secchi_ppm "CO fumi secchi ppm deve essere inferiore di 1.000.000"
		    incr error_num
		} else {
		    if {$co_fumi_secchi_ppm < 1} {
			set co_fumi_secchi_ppm [expr [iter_set_double $co_fumi_secchi_ppm] * 10000]
			set flag_co_perc "t"
		    }
		}
	    }
	};#rom04
	
	if {![string equal $rend_combust ""]} {
	    set rend_combust [iter_check_num $rend_combust 2]
	    if {$rend_combust == "Error"} {
		element::set_error $form_name rend_combust "Rendimento combustibile deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		#if {[iter_set_double $rend_combust] >  [expr pow(10,2)]
		# || [iter_set_double $rend_combust] < -[expr pow(10,2)]} {
		#    element::set_error $form_name rend_combust "Rendimento combustibile deve essere inferiore di 100"
		#    incr error_num
		#}
	    }
	}
	
	if {![string equal $rct_rend_min_legge ""]} {
	    set rct_rend_min_legge [iter_check_num $rct_rend_min_legge 2]
	    if {$rct_rend_min_legge == "Error"} {
		element::set_error $form_name rct_rend_min_legge "Rend.to combustione minimo di legge deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		#if {[iter_set_double $rct_rend_min_legge] >  [expr pow(10,2)]
		# || [iter_set_double $rct_rend_min_legge] < -[expr pow(10,2)]} {
		#    element::set_error $form_name rct_rend_min_legge "Rend.to combustione minimo di legge deve essere inferiore di 100"
		#    incr error_num
		#}
	    }
	}
	#rom01 ripeto i controlli per le prove aggiuntive
        set conta_prfumi 0
        while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
            incr conta_prfumi
            if {$conta_prfumi > 9} {
                break
            }
	    
	if {![string equal $o2_prfumi($conta_prfumi) ""]} {
	    set o2_prfumi($conta_prfumi) [iter_check_num $o2_prfumi($conta_prfumi) 2]
	    if {$o2_prfumi($conta_prfumi) == "Error"} {
		element::set_error $form_name o2.$conta_prfumi "O<sub><small>2</small></sub> deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		#rom10 modificata prima condizione: o2 non puo' essere > di 21
		#rom10 prima era > [expr pow(10,2)]
		if {[iter_set_double $o2_prfumi($conta_prfumi)] >= "21.00"  
		    ||  [iter_set_double $o2_prfumi($conta_prfumi)] < -[expr pow(10,2)]} {
		    element::set_error $form_name o2.$conta_prfumi "O<sub><small>2</small></sub> deve essere inferiore a 21"
		    incr error_num
		}
	    }
	}
	
	if {![string equal $co2_prfumi($conta_prfumi) ""]} {
	    set co2_prfumi($conta_prfumi) [iter_check_num $co2_prfumi($conta_prfumi) 2]
	    if {$co2_prfumi($conta_prfumi) == "Error"} {
		element::set_error $form_name co2.$conta_prfumi "co<sub><small>2</small></sub> deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $co2_prfumi($conta_prfumi)] >  [expr pow(10,2)]
		    ||  [iter_set_double $co2_prfumi($conta_prfumi)] < -[expr pow(10,2)]} {
		    element::set_error $form_name co2.$conta_prfumi "co<sub><small>2</small></sub> deve essere inferiore di 100"
		    incr error_num
		}
	    }
	}
	    
	    if {![string equal $portata_termica_effettiva_prfumi($conta_prfumi) ""]} {
		set portata_termica_effettiva_prfumi($conta_prfumi) [iter_check_num $portata_termica_effettiva_prfumi($conta_prfumi) 2]
		if {$portata_termica_effettiva_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name portata_termica_effettiva.$conta_prfumi "Portata termica effettiva deve essere numerico"
		    incr error_num
		} else {
		    if {[iter_set_double $portata_termica_effettiva_prfumi($conta_prfumi)] >  [expr pow(10,4)]
			||  [iter_set_double $portata_termica_effettiva_prfumi($conta_prfumi)] < -[expr pow(10,4)]} {
			element::set_error $form_name portata_termica_effettiva.$conta_prfumi "Portata termica effettiva deve essere inferiore di 10.000"
                    incr error_num
		    }
		}
	    }
	    
	    if {($portata_termica_effettiva_prfumi($conta_prfumi) > $pot_utile_nom_calc || $msg_scostamento == 1) 
		&& $portata_termica_effettiva ne ""} {
		element set_properties $form_name warning_portata  -value "<font color=blue><b>Scostamento della potenza max. al focolare superiore al 10%. Regolare il generatore prima di effettuare la misura del rendimento di combustione. </b></font>"
		
	    } else {
		element set_properties $form_name warning_portata  -value ""
	    }
	    
	    
	    if {![string equal $bacharach_prfumi($conta_prfumi) ""]} {
		set bacharach_prfumi($conta_prfumi) [iter_check_num $bacharach_prfumi($conta_prfumi) 0]
		if {$bacharach_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name bacharach.$conta_prfumi "Bacharach deve essere numerico"
		    incr error_num
		} else {
		    if {[iter_set_double $bacharach_prfumi($conta_prfumi)] >=  [expr pow(10,4)]
		    ||  [iter_set_double $bacharach_prfumi($conta_prfumi)] <= -[expr pow(10,4)]} {
			element::set_error $form_name bacharach.$conta_prfumi "Bacharach deve essere inferiore di 10.000"
			incr error_num
		    }
		}
	    }
	    if {![string equal $bacharach2_prfumi($conta_prfumi) ""]} {
		set bacharach2_prfumi($conta_prfumi) [iter_check_num $bacharach2_prfumi($conta_prfumi) 0]
		if {$bacharach2_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name bacharach.$conta_prfumi "Bacharach deve essere numerico"
                incr error_num
		} else {
		    if {[iter_set_double $bacharach2_prfumi($conta_prfumi)] >=  [expr pow(10,4)]
			||  [iter_set_double $bacharach2_prfumi($conta_prfumi)] <= -[expr pow(10,4)]} {
                    element::set_error $form_name bacharach.$conta_prfumi "Bacharach deve essere inferiore di 10.000"
                    incr error_num
		    }
		}
	    }
	    if {![string equal $bacharach3_prfumi($conta_prfumi) ""]} {
		set bacharach3_prfumi($conta_prfumi) [iter_check_num $bacharach3_prfumi($conta_prfumi) 0]
		if {$bacharach3_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name bacharach.$conta_prfumi "Bacharach deve essere numerico"
                incr error_num
		} else {
		    if {[iter_set_double $bacharach3_prfumi($conta_prfumi)] >=  [expr pow(10,4)]
			||  [iter_set_double $bacharach3_prfumi($conta_prfumi)] <= -[expr pow(10,4)]} {
                    element::set_error $form_name bacharach.$conta_prfumi "Bacharach deve essere inferiore di 10.000"
                    incr error_num
		    }
		}
	    }
	    if {![string equal $portata_comb_prfumi($conta_prfumi) ""]} {
		set portata_comb_prfumi($conta_prfumi) [iter_check_num $portata_comb_prfumi($conta_prfumi) 2]
		if {$portata_comb_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name portata_comb.$conta_prfumi "Portata comb deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
		} else {
		    if {[iter_set_double $portata_comb_prfumi($conta_prfumi)] >=  [expr pow(10,4)]
			||  [iter_set_double $portata_comb_prfumi($conta_prfumi)] <= -[expr pow(10,4)]} {
                    element::set_error $form_name portata_comb.$conta_prfumi "Portata comb deve essere inferiore di 10.000"
                    incr error_num
		    }
		}
	    }
    
	set flag_co_perc "f"
	if {![string equal $co_prfumi($conta_prfumi) ""]} {
	    if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		set co_prfumi($conta_prfumi) [iter_check_num $co_prfumi($conta_prfumi) 4]
	    } else {
                set co_prfumi($conta_prfumi) [iter_check_num $co_prfumi($conta_prfumi) 2]
	    }
	    if {$co_prfumi($conta_prfumi) == "Error"} {
		if {$coimtgen(regione) ne "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		    element::set_error $form_name co.$conta_prfumi "co deve essere numerico e pu&ograve; avere al massimo 4 decimali"
		} else {
		    element::set_error $form_name co.$conta_prfumi "co deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		}
		incr error_num
	    } else {
		if {[iter_set_double $co_prfumi($conta_prfumi)] >=  [expr pow(10,7)]
		    ||  [iter_set_double $co_prfumi($conta_prfumi)] <= -[expr pow(10,7)]} {
		    element::set_error $form_name co.$conta_prfumi "co deve essere inferiore di 1.000.000"
		    incr error_num
		} else {
		    if {[iter_set_double $co_prfumi($conta_prfumi)] < 1} {
			set co_prfumi($conta_prfumi) [expr $co_prfumi($conta_prfumi) * 10000]
			set flag_co_perc "t"
		    }
		}
	    }
	}
    	set flag_co_perc "f"
	    if {![string equal $co_fumi_secchi_ppm_prfumi($conta_prfumi) ""]} {#rom04 if e contenuto
		if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunto if else e contenuto di else
		    set co_fumi_secchi_ppm_prfumi($conta_prfumi) [iter_check_num $co_fumi_secchi_ppm_prfumi($conta_prfumi) 2]
		} else {
		    set co_fumi_secchi_ppm_prfumi($conta_prfumi) [iter_check_num $co_fumi_secchi_ppm_prfumi($conta_prfumi) 4]
		}
		if {$co_fumi_secchi_ppm_prfumi($conta_prfumi) == "Error"} {
		    if {$coimtgen(regione) eq "MARCHE"} {#gac07 aggiunto if else e contenuto di else
			element::set_error $form_name co_fumi_secchi_ppm.$conta_prfumi "CO fumi secchi ppm deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		    } else {
			element::set_error $form_name co_fumi_secchi_ppm.$conta_prfumi "CO fumi secchi ppm deve essere numerico e pu&ograve; avere al massimo 4 decimali"
		    }
		    incr error_num
		} else {
		    if {[iter_set_double $co_fumi_secchi_ppm_prfumi($conta_prfumi)] >=  [expr pow(10,7)]
			||  [iter_set_double $co_fumi_secchi_ppm_prfumi($conta_prfumi)] <= -[expr pow(10,7)]} {
                    element::set_error $form_name co_fumi_secchi_ppm.$conta_prfumi "CO fumi secchi ppm deve essere inferiore di 1.000.000"
                    incr error_num
		    } else {
			if {$co_fumi_secchi_ppm_prfumi($conta_prfumi) < 1} {
			    set co_fumi_secchi_ppm_prfumi($conta_prfumi) [expr $co_fumi_secchi_ppm_prfumi($conta_prfumi) * 10000]
                        set flag_fumi_secchi_ppm_co_perc "t"
			}
		    }
		}
	    };#rom04

	    if {![string equal $rend_combust_prfumi($conta_prfumi) ""]} {
		set rend_combust_prfumi($conta_prfumi) [iter_check_num $rend_combust_prfumi($conta_prfumi) 2]
		if {$rend_combust_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name rend_combust.$conta_prfumi "Rendimento combustibile deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		    incr error_num
		}
	    }

	    if {![string equal $rct_rend_min_legge_prfumi($conta_prfumi) ""]} {
		set rct_rend_min_legge_prfumi($conta_prfumi) [iter_check_num $rct_rend_min_legge_prfumi($conta_prfumi) 2]
		if {$rct_rend_min_legge_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name rct_rend_min_legge.$conta_prfumi "Rend.to combustione minimo di legge deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
		}
	    }

	    #rom15 Standardizzati controlli su Rendimento di Combustione.

	    if {[iter_check_num $rend_combust_prfumi($conta_prfumi) 2] > [iter_check_num $rct_rend_min_legge_prfumi($conta_prfumi) 2] && $rend_magg_o_ugua_rend_min eq "N"} {#rom15 if e contenuto
		element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
		incr error_num
	    }
	    
	    if {[iter_check_num $rend_combust_prfumi($conta_prfumi) 2] < [iter_check_num $rct_rend_min_legge_prfumi($conta_prfumi) 2] && $rend_magg_o_ugua_rend_min eq "S"} {#rom15 rom15 if e contenuto
		element::set_error $form_name rend_magg_o_ugua_rend_min "Scelta incongruente con i valori inseriti."
		incr error_num
	    }

	    
	} ;#rom01

	#rom38 Aggiunta condizione per le Marche.
	if {$cont_rend eq "N" && $coimtgen(regione) eq "MARCHE"} {
	    if {$portata_comb ne "" ||
		$portata_termica_effettiva ne "" ||
		$temp_fumi ne "" ||
		$temp_ambi ne "" ||
		$o2 ne "" ||
		$co2 ne "" ||
		$bacharach ne "" ||
		$bacharach2 ne "" ||
		$bacharach3 ne "" ||
		$co_fumi_secchi_ppm ne "" ||
		$co ne "" ||
		$rend_combust ne "" ||
		$rct_rend_min_legge ne "" ||
		$rct_modulo_termico ne ""
	    } {
		element::set_error $form_name warning_cont_rend "Non inserire la parte relativa ai controlli del rendimento di combustione in quanto il controllo non è stato effettuato "
		incr error_num
	    }
	    set conta_prfumi 0
	    while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
		incr conta_prfumi
		if {$conta_prfumi > 9} {
		    break
		}
		
		if {$portata_comb_prfumi($conta_prfumi) ne "" ||
		    $portata_termica_effettiva_prfumi($conta_prfumi) ne "" ||
		    $temp_fumi_prfumi($conta_prfumi) ne "" ||
		    $temp_ambi_prfumi($conta_prfumi) ne "" ||
		    $o2_prfumi($conta_prfumi) ne "" ||
		    $co2_prfumi($conta_prfumi) ne "" ||
		    $bacharach_prfumi($conta_prfumi) ne "" ||
		    $bacharach2_prfumi($conta_prfumi) ne "" ||
		    $bacharach3_prfumi($conta_prfumi) ne "" ||
		    $co_fumi_secchi_ppm_prfumi($conta_prfumi) ne "" ||
		    $co_prfumi($conta_prfumi) ne "" ||
		    $rend_combust_prfumi($conta_prfumi) ne "" ||
		    $rct_rend_min_legge_prfumi($conta_prfumi) ne "" ||
		    $rct_modulo_termico_prfumi($conta_prfumi) ne ""
		} {	
		element::set_error $form_name warning_cont_rend "Non inserire la parte relativa ai controlli del rendimento di combustione in quanto il controllo non è stato effettuato "
		incr error_num
		}	
	    }
	}

	
	#nic06: Sandro ha deciso di renderla obbligatoria
	#nic06 if {![string equal $potenza ""]}
        if {[string equal $potenza ""]} {
            element::set_error $form_name potenza "Inserire potenza"
            incr error_num
        } else {
            set potenza [iter_check_num $potenza 2]
            if {$potenza == "Error"} {
                element::set_error $form_name potenza "La potenza deve essere numerica e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } elseif {$potenza== "0,00"} {
		element::set_error $form_name potenza "La potenza deve essere maggiore di 0,00"
		incr error_num
	    } elseif {[iter_set_double $potenza] >=  [expr pow(10,7)]
	          ||  [iter_set_double $potenza] <= -[expr pow(10,7)]} {
		element::set_error $form_name potenza "Potenza deve essere inferiore di 10.000.000"
		incr error_num
	    } else {
		#sandro 230513
		if {$sw_pot_focolare_nom_ok eq "t"
                &&  $potenza > $pot_focolare_nom } {
		    element::set_error $form_name potenza "Potenza focolare utile > della nominale"
		    incr error_num
		    set sw_pot_focolare_nom_ok "f"
		}
		# fine sandro 230513
            }
        }

        if {![string equal $data_utile_inter ""]} {
            set data_utile_inter [iter_check_date $data_utile_inter]
            if {$data_utile_inter == 0} {
                element::set_error $form_name data_utile_inter "Data utile intervento deve essere una data"
                incr error_num
            }
        }

        if {![string equal $data_arrivo_ente ""]} {
            set data_arrivo_ente [iter_check_date $data_arrivo_ente]
            if {$data_arrivo_ente == 0} {
                element::set_error $form_name data_arrivo_ente "Data arrivo ente deve essere una data"
                incr error_num
            }
        }

        if {![string equal $data_prot ""]} {
            set data_prot [iter_check_date $data_prot]
            if {$data_prot == 0} {
                element::set_error $form_name data_prot "Data protocollo deve essere una data"
                incr error_num
            }
        } else {
	    if {$data_prot > $current_date} {
		element::set_error $form_name data_prot "Data protocollo deve essere inferiore alla data odierna"
		incr error_num
	    }
	}

	# costo e' obbligatorio se sono stati indicati gli altri estremi
	# del pagamento
	#sim19 aggiunto condizione su esente
	
	if {$sw_costo_null == "t" && $esente eq "f"} {
	    if {![string equal $tipologia_costo ""] || $flag_pagato == "S"} {
		element::set_error $form_name costo "Inserire il costo"
		incr error_num
	    }
	}

	# tipologia costo e' obbligatoria se sono stati indicati
	# gli altri estremi del pagamento
	if {[string equal $tipologia_costo ""]} {
	    if {$sw_costo_null == "f" || $flag_pagato == "S"} {
		element::set_error $form_name tipologia_costo "Inserire la tipologia del costo"
		incr error_num
	    }
	}
    
	# Sandro, 01/07/2014 per tutti gli enti prima del controllo del bollino calcolo la
	# potenza dell'impianto, per il momento quella nominale.
	# Prima veniva usata la pot_focolare_nom ma non andava bene (segnalazione di UCIT)

	db_1row query "select $nome_col_aimp_potenza as potenza_impianto
                         from coimaimp
                        where cod_impianto = :cod_impianto" 
    
	# se viene indicato il bollino (riferimento pagamento valorizzato e
	# tipologia costo = 'BO').
	set note_todo_boll ""
	if {![string equal $riferimento_pag ""] && $tipologia_costo == "BO"} {
	    # controlli sui bollini disattivati per CPADOVA, PRO, PLI
	    #	    if { ( $flag_ente == "P" && ( $sigla_prov == "RO" || $sigla_prov == "LI")
	    #		|| (   $flag_ente == "C" && $cod_comu == "8761") ) } 
	    # vieto l'inserimento del bollino se il manutentore non e' convenz.
	    if {[db_0or1row sel_manu_flag_convenzionato ""] == 0} {
		set flag_convenzionato ""
	    } 
	    if {$flag_convenzionato == "N"} {
		element::set_error $form_name riferimento_pag "Manutentore non convenzionato all'utilizzo dei bollini"
		incr error_num
	    }
	    
	    # verifico che non esistano altri modelli H con lo stesso bollino
	    # segnalando l'eventuale incongruenza solamente su un TODO
	    # (Savazzi dice che verra' controllato solo per una quadratura dei
	    # pagamenti).
	    if {$funzione == "M"} {
		set where_codice "and cod_dimp <> :cod_dimp"
	    } else {
		set where_codice ""
	    }
	    
	    db_1row sel_dimp_check_riferimento_pag ""
	    if {$count_riferimento_pag > 0} {
		if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {
		    #modifica 080114
		    #sim55 if {$funzione != "M" && $id_ruolo !=  "admin"} {#08114
			element::set_error $form_name riferimento_pag "Bollino gia' presente in altri allegati"
			incr error_num
		    #sim55 };#08114
		} elseif {$coimtgen(ente) eq "PLI"} {
		    element::set_error $form_name riferimento_pag "Bollino già presente in altri allegati"
		    incr error_num
		} elseif {$coimtgen(ente) eq "PCE"} {#sim06
                    element::set_error $form_name riferimento_pag "Bollino già presente in altri allegati";#sim06
                    incr error_num;#sim06
		} else {
		    # Caso standard
		    #sim44 append note_todo_boll "Il bollino applicato sulla dichiarazione e' gia' stato applicato precedentemente su un'altro modello"
		    element::set_error $form_name riferimento_pag "Bollino già presente in altri allegati";#sim44
                    incr error_num;#sim44
		}
	    }

	    set dbn_ente_collegato "";#nic05
	    set ls_dbn_ente_collegato "";#sim45
	    if {$coimtgen(ente) eq "PUD"} {#nic05
		set ls_dbn_ente_collegato "iterprgo";#nic05
	    } elseif {$coimtgen(ente) eq "PGO"} {#nic05
		set ls_dbn_ente_collegato "iterprud";#nic05
	    };#nic05

	    if {$coimtgen(ente) eq "PAN"} {;#sim42 if e suo contenuto
		set ls_dbn_ente_collegato "itercman"
	    } elseif {$coimtgen(ente) eq "CANCONA"} {;#sim42 if e suo contenuto 
		set ls_dbn_ente_collegato "iterpran"
	    }

	    if {$coimtgen(ente) eq "CFANO"} {;#sim45 if e suo contenuto
		set ls_dbn_ente_collegato "itercmjesi"
		lappend ls_dbn_ente_collegato "itercmsenigallia"
	    } elseif {$coimtgen(ente) eq "CJESI"} {;#sim45 if e suo contenuto 
		set ls_dbn_ente_collegato "itercmfano"
                lappend ls_dbn_ente_collegato "itercmsenigallia"
	    } elseif {$coimtgen(ente) eq "CSENIGALLIA"} {;#sim45 if e suo contenuto
		set ls_dbn_ente_collegato "itercmfano"
                lappend ls_dbn_ente_collegato "itercmjesi"
	    }

	    foreach dbn_ente_collegato $ls_dbn_ente_collegato {;#sim45

	    if {$dbn_ente_collegato ne ""} {#nic05
		db_1row -dbn $dbn_ente_collegato sel_dimp_check_riferimento_pag "";#nic05
		if {$count_riferimento_pag > 0} {#nic05
		    if {$funzione != "M" && $id_ruolo !=  "admin"} {#nic05
			element::set_error $form_name riferimento_pag "Bollino gia' presente in altri allegati inseriti sull'altro ente";#nic05
			incr error_num;#nic05
		    };#nic05
		};#nic05
	    };#nic05

   	    };#sim45

	    set flag_boll_compreso "f"
	    set flag_boll_pagato "t";#sim04
	    if {$flag_ente == "C" && $coimtgen(denom_comune) == "RIMINI"}  {
		#controllo del sul prefisso
		set anno_boll  [string range $riferimento_pag 0 4]
		if {$tipologia_costo == "BO"
		&& ($anno_boll != "2008/" && $anno_boll != "2009/" && $anno_boll != "2010/" && $anno_boll != "2011/" && $anno_boll != "2012/" && $anno_boll != "2013/"  &&  $anno_boll != "2014/" && $anno_boll != "2015/")
		} {
		    element::set_error $form_name riferimento_pag "Incongruenza Bollino/Tipologia Costo   es. anno/xxxx"
		    incr error_num
		}
		#fine controllo prefisso 

		set bol_nudo [string range $riferimento_pag 5 10]
		set bol_nudo [iter_check_num $bol_nudo 0]
		db_foreach sel_boll_manu "" {
		    set matricola_da [iter_check_num $matricola_da 0]
		    set matricola_a [iter_check_num $matricola_a 0]
		    if {$matricola_da != 0 && $matricola_a != 0 && $bol_nudo != "Error"} {
			if {$matricola_da <= $bol_nudo
			&&  $matricola_a  >= $bol_nudo
			} {
			    set flag_boll_compreso "t"
			}
		    }
		}

		#inizio boap                 
		if {$flag_boll_compreso == "f"} {
		    db_foreach sel_boll_boap "" {
			if {$matr_da <= $riferimento_pag && $matr_a >= $riferimento_pag} {
			    # ns_log Notice "coimdimp-g-gest;$matr_da <= $riferimento_pag && $matr_a >= $riferimento_pag"
			    set flag_boll_compreso "t"
			}
		    }
		}
		# fine boap

		if {$flag_boll_compreso == "f"} {
		    element::set_error $form_name riferimento_pag "Il bollino applicato sulla Dichiarazione non e' stato rilasciato al manutentore che ha compilato il modulo es. anno/xxxx"
		    incr error_num
		}
	
	    } elseif {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {
		set prosegui "t"
		# se il manutentore non ha bollini, non può inserire una dichiarazione
		if {[db_string query "select count(*) from coimboll where cod_manutentore = :cod_manutentore"] == 0} {
		    element::set_error $form_name riferimento_pag "Se non si e' in possesso di bollini, non si puo' inserire alcuna dichiarazione"
		    incr error_num
		    set prosegui "f"
		}

		if {$sw_pot_focolare_nom_ok eq "f"} {
		    set prosegui "f"
		}

		#13.09.2012
		if {$prosegui eq "t" && $potenza_impianto < 35.00} {
		    set riferimento_pag        [string trim $riferimento_pag]
		    set riferimento_pag_prefix [string range $riferimento_pag 0 0]
		    set riferimento_pag_suffix [string range $riferimento_pag 1 end]
		    
		    if {$riferimento_pag_prefix                   ne "G"
		    ||  [string length   $riferimento_pag]        ne 7
		    || ![string is digit $riferimento_pag_suffix]
		    } {
			element::set_error $form_name riferimento_pag "Num.Bollino errato: deve essere nel formato 'G' seguito da 6 cifre"
			incr error_num
			set prosegui "f"
		    }

		    if {$prosegui eq "t"} {
			# controllo sull'esistenza o meno di quel Bollino per quella ditta di manutenzione
			    
			# verifico che il numero bollino sia compreso tra le matricole
			# dei blocchetti rilasciati al manutentore indicato
			# (Savazzi dice che verra' controllato solo per una quadratura dei pagamenti).
			    
			set riferimento_pag_num [string trimleft $riferimento_pag_suffix "0"]
			set flag_boll_compreso "f"
			db_foreach sel_boll_manu "" {
			    if {$matricola_da <= $riferimento_pag_num && $matricola_a >= $riferimento_pag_num} {
				#ns_log Notice "coimdimp-g-gest;$matricola_da <= $riferimento_pag_num && $matricola_a >= $riferimento_pag_num"
				set flag_boll_compreso "t"
			    }
			}
			
			#inizio boap                 
			if {$flag_boll_compreso == "f"} {
			    db_foreach sel_boll_boap "" {
				if {$matr_da <= $riferimento_pag && $matr_a >= $riferimento_pag} {
				   # ns_log Notice "coimdimp-g-gest;$matr_da <= $riferimento_pag && $matr_a >= $riferimento_pag"
				    set flag_boll_compreso "t"
				}
			    }
			}
			# fine boap
			
			if {$flag_boll_compreso == "f"} {
			    #append note_todo_boll "Il bollino applicato sul modello  non e' stato rilasciato al manutentore che ha compilato il modulo Inoltre verificare: deve essere nel formato 'G' seguito da un numero"
			    element::set_error $form_name riferimento_pag "Num.Bollino non rilasciato al manutentore - Inoltre verificare: deve essere nel formato 'G' seguito da 6 cifre"
			    incr error_num
			}

		    }
		}
			
		if {$prosegui eq "t" && $potenza_impianto >= 35.00} {
		    set riferimento_pag        [string trim $riferimento_pag]
		    set riferimento_pag_prefix [string range $riferimento_pag 0 0]
		    if {$riferimento_pag_prefix eq "E"} {
			set riferimento_pag_suffix [string range $riferimento_pag 1 end]
			if {[string length   $riferimento_pag] ne 7
			|| ![string is digit $riferimento_pag_suffix]
			} {
			    element::set_error $form_name riferimento_pag "Num.Bollino errato: deve essere nel formato 'F1', 'F2', 'E' seguito da 6 cifre"
			    incr error_num
			    set prosegui "f"
			}
		    } else {
			set riferimento_pag_prefix [string range $riferimento_pag 0 1]
			set riferimento_pag_suffix [string range $riferimento_pag 2 end]
			if {$riferimento_pag_prefix ni [list "F1" "F2"]
			||  [string length   $riferimento_pag] ne 8
			|| ![string is digit $riferimento_pag_suffix]
			} {
			    element::set_error $form_name riferimento_pag "Num.Bollino errato: deve essere nel formato 'F1', 'F2', 'E' seguito da 6 cifre"
			    incr error_num
			    set prosegui "f"
			}
		    }
		    
		    # 22/07/2013 (Controllo richiesto tramite e-mail di Chiara Paravan di Ucit)
		    if {$prosegui eq "t"} {
			# Mail di Chiara Paravan del 17/07/2014: il controllo va fatto sulla potenza termica nominale al focolare del generatore (come per il modello F) e non sulla potenza_impianto
			if {$pot_focolare_nom < 350.00} {
			    if {[string range $riferimento_pag 0 0] ne "E"
			    &&  [string range $riferimento_pag 0 1] ne "F1"
			    } {
				element::set_error $form_name riferimento_pag "Num.Bollino errato: pu&ograve; iniziare solo per 'F1' o 'E' perch&egrave; la potenza termica nominale al focolare del generatore &egrave; inferiore a 350 kW"
				incr error_num
				set prosegui "f"
			    }
			} else {
			    if {[string range $riferimento_pag 0 0] ne "E"
			    &&  [string range $riferimento_pag 0 1] ne "F2"
			    } {
				element::set_error $form_name riferimento_pag "Num.Bollino errato: pu&ograve; iniziare solo per 'F2' o 'E' perch&egrave; la potenza termica nominale al focolare del generatore &egrave; &gt;= a 350 kW"
				incr error_num
				set prosegui "f"
			    }
			}
		    }
		
		    if {$prosegui eq "t"} {
			# controllo sull'esistenza o meno di quel Bollino per quella ditta di manutenzione
			
			# verifico che il numero bollino sia compreso tra le matricole
			# dei blocchetti rilasciati al manutentore indicato
			# (Savazzi dice che verra' controllato solo per una quadratura dei pagamenti).
			
			set riferimento_pag_num [string trimleft $riferimento_pag_suffix "0"]
			set flag_boll_compreso "f"
			db_foreach sel_boll_manu "" {
			    if {$matricola_da <= $riferimento_pag_num && $matricola_a >= $riferimento_pag_num} {
				ns_log Notice "coimdimp-rct-gest;$matricola_da <= $riferimento_pag_num && $matricola_a >= $riferimento_pag_num"
				set flag_boll_compreso "t"
			    }
			}
				
			#inizio boap                 
			if {$flag_boll_compreso == "f"} {
			    db_foreach sel_boll_boap "" {
				if {$matr_da <= $riferimento_pag && $matr_a >= $riferimento_pag} {
				    ns_log Notice "coimdimp-rct-gest;$matr_da <= $riferimento_pag && $matr_a >= $riferimento_pag"
				    set flag_boll_compreso "t"
				}
			    }
			}
			# fine boap

			if {$flag_boll_compreso == "f"} {
			    #append note_todo_boll "Il bollino applicato sul modello non e' stato rilasciato al manutentore che ha compilato il modulo"
			    element::set_error $form_name riferimento_pag "Num.Bollino non rilasciato al manutentore."
			    incr error_num
			}
		    }
		}
		# Fine personalizzazioni per PUD e PGO

	    } elseif {$coimtgen(ente) eq "PCE"} {

		#controllo del 28082013
		# verifico che il bollino sia compreso tra le matricole dei blocchetti
		set bol_nudo [string range $riferimento_pag 5 9]
		#set bol_nudo  "lpad(bol_nudo, 5, '0')"
		set bol_nudo [iter_check_num $bol_nudo 0]
		ns_log Notice "coimdimp-rct-gest;bol_nudo:$bol_nudo"
		set flag_boll_compreso "f"
		db_foreach sel_boll_manu "" {
		    set matricola_da [iter_check_num $matricola_da 0]
		    set matricola_a  [iter_check_num $matricola_a 0]
		    #set riferimento_pag [iter_check_num [string range $riferimento_pag 6 5] 0]
		    if {$matricola_da != 0 && $matricola_a != 0 && $bol_nudo != "Error"} {
			if {$matricola_da <= $bol_nudo
			&&  $matricola_a  >= $bol_nudo
			} {
			    set flag_boll_compreso "t"
			}
		    }
		}
		if {$flag_boll_compreso == "f"} {
		    #append note_todo_boll "Il bollino applicato sul modello  non e' stato rilasciato al manutentore che ha compilato il modulo"
		    element::set_error $form_name riferimento_pag "Il Bollino non e' stato rilasciato al manutentore che ha compilato il modulo"
		    incr error_num
		}
		
		#controllo del 28082013
		set anno_boll  [string range $riferimento_pag 0 3]
		if {$tipologia_costo != "BO"
		&&  $anno_boll == "2013"
		} {
		    element::set_error $form_name riferimento_pag "Incongruenza Bollino/Tipologia Costo"
		    incr error_num
		}
		#fine controllo del 28082013
	
		#controllo del 29082013
		if {$tipologia_costo == "BO" 
		&&  $anno_boll != "2013" 
		} {
		    element::set_error $form_name riferimento_pag "Incongruenza Bollino/Tipologia Costo Deve essere 2013/nnnnn"
		    incr error_num
		}
		#fine controllo del 29082013


		#fine caso PCE (Provincia di Caserta)

	    } elseif {$coimtgen(ente) eq "PPU"} {
		#sandro controlli prpu
		
		# verifico che il bollino sia compreso tra le matricole dei blocchetti
		set bol_nudo [string range $riferimento_pag 0 5]
		#set bol_nudo  "lpad(bol_nudo, 6, '0')"
		set bol_nudo [iter_check_num $bol_nudo 0]
		ns_log Notice "coimdimp-rct-gest;bol_nudo:$riferimento_pag - $bol_nudo"
		set flag_boll_compreso "f"
		db_foreach sel_boll_manu "" {
		    set matricola_da [iter_check_num $matricola_da 0]
		    set matricola_a  [iter_check_num $matricola_a 0]
		    if {$matricola_da != 0 && $matricola_a != 0 && $bol_nudo != "Error"} {
			if {$matricola_da <= $bol_nudo
			&&  $matricola_a  >= $bol_nudo
			} {
			    set flag_boll_compreso "t"
			}
		    }
		}
		if {$flag_boll_compreso == "f"} {
		    #append note_todo_boll "Il bollino applicato sul modello  non e' stato rilasciato al manutentore che ha compilato il modulo"
		    element::set_error $form_name riferimento_pag "Il Bollino non e' stato rilasciato al manutentore che ha compilato il modulo/Il bollino deve essere scritto nella forma XXXXXX, Inoltre piu' bollini devo essere separati da ;"
		    incr error_num
		}
		#sandro fine controlli prpu

	    } elseif {$coimtgen(ente) eq "CPESARO"} {#sim07 aggiunta if e suo contenuto

		set bol_nudo [string range $riferimento_pag 5 15]
		set bol_nudo [iter_check_num $bol_nudo 0]
		set flag_boll_compreso "f"
                db_foreach sel_boll_manu "" {
                    set matricola_da [iter_check_num $matricola_da 0]
                    set matricola_a  [iter_check_num $matricola_a 0]
                    set matricola_da [db_string query "select lpad(:matricola_da,6,0)"]
                    set matricola_a  [db_string query "select lpad(:matricola_a,6,0)"]
                    if {$matricola_da != 0 && $matricola_a != 0 && $bol_nudo != "Error"} {
                        if {$matricola_da <= $bol_nudo
                        &&  $matricola_a  >= $bol_nudo
                        } {
			    
                            set flag_boll_compreso "t"
                        }
                    }
                }
		if {$flag_boll_compreso == "f"} {
		    append note_todo_boll "Il bollino applicato sulla Dichiarazione non e' stato rilasciato al manutentore che ha compilato il modulo"
		}
	    } elseif {$coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA"} {;#sim46
		
		set bol_nudo [string range $riferimento_pag 1 [string length $riferimento_pag]]

		db_foreach sel_boll_manu "" {
		    if {$matricola_da <= $bol_nudo
			&&  $matricola_a  >= $bol_nudo
		    } {
			ns_log Notice "coimdimp-rct-gest;matricola_da=$matricola_da<=riferimento_pag:$riferimento_pag;matricola_a:$matricola_a>=riferimento_pag:$riferimento_pag"
			set flag_boll_compreso "t"
			
			if {$pagati eq "N"} {
			    set flag_boll_pagato "f"
			}		
			
		    }
		}

		if {$flag_boll_compreso == "f"} {
		    element::set_error $form_name riferimento_pag "Il bollino applicato sulla Dichiarazione non e' stato rilasciato al manutentore che ha compilato il modulo"
		    incr error_num
		}
		
	    } else {
		# Caso standard
		ns_log Notice "coimdimp-rct-gest;dentro;cod_manutentore:$cod_manutentore;flag_boll_compreso:$flag_boll_compreso"
		db_foreach sel_boll_manu "" {
		    if {$matricola_da <= $riferimento_pag
		    &&  $matricola_a  >= $riferimento_pag
		    } {
			ns_log Notice "coimdimp-rct-gest;matricola_da=$matricola_da<=riferimento_pag:$riferimento_pag;matricola_a:$matricola_a>=riferimento_pag:$riferimento_pag"
			set flag_boll_compreso "t"

			if {$pagati eq "N"} {#Aggiunta sim04 if e suo contenuto
			    set flag_boll_pagato "f"
			}		

		    }
		}

		if {[string length $riferimento_pag] !=7 && ($coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN")} {#sim51
		    set flag_boll_compreso "f"
		}

		if {$flag_boll_compreso == "f"} {
		    if {$coimtgen(ente) eq "PLI"} {
			element::set_error $form_name riferimento_pag "Il bollino non e' stato rilasciato al manutentore che ha compilato il modulo"
			incr error_num
		    } else {
			# Caso standard
			#sim44 append note_todo_boll "Il bollino applicato sulla Dichiarazione non e' stato rilasciato al manutentore che ha compilato il modulo"

			element::set_error $form_name riferimento_pag "Il bollino applicato sulla Dichiarazione non e' stato rilasciato al manutentore che ha compilato il modulo";#sim44
			incr error_num;#sim44

		    }
		}
	    }

	    if {$coimtgen(ente) eq "PLI" && $flag_boll_pagato eq "f" } {#sim04 if e suo contenuto
		element::set_error $form_name riferimento_pag "Bollino non pagato"
		incr error_num
	    }
	    
	}

    	if {![string equal $data_scad_pagamento ""]} {
	    set data_scad_pagamento [iter_check_date $data_scad_pagamento]
	    if {$data_scad_pagamento == 0} {
		element::set_error $form_name data_scad_pagamento "Data scadenza pagamento deve essere una data"
		incr error_num
	    }
	} else {
	    # se non e' stata compilata la data scadenza pagamento
	    # ed esistono gli altri estremi del pagamento
	    # devo calcolarla in automatico:
	    # se il pagamento e' effettuato,               con data controllo
	    # se il pagamento e' avvenuto tramite bollino, con data controllo
	    # negli altri casi con data controllo + gg_scad_pag_mh
	    # che e' un parametro di procedura.
	    if {![string equal $tipologia_costo ""] || $sw_costo_null == "f" || $flag_pagato   == "S"} {
		if {$tipologia_costo == "BO" || $flag_pagato == "S" || [string equal $gg_scad_pag_mh ""]} {
		    # se data_controllo non e' corretta, viene gia' segnalato
		    # l'errore sulla data_controllo.
		    if {$sw_data_controllo_ok == "t"} {
			set data_scad_pagamento $data_controllo
		    }
		} else {
		    # se data_controllo non e' corretta, viene gia' segnalato
		    # l'errore sulla data_controllo.
		    if {$sw_data_controllo_ok == "t"} {
			set data_scad_pagamento [clock format [clock scan "$gg_scad_pag_mh day" -base [clock scan $data_controllo]] -f "%Y%m%d"]
		    }
		}
	    }
	}

	set sw_data_prox_manut_ok "t"
	if {![string equal $data_prox_manut ""]} {#san04: aggiunta if ed il suo contenuto
            set data_prox_manut [iter_check_date $data_prox_manut]
            if {$data_prox_manut == 0} {
                element::set_error $form_name data_prox_manut "Data prossima manutenzione deve essere una data"
                incr error_num
		set sw_data_prox_manut_ok "f"
            } else {
		if {$sw_data_controllo_ok eq "t" && $data_prox_manut < $data_controllo} {
		    element::set_error $form_name data_prox_manut "Data prossima manutenzione deve essere superiore alla data controllo"
		    incr error_num
		    set sw_data_prox_manut_ok "f"
		}
	    }
        } else {;#sim40 aggiunto else e suo contenuto
	    #sim71 corretto anche if su controllo della data. Va fatto su tutta la regione
	    #sim75 if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PFI"} {;#sim42
		element::set_error $form_name data_prox_manut "Inserire Data prossima manutenzione"
		incr error_num
	    #sim75} 
	}

	#aggiunto condizione su comune e provincia di massa carrara
	if {$coimtgen(ente) ne "PFI" && $coimtgen(ente) ne "CCARRARA" && $coimtgen(ente) ne "PMS"} {;#sim31

	    eval $controllo_tariffa;#sim08

	    set costo [iter_check_num $tariffa 2]
	    element set_properties $form_name costo -value $tariffa;#sim08
	}

	# Le seguenti istruzioni che servono per calcolare la data_scadenza_autocert devono
	# essere identiche a quelle della proc iter_cari_rcee_tipo_1 definita nel sorgente
	# tcl/batch/iter-cari-rcee-tipo-1-procs.tcl.
	# Quando si modifica un sorgente, va modificato anche l'altro.
        # SF 271114 modificato Barletta e messa come udine
        if {$coimtgen(ente) eq "CRIMINI"}  {
	    
	    if {[string equal $data_scadenza_autocert ""]} {
		set data_8 "[expr [string range $data_controllo 0 3] - 4][string range $data_controllo 4 5][string range $data_controllo 6 7]"

		if {$flag_pagato eq "N"} {
		    set data_scadenza_autocert [string range $data_controllo 0 3]
		} elseif {$pot_focolare_nom >= 35 || $combustibile eq "1" || $combustibile eq "3"} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 1]
		} elseif {$data_insta < $data_8} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 2]
		} elseif {$tipo_a_c eq "C"} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 4]
		} elseif {$locale eq "I"} {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 2]
		} else {
		    set data_scadenza_autocert [expr [string range $data_controllo 0 3] + 4]
		}
		set data_scadenza_autocert "$data_scadenza_autocert[string range $data_controllo 4 7]"

		if {[string range $data_scadenza_autocert 4 7] == "0229"} {
		    set data_scadenza_autocert [string range $data_scadenza_autocert 0 3]
		    append data_scadenza_autocert "0228"
		}
	    } else {
                set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
                if {$data_scadenza_autocert == 0} {
                    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
                    incr error_num
                }
	    }

	} elseif {$coimtgen(ente) eq "PTA"} {#sim15: aggiunta if e suo contenuto
	    
	    if {$flag_errore_data_controllo eq "f"} {#rom04: aggiunta if e suo contenuto
#sim67	    if {$data_per_calcolo_scadenza eq ""} {#sim54
		set data_per_calcolo_scadenza $data_controllo
#sim67	    }

	    if {$potenza_impianto < 35.00} {;#2 anni
#sim54		set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
		set data_scadenza_autocert [db_string query "select :data_per_calcolo_scadenza::date + 730" -default ""];#sim54
	    } else {;#1 anno
#sim54		set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
		set data_scadenza_autocert [db_string query "select :data_per_calcolo_scadenza::date + 365" -default ""];#sim54
	    }
	    };#rom04

	} elseif {$coimtgen(ente) eq "CBENEVENTO"} {#rom27 Aggiunta elseif e il suo contenuto

	    if {$sw_data_controllo_ok == "t"} {

		if {$potenza_impianto < 100.00} {
		    set year_scadenza 2	
		} else {
		    set year_scadenza 1
		}

		set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '$year_scadenza year'" -default ""]
		
	    }   

	} elseif {$coimtgen(regione) eq "CAMPANIA"} {#sim73 if e suo contenuto

	    if {$sw_data_controllo_ok == "t"} {

		#se combustibile gpl o metano 2 anni a meno che non sia prima accensione e potenza <=100
		if {$combustibile eq "4" || $combustibile eq "5"} {

		    set year_scadenza 2

		    if {$potenza_impianto <= 100.00 && $data_controllo eq $data_insta} {
			set year_scadenza 4
		    }
	
		} else {

		    if {$potenza_impianto <= 100.00} {
			set year_scadenza 2
		    } else {
			set year_scadenza 1
		    }

		}
		set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '$year_scadenza year'" -default ""]
		
	    }


	} elseif {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PBT"} {#sim02  #sim22: Aggiunto || per BAT
	    
	    if {$potenza_impianto <= 100.00 } {#gac14 modificata if per aggiungere =
		
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			
			#se combustibile gpl o metano 4 anni
			if {$combustibile eq "4" || $combustibile eq "5"} {
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
			    
   			} else {;#per gli altri 2
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			}
		    }

		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
		
	    }
	    
	    if {$potenza_impianto > 100.00} {#gac14 modificata if per lasciare solo >
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			
			#se combustibile gpl o metano 2 anni
			if {$combustibile eq "4" || $combustibile eq "5"} {
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]

			} else {;#per gli altri 1 solo
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]

			}
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    #fine sim02

            #gac07 La regione Marche tiene come data scadenza sempre la data di fine mese
	    if {$coimtgen(regione) eq "MARCHE"} {
		set data_scadenza_autocert [db_string q "select (date_trunc('month', :data_scadenza_autocert::date) + interval '1 month' - interval '1 day')::date as end_of_month"]
	    }
        } elseif {$coimtgen(regione) eq "TOSCANA"} {#sim28

	    if {[string equal $data_scadenza_autocert ""]} {
		if {$sw_data_controllo_ok == "t" && $flag_errore_data_controllo eq "f" } {

		    set dt_controllo [clock format [clock scan "$data_controllo - 4 years"] -format "%Y%m%d"]

		    set data_insta_controllo $data_insta

		    #sim34 se metano o gpl e ha meno di 4 anni
		    if {$combustibile eq "4" || $combustibile eq "5"} {#sim34
			
			if {$potenza_impianto <= 100} {#se potenza minore di 100
			    
			    #primo controllo ha scadenza 4 anni
			    if {$dt_controllo <= $data_insta_controllo} {			    		    
				set anno_scad [expr [string range $data_controllo 0 3] + 4]
			    } else {#dopo il primo sempre 2 anni
				set anno_scad [expr [string range $data_controllo 0 3] + 2]
			    }
			    
			} else {#se potenza maggiore di 100
			    
			    #sempre 2 anni
			    set anno_scad [expr [string range $data_controllo 0 3] + 2]
			    
			}

		    } else {#tutti quelli tranne metano e gpl
			
			if {$potenza_impianto <= 100} {#se potenza minore di 100
			    
			    #2 anni
			    set anno_scad [expr [string range $data_controllo 0 3] + 2]
			    
			} else {#se potenza maggiore di 100
			    
			    #1 anno
			    set anno_scad [expr [string range $data_controllo 0 3] + 1]
			    
			}
		    }

		    #la scadenza va sempre al 31/12 dell'anno 
		    append anno_scad "1231"
		    set data_scadenza_autocert $anno_scad
		    
		}
	    } else {
		set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		if {$data_scadenza_autocert == 0} {
                        element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
                        incr error_num
		}
	    }
	    

	} elseif {$coimtgen(regione) eq "CALABRIA"} {#sim10

	    if {$potenza_impianto < 100.00 } {
		
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			
			#se combustibile gpl o metano 
			if {$combustibile eq "4" || $combustibile eq "5"} {

			    #se l'impianto e' "giovane", scade tra 4 anni
			    if {$flag_impianto_vecchio ne "1"} {
				set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
			    } else {;#altrimenti sono 2 anni
				set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			    }

   			} else {;#per gli altri 2
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			}
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
		
	    }
	    
	    if {$potenza_impianto >= 100.00} {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			
			#se combustibile gpl o metano 2 anni
			if {$combustibile eq "4" || $combustibile eq "5"} {
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			} else {;#per gli altri 1 solo
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
			}
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    
	    #fine sim10
	} elseif {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA" } {#sim61 aggiunta tutta if. Le righe commentate con #sim61 sono i vecchi calcoli
	    #rom26 Modificate condizioni dell'elseif, ora uso la condizione su tutta la regione Friuli
            #rom26 mentre prima c'era una condizione per ogni ente:
            #rom26 $coimtgen(ente) eq "PUD"
            #rom26 || $coimtgen(ente) eq "PGO"
            #rom26 || $coimtgen(ente) eq "PPN"
            #rom26 || $coimtgen(ente) eq "PTS"
            #rom26 || $coimtgen(ente) eq "CTRIESTE"

	    set tipo_combustibile [db_string q "select tipo as tipo_combustibile 
                                                  from coimcomb 
                                                 where cod_combustibile=:combustibile"]

	    set var_potenza_contr $pot_focolare_nom;#rom26

	    if {$var_potenza_contr < 35.00 } {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			#sim61 set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
			
			if {$tipo_combustibile eq "G"} {#sim61 if else e loro contenuto
			    #sim61 se gassoso 4 anni
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
			} else {
			    #sim61 se diverso  da gassoso 2 anni
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			}
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }

	    if {$var_potenza_contr >= 35.00 && $var_potenza_contr < 100.00} {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			#sim61 set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			
			if {$tipo_combustibile eq "G"} {#sim61 if else e loro contenuto
			    #sim61 se gassoso 2 anni
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			} else {
			    #sim61 se diverso da gassoso 1 anno
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
			}

		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    
	    if {$var_potenza_contr >= 100.00} {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			#sim61 set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]

			if {$tipo_combustibile eq "G"} {#sim61 if else e loro contenuto
			    #sim61 se gassoso 2 anni
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			} else {
			    #sim61 se diverso da gassoso 1 anno
			    set data_scadenza_autocert [db_string query "select :data_controllo::date + 365" -default ""]
			}
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    # Fine caso PUD e PGO e CBARLETTA
	    #rom26 Tolta condizione su CTRIESTE
	} elseif {$coimtgen(ente) eq "CBARLETTA"} {#sim56 #rom02

	    if {$pot_focolare_nom < 35.00 } {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 1460" -default ""]
			
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    
	    if {$pot_focolare_nom >= 35.00 && $pot_focolare_nom < 100.00} {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {
			
			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
						
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    
	    if {$pot_focolare_nom >= 100.00} {
		if {[string equal $data_scadenza_autocert ""]} {
		    if {$sw_data_controllo_ok == "t"} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + 730" -default ""]
			
		    }
		} else {
		    set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		    if {$data_scadenza_autocert == 0} {
			element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
			incr error_num
		    }
		}
	    }
	    # Fine caso CTRIESTE e CBARLETTA

        } elseif {$coimtgen(ente) eq "PCE"} {
            # Provincia di Caserta (usa anche il flag valid_mod_h_b al 04/08/2014)

            if {[string equal $data_scadenza_autocert ""]} {
                if {$sw_data_controllo_ok   == "t"
                &&  $sw_pot_focolare_nom_ok == "t"
                } {
                    if {$pot_focolare_nom < 35.00} {
                        db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                                ,$coimtgen(valid_mod_h))
                                                     ,'YYYYMMDD') as data_scadenza_autocert
                                         from dual"
                    } else {
                        db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                                ,$coimtgen(valid_mod_h_b))
                                                     ,'YYYYMMDD') as data_scadenza_autocert
                                         from dual"
                    }
                }
            } else {
                set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
                if {$data_scadenza_autocert == 0} {
                    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
                    incr error_num
                }
            }
            # Fine caso provincia di Caserta

	} elseif {$coimtgen(ente) eq "PMS" && $err_insta == 0} {#sim17 Massa

	    if {$sw_data_controllo_ok == "t"} {
		set data_insta_controllo [db_string q "select coalesce(:data_insta_contr::date,'1900-01-01')"]
		set oggi         [iter_set_sysdate]
		set dt_controllo [clock format [clock scan "$oggi - 8 years"] -format "%Y%m%d"]
		
		if {$data_insta_controllo < $dt_controllo} {
		    set flag_impianto_vecchio 1
		} else {
		    set flag_impianto_vecchio 0
		}
		
		if {$potenza_impianto < 100.00 && $flag_impianto_vecchio==0 && $locale eq "E"} {;#4 anni
		    set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '4 year'" -default ""]
		} else {;#2 anno
		    set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""]
		}
	    }

	} elseif {$coimtgen(regione) eq "BASILICATA"} {#rom16 aggiunta elseif e contenuto
	    
	    if {$sw_data_controllo_ok == "t"} {

		if {$tipo_comb in [list "S" "L"]} {
		    
		    # Generatori alimentati a combustibile liquido o solido:
		    # Se la potenza utile nominale e' tra 10 e 100 la scadenza e' di 2 anni.
		    # Se la potenza utile nominale e' maggiore di 100 la scadenza e' di un anno.
		    # Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).

		    if {$potenza_impianto >= 10.00 && $potenza_impianto <= 100.00} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""]

		    } elseif {$potenza_impianto > 100.00} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '1 year'" -default ""]

		    } else {
			# Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).
		    }
		} elseif {$tipo_comb in [list "G"]} {

		    #rom19 Modificate le scadenze per i generatori alimentati a gas per nuova legge regionale:
		    #rom19 Generatori alimentati a gas, metano o GPL:
		    #rom19 Se la potenza utile nominale e' tra 10 e 100 la scadenza e' di 2 anni.
		    #rom19 Se la potenza utile nominale e' maggiore di 100 la scadenza e' di 1 anno.
		    # Generatori alimentati a gas, metano o GPL:
		    # Se la potenza utile nominale e' tra 10 e 100 la scadenza e' di 4 anni.
		    # Se la potenza utile nominale e' maggiore di 100 la scadenza e' di 2 anni.
		    # Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).

		    if {$potenza_impianto >= 10.00 && $potenza_impianto <= 100.00} {

			#rom19set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '4 year'" -default ""]
			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""];#rom19

		    } elseif {$potenza_impianto > 100.00} {

			#rom19set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""]
			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '1 year'" -default ""];#rom19

		    } else {
			# Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).
		    }
		    
		} else {
		    
		}

	    } else {
                set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
                if {$data_scadenza_autocert == 0} {
                    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
                    incr error_num
                }
            }
	    
	} elseif {$coimtgen(ente) eq "PPA"} {#rom24 Aggiunta elseif e il suo contenuto

	    if {$sw_data_controllo_ok == "t"} {
		
		if {$tipo_comb in [list "S" "L"]} {
		    
		    # Generatori alimentati a combustibile liquido o solido:
		    # Se la potenza utile nominale e' tra 10 e 100 la scadenza e' di 2 anni.
		    # Se la potenza utile nominale e' maggiore di 100 la scadenza e' di un anno.
		    # Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).

		    if {$potenza_impianto >= 10.00 && $potenza_impianto <= 100.00} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""]

		    } elseif {$potenza_impianto > 100.00} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '1 year'" -default ""]

		    } else {
			# Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).
		    }
		} elseif {$tipo_comb in [list "G"]} {

		    # Generatori alimentati a gas, metano o GPL:
		    # Se la potenza utile nominale e' tra 10 e 100 la scadenza e' di 4 anni.
		    # Se la potenza utile nominale e' maggiore di 100 la scadenza e' di 2 anni.
		    # Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).

		    if {$potenza_impianto >= 10.00 && $potenza_impianto <= 100.00} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '4 year'" -default ""]

		    } elseif {$potenza_impianto > 100.00} {

			set data_scadenza_autocert [db_string query "select :data_controllo::date + interval '2 year'" -default ""]
			
		    } else {
			# Se la potenza utile nominale e' minore di 10 non e' un impianto termico (Sandro dixit).
		    }
		    
		} else {
		    
		}

	    } else {
                set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
                if {$data_scadenza_autocert == 0} {
                    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
                    incr error_num
                }
            }
   

	} else {
	    # Caso standard

	    if {[string equal $data_scadenza_autocert ""]} {
		if {$sw_data_controllo_ok == "t"} {
		    #27/06/2014 D'accordo con Sandro, usiamo il parametro gia' esistente
		    #coimtgen(valid_mod_h): Validità allegati (mesi)
		    #27/06/2014 set data_scadenza_autocert [db_string query "select :data_controllo::date + 775" -default ""]
		    db_1row query "select to_char(add_months(to_date(:data_controllo,'YYYYMMDD')
                                                            ,$coimtgen(valid_mod_h))
                                                 ,'YYYYMMDD') as data_scadenza_autocert
                                     from dual";#27062014
		}
	    } else {
		set data_scadenza_autocert [iter_check_date $data_scadenza_autocert]
		if {$data_scadenza_autocert == 0} {
		    element::set_error $form_name data_scadenza_autocert "Inserire correttamente"
		    incr error_num
		}
	    }
	}
	# Fine istruzioni che devono essere identiche a quelli di iter_cari_rcee_tipo_1

	if {[string equal $ora_inizio ""]} {
	    element::set_error $form_name ora_inizio "Inserire ora di arrivo"
	    incr error_num
	} else {
	    set ora_inizio [iter_check_time $ora_inizio]
	    if {$ora_inizio == 0} {
		element::set_error $form_name ora_inizio "Ora non corretta, deve essere hh:mm"
		incr error_num
	    }
	}
	if {[string equal $ora_fine ""]} {
	    element::set_error $form_name ora_fine "Inserire ora di partenza"
	    incr error_num
	} else {
	    set ora_fine [iter_check_time $ora_fine]
	    if {$ora_fine == 0} {
		element::set_error $form_name ora_fine "Ora non corretta, deve essere hh:mm"
		incr error_num
	    }
	}


	if {![string equal $tiraggio_fumi ""]} {
            set tiraggio_fumi [iter_check_num $tiraggio_fumi 2]
            if {$tiraggio_fumi == "Error"} {
                element::set_error $form_name tiraggio_fumi "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $tiraggio_fumi] >=  [expr pow(10,7)]
		    ||  [iter_set_double $tiraggio_fumi] <= -[expr pow(10,7)]} {
                    element::set_error $form_name tiraggio_fumi "Deve essere inferiore di 10.000.000"
                    incr error_num
                }
            }
        }
	 #rom01 ripeto i controlli per le prove aggiuntive
        set conta_prfumi 0
        while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
            incr conta_prfumi
            if {$conta_prfumi > 9} {
                break
            }
	    if {![string equal $tiraggio_fumi_prfumi($conta_prfumi) ""]} {
		set tiraggio_fumi_prfumi($conta_prfumi) [iter_check_num $tiraggio_fumi_prfumi($conta_prfumi) 2]
		if {$tiraggio_fumi_prfumi($conta_prfumi) == "Error"} {
		    element::set_error $form_name tiraggio_fumi.$conta_prfumi "Deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		    incr error_num
		} else {
		    if {[iter_set_double $tiraggio_fumi_prfumi($conta_prfumi)] >=  [expr pow(10,7)]
			||  [iter_set_double $tiraggio_fumi_prfumi($conta_prfumi)] <= -[expr pow(10,7)]} {
			element::set_error $form_name tiraggio_fumi.$conta_prfumi "Deve essere inferiore di 10.000.000"
			incr error_num
		    }
		}
	    }
	} ;#rom01
	    
	set sw_movi     "f"
	set data_pag    ""
	set importo_pag ""

	if {$sw_costo_null == "f" && ![string equal $tipologia_costo ""]} {
	    set sw_movi "t"
	    if {$flag_pagato == "S"} {
		set data_pag    $data_scad_pagamento
		if {$flag_portafoglio == "T"} {#sim65
                    set importo_pag [expr $costo + $importo_tariffa];#sim60
                } else {#sim65
                    set importo_pag $costo
                };#sim65
	    }
	}

	set conta 0
	# controllo sui dati delle anomalie
	while {$conta < 5} {
	    incr conta
	    if {![string equal $data_ut_int($conta) ""]} {
		set data_ut_int($conta) [iter_check_date $data_ut_int($conta)]
		if {$data_ut_int($conta) == 0} {
		    element::set_error $form_name data_ut_int.$conta "Data non corretta"
		    incr error_num
		} else {
		    if {$data_controllo > $data_ut_int($conta)} {
			element::set_error $form_name data_ut_int.$conta "Data precedente al controllo"
			incr error_num
		    }
		}
		if {[string equal $cod_anom($conta) ""]} {
		    element::set_error $form_name cod_anom.$conta "Inserire anche anomalia oltre alla data utile intervento"
		    incr error_num
		}
	    }
	    
	    if {![string equal $cod_anom($conta) ""]} {
		set sw_dup "f"
		set conta2 $conta
		while {$conta2 > 1 && $sw_dup == "f"} {
		    incr conta2 -1
		    if {$cod_anom($conta) == $cod_anom($conta2)} {
			element::set_error $form_name cod_anom.$conta "Anomalia gi&agrave; presente"
			incr error_num
			set sw_dup "t"
		    }
		}

		set cod_anom_db  $cod_anom($conta)
		set prog_anom_db $prog_anom($conta)
		if {$sw_dup == "f"
		    &&  [db_string sel_anom_count ""] >= 1
		} {
		    element::set_error $form_name cod_anom.$conta "Anomalia gi&agrave; presente"
		    incr error_num
		}
	    }
	}
	
	db_1row sel_tgen_canne "select flag_obbligo_canne from coimtgen"
	if {$flag_obbligo_canne == "S"} {
	    if {$scar_ca_si == "S"
		&& $scar_parete == "S"} {
		element::set_error $form_name scar_ca_si "Solo una delle tre opzioni pu&ograve; essere Si"
		incr error_num
	    } else {
		if {$scar_ca_si == "S"
		    && $scar_can_fu == "S"} {
		    element::set_error $form_name scar_ca_si "Solo una delle tre opzioni pu&ograve; essere Si"
		    incr error_num
		} else {
		    if {$scar_parete == "S"
			&& $scar_can_fu == "S"} {
			element::set_error $form_name scar_parete "Solo una delle tre opzioni pu&ograve; essere Si"
			incr error_num
		    }
		}
	    } 
	}
    }

    #21/10/2014 Sandro
    if {$coimtgen(ente) eq "CRIMINI"}  {
	if {$funzione eq "I"} {
	    db_1row query "
            select pdr, pod, foglio, mappale, subalterno
              from coimaimp
             where cod_impianto = :cod_impianto"

	    if {[string is space $pdr]
	    ||  [string is space $pod]
	    ||  [string is space $foglio]
	    ||  [string is space $mappale]
	    ||  [string is space $subalterno]
	    } {
		#nic20141217 Nicola 17/12/2014: devo propagare su Rimini ma Sandro ha detto di
		#nic20141217 commentare la sua modifica

                #nic20141217 element::set_error $form_name num_autocert "Inserire PDR e POD in Ditte/Tecnici  e i Dati Catastali in Ubicazione"
		#nic20141217 incr error_num
	    }
	}
    }
      if {$coimtgen(ente) eq "PFI"} {#san03: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160428"} {
	    db_1row query "
             select locale
               from coimgend
              where cod_impianto = :cod_impianto
              and flag_attivo = 'S' limit 1"

	    if {[string is space $locale]
	       } {
		element::set_error $form_name num_autocert "Inserire TIPO LOCALE su GENERATORE- Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }
    #21/10/2014 Sandro-Fine modifica

    if {($coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CJESI"  || $coimtgen(ente) eq "CSENIGALLIA") && $id_ruolo ==  "manutentore"} {;#san14 if e suo contenuto
	if { ($funzione eq "I" && $data_controllo >= "20150101")} {
	    db_1row query "select a.locale
                                , a.dpr_660_96
                             from coimgend a
                            where a.cod_impianto = :cod_impianto
                              and a.gen_prog     = :gen_prog"
            if {[string is space $locale]
		||  [string is space $dpr_660_96]
	    } {
		element::set_error $form_name num_autocert "Inserire i dati obbligatori sul Generatore - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }
 
    if {$coimtgen(ente) eq "PLI"} {#san03: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile == "3"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pdr]
	    ||  [string is space $pod]
	    } {
		element::set_error $form_name num_autocert "Inserire PDR e POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

    if {$coimtgen(ente) eq "PLI"} {#san03: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile ne "3"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pod]} {
		element::set_error $form_name num_autocert "Inserire POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

    if {$coimtgen(ente) eq "PBT"} {#san07: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20170320" && $combustibile == "5"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pdr]
	    ||  [string is space $pod]
	    } {
		element::set_error $form_name num_autocert "Inserire PDR e POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

    if {$coimtgen(ente) eq "PBT"} {#san03: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20170320" && $combustibile ne "5"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pod]} {
		element::set_error $form_name num_autocert "Inserire POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

# san fine 20032017
    if {$coimtgen(ente) eq "CANCONA"} {#sim38: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile == "5"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pdr]
	    } {
		element::set_error $form_name num_autocert "Inserire PDR in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

    if {$coimtgen(regione) eq "CALABRIA"} {#sim20: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile == "5"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pdr]
	    ||  [string is space $pod]
	    } {
		element::set_error $form_name num_autocert "Inserire PDR e POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

    if {$coimtgen(regione) eq "CALABRIA"} {#sim20: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile ne "5"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $pod]} {
		element::set_error $form_name num_autocert "Inserire POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }


    if {$coimtgen(ente) eq "PTA"} {#san05: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile == "3"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
          --sim16 , cod_intestatario
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $cod_int_contr]} {#sim16: aggiunta if e suo contenuto
                element::set_error $form_name cognome_contr "Inserire Intestatario Contratto"
		incr error_num
            }

	    #sim16 tolto             ||  [string is space $cod_intestatario]
	    if {[string is space $pdr]
	    ||  [string is space $pod]
	    } {
		element::set_error $form_name num_autocert "Inserire PDR e POD in Ditte/Tecnici, Intestatario in Soggetti - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }

    if {$coimtgen(ente) eq "PTA"} {#san05: aggiunta if e suo contenuto
	if {$funzione eq "I" && $data_controllo >= "20160101" && $combustibile ne "3"} {
	    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
          --sim16 , cod_intestatario
               from coimaimp
              where cod_impianto = :cod_impianto"

	    if {[string is space $cod_int_contr]} {#sim16: aggiunta if e suo contenuto
		element::set_error $form_name cognome_contr "Inserire Intestatario Contratto"
		incr error_num
	    }

	    #sim16 tolto             ||  [string is space $cod_intestatario]
	    if {[string is space $pod]
               } {
		element::set_error $form_name num_autocert "Inserire POD in Ditte/Tecnici - Si puo' aprire una Nuova finestra senza uscire dal programma"
		incr error_num
	    }
	}
    }
    
    if {![db_0or1row query "
        select patentino 
          from coimmanu 
         where cod_manutentore = :cod_manutentore"]
    } {#sim09:aggiunta if e suo contenuto
	set patentino "f"
    }

    #rom34 Aggiunta condizione su Basilicata
    if {$coimtgen(regione) in [list "MARCHE" "BASILICATA"] &&
	[db_0or1row q "select 1 
                         from coimaimp 
                        where cod_impianto=:cod_impianto 
                          and flag_resp != 'T'"]} {#sim74 if e suo contenuto
	set patentino "t"
    }
    
    if {$coimtgen(ente) eq "CCARRARA"} {;#san10
        set patentino "t"
    }

    #sim33 aggiunto if su funzione
    if {$funzione eq "I" && $potenza_impianto > 232 && $patentino eq "f"} {#sim09: aggiunta if e suo contenuto
	element::set_error $form_name $error_nome_col_potenza "Manutentore non fornito di patentino. Impossibile inserire impianti con potenza maggiore di 232 kW"
	incr error_num
    }
    #gac01 aggiunti controlli su stagione_risc, stagione_risc2, consumo_annuo, consumo_annuo2
    #Sandro il 13/06/2018 ha detto di togliere i controlli
#    if {[string is space $stagione_risc]} {
#	element::set_error $form_name stagione_risc "Inserire Stagione di riscaldamento attuale"
#        incr error_num
#    }
#    if {[string is space $stagione_risc2]} {
#        element::set_error $form_name stagione_risc2 "Inserire Stagione di riscaldamento precedente"
#        incr error_num
#    }
    if {![string equal $acquisti ""]} {
	set acquisti [iter_check_num $acquisti 2]
	if {$acquisti == "Error"} {
	    element::set_error $form_name acquisti "Acquisti deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $acquisti2 ""]} {
	set acquisti2 [iter_check_num $acquisti2 2]
	if {$acquisti2 == "Error"} {
	    element::set_error $form_name acquisti2 "Acquisti deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_iniz ""]} {
	set scorta_o_lett_iniz [iter_check_num $scorta_o_lett_iniz 2]
	if {$scorta_o_lett_iniz == "Error"} {
	    element::set_error $form_name scorta_o_lett_iniz "Scorta o lettura iniziale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_iniz2 ""]} {
	set scorta_o_lett_iniz2 [iter_check_num $scorta_o_lett_iniz2 2]
	if {$scorta_o_lett_iniz2 == "Error"} {
	    element::set_error $form_name scorta_o_lett_iniz2 "Scorta o lettura iniziale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_fin ""]} {
	set scorta_o_lett_fin [iter_check_num $scorta_o_lett_fin 2]
	if {$scorta_o_lett_fin == "Error"} {
	    element::set_error $form_name scorta_o_lett_fin "Scorta o lettura finale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_fin2 ""]} {
	set scorta_o_lett_fin2 [iter_check_num $scorta_o_lett_fin2 2]
	if {$scorta_o_lett_fin2 == "Error"} {
	    element::set_error $form_name scorta_o_lett_fin2 "Scorta o lettura finale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    
    #gac01 aggiunti controlli e calcolo consumo anno automatico nel caso in cui consumo_annuo o consumo_annuo2 siano vuoti
    if {[string is space $consumo_annuo] && [string is space $scorta_o_lett_iniz] &&  [string is space $scorta_o_lett_fin]} {
        #Sandro il 13/06/2018 ha detto di togliere i controlli
	#element::set_error $form_name consumo_annuo "Inserire Consumi stagione"
        #incr error_num
    } elseif {[string is space $consumo_annuo] && [string is space $scorta_o_lett_iniz]} {
	set scorta_o_lett_iniz "0.00"
	set consumo_annuo [expr $scorta_o_lett_fin - $scorta_o_lett_iniz]
    } elseif {[string is space $consumo_annuo] && [string is space $scorta_o_lett_fin]} {
        set scorta_o_lett_fin "0.00"
        set consumo_annuo [expr $scorta_o_lett_fin - $scorta_o_lett_iniz]
    } elseif {[string is space $consumo_annuo]} {
        set consumo_annuo [expr $scorta_o_lett_fin - $scorta_o_lett_iniz]
    }

    if {[string is space $consumo_annuo2] && [string is space $scorta_o_lett_iniz2] &&  [string is space $scorta_o_lett_fin2]} { 
	#Sandro il 13/06/2018 ha detto di togliere i controlli
        #element::set_error $form_name consumo_annuo2 "Inserire Consumi stagione"
        #incr error_num
    } elseif {[string is space $consumo_annuo2] && [string is space $scorta_o_lett_iniz2]} {
        set scorta_o_lett_iniz2 "0.00"
        set consumo_annuo2 [expr $scorta_o_lett_fin2 - $scorta_o_lett_iniz2]
    } elseif {[string is space $consumo_annuo2] && [string is space $scorta_o_lett_fin2]} {
        set scorta_o_lett_fin2 "0.00"
        set consumo_annuo2 [expr $scorta_o_lett_fin2 - $scorta_o_lett_iniz2]
    } elseif {[string is space $consumo_annuo2]} {
	set consumo_annuo2 [expr $scorta_o_lett_fin2 - $scorta_o_lett_iniz2]
    }
    
    if {![string equal $elet_esercizio_1 ""]} {
        set elet_esercizio_1 [iter_check_num $elet_esercizio_1 0]
        if {$elet_esercizio_1 == "Error"} {
            element::set_error $form_name elet_esercizio_2 "Esercizio deve essere numerico"
            incr error_num
        }
    }
    if {![string equal $elet_esercizio_2 ""]} {
        set elet_esercizio_2 [iter_check_num $elet_esercizio_2 0]
        if {$elet_esercizio_2 == "Error"} {
            element::set_error $form_name elet_esercizio_2 "Esercizio deve essere numerico"
            incr error_num
        }
    }
    if {![string equal $elet_esercizio_3 ""]} {
        set elet_esercizio_3 [iter_check_num $elet_esercizio_3 0]
        if {$elet_esercizio_3 == "Error"} {
            element::set_error $form_name elet_esercizio_4 "Esercizio deve essere numerico"
            incr error_num
        }
    }
    if {![string equal $elet_esercizio_4 ""]} {
        set elet_esercizio_4 [iter_check_num $elet_esercizio_4 0]
        if {$elet_esercizio_4 == "Error"} {
            element::set_error $form_name elet_esercizio_4 "Esercizio deve essere numerico"
            incr error_num
        }
    }

    if {![string equal $elet_lettura_iniziale ""]} {
        set elet_lettura_iniziale [iter_check_num $elet_lettura_iniziale 2]
        if {$elet_lettura_iniziale == "Error"} {
            element::set_error $form_name elet_lettura_iniziale "Lettura iniziale deve essere numerico e può avere al massimo 2 decimali"
            incr error_num
        }
    }

    if {![string equal $elet_lettura_iniziale_2 ""]} {
        set elet_lettura_iniziale_2 [iter_check_num $elet_lettura_iniziale_2 2]
        if {$elet_lettura_iniziale_2 == "Error"} {
            element::set_error $form_name elet_lettura_iniziale_2 "Lettura iniziale deve essere numerico e può avere al massimo 2 decimali"
            incr error_num
        }
    }

    if {![string equal $elet_lettura_finale ""]} {
        set elet_lettura_finale [iter_check_num $elet_lettura_finale 2]
        if {$elet_lettura_finale == "Error"} {
            element::set_error $form_name elet_lettura_finale "Lettura finale deve essere numerico e può avere al massimo 2 decimali"
            incr error_num
        }
    }

    if {![string equal $elet_lettura_finale_2 ""]} {
        set elet_lettura_finale_2 [iter_check_num $elet_lettura_finale_2 2]
        if {$elet_lettura_finale_2 == "Error"} {
            element::set_error $form_name elet_lettura_finale_2 "Lettura finale deve essere numerico e può avere al massimo 2 decimali"
            incr error_num
        }
    }

    if {![string equal $elet_consumo_totale ""]} {
        set elet_consumo_totale [iter_check_num $elet_consumo_totale 2]
        if {$elet_consumo_totale == "Error"} {
            element::set_error $form_name elet_consumo_totale "Consumo totale deve essere numerico e può avere al massimo 2 decimali"
            incr error_num
        }
    }

    if {![string equal $elet_consumo_totale_2 ""]} {
        set elet_consumo_totale_2 [iter_check_num $elet_consumo_totale_2 2]
        if {$elet_consumo_totale_2 == "Error"} {
            element::set_error $form_name elet_consumo_totale_2 "Consumo totale deve essere numerico e può avere al massimo 2 decimali"
            incr error_num
        }
    }

        
    if {$coimtgen(regione) eq "MARCHE"} {#gac07

	if {$cod_tprc eq "" && $funzione ne "D"} {#gac07 if e contenuto
	    element::set_error $form_name cod_tprc "Inserire"
	    incr error_num
	}
	
	db_1row q "select --flag_sostituito
                    gen_prog_originario
                 from coimgend
                where cod_impianto = :cod_impianto
                  and gen_prog = :gen_prog
                limit 1";#gac07
	#gac07 PRIMMES - SOSTGEN
	if {$gen_prog_originario eq "" && $cod_tprc eq "SOSTGEN"} {
	    element::set_error $form_name cod_tprc "ATTENZIONE: dato non corretto - il generatore selezionato non è stato inserito in sostituzione di un altro generatore. $gen_prog"
	    incr error_num
	}
	#rom31 Aggiunti i combustibili ARIA PROPANATA, GNL e SYNGAS
	#rom31 Riscritta if utilizzando il comando in per i valori della variabile descr_comb
	#rom31if {$cont_rend eq "N" && ($descr_comb eq "METANO" || $descr_comb eq "PROPANO" || $descr_comb eq "GPL" || $descr_comb eq "BUTANO" || $descr_comb eq "GASOLIO" || $descr_comb eq "OLIO")} {}#gac07 if e contenuto
	if {$cont_rend eq "N" && ($descr_comb in [list "METANO" "PROPANO" "GPL" "BUTANO" "GASOLIO" "OLIO" "ARIA PROPANATA" "GNL" "SYNGAS"])} {
	    if {$osservazioni eq ""} {
		set msg_osservazioni_cont_rend "<font color=blue>| Indicare nelle osservazioni il perchè del mancato controllo, come previsto dalla norma UNI 10389</font>"
		
	    }
	}

	if {$prescrizioni ne "" && $flag_status eq "P"} {#gac07
	    element::set_error $form_name flag_status "Scelta incongruente con l'inserimento di Prescrizioni"
	}

	if {$flag_pagato eq "" && $funzione ne "D"} {#gac07 if e suo contenuto
	    if {$cod_dimp_precedente eq "" } {
		element::set_error $form_name flag_pagato "Inserire"
		incr error_num
	    }
	} else {
	    if {$flag_pagato eq "N" && $cod_tprc eq "CADALLE"} {
		element::set_error $form_name flag_pagato "Scelta incoerente"
		incr error_num
	    } elseif {($flag_pagato eq "S" || $flag_pagato eq "C")
		      && ($cod_tprc eq "PRIMMES" || $cod_tprc eq "SOSTGEN" || $cod_tprc eq "RISTRUT" || $cod_tprc eq "RIATTIV" || $cod_tprc eq "MANSTRA")} {
		element::set_error $form_name flag_pagato "Scelta incoerente"
		incr error_num
	
	    }
	}
	#rom11 Se sono un installatore e cerco di inserire l'RCEE posso farlo solo per alcune motivazioni.
	#rom11 Se l'istallatore figura anche come manutentore dell'impianto allora non lo devo bloccare.
	#rom14 Aggiunto il coalesce alle where su cod_installatore e cod_manutentore.
	if {[db_0or1row q "select 1 
                             from coimaimp 
                            where cod_impianto = :cod_impianto
                              and coalesce(cod_installatore,'') = :cod_manu
	                      and coalesce(cod_manutentore,'') != :cod_manu"] &&
	    !($cod_tprc in [list "PRIMMES" "SOSTGEN" "RISTRUT"])} {#rom11 if e contenuto
	    element::set_error $form_name cod_tprc "L'RCEE per le ditte di installazione &egrave; consentito solo per i seguenti motivi:<br>- Prima messa in servizio (nuova installazione)<br>- Sostituzione del generatore<br>- Ristrutturazione dell'impianto"
	    incr error_num
	}

    } else {
	if {$flag_combo_tipibol eq "T" && $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom32 aggiunta if e suo contenuto
	    element::set_value $form_name flag_pagato "S"
	    set flag_pagato [string trim [element::get_value $form_name flag_pagato]]
	}
	if {$flag_pagato eq "" && $funzione ne "D"} {#gac07 if e suo contenuto
		element::set_error $form_name flag_pagato "Inserire"
		incr error_num
	}
    }

    if {$coimtgen(regione) eq "MARCHE"} {#rom05 aggiunta if e suo contenuto
	if {![db_0or1row q "select 1 
                              from coimdope_aimp a
                                 , coimdope_gend b
                             where a.cod_impianto = :cod_impianto
                               and a.cod_dope_aimp = b.cod_dope_aimp 
                               and b.gen_prog     = :gen_prog
                             limit 1"]} {
	    element::set_error $form_name warning_dfm "Manca la DFM (Si pu&ograve; procedere comunque con il RCEE ma occorrre inserirla successivamente al RCEE)"
	    #rom06incr error_num
	} else {
	    #come frequenza va presa la prima dell'ultima DFM inserita
	    if {![db_0or1row q "select a.data_dich
                                     , b.frequenza
                                  from coimdope_aimp a
                                     , coimdope_gend b 
                                 where a.cod_impianto  = :cod_impianto 
                                   and a.cod_dope_aimp = b.cod_dope_aimp 
                                   and b.gen_prog = :gen_prog 
                              order by a.data_dich desc,a.cod_dope_aimp 
                                 limit 1"]} {
		set data_dich ""
		set frequenza ""

	    } else {
		if {$funzione ne "D"} {
		
		    if {[string is digit $frequenza] && $data_controllo ne "" && $sw_data_controllo_ok == "t" && $sw_data_prox_manut_ok=="t" && $data_prox_manut ne ""} {#gac12 aggiunta if perche in caso di dati sporchi andava in errore la query
			
			#		    set data_controllo_per_frequenza [iter_check_date $data_controllo]
			set data_controllo_per_frequenza [db_string q "select coalesce(:data_controllo::date,'1900-01-01')"]
			set data_prox_manut_per_frequenza [db_string q "select coalesce(:data_prox_manut::date,'1900-01-01')"]
			
			#ricavo la data dell'ultimo RCEE (se presente)
			db_0or1row q "select max(data_controllo) as data_controllo_ultimo_rcee 
                                    from coimdimp 
                                   where cod_impianto = :cod_impianto
                                     and flag_tracciato='R1'
                                     and cod_dimp != coalesce(:cod_dimp,'')
                                     and data_controllo <= :data_controllo_per_frequenza"

			if {$data_controllo_ultimo_rcee ne ""} {
			    set data_dfm_per_calcolo  [db_string q "select (:data_controllo_ultimo_rcee::date + interval '$frequenza month')::date" -default ""]
			} else {
			    set data_dfm_per_calcolo ""
			}
		    } else {
			set data_dfm_per_calcolo ""
		    }
		    
		    #$data_controllo_per_frequenza-$data_prox_manut-$data_dfm_per_calcolo
#		    if {$sw_data_controllo_ok == "t" && $data_dfm_per_calcolo ne "" && $data_controllo_per_frequenza > $data_dfm_per_calcolo && $data_prox_manut_per_frequenza > $data_dfm_per_calcolo} {
#			set data_controllo_ultimo_rcee_pretty [db_string q "select iter_edit_data(:data_controllo_ultimo_rcee)"]
			#set warning_dfm "<font color=red>Incongruenza con la DFM, controllo eseguito il $data_controllo_ultimo_rcee_pretty</font>"
			
			#element set_properties $form_name warning_dfm       -value $warning_dfm
#		    } else {
			#element set_properties $form_name warning_dfm       -value ""
#		    }
		    
#		    if {$sw_data_prox_manut_ok=="t" && $data_prox_manut_per_frequenza > $data_dfm_per_calcolo} {
			
			#element::set_error $form_name data_prox_manut "La data indicata supera la cadenza manutentiva stabilita dalla DFM"
			
#		    }
		    
		}
	    }
	}	

	
    }

    #Per regione marche tutti i controlli devono essere posti sopra questa if
    if {$coimtgen(regione) eq "MARCHE"} {#gac07
	#gac07 if {$cod_tprc eq "CADALLE" && $changed_field eq "cod_tprc"} {}
	if {$error_num==0 && $flag_pagato eq "S" && $funzione eq "I"} {
	    
	    if {$is_warning_p eq "f"} {#gac07 aggiunto if e suo contenuto
		element::set_error $form_name msg_rcee "ATTENZIONE: confermando l'inserimento del REE applicherai anche il relativo segno identificativo."
		incr error_num
	    }
	    set is_warning_p "t"
	} else {
	    set is_warning_p "f"
	}
	element set_properties $form_name is_warning_p           -value $is_warning_p
    }

    if {$coimtgen(regione) ne "MARCHE"} {#rom15 aggiunta if e suo contenuto
	if {[string equal $flag_pagato "N"]	&&
	    [string equal $osservazioni ""]} {#rom15 aggiunta if e contenuto
	    
	    element::set_error $form_name flag_pagato "Indicare le Osservazioni."
	    incr error_num
	    
	}
    }

    if {$error_num > 0} {

	#sim77 se ho avuto errori devo sempre ripopolare le options del controllo fumi in base al combustibile come fatto
	#sim77 nel is_request  
	#rom31 Aggiunti i combustibili ARIA PROPANATA, GNL e SYNGAS
        #rom31 Riscritta if utilizzando il comando in per i valori della variabile descr_comb
	#rom031if {!($descr_comb eq "METANO"  || 
        #rom31$descr_comb eq "PROPANO" || 
	#rom31$descr_comb eq "GPL"     || 
	#rom31$descr_comb eq "BUTANO"  || 
	#rom31$descr_comb eq "GASOLIO" || 
	#rom31$descr_comb eq "OLIO")} {}#sim77 if e suo contenuto
	if {!($descr_comb in [list "METANO" "PROPANO" "GPL" "BUTANO" "GASOLIO" "OLIO" "ARIA PROPANATA" "GNL" "SYNGAS"])} {#rom31 Aggiunta if ma non il suo contenuto
    	    element set_properties $form_name cont_rend -options {{{Non effettuato} N}}
	    element set_properties $form_name cont_rend -html    {readonly {} class form_element}
	    set cont_rend "N"

	}


	if {$coimtgen(regione) eq "MARCHE"} {#gac07
	    element::set_error $form_name err_rcee "ATTENZIONE sono presenti degli errori nella pagina"
	} else {
	    if {$flag_errore_data_controllo == "f"} {
		element::set_error $form_name data_controllo "ATTENZIONE sono presenti degli errori nella pagina"
	    }
	}
	ad_return_template
	return
    } else {	

	if {$flag_portafoglio == "T"
	    && $funzione == "I"
	    && $data_controllo >= "20080801"
	    && $importo_tariffa >= "0.00"
	} {
	    set cod_manu [iter_check_uten_manu $id_utente]
	    if {[string range $id_utente 0 1] == "AM"} {
		set cod_manu $id_utente
	    }
	    if {![string equal $cod_manu ""]} {
		set url "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio"
	    } else {
		set url "lotto/balance?iter_code=$cod_manutentore&ente_portafoglio=$ente_portafoglio"
	    }
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    #ns_return 200 text/html "$result(page) $cod_manu"
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
	    } else {
		set saldo ""
		set conto_manu ""
	    }

	    if {[string equal $saldo ""]} {
		if {$coimtgen(regione) eq "MARCHE"} {#gac07
		    element::set_error $form_name err_rcee "ATTENZIONE transazione non avvenuta correttamente "
		} else {
		    element::set_error $form_name data_controllo "ATTENZIONE transazione non avvenuta correttamente "
		}
		ad_return_template
		return
	    }

	    set tot_importo_wallet [expr $costo + $importo_tariffa]

	    if {[expr [iter_check_num $saldo 2] + 0] >= $tot_importo_wallet} {
		set oggi [db_string sel_date "select current_date"]
		db_1row sel_dual_cod_dimp ""
		set database [db_get_database]
		set reference "$cod_dimp+$database"

		set costo_wallet $costo
		set importo_tariffa_wallet $importo_tariffa

		if {![string equal $cod_manu ""]} {
		    set url "lotto/itermove?iter_code=$cod_manu&body_id=1&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$costo_wallet&ente_portafoglio=$ente_portafoglio"
		    set url_reg "lotto/itermove?iter_code=$cod_manu&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_tariffa_wallet&ente_portafoglio=$ente_portafoglio"
		} else {
		    set url "lotto/itermove?iter_code=$cod_manutentore&body_id=1&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$costo_wallet&ente_portafoglio=$ente_portafoglio"
		    set url_reg "lotto/itermove?iter_code=$cod_manutentore&body_id=3&tran_type_id=2&payment_type=1&payment_date=$oggi&reference=$reference&description=pagamento&amount=$importo_tariffa_wallet&ente_portafoglio=$ente_portafoglio"
		}
		set data [iter_httpget_wallet $url]
		array set result $data
		#		ns_return 200 text/html "$result(page)"; return
		set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
		if {$risultato == "OK"} {
		    set transaz_eff "T"
		} else {
		    if {$coimtgen(regione) eq "MARCHE"} {#gac07
			element::set_error $form_name err_rcee "ATTENZIONE transazione non avvenuta correttamente"
		    } else {
			element::set_error $form_name data_controllo "ATTENZIONE transazione non avvenuta correttamente"
		    }
		    ad_return_template
		    return
		}

		#se presente tariffa regionale carico anche il suo movimento
		if {$importo_tariffa_wallet > 0} {
		    set data [iter_httpget_wallet $url_reg]
		    array set result $data
		    #		ns_return 200 text/html "$result(page)"; return
		    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
		    if {$risultato == "OK"} {
			set transaz_eff "T"
		    } else {
			if {$coimtgen(regione) eq "MARCHE"} {#gac07
			    element::set_error $form_name err_rcee "ATTENZIONE transazione non avvenuta correttamente"
			} else {
			    element::set_error $form_name data_controllo "ATTENZIONE transazione non avvenuta correttamente"
			}
			ad_return_template
			return
		    }
		}

	    } else {
		if {$coimtgen(regione) eq "MARCHE"} {#gac07
		    element::set_error $form_name err_rcee "ATTENZIONE il saldo del manutentore non &egrave; sufficente"
		} else {
		    element::set_error $form_name data_controllo "ATTENZIONE il saldo del manutentore non &egrave; sufficente"
		}
		ad_return_template
		return
	    }
	} else {
	    if {$funzione == "I"} {
		db_1row sel_dual_cod_dimp ""
	    }
	}
    }

    if {$funzione != "V"} {
	# leggo i soggetti, la potenza e data prima dich dell'impianto
	# che servono in preparazione inserimento, modifica e cancellazione
	if {[db_0or1row sel_aimp_old ""] == 0} {
	    iter_return_complaint "Impianto non trovato"
	}
    }

    if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#nic06
	set potenza_chk $potenza;#nic06
    } else {#nic06
	set potenza_chk $pot_focolare_nom
    };#nic06

    if {$funzione == "I" || $funzione == "M"} {
	# controllo se esiste un modello H con data piu' recente, in questo caso non vado ad eseguire gli aggiornamenti
	if {[db_0or1row check_modh_old ""] == 0} {
	    set data_ultimo_modh "19000101"
	}

	# Preparo i default per le note da segnalare sui todo
	set note_todo          ""
	set flag_evasione_todo "E"
	set data_controllo_db [string range $data_controllo 0 3]
	append data_controllo_db [string range $data_controllo 5 6]
	append data_controllo_db [string range $data_controllo 8 9]
	if {$data_controllo >= $data_ultimo_modh} {
	    # La potenza va confrontata con quella dell'impianto:
	    # se quella dell'impianto e' non nota, quella del modello h sovrascrive
	    # quella dell'impianto. L'aggiornamento viene registrato nel todo.
	    # se quella dell'impianto e' nota, la differenza viene segnalata todo.

	    # I soggetti del modello h vanno confrontati con quelli dell'impianto:
	    # se vi sono differenze, a seconda del parametro flag_agg_sogg,
	    # essi vanno a sovrascrivere quelli dell'impianto e l'aggiornamento
	    # viene registrato.
	    # Se il parametro flag_agg_sogg = "N" allora la differenza viene
	    # solo segnalata nel todo.

	    # preparo variabili editate e descrizione da utilizzare nei todo
	    if {[string is space $cod_manutentore]} {
		set desc_manu     "NON NOTO"
	    } else {
		set desc_manu     "$cognome_manu $nome_manu"
	    }
	    if {[string is space $cod_manutentore_old]} {
		set desc_manu_old "NON NOTO"
	    } else {
		set desc_manu_old "$cognome_manu_old $nome_manu_old"
	    }

	    if {[string is space $cod_responsabile]} {
		set desc_resp     "NON NOTO"
	    } else {
		set desc_resp     "$cognome_resp $nome_resp"
	    }
	    if {[string is space $cod_responsabile_old]} {
		set desc_resp_old "NON NOTO"
	    } else {
		set desc_resp_old "$cognome_resp_old $nome_resp_old"
	    }

	    if {[string is space $cod_occupante]} {
		set desc_occu     "NON NOTO"
	    } else {
		set desc_occu     "$cognome_occu $nome_occu"
	    }
	    if {[string is space $cod_occupante_old]} {
		set desc_occu_old "NON NOTO"
	    } else {
		set desc_occu_old "$cognome_occu_old $nome_occu_old"
	    }

	    if {[string is space $cod_proprietario]} {
		set desc_prop     "NON NOTO"
	    } else {
		set desc_prop     "$cognome_prop $nome_prop"
	    }
	    if {[string is space $cod_proprietario_old]} {
		set desc_prop_old "NON NOTO"
	    } else {
		set desc_prop_old "$cognome_prop_old $nome_prop_old"
	    }

	    if {[string is space $cod_int_contr]} {
		set desc_contr     "NON NOTO"
	    } else {
		set desc_contr     "$cognome_contr $nome_contr"
	    }
	    if {[string is space $cod_int_contr_old]} {
		set desc_contr_old "NON NOTO"
	    } else {
		set desc_contr_old "$cognome_contr_old $nome_contr_old"
	    }
	    

	    # inizio della fase di confronto dati modello h ed impianto
	    
	    set potenza_edit     [iter_edit_num $potenza_chk 2]

	    #potenza_old viene letta in modo dinamico con $nome_col_aimp_potenza
	    set potenza_old_edit [iter_edit_num $potenza_old 2]

	    #nic06 if {$potenza > 0}
	    if {$potenza_chk > 0} {#nic06
		# potenza dell'impianto non nota e del modello h valorizzata
		if {$potenza_old == 0 || [string equal $potenza_old ""]} {
		    if {[db_0or1row sel_pote_fascia ""] == 0} {
			set cod_potenza ""
		    }
		    
		    set dml_aimp_pote [db_map upd_aimp_pote]
		    append note_todo "Potenza dell'impianto aggiornata da NON NOTA a $potenza_edit kW \n"

		    db_1row sel_gend_count ""
		    if {$conta_gend == 1} {
			set dml_gend_pote [db_map upd_gend_pote]
		    }
		} else {
		    # potenza dell'impianto nota e del modello h valorizzata
		    if {$potenza != $potenza_old} {
			# segnalo solamente la differenza sul todo
			append note_todo "Potenza dell'impianto ($potenza_old_edit kW) diversa dalla potenza dell'RCEE di tipo 1 ($potenza_edit kW) \n"
		    }
		}
	    }

	    # se e' cambiato almeno un soggetto:

	    if {$cod_manutentore  != $cod_manutentore_old
		|| $cod_responsabile != $cod_responsabile_old
		|| $cod_occupante    != $cod_occupante_old
		|| $cod_proprietario != $cod_proprietario_old
		|| $cod_int_contr    != $cod_int_contr_old
	    } {
		# evito di cancellare il responsabile dell'impianto.
		if {[string equal $cod_responsabile ""]} {
		    set cod_responsabile_new $cod_responsabile_old
		} else {
		    set cod_responsabile_new $cod_responsabile
		}

		# se e' cambiato anche solo un soggetto, i soggetti del modello
		# h sovrascrivono quelli dell'impianto.
		if {$flag_agg_sogg == "T"} {
		    # valorizzo il nuovo flag_resp
		    if {      $cod_responsabile_new == $cod_occupante} {
			set flag_resp "O"
		    } elseif {$cod_responsabile_new == $cod_proprietario} {
			set flag_resp "P"
		    } elseif {$cod_responsabile_new == $cod_amministratore_old} {
			set flag_resp "A"
		    } elseif {$cod_responsabile_new == $cod_intestatario_old} {
			set flag_resp "I"
		    } else {
			set flag_resp "T"
		    }
		    if {$coimtgen(regione) ne "MARCHE"} {#regione marche non può cambiare i soggetti dal RCEE. deve farlo sempre dalla schermata della scheda 1.6 Soggetti che operano sull'impianto
			set dml_upd_aimp_sogg [db_map upd_aimp_sogg]
		    }
		}

		# scrivo le note nel todo ed inserisco lo storico.
		if {$cod_manutentore != $cod_manutentore_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Manutentore dell'impianto aggiornato da $desc_manu_old a $desc_manu \n"
			# memorizzo il vecchio manutentore nello storico
			set ruolo "M"
			if {![string equal $cod_manutentore_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_manu [db_map ins_rife]
			}
		    } else {
			append note_todo "Manutentore dell'impianto ($desc_manu_old) diverso dal manutentore del modello H ($desc_manu) \n"
		    }
		}

		if {$cod_responsabile_new != $cod_responsabile_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Responsabile dell'impianto aggiornato da $desc_resp_old a $desc_resp \n"
			# memorizzo il vecchio responsabile nello storico
			set ruolo "R"
			if {![string equal $cod_responsabile_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_resp [db_map ins_rife]
			}
		    } else {
			append note_todo "Responsabile dell'impianto ($desc_resp_old) diverso dal responsabile del modello H ($desc_resp) \n"
		    }
		}

		if {$cod_occupante != $cod_occupante_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Occupante dell'impianto aggiornato da $desc_occu_old a $desc_occu \n"
			# memorizzo il vecchio occupante nello storico
			set ruolo "O"
			if {![string equal $cod_occupante_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_occu [db_map ins_rife]
			}
		    } else {
			append note_todo "Occupante dell'impianto ($desc_occu_old) diverso dall'occupante del modello H ($desc_occu) \n"
		    }
		}

		if {$cod_proprietario != $cod_proprietario_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Proprietario dell'impianto aggiornato da $desc_prop_old a $desc_prop \n"
			# memorizzo il vecchio proprietario nello storico
			set ruolo "P"
			if {![string equal $cod_proprietario_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_prop [db_map ins_rife]
			}
		    } else {
			append note_todo "Proprietario dell'impianto ($desc_prop_old) diverso dal proprietario del modello H ($desc_prop) \n"
		    }
		}

		if {$cod_int_contr != $cod_int_contr_old} {
		    if {$flag_agg_sogg == "T"} {
			append note_todo "Intestatario Contratto dell'impianto aggiornato da $desc_contr_old a $desc_contr \n"
			# memorizzo il vecchio occupante nello storico
			set ruolo "T"
			if {![string equal $cod_int_contr_old ""]
			    &&   [db_0or1row sel_rife_check ""] == 0
			} {
			    set dml_ins_rife_inte [db_map ins_rife]
			}
		    }
		}
	    }
	    if {[string equal $dt_prima_dich ""]} {
		set dml_upd_aimp_prima_dich [db_map upd_aimp_prima_dich]
	    }

	    # 18/06/2014: Richiesto da Udine ma va bene per tutti.
	    # Se non esiste il bollino, non bisogna aggiornare le date ultimo controllo e
	    # scadenza sulla coimaimp.
	    # Ignoriamo il caso del bollettino postale che ormai non e' piu' usato da nessuno
	    # 30-08-2019 Salerno usa ancora i bollettini senza riferimento e deve comunque aggiornare l'impianto
	    #rom13 sostituito || $coimtgen(ente) eq "PSA" con || $coimtgen(regione) eq "CAMPANIA"
	    if {![string is space $riferimento_pag] || $flag_portafoglio eq "T" || $coimtgen(regione) eq "CAMPANIA"} {
		set dml_upd_aimp_ultim_dich [db_map upd_aimp_ultim_dich]
	    }
	} else {
	    # se il min di data autocertificazione dei modh di quell'impianto ï¿½ piu recente della data del controllo
	    # vado a fare l'update sull'impianto
	    db_1row sel_min_data_controllo ""
	    if {[string equal $min_data_controllo ""]
		|| $min_data_controllo > [iter_check_date $data_controllo]} {
		set dml_upd_aimp_prima_dich [db_map upd_aimp_prima_dich]
	    }
	}

	if {![string equal $note_todo ""]} {
	    set dml_todo_aimp [db_map ins_todo]
	}
	
	# Preparo esito e flag_pericolosita.
	# Se c'e' almeno un'anomalia, l'esito viene forzato a negativo.
	# Se c'e' almeno un'anomalia pericolosa, flag_pericolosita diventa 'T'.

	set flag_pericolosita "F"
	set conta 0
	# ciclo sulle anomalie presenti nella form
	while {$conta < 5} {
	    incr conta
	    if {![string equal $cod_anom($conta) ""]} {
		set flag_status "N"

		set cod_anomalia $cod_anom($conta)
		if {[db_0or1row sel_tano_scatenante ""] == 0} {
		    set flag_scatenante "F"
		}
		if {$flag_scatenante == "T"} {
		    set flag_pericolosita  "T"
		}
	    }
	}

	# in modifica devo considerare anche le anomalie che non compaiono
	# nella pagina corrente (oltre a 5)
	if {$funzione == "M"} {
	    db_foreach sel_tano_anom "" {
		set flag_uguale "f"
		foreach cod_tanom_old $list_anom_old {
		    if {$cod_tanom_old == $cod_tanom_check} {
			set flag_uguale "t"
		    }
		}
		if {$flag_uguale == "f"
		    &&  $flag_scatenante_check == "T"
                } {
		    set flag_pericolosita "T"
		}
	    }
	}

	# in inserimento ed in modifica valorizzo lo stato di conformita'
        # dell'impianto in base all'esito del M.H.
	if {![string equal $flag_status ""]} {
	    # lo aggiorno solo se l'esito del M.H. non e' null
	    if {$flag_status == "P"} {
		set stato_conformita "S"
	    } else {
		set stato_conformita "N"
	    }
	    set dml_upd_aimp_stato [db_map upd_aimp_stato]
	}
    }

    set lista_pesi [list]
    switch $conformita {
	"N" {lappend lista_pesi [list "conformita" "N"]}
	"C" {lappend lista_pesi [list "conformita" "C"]}
    }
    switch $lib_impianto {
	"N" {lappend lista_pesi [list "lib_impianto" "N"]}
	"C" {lappend lista_pesi [list "lib_impianto" "C"]}
    }
    switch $lib_uso_man {
	"N" {lappend lista_pesi [list "lib_uso_man" "N"]}
	"C" {lappend lista_pesi [list "lib_uso_man" "C"]}
    }
    switch $idoneita_locale {
	"N" {lappend lista_pesi [list "idoneita_locale" "N"]}
    }
    switch $ap_ventilaz {
	"N" {lappend lista_pesi [list "ap_ventilaz" "N"]}
	"C" {lappend lista_pesi [list "ap_ventilaz" "C"]}
    }
    switch $ap_vent_ostruz {
	"N" {lappend lista_pesi [list "ap_vent_ostruz" "N"]}
	"C" {lappend lista_pesi [list "ap_vent_ostruz" "C"]}
    }
    switch $pendenza {
	"N" {lappend lista_pesi [list "pendenza" "N"]}
	"C" {lappend lista_pesi [list "pendenza" "C"]}
    }
    switch $sezioni {
	"N" {lappend lista_pesi [list "sezioni" "N"]}
	"C" {lappend lista_pesi [list "sezioni" "C"]}
    }
    switch $curve {
	"N" {lappend lista_pesi [list "curve" "N"]}
	"C" {lappend lista_pesi [list "curve" "C"]}
    }
    switch $lunghezza {
	"N" {lappend lista_pesi [list "lunghezza" "N"]}
	"C" {lappend lista_pesi [list "lunghezza" "C"]}
    }
    switch $conservazione {
	"N" {lappend lista_pesi [list "conservazione" "N"]}
	"C" {lappend lista_pesi [list "conservazione" "C"]}
    }
    switch $scar_ca_si {
	"N" {lappend lista_pesi [list "scar_ca_si" "N"]}
	"C" {lappend lista_pesi [list "scar_ca_si" "C"]}
    }
    switch $scar_parete {
	"N" {lappend lista_pesi [list "scar_parete" "N"]}
	"C" {lappend lista_pesi [list "scar_parete" "C"]}
    }
    switch $riflussi_locale {
	"N" {lappend lista_pesi [list "riflussi_locale" "N"]}
	"C" {lappend lista_pesi [list "riflussi_locale" "C"]}
    }
    switch $assenza_perdite {
	"N" {lappend lista_pesi [list "assenza_perdite" "N"]}
	"C" {lappend lista_pesi [list "assenza_perdite" "C"]}
    }
    switch $cont_rend {
	"N" {lappend lista_pesi [list "cont_rend" "N"]}
    }
    switch $pulizia_ugelli {
	"N" {lappend lista_pesi [list "pulizia_ugelli" "N"]}
	"C" {lappend lista_pesi [list "pulizia_ugelli" "C"]}
    }
    switch $antivento {
	"N" {lappend lista_pesi [list "antivento" "N"]}
	"C" {lappend lista_pesi [list "antivento" "C"]}
    }
    switch $scambiatore {
	"N" {lappend lista_pesi [list "scambiatore" "N"]}
	"C" {lappend lista_pesi [list "scambiatore" "C"]}
    }
    switch $accens_reg {
	"N" {lappend lista_pesi [list "accens_reg" "N"]}
	"C" {lappend lista_pesi [list "accens_reg" "C"]}
    }
    switch $disp_comando {
	"N" {lappend lista_pesi [list "disp_comando" "N"]}
	"C" {lappend lista_pesi [list "disp_comando" "C"]}
    }
    switch $ass_perdite {
	"N" {lappend lista_pesi [list "ass_perdite" "N"]}
	"C" {lappend lista_pesi [list "ass_perdite" "C"]}
    }
    switch $valvola_sicur {
	"N" {lappend lista_pesi [list "valvola_sicur" "N"]}
	"C" {lappend lista_pesi [list "valvola_sicur" "C"]}
    }
    switch $vaso_esp {
	"N" {lappend lista_pesi [list "vaso_esp" "N"]}
	"C" {lappend lista_pesi [list "vaso_esp" "C"]}
    }
    switch $disp_sic_manom {
	"N" {lappend lista_pesi [list "disp_sic_manom" "N"]}
	"C" {lappend lista_pesi [list "disp_sic_manom" "C"]}
    }
    switch $organi_integri {
	"N" {lappend lista_pesi [list "organi_integri" "N"]}
	"C" {lappend lista_pesi [list "organi_integri" "C"]}
    }
    switch $circ_aria {
	"N" {lappend lista_pesi [list "circ_aria" "N"]}
	"C" {lappend lista_pesi [list "circ_aria" "C"]}
    }
    switch $guarn_accop {
	"N" {lappend lista_pesi [list "guarn_accop" "N"]}
	"C" {lappend lista_pesi [list "guarn_accop" "C"]}
    }
    switch $assenza_fughe {
	"N" {lappend lista_pesi [list "assenza_fughe" "N"]}
	"A" {lappend lista_pesi [list "assenza_fughe" "A"]}
    }
    switch $coibentazione {
	"N" {lappend lista_pesi [list "coibentazione" "N"]}
	"A" {lappend lista_pesi [list "coibentazione" "A"]}
    }
    switch $eff_evac_fum {
	"N" {lappend lista_pesi [list "eff_evac_fum" "N"]}
	"A" {lappend lista_pesi [list "eff_evac_fum" "A"]}
    }

    if {$funzione == "I" && $coimtgen(ente) ne "PPD"} {#rom07 spostata qui l'if e contenuto
	
	db_transaction {;#sim32
	    
	    set dml_upd_tppt [db_map upd_tppt]
	    db_dml dml_upd_tppt $dml_upd_tppt
	    set n_prot [db_string query "select descr || '/' || progressivo from coimtppt where cod_tppt = 'UC'"]
	    
	}
	#sim32 set n_prot [db_string query "select descr || '/' || progressivo + 1 from coimtppt where cod_tppt = 'UC'"]
	set data_prot [db_string query "select iter_edit_data(current_date)"]
    };#rom07


    if {$coimtgen(regione) eq "MARCHE" && $funzione in [list "M" "I"]} {#rom18 Aggiunta if e suo contenuto
	if {[db_0or1row q "select 1 
                             from coimcomb
                            where cod_combustibile = :combustibile_dimp
                              and um              != :unita_misura_consumi"]} {
	    
	    # Calcolo i valori dei consumi moltiplicando i valori per il fattore di conversione nell'unita' principale
	    set fatt_di_conv [db_string q "select fattore_conversione 
                                     from coimcomb_fatt_conv
                                    where cod_combustibile = :combustibile_dimp
                                      and um_secondaria    = :unita_misura_consumi"]
	    
	    if {[iter_check_num $acquisti] ne "Error"} {    
		set acquisti [expr $acquisti * $fatt_di_conv]
	    }
	    if {[iter_check_num $scorta_o_lett_iniz] ne "Error"} {
		set scorta_o_lett_iniz  [expr $scorta_o_lett_iniz  * $fatt_di_conv]
	    }
	    if {[iter_check_num $scorta_o_lett_fin] ne "Error"} {
		set scorta_o_lett_fin   [expr $scorta_o_lett_fin   * $fatt_di_conv]
	    }
	    if {[iter_check_num $consumo_annuo] ne "Error"} {
		set consumo_annuo       [expr $consumo_annuo       * $fatt_di_conv]
	    }
	    if {[iter_check_num $acquisti2] ne "Error"} {
		set acquisti2           [expr $acquisti2           * $fatt_di_conv]
	    }
	    if {[iter_check_num $scorta_o_lett_iniz2] ne "Error"} {
		set scorta_o_lett_iniz2 [expr $scorta_o_lett_iniz2 * $fatt_di_conv]
	    }
	    if {[iter_check_num $scorta_o_lett_fin2] ne "Error"} {
		set scorta_o_lett_fin2  [expr $scorta_o_lett_fin2  * $fatt_di_conv]
	    }
	    if {[iter_check_num $consumo_annuo2] ne "Error"} {
		set consumo_annuo2      [expr $consumo_annuo2      * $fatt_di_conv]
	    }
	}
    }
    
    switch $funzione {
        I { if {$flag_portafoglio == "T"
		&& $data_controllo >= "20080801"} {
	    set azione "I"
	    set dml_trans [db_map ins_trans]
	} else {
	    set tariffa_reg ""
	    set importo_tariffa ""
	}
	    #	    ns_return 200 text/html " $tabella $stn"; return
	    
	    if {[exists_and_not_null tabella]} {
		set cod_dimp $cod_dimp_ins
	    }

	    if {$coimtgen(ente) eq "PPA" && $costo > 0.00} {#rom25 Aggiunte if, else e il loro contenuto
		set riferimento_pag $cod_dimp
	    } else {
		set riferimento_pag $riferimento_pag
	    }		
	    
	    set dml_sql [db_map ins_dimp]	
	    #sim32 set dml_upd_tppt [db_map upd_tppt]	

	    # aggiorno su coimaimp il soggetto intestario del contratto
	    set dml_sql1 [db_map upd_aimp]

	    if {$sw_movi == "t"} {
		db_1row sel_dual_cod_movi ""
		set dml_movi [db_map ins_movi]
	    }

	    # in inserimento aggiorno sempre flag_dichiarato
	    set flag_dichiarato "S"

	    # in sel_aimp_old avevo letto data_prima_dich, data_installaz
	    # e note di coimaimp.

	    # se data_installaz non e' valorizzata, ci metto data_controllo
	    # e lo segnalo nelle note.
	    if {[string equal $data_installaz ""]} {
		set data_installaz  $data_controllo
		if {![string is space $note_aimp]} {
		    append note_aimp " "
		}
		append note_aimp "Data installazione presunta da data controllo del primo modello."
	    }

	    set dml_upd_aimp_flag_dich_data_inst [db_map upd_aimp_flag_dich_data_inst]

	    # gestione inserimento delle anomalie + inserimento rispettivi todo
	    set dml_ins_anom      [db_map ins_anom]
	    set dml_ins_todo_anom [db_map ins_todo]

	    # gestione inserimento dei todo relativi ai bollini
	    if {![string equal $note_todo_boll ""]} {
		set dml_ins_todo_boll [db_map ins_todo]
	    }

	    # aggiorno il controllo in agenda manutentore
	    # ad eseguito e con data_esecuzione = data_controllo
	    # se richiamato da coimgage-gest
	    if {![string is space $cod_opma]} {
		set stato           "2"
		set data_esecuzione $data_controllo
		set dml_upd_gage    [db_map upd_gage]
	    }
	    if {$flag_mod_gend == "S"} {
		set dml_upd_gend [db_map upd_gend]
                db_1row sel_gend_count "";#nic03
                if {$conta_gend == 1} {#nic03
                    set aggiorna_potenze_impianto " , potenza       = :pot_focolare_nom
                                                    , potenza_utile = :potenza ";#nic03
		    if {$potenza_chk > 0} {#nic06 Aggiunta if ed il suo contenuto (concordata con Sandro)
			if {[db_0or1row sel_pote_fascia ""]} {
			    append aggiorna_potenze_impianto " , cod_potenza = :cod_potenza"
			}
		    }
                } else {#nic03
                    set aggiorna_potenze_impianto "";#nic03
                };#nic03
		set dml_upd_aimp_mod [db_map upd_aimp_mod]
	    }
	}
        M {
	    
	    if {$flag_portafoglio== "T"} {#gac01
		set costo $costo_old
	    }
	    
	    set dml_sql [db_map upd_dimp]

	    if {$flag_portafoglio == "T"
		&& $data_controllo >= "20080801"} {
		set azione "M"
		set dml_trans [db_map ins_trans]
	    }

	    # aggiorno su coimaimp il soggetto intestario del contratto
	    set dml_sql1 [db_map upd_aimp]
	    
	    if {![exists_and_not_null tabella]} {
		if {$sw_movi == "t"} {
		    if {[db_0or1row sel_movi_check ""] == 0} {
			db_1row sel_dual_cod_movi ""
			set dml_movi  [db_map ins_movi]
		    } else {
			set dml_movi  [db_map upd_movi]
		    }
		} else {
		    set dml_movi      [db_map del_movi]
		}
	    }

	    # gestione delle anomalie: cancellazione todo ed anom
	    # e reinserimento anom e todo
	    set dml_del_todo_anom [db_map del_todo_anom]
	    set dml_del_anom      [db_map del_anom]
	    set dml_ins_anom      [db_map ins_anom]
	    set dml_ins_todo_anom [db_map ins_todo]

	    # gestione dei todo relativi ai bollini:
	    # cancellazione ed eventuale inserimento
	    set dml_del_todo_boll [db_map del_todo_boll]
	    if {![string equal $note_todo_boll ""]} {
		set dml_ins_todo_boll [db_map ins_todo]
	    }
	    if {$flag_mod_gend == "S"} {
		set dml_upd_gend [db_map upd_gend]

                db_1row sel_gend_count "";#nic03
                if {$conta_gend == 1} {#nic03
                    set aggiorna_potenze_impianto " , potenza       = :pot_focolare_nom
                                                    , potenza_utile = :potenza ";#nic03
		    if {$potenza_chk > 0} {#nic06 Aggiunta if ed il suo contenuto (concordata con Sandro)
			if {[db_0or1row sel_pote_fascia ""]} {
			    append aggiorna_potenze_impianto " , cod_potenza = :cod_potenza"
			}
		    }

                } else {#nic03
                    set aggiorna_potenze_impianto "";#nic03
                };#nic03
		set dml_upd_aimp_mod [db_map upd_aimp_mod]
	    }
	}
        D { db_1row query "select stato_dich from coimdimp where cod_dimp = :cod_dimp"
	    if {[exists_and_not_null stato_dich]} {
		iter_return_complaint "Presenti richieste di storno. Funzione di storno impossibile"
	    } else {
		set dml_sql  [db_map del_dimp]

		if {$flag_portafoglio == "T"
		    && [iter_check_date $data_controllo] >= "20080801"} {
		    set azione "D"
		    set dml_trans [db_map ins_trans]
		}
		set dml_movi [db_map del_movi]
		#	    db_1row sel_dimp_count ""
		#	    if {$conta_dimp == 0} {
		#		iter_return_complaint "Record non trovato"
		#	    }
		#	    if {$conta_dimp == 1} {
		# se il modello h che vado a cancellare e' l'unico presente 
		# per l'impianto, valorizzo la data ultima dichiarazione
		# dell'impianto con la data prima dichiarazione
		#		set data_ultim_dich   $data_prima_dich
		#	    } else {
		# se il modello h che vado a cancellare non e' l'unico 
		# presente per l'impianto, valorizzo la data ultima 
		# dichiarazione dell'impianto con la data_controllo
		# dell'ultimo modello h.
		#		db_1row sel_dimp_last ""
		#		set data_ultim_dich   $data_controllo
		#	    }
		#	    set dml_upd_aimp_ultim_dich [db_map upd_aimp_ultim_dich]

		set dml_del_todo_all    [db_map del_todo_all]
		set dml_del_anom_all    [db_map del_anom_all]
		# aggiorno il controllo in agenda manutentore
		# a 'da eseguire' e con data_esecuzione = null
		# se richiamato da coimgage-gest
		if {![string is space $cod_opma]} {
		    set stato           "1"
		    set data_esecuzione ""
		    set dml_upd_gage    [db_map upd_gage]
		}
	    }
	}
}

# Lancio la query di manipolazione dati contenute in dml_sql
if {[info exists dml_sql]} {
        with_catch error_msg {

            db_transaction {
		db_dml dml_coimdimp $dml_sql

		if {$funzione == "I"} {
		    if {$readonly_n_prot eq "readonly"} {
			#sim32 db_dml dml_upd_tppt $dml_upd_tppt
		    }
		}
		db_1row sel_tgen ""
		if {[string equal $flag_pesi "S"]} {
		    db_dml del_dipe ""
		    if {$funzione != "D"} {
			foreach peso $lista_pesi {
			    set nome_campo [lindex $peso 0]
			    set tipo_peso  [lindex $peso 1]
			    db_dml ins_dipe ""
			}
			db_1row sel_tot_pesi ""
			db_dml upd_dipe ""
		    }
		}
		
		if {[info exists dml_trans]} {
		    db_dml dml_coimtrans $dml_trans
		}

		if {[info exists dml_sql1]} {
		    db_dml dml_coimaimp $dml_sql1
		}
		
		if {[info exists dml_movi]} {
		    #sim60 i movimenti devono tenere conto del contributo regionale
		    if {$importo_tariffa eq ""} {#sim60 if e else e loro contenuto
			set importo_tariffa_movi 0
		    } else {
			set importo_tariffa_movi $importo_tariffa
		    }
		
		    set costo [expr $costo + $importo_tariffa_movi];#sim60
		    db_dml dml_coimmovi $dml_movi
		}
		
		if {[info exists dml_upd_aimp_flag_dich_data_inst]} {
		    set note $note_aimp
		    db_dml dml_coimaimp_flag_dich_data_inst $dml_upd_aimp_flag_dich_data_inst
		}
		
		if {[info exists dml_upd_aimp_stato]} {
		    db_dml dml_coimaimp_stato $dml_upd_aimp_stato
		}
		
		if {[info exists dml_aimp_pote]} {
		    db_dml dml_coimaimp $dml_aimp_pote
		}
		if {[info exists dml_gend_pote]} {
		    db_dml dml_coimgend $dml_gend_pote
		}
		if {[info exists dml_upd_aimp_sogg]} {
		    db_dml dml_coimaimp $dml_upd_aimp_sogg
		}
		if {[info exists dml_ins_rife_manu]} {
		    set ruolo            "M"
		    set cod_soggetto_old $cod_manutentore_old
		    db_dml dml_coimrife  $dml_ins_rife_manu
		}
		if {[info exists dml_ins_rife_resp]} {
		    set ruolo            "R"
		    set cod_soggetto_old $cod_responsabile_old
		    db_dml dml_coimrife  $dml_ins_rife_resp
		}
		if {[info exists dml_ins_rife_occu]} {
		    set ruolo            "O"
		    set cod_soggetto_old $cod_occupante_old
		    db_dml dml_coimrife  $dml_ins_rife_occu
		}
		if {[info exists dml_ins_rife_prop]} {
		    set ruolo            "P"
		    set cod_soggetto_old $cod_proprietario_old
		    db_dml dml_coimrife  $dml_ins_rife_prop
		}
		if {[info exists dml_ins_rife_inte]} {
		    set ruolo            "T"
		    set cod_soggetto_old $cod_int_contr_old
		    db_dml dml_coimrife  $dml_ins_rife_inte
		}
		if {[info exists dml_todo_aimp]} {
		    db_1row sel_dual_cod_todo ""
		    set tipologia     "5"
		    set note          $note_todo
		    set data_evento   $data_controllo
		    set flag_evasione $flag_evasione_todo
		    if {$flag_evasione == "N"} {
			set data_evasione ""
			set data_scadenza [iter_set_sysdate]
		    } else {
			set data_evasione $data_evento
			set data_scadenza $data_evento
		    }
		    db_dml dml_coimtodo_aimp $dml_todo_aimp
		}
		
		# in caso di aggiornamento elimino le anomalie
		# con i rispettivi todo
		if {[info exists dml_del_anom]} {
		    set conta 0
		    while {$conta < 5} {
			incr conta
			set prog_anom_db $prog_anom($conta)
			
			if {[info exists dml_del_todo_anom]} {
			    db_dml dml_coimtodo $dml_del_todo_anom
			}
			db_dml dml_coimanom $dml_del_anom
		    }
		}
		
		# in inserimento/aggiornamento inserisco le anomalie con i
		# rispettivi todo
		if {[info exists dml_ins_anom]} { 
		    set conta 0
		    while {$conta < 5} {
			incr conta
			
			if {![string equal $cod_anom($conta) ""]} {
			    # inserisco l'anomalia
			    set prog_anom_db   $prog_anom($conta)
			    set cod_anom_db    $cod_anom($conta)
			    set data_ut_int_db $data_ut_int($conta)
			    
			    db_dml dml_coimanom $dml_ins_anom
			    
			    if {[info exists dml_ins_todo_anom]} {
				db_1row sel_dual_cod_todo ""
				
				set tipologia     "1"
				# estraggo la descrizione anomalia da mettere
				# nelle note del todo

				if {[db_0or1row sel_tano ""] == 0} {
				    set note ""
				}
				
				set data_evento   $data_controllo
				set flag_evasione "N"
				set data_evasione ""
				set data_scadenza $data_ut_int_db
				db_dml dml_coimtodo_anom $dml_ins_todo_anom
			    }
			}
		    }
		}
		if {$funzione ne "D"} {#gac09 aggiunta if se no andava in errore la cancellazione
		    #rom01 inserisco le prove fumi
		    set conta_prfumi 0;#rom01
		    
		    db_dml q "delete from coimdimp_prfumi where cod_dimp=:cod_dimp";#rom01
		    
		    while {$conta_prfumi < ($num_prove_fumi -1)} {#rom01 while e suo contenuto
			incr conta_prfumi
			if {$conta_prfumi > 9} {
			    break
			}
			
			set cod_prfumi_new [db_string q "select coalesce(max(cod_prfumi::integer),'0') + 1 
                                               from coimdimp_prfumi"];#sim08
			
			
			
			incr cod_prfumi_new
			
			set progressivo_prova_fumi_new [db_string q "select coalesce(max(progressivo_prova_fumi),1) + 1 
                                                                   from coimdimp_prfumi 
                                                                  where cod_dimp=:cod_dimp"]
			
			set tiraggio_fumi_new       $tiraggio_fumi_prfumi($conta_prfumi)
			set temp_fumi_new           $temp_fumi_prfumi($conta_prfumi)
			set temp_ambi_new           $temp_ambi_prfumi($conta_prfumi)
			set o2_new                  $o2_prfumi($conta_prfumi)
			set co2_new                 $co2_prfumi($conta_prfumi)
			set bacharach_new           $bacharach_prfumi($conta_prfumi)
			set co_new                  $co_prfumi($conta_prfumi)
			set co_fumi_secchi_ppm_new  $co_fumi_secchi_ppm_prfumi($conta_prfumi)
			set rend_combust_new        $rend_combust_prfumi($conta_prfumi)
			set rct_rend_min_legge_new  $rct_rend_min_legge_prfumi($conta_prfumi)
			set rct_modulo_termico_new  $rct_modulo_termico_prfumi($conta_prfumi)
			set bacharach2_new          $bacharach2_prfumi($conta_prfumi)
			set bacharach3_new          $bacharach3_prfumi($conta_prfumi)
			set portata_comb_new        $portata_comb_prfumi($conta_prfumi)
			set portata_termica_effettiva_new $portata_termica_effettiva_prfumi($conta_prfumi)
			db_dml q "insert into coimdimp_prfumi 
                                    ( cod_prfumi
                                    , cod_dimp 
                                    , progressivo_prova_fumi                                    
                                    , tiraggio
                                    , temp_fumi 
                                    , temp_ambi 
                                    , o2 
                                    , co2 
                                    , bacharach 
                                    , co 
                                    , co_fumi_secchi_ppm
                                    , rend_combust 
                                    , rct_rend_min_legge                                     
                                    , rct_modulo_termico
                                    , bacharach2   --gac02
                                    , bacharach3   --gac02
                                    , portata_comb --gac02 
                                    , portata_termica_effettiva --gac03
                                    ) values ( 
                                      :cod_prfumi_new
                                    , :cod_dimp
                                    , :progressivo_prova_fumi_new
                                    , :tiraggio_fumi_new
                                    , :temp_fumi_new
                                    , :temp_ambi_new
                                    , :o2_new
                                    , :co2_new
                                    , :bacharach_new
                                    , :co_new
                                    , :co_fumi_secchi_ppm_new
                                    , :rend_combust_new
                                    , :rct_rend_min_legge_new
                                    , :rct_modulo_termico_new
                                    , :bacharach2_new   --gac02
                                    , :bacharach3_new   --gac02
                                    , :portata_comb_new --gac02
                                    , :portata_termica_effettiva_new --gac03

                                    
                                    ) "
		    } ;#rom01
		};#gac09
		# in caso di aggiornamento elimino i todo dei bollini
		# li individuo con like delle note sotto indicate
                if {[info exists dml_del_todo_boll]} {
		    set note "Il bollino applicato sul modello H%"
		    db_dml dml_coimtodo_boll $dml_del_todo_boll
		}

		# in inserimento/aggiornamento inserisco gli eventuali
		# todo dei bollini
                if {[info exists dml_ins_todo_boll]} {
		    db_1row sel_dual_cod_todo ""
		    set tipologia     "1"
		    set note          $note_todo_boll
		    set data_evento   $data_controllo
		    set flag_evasione "N"
		    set data_evasione ""
		    set data_scadenza [iter_set_sysdate]

		    db_dml dml_coimtodo_boll $dml_ins_todo_boll
		}

		# in cancellazione elimino tutti i todo e tutte le anom
		# relative al modello H
		if {[info exists dml_del_todo_all]} {
		    db_dml dml_coimtodo $dml_del_todo_all
		}
		if {[info exists dml_del_anom_all]} {
		    db_dml dml_coimanom $dml_del_anom_all
		}

		# in inserimento ed in cancellazione aggiorno il controllo
		# in agenda manutentore
		if {[info exists dml_upd_gage]} {
		    db_dml dml_coimgage $dml_upd_gage
		}

		if {[info exists dml_upd_aimp_prima_dich]} {
		    db_dml dml_coimaimp $dml_upd_aimp_prima_dich
		}

		if {[info exists dml_upd_aimp_ultim_dich]} {
		    db_dml dml_coimaimp $dml_upd_aimp_ultim_dich
		}
                if {[info exists dml_upd_gend]} {
		    db_dml dml_coimgend $dml_upd_gend
		}
                if {[info exists dml_upd_aimp_mod]} {
		    db_dml dml_coimaimp $dml_upd_aimp_mod
		}
	    }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione eq "I"} {
        set last_cod_dimp [list $data_controllo $cod_dimp]
    }

    set link_list [subst $link_list_script]
    set link_gest [export_url_vars flag_tracciato cod_dimp last_cod_dimp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp url_gage flag_no_link cod_opma data_ins tabella]

    switch $funzione {
        M {set return_url "coimdimp-gest?funzione=V&$link_gest"}
        D {
	    if {$flag_no_link == "F"} { 
		set return_url  "$pack_dir/coimdimp-list?$link_list"
	    } else {
		set return_url  "coimdimp-gest?funzione=I&$link_gest"
	    }  
	}
        I { 
	    if {$nome_funz_caller == "insmodg"} {
		set return_url "$pack_dir/coimdimp-ins-filter?&nome_funz=insmodg&[export_url_vars flag_tracciato]&cod_impianto_old=$cod_impianto&cod_dimp_old=$cod_dimp"
	    } else {

		#if regione marche
		if {$coimtgen(regione) eq "MARCHE"} {#gac10 se regione Marche
		    #estraggo il gen_prog_est perche il gen_prog non va bene
		    set gen_prog_est [db_string q "select gen_prog_est 
                                                     from coimgend 
                                                    where gen_prog     = :gen_prog
                                                      and cod_impianto = :cod_impianto" -default ""]
		    set num_gen_successivo [db_string q "select count(*) 
                                                           from coimgend 
                                                          where gen_prog_est > :gen_prog_est 
                                                            and cod_impianto = :cod_impianto 
                                                            and flag_attivo  = 'S'" -default ""];#gac10

		    if {$num_gen_successivo > "0"} {		    
			set prossimo_gen [db_string q "select gen_prog 
                                                         from coimgend 
                                                        where cod_impianto = :cod_impianto 
                                                          and gen_prog_est > :gen_prog_est
                                                          and flag_attivo  = 'S' 
                                                     order by gen_prog 
                                                        limit 1" -default ""];#gac10 

			
			set link [export_vars -base "coimdimp-rct-gest" {flag_tracciato cod_impianto {gen_prog $prossimo_gen} nome_funz nome_funz_caller extra_par caller url_aimp url_list_aimp  extra_par_inco cod_dimp tabella cod_dimp {funzione I}}]
			
			set return_url "coimdimp-rct-gest?cod_dimp_precedente=$cod_dimp&gen_prog=$prossimo_gen&$link"

		    } else {
			set return_url "coimdimp-gest?funzione=V&$link_gest&transaz_eff=$transaz_eff"
		    }
		} else { 
		    set return_url "coimdimp-gest?funzione=V&$link_gest&transaz_eff=$transaz_eff"
		}
            }
	    #nic01 if {![string equal $__refreshing_p 0] && ![string equal $__refreshing_p ""]} {
	    #nic01     ad_returnredirect "coimdimp-gest?funzione=I&$link_list&__refreshing_p=$__refreshing_p"
	    #nic01 }
	}
        V {set return_url "$pack_dir/coimdimp-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
