#www/caldaie/src/
ad_page_contract {
    lista per scarico incontri

    @author         Paolo Formizzi Adhoc
    @creation-date  27/04/2004

    @cvs-id coiminco-scar.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 15/01/2024 Aguinto la colonna codice fiscale, e ho valorizzato il campo codice impianto
    but01                 con il codice_impianto_est.

    rom02 12/01/2024 Sandro ha chiesto di aggiungere le colonne stato e motivo annullamento
    rom02            al file di scarico, va bnee per tutti gli enti.

    rom01 21/07/2022 Su richiesta della Provincia di Salerno aggiunta la colonna flag_blocca_rcee.
    rom01            Sandro ha detto che va bene per tutti.

} {
    {cod_cinc          ""}
    {f_data            ""}
    {f_tipo_data       ""}
    {f_cod_impianto    ""}
    {f_cod_enve        ""}
    {f_cod_tecn        ""}
    {f_cod_esito       ""}
    {f_cod_comune      ""}
    {f_cod_via         ""}
    {f_descr_via       ""}
    {f_descr_topo      ""}
    {f_tipo_estrazione ""}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {f_anno_inst_da    ""}
    {f_anno_inst_a     ""}
    {f_cod_comb        ""}
    {f_numero          ""}

}

# Imposto variabili tipiche di ogni funzione
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

# imposto filtro per data
if {![string equal $f_data ""]} {
    switch $f_tipo_data {
	"E" {set where_data "and a.data_estrazione   = :f_data"}
	"I" {set where_data "and a.data_verifica     = :f_data"}
	"A" {set where_data "and a.data_assegn       = :f_data"}
    }
} else {
    set where_data ""
}

if {![string equal $f_cod_impianto ""]} {
    set where_codice "and c.cod_impianto_est = upper(:f_cod_impianto)"
} else {
    set where_codice ""
}

#imposto il filtro per ente verificatore
#if {![string equal $f_cod_enve ""]} {
#    set where_enve "and a.cod_opve in (select cod_opve 
#                                         from coimopve 
#                                        where cod_enve = :f_cod_enve)"
#} else {
    set where_enve ""
#}

# imposto il filtro per il tecnico
#if {![string equal $f_cod_tecn ""]} {
#    set where_tecn "and a.cod_opve = :f_cod_tecn"
#} else {
    set where_tecn ""
#}

# imposto il filtro per esito
if {![string equal $f_cod_esito ""]} {
    set where_esito "and a.esito = :f_cod_esito"
} else {
    set where_esito ""
}

# imposto il filtro per comune
if {![string equal $f_cod_comune ""]} {
    set where_comune "and c.cod_comune = :f_cod_comune"
} else {
    set where_comune ""
}

if {![string equal $f_numero ""]} {
   set limit_pos "limit $f_numero"
    set limit_ora "where rownum <= $f_numero"
} else {
  set limit_pos ""
    set limit_ora ""
}

# imposto filtro per via
if {![string equal $f_cod_via ""]} {
    set where_via "and c.cod_via = :f_cod_via"
} else {
    set where_via ""
    if {(![string equal $f_descr_via ""]
    ||   ![string equal $f_descr_topo ""])
    &&  $flag_viario == "F"
    } {
	set f_descr_via1  [iter_search_word $f_descr_via]
	set f_descr_topo1 [iter_search_word $f_descr_topo]
	set where_via "
        and c.indirizzo like upper(:f_descr_via1)
        and c.toponimo  like upper(:f_descr_topo1)"
    }
}

# imposto filtro per combustibile
if {![string equal $f_cod_comb ""]} {
    set where_comb "and c.cod_combustibile = :f_cod_comb"
} else {
    set where_comb ""
}

# imposto filtro per data
if {![string equal $f_anno_inst_da ""]} {
    set where_anno_inst_da "and substr(c.data_installaz,1,4) >= :f_anno_inst_da"
} else {
    set where_anno_inst_da ""
}

if {![string equal $f_anno_inst_a ""]} {
    set where_anno_inst_a  "and substr(c.data_installaz,1,4) <= :f_anno_inst_a"
} else {
    set where_anno_inst_a ""
}


# imposto filtro per tipo estrazione
if {![string equal $f_tipo_estrazione ""]} {
    set where_tipo_estr "and a.tipo_estrazione = :f_tipo_estrazione"
} else {
    set where_tipo_estr ""
}

if {![string equal $f_cod_enve ""]} {
   if {[db_0or1row sel_enve ""] == 0} {
         set ragione_01 ""
   }

   if {![string equal $f_cod_tecn ""]} {
       if {[db_0or1row sel_tecn ""] == 0} {
	   set nome_verif    ""
	   set cogn_verif    ""
       }
   } else {
       set nome_verif    ""
       set cogn_verif    ""
   }
    
} else {
  set ragione_01 ""
  set nome_verif ""
  set cogn_verif ""
}
set current_datetime [clock format [clock seconds] -f "%Y-%m-%d %H:%M:%S"]
set nome_file          "Scarico appuntamenti da assegnare"
set nome_file          [iter_temp_file_name -permanenti $nome_file]
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]
set file_csv         "$permanenti_dir/$nome_file.csv"
set file_csv_url     "$permanenti_dir_url/$nome_file.csv"

set file_id [open $file_csv w]
fconfigure $file_id -encoding iso8859-1

# imposto la prima riga del file csv
set     head_cols ""
lappend head_cols "Codice appuntamento"
lappend head_cols "Note della verifica"
lappend head_cols "N. verbale"
lappend head_cols "Tipo visita"
lappend head_cols "Tariffa"
lappend head_cols "Codice impianto"
lappend head_cols "Data"
lappend head_cols "Ora"
lappend head_cols "Ente verif"
lappend head_cols "Verif cog."
lappend head_cols "Verif. nome"
lappend head_cols "Tipo verifica"
lappend head_cols "Potenza"
lappend head_cols "Utente"
lappend head_cols "Codice fiscale";#but01
lappend head_cols "Utente 2"
lappend head_cols "Indirizzo"
lappend head_cols "CAP"
lappend head_cols "Comune"
lappend head_cols "Note"
lappend head_cols "Indirizzo (recapito)"
lappend head_cols "CAP (recapito)"
lappend head_cols "Comune (recapito)"
lappend head_cols "Provincia (recapito)"
lappend head_cols "Telefono"
lappend head_cols "Cellulare"
lappend head_cols "Esito"
lappend head_cols "Progressivo generatore"
lappend head_cols "Data controllo"
lappend head_cols "Num. verbale"
lappend head_cols "Data verbale"
lappend head_cols "Costo verifica"
lappend head_cols "Tipologia costo"
lappend head_cols "Riferimento pagamento"
lappend head_cols "Data scadenza pagamento"
lappend head_cols "Presenziante"
lappend head_cols "Presenza libretto"
lappend head_cols "Libretto corretto"
lappend head_cols "Dichiarazione conformita'"
lappend head_cols "Libretto manutenzione"
lappend head_cols "Potenza combustibile"
lappend head_cols "Potenza termica al focolare"
lappend head_cols "Stato coibentazione"
lappend head_cols "Stato canna fumaria"
lappend head_cols "Verifica dispositivi di regolazione/controllo"
lappend head_cols "Verifica aerazione"
lappend head_cols "Taratura di regolazione/controllo"
lappend head_cols "CO nei fumi secchi"
lappend head_cols "PPM"
lappend head_cols "Eccesso d'aria %"
lappend head_cols "Perdita ai fumi %"
lappend head_cols "Rendimento convenzionale %"
lappend head_cols "Rendiento minimo richiesto %"
lappend head_cols "Temperatura fumi 1° lettura"
lappend head_cols "Temperatura fumi 2° lettura"
lappend head_cols "Temperatura fumi 3° lettura"
lappend head_cols "Temperatura fumi valore medio"
lappend head_cols "Temperatura aria comburente 1° lettura"
lappend head_cols "Temperatura aria comburente 2° lettura"
lappend head_cols "Temperatura aria comburente 3° lettura"
lappend head_cols "Temperatura aria comburente valore medio"
lappend head_cols "Temperatura mantello 1° lettura"
lappend head_cols "Temperatura mantello 2° lettura"
lappend head_cols "Temperatura mantello 3° lettura"
lappend head_cols "Temperatura mantello valore medio"
lappend head_cols "Temperatura fluido in mandata 1° lettura"
lappend head_cols "Temperatura fluido in mandata 2° lettura"
lappend head_cols "Temperatura fluido in mandata 3° lettura"
lappend head_cols "Temperatura fluido in mandata valore medio"
lappend head_cols "Co2 1° letture"
lappend head_cols "Co2 2° lettura"
lappend head_cols "Co2 3° lettura"
lappend head_cols "Co2 valore medio"
lappend head_cols "O2 1° lettura"
lappend head_cols "O2 2° lettura"
lappend head_cols "O2 3° lettura"
lappend head_cols "O2 valore medio"
lappend head_cols "CO (RPM) 1° lettura"
lappend head_cols "CO (RPM) 2° lettura"
lappend head_cols "CO (RPM) 3° lettura"
lappend head_cols "CO (RPM) valore medio"
lappend head_cols "Indice di fumosita'-bacharach 1° lettura"
lappend head_cols "Indice di fumosita'-bacharach 2° lettura"
lappend head_cols "Indice di fumosita'-bacharach 3° lettura"
lappend head_cols "Indice di fumosita'-bacharach valore medio"
lappend head_cols "Manutenzione 8A"
lappend head_cols "CO riferifo ai fumi secchi 8B"
lappend head_cols "Indice di fumosita' 8C"
lappend head_cols "Rendimento convenzionale 8D"
lappend head_cols "Esito verifica"
lappend head_cols "Strumento"
lappend head_cols "Osservazione/Raccomandazioni"
lappend head_cols "Note responsabile"
lappend head_cols "Note non conformita'"
lappend head_cols "Flag blocca RCEE";#rom01
lappend head_cols "Stato appuntamento";#rom02
lappend head_cols "Motivo annullamento";#rom02

# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "cod_inco"
lappend file_cols "note_verifica"
lappend file_cols "n_verbale"
lappend file_cols "tipo_visita"
lappend file_cols "tariffa"
lappend file_cols "cod_impianto_est";#but01 sostituito cod_impianto
lappend file_cols "data_verifica"
lappend file_cols "ora_verifica"
lappend file_cols "ragione_01"
lappend file_cols "cogn_verif"
lappend file_cols "nome_verif"
lappend file_cols "tipo_ver"
lappend file_cols "potenza"
lappend file_cols "resp"
lappend file_cols "cod_fiscale";#but01
lappend file_cols "resp2"
lappend file_cols "indirizzo_ext"
lappend file_cols "cap"
lappend file_cols "comune"
lappend file_cols "note"
lappend file_cols "indirizzo_sogg"
lappend file_cols "cap_sogg"
lappend file_cols "comune_sogg"
lappend file_cols "provincia_sogg"
lappend file_cols "telefono"
lappend file_cols "cellulare"
lappend file_cols "esito"
lappend file_cols "gen_prog"
lappend file_cols "data_controllo"
lappend file_cols "verb_n"
lappend file_cols "data_verb"
lappend file_cols "costo"
lappend file_cols "tipologia_costo"
lappend file_cols "riferimento_pag"
lappend file_cols "data_scad_pag"
lappend file_cols "nominativo_pres"
lappend file_cols "presenza_libretto"
lappend file_cols "libretto_corretto"
lappend file_cols "dich_conformita"
lappend file_cols "libretto_manutenz"
lappend file_cols "mis_port_combust"
lappend file_cols "mis_pot_focolare"
lappend file_cols "stato_coiben"
lappend file_cols "stato_canna_fum"
lappend file_cols "verifica_dispo"
lappend file_cols "verifica_areaz"
lappend file_cols "taratura_dispos"
lappend file_cols "co_fumi_secchi"
lappend file_cols "ppm"
lappend file_cols "eccesso_aria_perc"
lappend file_cols "perdita_ai_fumi"
lappend file_cols "rend_comb_conv"
lappend file_cols "rend_comb_min"
lappend file_cols "temp_fumi_1a"
lappend file_cols "temp_fumi_2a"
lappend file_cols "temp_fumi_3a"
lappend file_cols "temp_fumi_md"
lappend file_cols "t_aria_comb_1a"
lappend file_cols "t_aria_comb_2a"
lappend file_cols "t_aria_comb_3a"
lappend file_cols "t_aria_comb_md"
lappend file_cols "temp_mant_1a"
lappend file_cols "temp_mant_2a"
lappend file_cols "temp_mant_3a"
lappend file_cols "temp_mant_md"
lappend file_cols "temp_h2o_out_1a"
lappend file_cols "temp_h2o_out_2a"
lappend file_cols "temp_h2o_out_3a"
lappend file_cols "temp_h2o_out_md"
lappend file_cols "co2_1a"
lappend file_cols "co2_2a"
lappend file_cols "co2_3a"
lappend file_cols "co2_md"
lappend file_cols "o2_1a"
lappend file_cols "o2_2a"
lappend file_cols "o2_3a"
lappend file_cols "o2_md"
lappend file_cols "co_1a"
lappend file_cols "co_2a"
lappend file_cols "co_3a"
lappend file_cols "co_md"
lappend file_cols "indic_fumosita_1a"
lappend file_cols "indic_fumosita_2a"
lappend file_cols "indic_fumosita_3a"
lappend file_cols "indic_fumosita_md"
lappend file_cols "manutenzione_8a"
lappend file_cols "co_fumi_secchi_8b"
lappend file_cols "indic_fumosita_8c"
lappend file_cols "rend_comb_8d"
lappend file_cols "esito_verifica"
lappend file_cols "strumento"
lappend file_cols "note_verificatore"
lappend file_cols "note_resp"
lappend file_cols "note_conf"
lappend file_cols "flag_blocca_rcee";#rom01
lappend file_cols "des_stato";#rom02
lappend file_cols "descr_noin";#rom02

 
if {$flag_viario == "T"} {
    set sel_inco "sel_inco_si_vie"
} else {
    set sel_inco "sel_inco_no_vie"
}

set lista_cod ""
# inizio del ciclo
set sw_primo_rec "t"
db_foreach $sel_inco "" {

    if {$sw_primo_rec == "t"} {
	set sw_primo_rec "f"
	iter_put_csv $file_id head_cols
    }
    if {[exists_and_not_null localita]} {
	set indirizzo_sogg "$indirizzo_sogg - $localita"
    }

    lappend lista_cod $cod_inco
    set file_col_list ""

    set note_verifica ""
    set n_verbale     ""
    set tipo_visita   ""
    set tariffa       ""
    set tipo_ver      ""
    set potenza       ""
    set data_verifica ""
    set ora_verifica  ""
    set resp2         ""
    set cellulare     ""
    set esito         ""
    set gen_prog ""
    set data_controllo ""
    set verb_n ""
    set data_verb ""
    set cod_opve ""
    set costo ""
    set nominativo_pres ""
    set presenza_libretto ""
    set libretto_corretto ""
    set dich_conformita ""
    set libretto_manutenz ""
    set mis_port_combust ""
    set mis_pot_focolare ""
    set stato_coiben ""
    set stato_canna_fum ""
    set verifica_dispo ""
    set verifica_areaz ""
    set taratura_dispos ""
    set co_fumi_secchi ""
    set ppm ""
    set eccesso_aria_perc ""
    set perdita_ai_fumi ""
    set rend_comb_conv ""
    set rend_comb_min ""
    set temp_fumi_1a ""
    set temp_fumi_2a ""
    set temp_fumi_3a ""
    set temp_fumi_md ""
    set t_aria_comb_1a ""
    set t_aria_comb_2a ""
    set t_aria_comb_3a ""
    set t_aria_comb_md ""
    set temp_mant_1a ""
    set temp_mant_2a ""
    set temp_mant_3a ""
    set temp_mant_md ""
    set temp_h2o_out_1a ""
    set temp_h2o_out_2a ""
    set temp_h2o_out_3a ""
    set temp_h2o_out_md ""
    set co2_1a ""
    set co2_2a ""
    set co2_3a ""
    set co2_md ""
    set o2_1a ""
    set o2_2a ""
    set o2_3a ""
    set o2_md ""
    set co_1a ""
    set co_2a ""
    set co_3a ""
    set co_md ""
    set indic_fumosita_1a ""
    set indic_fumosita_2a ""
    set indic_fumosita_3a ""
    set indic_fumosita_md ""
    set manutenzione_8a ""
    set co_fumi_secchi_8b ""
    set indic_fumosita_8c ""
    set rend_comb_8d ""
    set esito_verifica ""
    set strumento ""
    set note_verificatore ""
    set note_resp ""
    set note_conf ""
    set tipologia_costo ""
    set riferimento_pag ""
    set data_scad_pag ""
    
    foreach column_name $file_cols {
	lappend file_col_list [set $column_name]
    }
    iter_put_csv $file_id file_col_list

} if_no_rows {
    set msg_err      "Nessuna incontro selezionato con i criteri utilizzati"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_id msg_err_list
}

with_catch error_msg {
    db_transaction {
	# per motivi di prestazioni faccio una update ogni 500 record
	# valorizzando la where condition con una 'in'
        set ind_inco 0
        set num_inco [llength $lista_cod]
        while {$ind_inco < $num_inco} {
            set max_upd 500
            set ind_upd 0
            set in_cod_inco ""
	    while {$ind_inco < $num_inco
               &&  $ind_upd  < $max_upd
	    } {
		set cod_inco [lindex $lista_cod $ind_inco]
                if {$ind_upd > 0} {
                    append in_cod_inco ", "
		}
		append in_cod_inco "'$cod_inco'"
		incr ind_inco
		incr ind_upd
	    }
            if {[string equal $f_cod_tecn ""]} {
	        db_dml upd_inco ""
	    } else {
                db_dml upd_inco2 ""
	    }
	}
    }
} {
    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
    seguente messaggio di errore <br><b>$error_msg</b><br>
    Contattare amministratore di sistema e comunicare il messaggio
    d'errore. Grazie."
}


ad_returnredirect $file_csv_url
ad_script_abort
