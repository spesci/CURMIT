ad_page_contract {

    @author         Valentina Catte
    @creation-date  14/06/2004

    @cvs-id coimaimp-list-csv.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom07 04/02/2026 Aggiunta condizione per Regione Marche su ordinamento lista.

    mat01 28/03/2025 Aggiornate le query per udine quando l'impianto è del freddo

    ric03 26/11/2024 MEV per regione Marche ordine 63/2022 punti 21 e 32.

    rom06 07/05/2024 Aggiunti filtri per cruscotto pagina iniziale
    
    rom05 16/04/2024 Aggiunti campi tipo pompa di calore per il freddo e combustibile su richiesta di Ucit.
    rom05            Sandro ha detto che va bene per tutti gli enti.

    ric02 09/06/2023 Ticket 'anomalia scarica csv'. Rinominate colonne, calcolo potenza maggiore.
    
    ric01 08/06/2023 Sviluppi per regione marche per aggiunta criteri aggiuntivi.   

    rom04 17/01/2023 Sviluppo per Palermo Energia: aggiunto filro "Per Soggetto presente nello storico RCEE".

    mic01 13/05/2022 Corretta anomalia, l'estrazione del file csv non teneva conto del filtro
    mic01            per targa o cod_impianto_princ.

    rom03 10/01/2021 Aggiunto filtro f_pod

    rom02 20/09/2021 Riportata correzione fatta in coimaimp-list: Per Regione Marche le potenze
    rom02            da mostrare sono differenti dallo standard e cambia il ragionamento
    rom02            in base alla tipologia di impianto.

    rom01 13/03/2019 Aggiunti i filtri f_impianto_inserito, f_impianto_modificato,
    rom01            f_soggetto_modificato e f_generatore_sostituito

    san02 02/02/2018 Aggiunto all'estrazione il campo targa

    san01 24/02/2016 Il filtro f_cod_utenza ora filtrerà sul campo pdr

    nic02 12/02/2016 Gestito parametro coimtgen(flag_potenza) per usare la potenza utile.

    nic01 13/08/2014 Bisogna rendere coerente il filtro sui modelli scaduti con la colonna
    nic01            esposta (RCT). Sandro mi ha detto di usare sempre data_scad_dich e non
    nic01            piu' to_date(add_months(a.data_ultim_dich, :valid_mod_h),'yyyy-mm-dd')
    nic01            anche quando data_scad_dich e' null.

} {
    {last_cod_impianto    ""}

    {f_cod_impianto_est   ""}
    {f_cod_impianto_princ ""}
    {f_targa              ""}
    {f_resp_cogn          ""} 
    {f_resp_nome          ""} 
    {f_resp_cogn_rcee     ""}
    {f_resp_nome_rcee     ""}

    {f_comune             ""}
    {f_quartiere          ""}
    {f_cod_via            ""}
    {f_desc_topo          ""}
    {f_desc_via           ""}
    {f_civico_da          ""}
    {f_civico_a           ""}

    {f_cod_manu           ""}
    {f_manu_cogn          ""}
    {f_manu_nome          ""}

    {f_data_mod_da        ""}
    {f_data_mod_a         ""}
    {f_utente             ""}

    {f_potenza_da         ""}
    {f_potenza_a          ""}
    {f_data_installaz_da  ""}
    {f_data_installaz_a   ""}
    {f_flag_dichiarato    ""}
    {f_stato_conformita   ""}
    {f_cod_combustibile   ""}
    {f_cod_tpim           ""}
    {f_cod_tpdu           ""}
    {f_stato_aimp         ""}
    {f_matricola          ""}
    {f_cod_cost           ""}
    {f_mod_h              ""}
    {f_dpr_412            ""}
    {f_cod_utenza         ""}
    {f_pod                ""}
    {f_cod_impianto_old   ""}
    {conta_flag           ""}
    {f_riferimento        ""}
    {f_da_data_verifica   ""}
    {f_a_data_verifica    ""}

    {nome_funz            ""}

    {url_citt             ""}
    {cod_amministratore   ""}
    {cod_cittadino        ""}

    {url_manu             ""}
    {cod_manutentore      ""}
    {f_prov_dati          ""}
    {f_bollino            ""}
    {f_flag_tipo_impianto ""}
    {f_impianto_inserito     ""}
    {f_impianto_modificato   ""}
    {f_soggetto_modificato   ""}
    {f_generatore_sostituito ""}
    {f_ibrido                ""}
    {f_pagato                ""}
    {f_tprc                  ""}

    {f_da_data_scad ""}
    {f_a_data_scad  ""}

    {f_dich_conformita  ""}
    {f_dfm_manu         ""}
    {f_dfm_resp_mod     ""}

}

# Imposto variabili tipiche di ogni funzione
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

iter_get_coimtgen
set flag_viario       $coimtgen(flag_viario)
set valid_mod_h       $coimtgen(valid_mod_h)
set mesi_evidenza_mod $coimtgen(mesi_evidenza_mod)
set flag_gest_targa   $coimtgen(flag_gest_targa);#mic01

# imposto filtro

if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#nic02 aggiunta if ed il suo contenuto
    set colonna_potenza "a.potenza_utile";#nic02
} else {#nic02
    set colonna_potenza "a.potenza"
};#nic02

if {[string equal $f_resp_cogn ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $f_resp_cogn]
    set where_word  " and b.cognome like upper(:search_word_1)"
}

if {[string equal $f_resp_nome ""]} {
    set where_nome ""
} else {
    set f_resp_nome_1 [iter_search_word $f_resp_nome]
    set where_nome  " and b.nome like upper(:f_resp_nome_1)"
}

if {![string equal $f_cod_impianto_est ""]} {
    set where_codimp_est " and a.cod_impianto_est = upper(:f_cod_impianto_est)"
} else {
    set where_codimp_est ""
}

if {![string equal $f_cod_impianto_princ ""]} {#mic01 Aggiunte if, else e loro contenuto
    set where_codimp_princ " and h.cod_impianto_est = upper(:f_cod_impianto_princ)"
} else {
    set where_codimp_princ ""
}

if {![string equal $f_targa ""]} {#mic01: Aggiunte if, else e loro contenuto
    set where_targa " and upper(a.targa) = upper(:f_targa)"
} else {
    set where_targa ""
}

if {![string equal $f_mod_h ""]} {
    # se valorizzato con 1 seleziono gli impianti senza modello H
    # se valorizzato con 2 seleziono gli impianti con mod h scaduti
    switch $f_mod_h  {
	"1" {
	    set where_mod_h "and (select count(*)
                                    from coimdimp n
                                   where n.cod_impianto         = a.cod_impianto
                                 ) = 0" 
	}
	"2" {
	    #nic01 set where_mod_h "and to_date(add_months(a.data_ultim_dich, :valid_mod_h),'yyyy-mm-dd') < current_date"
	    set where_mod_h "and a.data_scad_dich < current_date";#nic01
	}
	default {set where_mod_h ""}
    }
} else {
    set where_mod_h ""
}

if {![string equal $f_da_data_scad ""] || ![string equal $f_a_data_scad ""]} {#rom06 if, else e contenuto
    set where_data_scad "and a.data_scad_dich between :f_da_data_scad and :f_a_data_scad"
} else {
    set where_data_scad ""
}

if {![string equal $f_quartiere ""]} {
    set where_quartiere "and a.cod_qua = :f_quartiere"
} else {
    set where_quartiere ""
}

# imposto la condizione per gli impianti di un soggetto

if {![string equal $cod_amministratore ""]} {
    set where_amministratore "and a.cod_amministratore = :cod_amministratore"
} else {
    set where_amministratore ""
}

# imposto la condizione SQL per cod_costruttore
if {![string equal $f_cod_cost ""]} {
    set where_cost "and g.cod_cost = :f_cod_cost"
} else {
    set where_cost ""
}

# imposto la condizione per gli impianti di un amministratore

if {![string equal $cod_cittadino ""]} {
    set nome_funz_citt [iter_get_nomefunz coimcitt-gest]
    set sogg_join   [db_map sogg_join]
    set where_sogg  [db_map where_sogg]
    set ruolo [db_map ruolo_citt]
} else {
    set nome_funz_citt ""
    set sogg_join  ""
    set where_sogg ""
    set ruolo          ""
}

# imposto la condizione SQL per il comune e la via
if {![string equal $f_comune ""]} {
    set where_comune "and a.cod_comune = :f_comune"
} else {
    set where_comune ""
}

set where_via ""
if {![string equal $f_cod_via ""]
&&  $flag_viario == "T"
} {
    set where_via "and a.cod_via = :f_cod_via"
} 

if {(![string equal $f_desc_via ""]
||   ![string equal $f_desc_topo ""])
&&  $flag_viario == "F"
} {
    set f_desc_via1  [iter_search_word $f_desc_via]
    set f_desc_topo1 [iter_search_word $f_desc_topo]
    set where_via "and a.indirizzo like upper(:f_desc_via1)
                   and a.toponimo  like upper(:f_desc_topo1)"
}

if {![string equal $f_riferimento ""]} {
    set where_rife "and exists (select '1'
                                  from coimdimp f
                                 where f.riferimento_pag = :f_riferimento
                                   and f.cod_impianto = a.cod_impianto limit 1)"
} else {
    set where_rife ""
}


if {[string equal $f_matricola ""]} {
    set where_matr ""
} else {
    set f_matricola [iter_search_word $f_matricola]
    set where_matr  " and upper(g.matricola) like upper(:f_matricola)"
}

set col_numero  "to_number(a.numero,'99999999')"
# se richiesta selezione per civico
if {![string equal $f_civico_da ""]} {
    set where_civico_da "and $col_numero >= :f_civico_da"
} else {
    set where_civico_da ""
}
if {![string equal $f_civico_a ""]} {
    set where_civico_a "and $col_numero <= :f_civico_a"
} else {
    set where_civico_a ""
}

# se richiesta selezione per data_mod
if {![string equal $f_data_mod_da ""] 
||  ![string equal $f_data_mod_a  ""]
} {
    if {[string equal $f_data_mod_da ""]} {
	set f_data_mod_da "18000101"
    }
    # dato che oracle memorizza anche l'ora, sono costretto a fare cosi':
    append f_data_mod_da " 00:00:00"

    if {[string equal $f_data_mod_a ""]} {
	set f_data_mod_a  "21001231"
    }
    # dato che oracle memorizza anche l'ora, sono costretto a fare cosi':
    append f_data_mod_a  " 23:59:59"

    #rom01set where_data_mod "
    #rom01and (   a.data_mod between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
    #rom01                       and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
    #rom01     or a.data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
    #rom01                       and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
    #rom01    )"
    set where_data_mod "and (";#rom01
    set sw_where_data_mod f;#rom01
    if {$f_impianto_inserito eq "S"} {#rom01 aggiunta if e suo contenuto
	set sw_where_data_mod t
	append where_data_mod "
              a.data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')"
    }
    if {$f_impianto_modificato eq "S"} {#rom01 aggiunta if e suo contenuto
	if {$sw_where_data_mod eq "t"} {
	    set sw_where_data_mod f
	    append where_data_mod "
           and "
	}
	set sw_where_data_mod t
	append where_data_mod "
               a.data_mod between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')"
    }
    if {$f_soggetto_modificato eq "S"} {#rom01 aggiunta if e suo contenuto
	if {$sw_where_data_mod eq "t"} {
	    set sw_where_data_mod f
	    append where_data_mod "
           and "
	}
	set sw_where_data_mod t
	append where_data_mod "
               a.cod_impianto in (select cod_impianto
                                    from coimrife
                                   where data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                                     and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
                                  )"
	
    }
    if {$f_generatore_sostituito eq "S"} {#rom01 aggiunta if e suo contenuto
	if {$sw_where_data_mod eq "t"} {
	    set sw_where_data_mod f
	    append where_data_mod "
           and "
	}
	append where_data_mod "
                        a.cod_impianto in (select cod_impianto
                                             from coimgend 
                                            where flag_sostituito ='S'
                                              and data_mod between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
                                          )"
	
    }
    append where_data_mod "
           )"
    
    if {$f_impianto_inserito eq "N" && $f_impianto_modificato eq "N" && $f_soggetto_modificato eq "N" && $f_generatore_sostituito eq "N"} {#rom01 aggiunta if e suo contenuto
	set where_data_mod ""
    };#rom01

} else {
    set where_data_mod ""
}

# se richiesta selezione per id_utente
if {![string equal $f_utente ""]} {
    set where_utente "and a.utente = :f_utente"
} else {
    set where_utente ""
}

# se richiesta selezione per potenza
if {![string equal $f_potenza_da ""] 
||  ![string equal $f_potenza_a ""]
} {
   if {[string equal $f_potenza_da ""]} {
       set f_potenza_da 0
   }
   if {[string equal $f_potenza_a ""]} {
       set f_potenza_a 9999999.99
   }

    if {$coimtgen(regione) eq "MARCHE"} {#rom02 Aggiunta if e suo contenuto
	set where_pot "
   and (
       case when a.flag_tipo_impianto in ('R','C')
            then (select coalesce(sum(pot_utile_nom),'0.00')    as potenza  --rom03
                    from coimgend w_gend
                   where w_gend.cod_impianto = a.cod_impianto
                     and flag_attivo = 'S'
                   group by a.cod_impianto)
            when a.flag_tipo_impianto ='F'
            then (select greatest(coalesce(sum(pot_focolare_lib),'0.00') , coalesce(sum(pot_focolare_nom),'0.00'))
                    from coimgend w_gend1
                   where w_gend1.cod_impianto = a.cod_impianto
                     and flag_attivo = 'S'
                    group by a.cod_impianto)
            when a.flag_tipo_impianto ='T'
            then (select coalesce(sum(pot_focolare_nom),'0.00') as potenza
                    from coimgend w_gend2
                   where w_gend2.cod_impianto = a.cod_impianto
                     and flag_attivo = 'S'
                   group by a.cod_impianto)
       end
    ) between :f_potenza_da and :f_potenza_a"

    } elseif {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} { #mat01 aggiunto elseif e contenuto

        set where_pot "
        and (
             case when a.flag_tipo_impianto = 'F'
             then (select greatest( cimp2.potenza_utile,cimp2.potenza) as potenza
                   from coimaimp cimp2
                    where cimp2.cod_impianto = a.cod_impianto)
             else $colonna_potenza
             end
          ) between :f_potenza_da and :f_potenza_a
       "
    } else {#rom02 Aggiunta else ma non il suo contenuto
	
	set where_pot "and $colonna_potenza between :f_potenza_da
                                                and :f_potenza_a"
    };#rom02
    
} else {
   set where_pot ""
}

# imposto la condizione SQL per cod_combustibile
if {![string equal $f_cod_combustibile ""]} {
    set where_comb "and a.cod_combustibile = :f_cod_combustibile"
} else {
    set where_comb ""
}

if {![string is space $cod_amministratore]} {
    set where_ammin "and a.cod_amministratore = :cod_amministratore"
} else {
    set where_ammin ""
}


# se richiesta selezione per data_installazione
if {![string equal $f_data_installaz_da ""] || ![string equal $f_data_installaz_a ""]} {
    if {[string equal $f_data_installaz_da ""]} {
	set f_data_installaz_da "18000101"
    }
    if {[string equal $f_data_installaz_a ""]} {
	set f_data_installaz_a  "21001231"
    }
    set where_data_installaz "and a.data_installaz between :f_data_installaz_da
                                                      and :f_data_installaz_a"
} else {
    set where_data_installaz ""
}

# se richiesta selezione per data_verifica
if {![string equal $f_da_data_verifica ""] || ![string equal $f_a_data_verifica ""]} {
   if {[string equal $f_da_data_verifica ""]} {
	set f_da_data_verifica "18000101"
   }
   if {[string equal $f_a_data_verifica ""]} {
	set f_a_data_verifica  "21001231"
   }
    set from_clause " left outer join coimcimp e on e.cod_impianto  = a.cod_impianto"
    set where_data_verifica "and e.data_controllo between :f_da_data_verifica
                                                     and :f_a_data_verifica  and e.cod_cimp = (select max(o.cod_cimp)
                                                                            from coimcimp o
                                                                           where o.cod_impianto = a.cod_impianto
                                                  )"
} else {
    set from_clause ""
    set where_data_verifica ""
}


# imposto la condizione SQL per flag_dichiarato
if {![string is space $f_flag_dichiarato]} {
    set where_flag_dichiarato "and a.flag_dichiarato = :f_flag_dichiarato"
} else {
    set where_flag_dichiarato ""
}

# imposto la condizione SQL per tipologia
if {![string is space $f_cod_tpim]} {
    set where_cod_tpim "and a.cod_tpim = :f_cod_tpim"
} else {
    set where_cod_tpim ""
}

# imposto la condizione SQL per prov_dati
if {![string is space $f_prov_dati]} {
    set where_prov_dati "and a.provenienza_dati = :f_prov_dati"
} else {
    set where_prov_dati ""
}

# imposto la condizione SQL per stato_conformita
if {![string is space $f_stato_conformita]} {
    set where_stato_conformita "and a.stato_conformita = :f_stato_conformita"
} else {
    set where_stato_conformita ""
}

# imposto la condizione SQL per cod_tpdu
if {![string is space $f_cod_tpdu]} {
    set where_tpdu "and a.cod_tpdu = :f_cod_tpdu"
} else {
    set where_tpdu ""
}

# imposto la condizione SQL per stato
if {![string is space $f_stato_aimp]} {
    set where_stato_aimp "and a.stato = :f_stato_aimp"
} else {
    set where_stato_aimp ""
}

# imposto la condizione SQL per manutentore
if {![string is space $f_cod_manu]} {
    set where_manu "and a.cod_manutentore = :f_cod_manu"
} else {
    set where_manu ""
}

# imposto la condizione SQL per manutentore proveniente da vis. manutentori
if {![string is space $cod_manutentore]} {
    set where_manutentore "and (a.cod_manutentore = :cod_manutentore 
                            or  a.cod_installatore = :cod_manutentore)"
    set nome_funz_manu [iter_get_nomefunz coimmanu-gest]
} else {
    set where_manutentore ""
    set nome_funz_manu ""
}

# imposto la condizione SQL per numero bollino
if {![string equal $f_bollino ""]} {
    set where_bollino "and exists (select '1' from coimdimp x where x.riferimento_pag = :f_bollino and x.cod_impianto = a.cod_impianto)"
} else {
    set where_bollino ""
}

# sf 11112013 comune utente

db_0or1row sel_cout_check " select count(*) as conta_cout
                                   from coimcout
                                   where id_utente = :id_utente
                                         "
	
if {$conta_cout > 0} {
    set where_cout "and a.cod_comune in (select ll.cod_comune from coimcout ll where ll.id_utente = :id_utente)"
} else {
    set where_cout ""
}

# sf fine


# stabilisco l'ordinamento ed uso una inner join al posto di una outer join
# sulle tabelle dove uso un filtro (Ottimizzazione solo per postgres)
set citt_join_pos "left outer join"
set citt_join_ora "(+)"
if {![string equal $f_cod_impianto_est ""]} {
    set ordine ""
} else {
    if {![string equal $f_resp_cogn ""]
    ||  ![string equal $f_resp_nome ""]
    || (   [string equal $f_quartiere ""]
	&& [string equal $f_cod_via   ""]
	&& [string equal $f_desc_topo ""]
	&& [string equal $f_desc_via  ""])
    } {
	set ordine        "nome"
        #ric03  set citt_join_pos "inner join"
	#Faccio lo stesso join che fa la lista
	set citt_join_pos "left outer join";#ric03
        set citt_join_ora ""
    } else {
	set ordine "via"
    }
}

switch $f_dpr_412 {
    "S" {set where_dpr "and a.flag_dpr412 = 'S'"}
    "N" {set where_dpr "and a.flag_dpr412 = 'N'"}
    default {set where_dpr ""}
}
if {![string equal $f_cod_impianto_old ""]} {
    set where_codimp_old " and a.cod_impianto_old = upper(:f_cod_impianto_old)"
} else {
    set where_codimp_old ""
}
if {![string equal $f_cod_utenza ""]} {
    #san01 where_cod_utenza " and a.cod_amag = upper(:f_cod_utenza)"
    #rom03set where_cod_utenza " and a.pdr = upper(:f_cod_utenza)";#san01
    set where_cod_utenza " and upper(a.pdr) = upper(:f_cod_utenza)";#rom03
} else {
    set where_cod_utenza ""
}

if {![string equal $f_pod ""]} {#rom03 Aggiunte if, else e loro contenuti
    set where_pod " and upper(a.pod) = upper(:f_pod)"
} else {
    set where_pod ""
}

set where_sogg_rcee "";#rom04
set where_resp_rcee "";#rom04
if {$coimtgen(ente) eq "PPA"} {#rom04 Aggiunta if e il suo contenuto


    if {[string equal $f_resp_nome_rcee ""]} {
	set where_nome_rcee ""
    } else {
	set f_resp_nome_rcee_1 [iter_search_word $f_resp_nome_rcee]
	set where_nome_rcee  " and rcee.nome like upper(:f_resp_nome_rcee_1)"
    }

    if {[string equal $f_resp_cogn_rcee ""]} {
	set where_cogn_rcee ""
    } else {
	set f_resp_cogn_rcee_1 [iter_search_word $f_resp_cogn_rcee]
	set where_cogn_rcee  " and rcee.cognome like upper(:f_resp_cogn_rcee_1)"
    }

    if {$where_cogn_rcee ne "" || $where_nome_rcee ne ""} {

	set where_resp_rcee " and exists (select 1 
                                            from coimdimp dimp
                                               , coimcitt rcee
                                           where dimp.cod_responsabile = rcee.cod_cittadino 
                                             and dimp.cod_impianto = a.cod_impianto 
                                             $where_nome_rcee 
                                             $where_cogn_rcee 
                                           limit 1) "
    }
}

#inizio dpr74
if {![string equal $f_flag_tipo_impianto ""]} {
    set where_tipo_impianto " and a.flag_tipo_impianto = upper(:f_flag_tipo_impianto)"
} else {
    set where_tipo_impianto ""
}
#fine dpr74

#ric01 inizio
if {[string equal $f_ibrido ""]} {
    set where_ibrido ""
} else {
    set where_ibrido  " and a.flag_ibrido = :f_ibrido"
}

set where_dimp ""
set where_pagato ""
set where_tprc ""

if {![string equal $f_pagato ""] || ![string equal $f_tprc ""]} { 
    
    if {![string equal $f_pagato ""]} {
	set where_pagato  " and dimp.flag_pagato = :f_pagato"
    }
    
    if {![string equal $f_tprc ""]} {   
	set where_tprc  " and dimp.cod_tprc = :f_tprc"
    }

    set where_dimp "
      and a.cod_impianto in (
      select cod_impianto_dimp
        from (select max(data_controllo) as max_dt_dimp
                       , cod_impianto as cod_impianto_dimp  
                    from coimdimp
                group by cod_impianto) as max_dimp
      inner join coimdimp dimp
              on dimp.cod_impianto=max_dimp.cod_impianto_dimp
             and max_dimp.max_dt_dimp = dimp.data_controllo
      where 1=1
         $where_pagato
         $where_tprc)"

}

#ric01 fine

#ric03 inizio
#ric03 imposto la condizione SQL per la dichiarazione di conformita sull'ultimo RCEE
set where_dich_conformita ""
set where_dfm_manu ""
set where_dfm_resp_mod ""
if {$coimtgen(regione) eq "MARCHE"} {
    if {![string equal $f_dich_conformita ""]} {
	set  where_dich_conformita "  and a.cod_impianto in (select dimp2.cod_impianto
                                                               from
                                                                    (select max(data_controllo) as max_dt_dimp2
                                                                          , cod_impianto as cod_impianto_dimp2
                                                                       from coimdimp max_dimp
                                                                   group by cod_impianto) as max_dimp2

                                                         inner join coimdimp dimp2 on dimp2.cod_impianto   = max_dimp2.cod_impianto_dimp2
                                                                                  and dimp2.data_controllo = max_dimp2.max_dt_dimp2

                                                              where dimp2.conformita = :f_dich_conformita
                                                                and dimp2.flag_tracciato in ('R1', 'R2', 'R3', 'R4')) "
    }  
    
    #ric03 imposto la condizione SQL per la dfm del manutentore
    if {![string equal $f_dfm_manu ""]} {
	if {![string is space $cod_manutentore]} {
	    if {$f_dfm_manu eq "S"} {
		set where_dfm_manu " and exists (select 1
                                                   from coimdope_aimp dope
                                                   where dope.cod_impianto    = a.cod_impianto
                                                     and dope.cod_manutentore = :cod_manutentore           
                                                   limit 1)"	    
	    } else {
		set where_dfm_manu " and not exists (select 1
                                                       from coimdope_aimp dope
                                                      where dope.cod_impianto    = a.cod_impianto
                                                        and dope.cod_manutentore = :cod_manutentore
                                                      limit 1)"
	    }	
	}
    }

    #ric03 imposto la condizione SQL per la dfm inserita se cambiato il responsabile
    if {![string equal $f_dfm_resp_mod ""]} {
	if {![string is space $cod_manutentore]} {
	    if {$f_dfm_resp_mod eq "S"} {
		set where_dfm_resp_mod " and exists (select 1
                                                       from coimdope_aimp dope
                                                      where dope.cod_impianto    = a.cod_impianto
                                                        and dope.cod_manutentore = :cod_manutentore
                                                        and dope.cod_responsabile in (select cod_responsabile 
                                                                                        from coimaimp aimp
                                                                                       where aimp.cod_impianto = a.cod_impianto)
                                                      limit 1)"
	    } else {
		set where_dfm_resp_mod " and not exists (select 1
                                                           from coimdope_aimp dope
                                                          where dope.cod_impianto    = a.cod_impianto
                                                            and dope.cod_manutentore = :cod_manutentore
                                                            and dope.cod_responsabile in (select cod_responsabile
                                                                                            from coimaimp aimp
                                                                                           where aimp.cod_impianto = a.cod_impianto)
                                                           limit 1)"
	    }
	}
    }

} 
#ric03 fine

# imposto l'ordinamento della query e la condizione per la prossima pagina
switch $ordine {
    "via" {
	switch $flag_viario {
	    "T" {set col_via "d.descrizione"}
	    "F" {set col_via "a.indirizzo" }
	}

	if {$coimtgen(regione) eq "MARCHE"} {#rom07 Aggiunta if e contenuto
	    set ordinamento "order by $col_via
                                , a.numero
                                , a.cod_impianto_est"
	} else {#rom07 Aggiunta else e contenuto
	    set ordinamento "order by $col_via
                                , $col_numero
                                , a.cod_impianto_est"
	};#rom07
	    
	if {![string equal $last_cod_impianto ""]} {
	    set via              [lindex $last_cod_impianto 0]
	    set numero           [lindex $last_cod_impianto 1]
	    set cod_impianto_est [lindex $last_cod_impianto 2]

	    if {[string equal $via ""]} {
		set via_eq      "is null"
                set or_via      ""
	    } else {
		set via_eq      "= :via"
		set or_via      "or ($col_via > :via)"
	    }

	    if {[string equal $numero ""]} {
		set numero_eq   "is null"
                set or_numero   ""
	    } else {
		set numero_eq   "= :numero"
                set or_numero   "or (    $col_via    $via_eq
                                     and $col_numero > :numero)"
	    }
	    set where_last "and (
                                    (    $col_via   $via_eq
                                     and $col_numero $numero_eq
                                     and a.cod_impianto_est > :cod_impianto_est)
                                 $or_numero
                                 $or_via
                                )"
	} else {
	    set where_last ""
        }
    }

    "nome"   {
	set ordinamento "order by b.cognome, b.nome, a.cod_impianto_est"

	if {![string equal $last_cod_impianto ""]} {
	    set cognome          [lindex $last_cod_impianto 0]
	    set nome             [lindex $last_cod_impianto 1]
	    set cod_impianto_est [lindex $last_cod_impianto 2]
	    if {[string equal $cognome ""]} {
		set cognome_eq  "is null"
		set or_cognome  ""
	    } else {
		set cognome_eq  "= :cognome"
		set or_cognome  "or  (b.cognome > :cognome)"
	    }
	    
	    if {[string equal $nome ""]} {
		set nome_eq     "is null"
		set or_nome     ""
	    } else {
		set nome_eq     "= :nome"
		set or_nome     "or  (     b.cognome $cognome_eq
                                      and  b.nome    > :nome)"
	    }

	    set where_last "and (
                                     (    b.cognome  $cognome_eq
                                      and b.nome     $nome_eq
                                      and a.cod_impianto_est > :cod_impianto_est)
                                 $or_nome
                                 $or_cognome
                                )"
         } else {
             set where_last ""
         }
    }
    default {
	set ordinamento ""
	set where_last  ""
    }
}

db_1row sel_dat_check_mod_h ""

set current_datetime [clock format [clock seconds] -f "%Y-%m-%d %H:%M:%S"]
set nome_file        "Estrazione Impianti"
set nome_file         [iter_temp_file_name -permanenti $nome_file]
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]
set file_csv         "$permanenti_dir/$nome_file.csv"
set file_csv_url     "$permanenti_dir_url/$nome_file.csv"

set file_id [open $file_csv w]
fconfigure $file_id -encoding iso8859-1

# imposto la prima riga del file csv

set     head_cols ""
lappend head_cols "Codice"

if {$flag_gest_targa eq "T"} {#mic01 Aggiunta if ma non il contenuto

    lappend head_cols "Targa";#san02
  
} else {#mic01 Aggiunto else e il suo contenuto

    lappend head_cols "Cod. imp. princ."
}

lappend head_cols "POD";#san02
lappend head_cols "PDR";#san02
lappend head_cols "Responsabile"
lappend head_cols "Indirizzo Resp."
lappend head_cols "Comune Resp."
lappend head_cols "Mail Resp."
lappend head_cols "Telefono Resp."
lappend head_cols "Codice Fiscale/Partita Iva"
lappend head_cols "Comune Ubic"
lappend head_cols "Indirizzo Ubic."
lappend head_cols "CAP Ubic"
#ric02 lappend head_cols "Potenza Nom"
#ric02 lappend head_cols "Potenza Utile"
lappend head_cols "Combustibile";#rom05
lappend head_cols "Potenza massima nominale";#ric02
lappend head_cols "Potenza nominale utile" ;#ric02
lappend head_cols "Matr. 1° gen."
lappend head_cols "Sist.az. 1° gen.";#rom05
lappend head_cols "Data RCEE."
lappend head_cols "Data Scad.RCEE."
lappend head_cols "Data Pross.Manut."
lappend head_cols "Importo Pagato"
lappend head_cols "RCEE"
lappend head_cols "Rapporto Ispezione"
lappend head_cols "DAM"
lappend head_cols "Dic.Frequenza"
lappend head_cols "Dichiarato"
lappend head_cols "Conforme"
lappend head_cols "Data Libretto"
lappend head_cols "Modificato"
lappend head_cols "Stato"
lappend head_cols "Tipo. Imp."
lappend head_cols "Cod. Manu.";#Sandro 28/07/2014
lappend head_cols "Manutentore";#Sandro 28/07/2014
lappend head_cols "Telefono";#Sandro 12 03 2019
lappend head_cols "Mail";#Sandro 12 03 2019
lappend head_cols "Pec";#Sandro 12 03 2019
lappend head_cols "Indirizzo";#Sandro 12 03 2019
lappend head_cols "Comune";#Sandro 12 03 2019

# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "cod_impianto_est"

if {$flag_gest_targa eq "T"} {#mic01 Aggiunta if ma non il contenuto

    lappend file_cols "targa";#san02
  
} else {#mic01 Aggiunto else e il suo contenuto

    lappend file_cols "cod_impianto_princ";#san02
}

lappend file_cols "pod";#san02
lappend file_cols "pdr";#san02
lappend file_cols "resp"
lappend file_cols "ind_resp"
lappend file_cols "ind_resp_2"
lappend file_cols "email_resp"
lappend file_cols "telefono_resp"
lappend file_cols "cod_fiscale"
lappend file_cols "comune"
lappend file_cols "indir"
lappend file_cols "cap"
lappend file_cols "desc_comb_aimp";#rom05
lappend file_cols "potenza"
lappend file_cols "potenza_u"
lappend file_cols "matricola_gen1"
lappend file_cols "sist_azio_gen1";#rom05
lappend file_cols "data_ultima_dich"
lappend file_cols "data_scadenza"
lappend file_cols "prox_manut"
lappend file_cols "costo_d"
lappend file_cols "swc_mod_h"
lappend file_cols "swc_rapp"
lappend file_cols "swc_dam"
lappend file_cols "swc_freq"
lappend file_cols "swc_dichiarato"
lappend file_cols "swc_conformita"
lappend file_cols "data_libretto"
lappend file_cols "swc_mod"
lappend file_cols "stato"
lappend file_cols "flag_tipo_impianto"
lappend file_cols "cod_man";#Sandro 28/07/2014
lappend file_cols "manu";#Sandro 28/07/2014
lappend file_cols "telefono_man";#Sandro 12 03 2019
lappend file_cols "email_man";#Sandro 12 03 2019
lappend file_cols "pec_man";#Sandro 12 03 2019
lappend file_cols "indirizzo_man";#Sandro 12 03 2019
lappend file_cols "comune_man";#Sandro 12 03 2019

set sw_primo_rec "t"

if {$flag_viario == "T"} {
    set sel_aimp [db_map sel_aimp_vie]
} else {
    set sel_aimp [db_map sel_aimp_no_vie]
}

db_foreach sel_aimp $sel_aimp {
    set file_col_list ""
    set matricola_gen1 "\'$matricola_gen1"
    set pdr "\'$pdr"
    set pod "\'$pod"
    regsub {,} $indir { n.} indir
#    regsub {,} $potenza {.} potenza

    if {$sw_primo_rec == "t"} {
	set sw_primo_rec "f"
	iter_put_csv $file_id head_cols
    }

    foreach column_name $file_cols {
	lappend file_col_list [set $column_name]
    }
    iter_put_csv $file_id file_col_list

} if_no_rows {
    set msg_err      "Nessun impianto selezionato con i criteri utilizzati"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_id msg_err_list
}

ad_returnredirect $file_csv_url
ad_script_abort
