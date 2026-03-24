ad_page_contract {

    @author                  Luca Romitti
    @creation-date           04/04/2018
    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
    mat01  17/03/2026 Aggiunta la gestione del db di test.

    rom03  15/01/2019 Corretto il modo in cui veniva calcolato num_fatt. Non è il max o il max+1
    rom03             dell'anno in cui ci troviamo(current_date) ma il max o max+1 dell'anno 
    rom03             indicato dall'utente(data_fattura).

    sim01  03/08/2018 Corretto il modo in cui veniva calcolato cod_fattura. Non è il max+1
    sim01             dell'anno ma il max +1 generale.

    rom02  08/06/2018 Aggiunto campo data_fattura su richiesta di Sandro.

    rom01  26/04/2018 Aggiunto campo tipo_pagamento su richiesta di Sandro.
    
} {
    {caller         "index"}
    {nome_funz           ""}
    {nome_funz_caller    ""}
    {receiving_element   ""}
    {data_fattura        ""}
    conferma:multiple
}  -properties {
    page_title:onevalue
    context_bar:onevalue
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


set where_cod_movi "and a.cod_movi in ('[join $conferma ',']')"

set flag_prima_fattura "t"

db_foreach sel_movi ""  {
    

    if {[db_0or1row q "select a.cod_fatt 
                         from coimmovi a
                            , coimfatt b 
                        where a.cod_movi = :cod_movi 
                          and a.cod_fatt = b.cod_fatt "] 
	
    } {    iter_return_complaint "La fattura è già stata stampata, per ristamparla utilizzare la funzione 'Ristampa fattura'" }
    
    iter_get_coimtgen
    set dbn_ente_ancona ""
    if {$coimtgen(ente) eq "CANCONA"} {
	set dbn_ente_ancona "iterpran";#mat01
    } elseif {$coimtgen(ente) eq "PAN"} {
	set dbn_ente_ancona "itercman";#mat01
    }
    if {[string match "*test*" [db_get_database]]} {#mat01 aggiunta if e contenuto
	set dbn_ente_ancona ""
    }
    
    if {$dbn_ente_ancona ne ""} {
	db_1row q "select --sim01 coalesce(max(cod_fatt::integer), '0') as codice_fattura_1
                    --sim01, 
                    coalesce(max(num_fatt::integer), '0') as numero_fattura_1
                 from coimfatt
                 where to_char(data_fatt,'yyyy') = to_char(:data_fattura::date, 'yyyy') --rom03
               --rom03 to_char(data_fatt,'yyyy') = to_char(current_date,'yyyy')"
	
	db_1row -dbn $dbn_ente_ancona q "select --sim01 coalesce(max(cod_fatt::integer), '0') as codice_fattura_2
                                          --sim01,
                                            coalesce(max(num_fatt::integer), '0') as numero_fattura_2
                                       from coimfatt
                                      where to_char(data_fatt,'yyyy') = to_char(:data_fattura::date, 'yyyy') --rom03
                                    --rom03 to_char(data_fatt,'yyyy') = to_char(current_date,'yyyy')"
	
	
	#sim01if {$codice_fattura_1 >= $codice_fattura_2 && $numero_fattura_1 >= $numero_fattura_2} {}
	if {$numero_fattura_1 >= $numero_fattura_2} {#sim01
	    #sim01 set codice_fattura [expr {$codice_fattura_1 + 1 }]
	    set numero_fattura [expr {$numero_fattura_1 + 1 }]
	} else { 
	    #sim01 set codice_fattura [expr {$codice_fattura_2 + 1 }]
	    set numero_fattura [expr {$numero_fattura_2 + 1 }]
	}

    } else {  
	
	db_1row q "select --sim01 coalesce(max(cod_fatt::integer), '0') + 1 as codice_fattura
                    --sim01, 
                    coalesce(max(num_fatt::integer), '0') + 1 as numero_fattura
                 from coimfatt
                where to_char(data_fatt,'yyyy') = to_char(:data_fattura::date, 'yyyy') --rom03
              --rom03 to_char(data_fatt,'yyyy') = to_char(current_date,'yyyy')" 
	
    }
    

    db_1row q "select coalesce(max(cod_fatt::integer), '0') + 1 as codice_fattura
                 from coimfatt";#sim01

    
    if {$flag_prima_fattura eq "t"} {
	set flag_prima_fattura "f"
	set f_da_num_fatt $numero_fattura
    }
    
    set f_a_num_fatt $numero_fattura
    
    set perc_iva 22 
    
    db_1row q "select m.flag_pagato
                , m.nota
                , m.importo as imponibile
                , i.cod_responsabile as cod_soggetto
             from coimmovi as m 
                , coimaimp as i
            where m.cod_movi     = :cod_movi
              and m.cod_impianto = i.cod_impianto"

    set tipo_pagamento [db_string q "select a.descrizione 
                                       from coimtp_pag a
                                          , coimmovi b
                                      where a.cod_tipo_pag = b.tipo_pag
                                        and b.cod_movi = :cod_movi" -default ""];#rom01
    

    db_dml ins_fatt "insert into coimfatt
                                ( cod_fatt  
                                , data_fatt
                                , cod_sogg
                                , tipo_sogg
                                , flag_pag
                                , nota
                                , data_ins
                                , id_utente
                                , imponibile
                                , num_fatt
                                , perc_iva
                                , desc_fatt
                                , mod_pag            --rom01
                                ) values
                                ( :codice_fattura
                                , :data_fattura      --rom02
                                , :cod_soggetto
                                , 'C'
                                , :flag_pagato
                                , :nota
                                , current_date
                                , :id_utente
                                , :imponibile
                                , :numero_fattura
                                , :perc_iva
                                , 'Visita ispettiva'
                                , :tipo_pagamento    --rom01
                                ) "
    
    db_dml upd_mov "update coimmovi 
                       set cod_fatt=$codice_fattura 
                     where cod_movi= :cod_movi" 
    
}

#richiamo stampa con id_primo e ultimo
set anno_fatt [string range [iter_set_sysdate] 0 3]
set link_list [export_url_vars f_da_num_fatt f_a_num_fatt anno_fatt cod_movi]



set return_url "coimfatt-isp-layout-multi?$link_list&nome_funz=fatt-isp-multi&nome_funz_caller=fatt-isp-multi"

ad_returnredirect $return_url
ad_script_abort


ad_return_template
