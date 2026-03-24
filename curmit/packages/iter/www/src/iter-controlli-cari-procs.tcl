ad_page_contract {@dob} {
    {cod_batc      ""}
    {id_utente     ""}
    {file_name     ""}
}


ns_log notice "prova dob inizio iter-controlli-cari file_name (par)  $file_name"

# aggiorno stato di coimbatc
#iter_batch_upd_flg_sta -iniz $cod_batc


# reperisco le colonne della tabella parametri
iter_get_coimtgen

# valorizzo la data_corrente (serve per l'inserimento)
set data_corrente  [iter_set_sysdate]

set permanenti_dir [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]

ns_log notice "prova dob permanenti_dir $permanenti_dir"
ns_log notice "prova dob permanenti_dir_url $permanenti_dir_url"


set file_inp_name  "Controlli-da-esterno-input"
set file_inp_name  [iter_temp_file_name -permanenti $file_inp_name]

ns_log notice "prova dob file_inp_name $file_inp_name" 
set file_esi_name  "Controlli-da-esterno-esito"
set file_esi_name  [iter_temp_file_name -permanenti $file_esi_name]
set file_out_name  "Controlli-da-esterno-caricati"
set file_out_name  [iter_temp_file_name -permanenti $file_out_name]
set file_err_name  "Controlli-da-esterno-scartati"
set file_err_name  [iter_temp_file_name -permanenti $file_err_name]

set file_inp       "${permanenti_dir}/$file_inp_name.csv"

ns_log notice "prova dob file_inp $file_inp" 

set file_esi       "${permanenti_dir}/$file_esi_name.adp"
set file_out       "${permanenti_dir}/$file_out_name.txt"
set file_err       "${permanenti_dir}/$file_err_name.txt"
set file_inp_url   "${permanenti_dir_url}/$file_inp_name.csv"
# in file_esi_url non metto .adp altrimenti su vestademo non
# viene trovata la url!!
set file_esi_url   "${permanenti_dir_url}/$file_esi_name"
set file_out_url   "${permanenti_dir_url}/$file_out_name.txt"
set file_err_url   "${permanenti_dir_url}/$file_err_name.txt"

# rinomino il file (che per ora ha lo stesso nome di origine)
# con un nome legato al programma ed all'ora di esecuzione

ns_log notice "prova dob mv $file_name $file_inp"
exec mv $file_name $file_inp

# apro il file in lettura e metto in file_inp_id l'identificativo
# del file per poterlo leggere successivamente
if {[catch {set file_inp_id [open $file_inp r]}]} {
    iter_return_complaint "File csv di input non aperto: $file_inp"
}
# dichiaro di leggere in formato iso West European e di utilizzare
# crlf come fine riga (di default andrebbe a capo anche con gli
# eventuali lf contenuti tra doppi apici).
fconfigure $file_inp_id -encoding iso8859-1 -translation crlf

# apro il file in scrittura e metto in file_esi_id l'identificativo
# del file per poterlo scrivere successivamente
if {[catch {set file_esi_id [open $file_esi w]}]} {
    iter_return_complaint "File di esito caricamento non aperto: $file_esi"
}
# dichiaro di scrivere in formato iso West European
fconfigure $file_esi_id -encoding iso8859-1

# apro il file in scrittura e metto in file_out_id l'identificativo
# del file per poterlo scrivere successivamente
if {[catch {set file_out_id [open $file_out w]}]} {
    iter_return_complaint "File csv dei record caricati non aperto: $file_out"
}
# dichiaro di scrivere in formato iso West European
fconfigure $file_out_id -encoding iso8859-1

# apro il file in scrittura e metto in file_err_id l'identificativo
# del file per poterlo scrivere successivamente
if {[catch {set file_err_id [open $file_err w]}]} {
    iter_return_complaint "File csv dei record scartati non aperto: $file_err"
}
# dichiaro di scrivere in formato iso West European
fconfigure $file_err_id -encoding iso8859-1




# preparo e scrivo scrivo la riga di intestazione per file out
set     head_cols ""
lappend head_cols "Impianto"
lappend head_cols "Generatore"
iter_put_csv $file_out_id head_cols

# preparo e scrivo la riga di intestazione del file degli errori
lappend head_cols "Motivo di scarto"
iter_put_csv $file_err_id head_cols

# definisco il tracciato record del file di input
set     file_cols ""
lappend file_cols "codice_impianto"
lappend file_cols "prog_generatore"
lappend file_cols "data_controllo"
lappend file_cols "tipo_documento"
lappend file_cols "num_rapporto"
lappend file_cols "ora_inizio"
lappend file_cols "ora_fine"
lappend file_cols "num_protocollo"
lappend file_cols "data_protocollo"
lappend file_cols "cogn_verificatore"
lappend file_cols "nome_verificatore"
lappend file_cols "data_ult_autocert"
lappend file_cols "data_pag_ult_autocert"
lappend file_cols "nome_resp"
lappend file_cols "cogn_resp"
lappend file_cols "indir_resp"
lappend file_cols "comune_resp"
lappend file_cols "prov_resp"
lappend file_cols "natura_giur_resp"
lappend file_cols "cap_resp"
lappend file_cols "ident_fisc_resp"
lappend file_cols "telef_resp"
lappend file_cols "delegato_resp"
lappend file_cols "volumetria"
lappend file_cols "consumi_ult_stag"
lappend file_cols "combustibile"
lappend file_cols "potenza focolare_nom"
lappend file_cols "potenza_utile_nom"
lappend file_cols "portata_comb"
lappend file_cols "potenza_focolare_nom_imp"
lappend file_cols "pendenza_canali"
lappend file_cols "verifica_scarico"
lappend file_cols "presenza_foro"
lappend file_cols "foro_corretto"
lappend file_cols "stato_coibentazione"
lappend file_cols "foro_accessibile"
lappend file_cols "conformita_locale"
lappend file_cols "dispos_contr_pres"
lappend file_cols "dispos_contr_funz"
lappend file_cols "verif_aeraz"
lappend file_cols "accesso_centrale"
lappend file_cols "mezzi_antincedio"
lappend file_cols "rubinetto_intercett"
lappend file_cols "cartell_prevista"
lappend file_cols "interr_gen_est"
lappend file_cols "assenza_mat_estr"
lappend file_cols "apert_ventil_libera"
lappend file_cols "disp_regol_clima_pres"
lappend file_cols "disp_regol_clima_funz"
lappend file_cols "pres_libretto"
lappend file_cols "libretto_corretto"
lappend file_cols "libretto_manut_imp"
lappend file_cols "libretto_manut_bruc"
lappend file_cols "dich_conf_imp"
lappend file_cols "dich_conf_imp_elett"
lappend file_cols "certif_prev_incendi"
lappend file_cols "data_ult_manut"
lappend file_cols "data_ult_anal_comb"
lappend file_cols "autocert_pres"
lappend file_cols "note"
lappend file_cols "autocert_con_prescr"
lappend file_cols "descr_strum"
lappend file_cols "marca_strum"
lappend file_cols "modello_strum"
lappend file_cols "matricola_strum"
lappend file_cols "data_taratura_strum"
lappend file_cols "fumos_mis_1"
lappend file_cols "fumos_mis_2"
lappend file_cols "fumos_mis_3"
lappend file_cols "temp_flu_mand_mis_1"
lappend file_cols "temp_flu_mand_mis_2"
lappend file_cols "temp_flu_mand_mis_3"
lappend file_cols "temp_flu_mand_med"
lappend file_cols "temp_aria_comb_mis_1"
lappend file_cols "temp_aria_comb_mis_2"
lappend file_cols "temp_aria_comb_mis_3"
lappend file_cols "temp_aria_comb_med"
lappend file_cols "temp_fumi_mis_1"
lappend file_cols "temp_fumi_mis_2"
lappend file_cols "temp_fumi_mis_3"
lappend file_cols "temp_fumi_med"
lappend file_cols "co_mis_1"
lappend file_cols "co_mis_2"
lappend file_cols "co_mis_3"
lappend file_cols "co_med"
lappend file_cols "co2_mis_1"
lappend file_cols "co2_mis_2"
lappend file_cols "co2_mis_3"
lappend file_cols "co2_med"
lappend file_cols "02_mis_1"
lappend file_cols "02_mis_2"
lappend file_cols "02_mis_3"
lappend file_cols "02_med"
lappend file_cols "temp_mant_mis_1"
lappend file_cols "temp_mant_mis_2"
lappend file_cols "temp_mant_mis_3"
lappend file_cols "temp_mant_med"
lappend file_cols "eccesso_aria_mis_1"
lappend file_cols "eccesso_aria_mis_2"
lappend file_cols "eccesso_aria_mis_3"
lappend file_cols "eccesso_aria_med"
lappend file_cols "manutenzione_8a"
lappend file_cols "manutenzione_anni_prec"
lappend file_cols "co_rilevato"
lappend file_cols "co_fumi_secchi_8b"
lappend file_cols "fumos_med"
lappend file_cols "indice_fumos_8c"
lappend file_cols "rend_min"
lappend file_cols "rend_combustione"
lappend file_cols "rend_combustibile_8d"
lappend file_cols "pericolosita"
lappend file_cols "esito"
lappend file_cols "note_conformita"
lappend file_cols "note_verificatore"
lappend file_cols "note_responsabile"
lappend file_cols "mod_pagam"
lappend file_cols "costo_verifica"
lappend file_cols "rifer_pagam"
lappend file_cols "data_ins"
lappend file_cols "data_modif"
lappend file_cols "ultimo_utente"
lappend file_cols "anomalie"

	
# costruisco il record di input
set file_inp_col_list ""
foreach column_name $file_cols {
    lappend file_inp_col_list $column_name
}

set ctr_inp 0
set ctr_err 0
set ctr_out 0
set ctr_ins 0

ns_log notice "prova dob inizio ciclo lettura file $file_inp_id "

# Salto il primo record che deve essere di testata
iter_get_csv $file_inp_id file_inp_col_list |

# Ciclo di lettura sul file di input
# uso la proc perche' i file csv hanno caratteristiche 'particolari'
iter_get_csv $file_inp_id file_inp_col_list |
while {![eof $file_inp_id]} {
    incr ctr_inp
    ns_log notice "prova dob letto record $ctr_inp   "
    
    # valorizzo le relative colonne
    set ind 0
    foreach column_name $file_cols {
	set valore_colonna [lindex $file_inp_col_list $ind]
	set valore_colonna [string trim $valore_colonna]
	set $column_name   $valore_colonna
	incr ind
	ns_log notice "prova dob ciclo costruzione riga variabile$ind  column_name = $column_name valore_colonna = $valore_colonna"
    }
    
    # controllo record
    set carica "S"
    set motivo_scarto ""
    
    if {[string equal $codice_impianto ""]} {
	set carica        "N"
	append motivo_scarto "/ Manca codice impianto"
    }
    if {[string equal $prog_generatore ""]} {
	set carica        "N"
	append motivo_scarto "/ Manca il generatore"
    }
    if {![db_0or1row query "select a.cod_impianto
                                         from coimaimp a
                                             ,coimgend b
                                        where a.cod_impianto     = b.cod_impianto
                                          and b.gen_prog         = :prog_generatore
                                          and a.cod_impianto_est = :codice_impianto"]} {
	set carica        "N"
	append motivo_scarto " / Impianto o generatore non presente a sistema"
    }

    ns_log notice "prova dob controllo data $data_controllo"
    set data_controllo [iter_check_date $data_controllo]
    ns_log notice "prova dob dopo controllo data $data_controllo"
    if {$data_controllo == 0} {
	set carica        "N"
	append motivo_scarto " / Data controllo non corretta"
    }
    if {![string equal $data_protocollo ""]} {
	set data_protocollo [iter_check_date $data_protocollo]
	if {$data_protocollo == 0} {
	    set carica        "N"
	    append motivo_scarto " / Data protocollo errata"
	}
    }

    if {![db_0or1row query "select cod_opve 
                              from coimopve 
                             where cognome = :cogn_verificatore 
                               and coalesce(nome,'') = coalesce(:nome_verificatore,'')"]} {
	set cod_opve ""
    }
    if {![db_0or1row query "select cod_combustibile 
                              from coimcomb 
                             where descr_comb = :combustibile"]} {
	set cod_combustibile ""
    }
    
    
    
    if {[string equal $cogn_resp ""]} {
	set where_cogn_chk " and cognome is null"
    } else {
	set where_cogn_chk " and upper(cognome) = :cogn_resp"
    }
    if {[string equal $nome_resp ""]} {
	set where_nome_chk " and nome is null"
    } else {
	set where_nome_chk " and upper(nome) = :nome_resp"
    }
    if {[string equal $indir_resp ""]} {
	set where_indirizzo_chk " and indirizzoo is null"
    } else {
	set where_indirizzo_chk " and upper(indirizzo) = :indir_resp"
    }
    if {[string equal $comune_resp ""]} {
	set where_comune_chk " and comune is null"
    } else {
	set where_comune_chk " and upper(comune) = :comune_resp"
    }
    if {[string equal $prov_resp ""]} {
	set where_provincia_chk " and provincia is null"
    } else {
	set where_provincia_chk " and upper(provincia) = :prov_resp"
    }
    
    if {[db_0or1row sel_citt_check "select max(cod_cittadino) as cod_resp from coimcitt
		                                                         where upper(cognome) = upper(:cogn_resp)
                                                                           and cod_fiscale = :ident_fisc_resp
                                                                        $where_nome_chk
	                                                                $where_indirizzo_chk
	                                                                $where_comune_chk
	                                                                $where_provincia_chk"] == 0} {
	set cod_resp ""
    }
    
    set anomalie [db_string query "select replace(:anomalie,';',' ')"]

    # ......................................... controlli
    
    ns_log notice "prova dob fine controlli iter-controlli-cari"
    
    # fine controlli 
    
    # ricostruisco il record di output
    set file_out_col_list ""
    lappend file_out_col_list $codice_impianto
    lappend file_out_col_list $prog_generatore
    set ind 0

#    foreach column_name $file_cols {
#	lappend file_out_col_list [set $column_name]
#	incr ind
#    }


    if {$carica == "S"} {
	
	#inserisco il controllo nel DB  

	db_1row query "select nextval('coimcimp_s') as cod_cimp"

	db_dml ins_cimp " insert
             into coimcimp 
                ( cod_cimp
                , cod_impianto
                , gen_prog
                , data_controllo
                , cod_opve
                , costo
                , presenza_libretto
                , libretto_corretto
                , dich_conformita
                , libretto_manutenz
                , mis_port_combust
                , mis_pot_focolare
                , stato_coiben
                , verifica_areaz
                , rend_comb_conv
                , rend_comb_min
                , temp_fumi_md
                , t_aria_comb_md
                , temp_mant_1a
                , temp_mant_2a
                , temp_mant_3a
                , temp_mant_md
                , co2_md
                , o2_md
                , co_md
                , indic_fumosita_1a
                , indic_fumosita_2a
                , indic_fumosita_3a
                , indic_fumosita_md
                , manutenzione_8a
                , co_fumi_secchi_8b
                , indic_fumosita_8c

                , esito_verifica
                , note_verificatore
                , note_resp
                , note_conf
                , tipologia_costo
                , riferimento_pag
                , pot_focolare_nom
                , cod_combustibile
                , cod_responsabile
                , flag_pericolosita
                , data_ins
                , utente
                , flag_tracciato
                , new1_data_paga_dimp
                , new1_conf_locale
                , new1_asse_mate_estr
                , new1_pres_mezzi
                , new1_pres_cartell
                , new1_pres_intercet 
                , new1_dimp_pres
                , new1_dimp_prescriz
                , new1_data_ultima_manu
                , new1_manu_prec_8a
                , new1_co_rilevato
                , new1_foro_presente
                , new1_foro_corretto
                , new1_foro_accessibile
                , eccesso_aria_perc_1a
                , eccesso_aria_perc_2a
                , eccesso_aria_perc_3a
                , n_prot
                , data_prot
                , verb_n
                , data_verb
                , ora_inizio
                , ora_fine 

                , delegato_ragsoc

                , pendenza
                , ventilaz_lib_ostruz
                , disp_reg_cont_pre
                , disp_reg_cont_funz
                , disp_reg_clim_funz
                , volumetria
                , comsumi_ultima_stag
                , t_aria_comb_1a
                , t_aria_comb_2a
                , t_aria_comb_3a
                , temp_fumi_1a
                , temp_fumi_2a
                , temp_fumi_3a
                , co_1a
                , co_2a
                , co_3a
                , co2_1a
                , co2_2a
                , co2_3a
                , o2_1a
                , o2_2a
                , o2_3a
                , cod_sanzione_1
                , cod_sanzione_2
                , tiraggio
                , accens_funz_gen
                , libr_manut_bruc
                , doc_prev_incendi   
                , strumento
                , marca_strum
                , modello_strum
                , matr_strum
                , dt_tar_strum
                , eccesso_aria_perc
                )
           values 
                (:cod_cimp
                ,:cod_impianto
                ,:prog_generatore
                ,:data_controllo
                ,:cod_opve
                ,:costo_verifica
                ,:pres_libretto
                ,:libretto_corretto
                ,:dich_conf_inp
                ,:libretto_manut_imp
                ,:portata_comb
                ,:potenza_focolare_utile
                ,:stato_coibentazione
                ,:verif_areaz
                ,:rend_combustione
                ,:rend_min
                ,:temp_fumi_med
                ,:temp_aria_comb_med
                ,:temp_mant_mis_1
                ,:temp_mant_mis_2
                ,:temp_mant_mis_3
                ,:temp_mant_med
                ,:co2_med
                ,:o2_med
                ,:co_med
                ,:fumos_mis1
                ,:fumos_mis2
                ,:fumos_mis3
                ,:fumosita_med
                ,:manutenzione
                ,:co_fumi_secchi_8b
                ,:indice_fumos_8c
                ,:esito
                ,:note_verificatore
                ,:note_responsabile
                ,:note_conformita
                ,:mod_pagam
                ,:rifer_pagam
                ,:pot_focolare_nom_imp
                ,:cod_combustibile
                ,:cod_resp
                ,:pericolosita
                , current_date
                ,:id_utente
                ,'AA'
                ,:data_ult_manut
                ,:conformita_locale
                ,:assenza_mat_estr
                ,:mezzi_antincedio
                ,:cartell_prevista
                ,:rubinetto_intercett  
                ,:autocert_pres
                ,:autocert_con_prescr
                ,:data_ultima_manu
                ,:manutenzione anni_prec
                ,:co_rilevato
                ,:presenza_foro
                ,:foro_corretto
                ,:foro_accessibile
                ,:eccesso_aria_mis_1
                ,:eccesso_aria_mis_2
                ,:eccesso_aria_mis_3
                ,:num_protocollo
                ,:data_protocollo
                ,:num_protocollo
                ,:data_protocollo
                ,:ora_inizio
                ,:ora_fine 
                .:delegato_resp
                ,:pendenza_canali
                ,:apert_ventil_libera
                ,:dispos_contr_pres
                ,:dispos_contr_funz
                ,:disp_regol_clima_funz
                ,:volumetria
                ,:comsumi_ult_stag
             
                ,:temp_aria_comb_mis1
                ,:temp_aria_comb_mis2
                ,:temp_aria_comb_mis3
                ,:temp_fumi_mis1
                ,:temp_fumi_mis2
                ,:temp_fumi_mis3
                ,:co_mis1
                ,:co_mis2
                ,:co_mis3
                ,:co2_mis1
                ,:co2_mis2
                ,:co2_mis3
                ,:o2_mis1
                ,:o2_mis2
                ,:o2_mis3
                ,:cod_sanzione_1
                ,:cod_sanzione_2
                ,:tiraggio
                ,:interr_gen_est
                ,:libretto_manut_bruc
                ,:certif_prev_incendi
                ,:descr_strum
                ,:marca_strum
                ,:modello_strum
                ,:matricola_strum
                ,:data_taratura_strum
                ,:eccesso_aria_med
                )"
	ns_log notice "prova dob inserito coimcimp $cod_cimp"
	
	set conta 1
	foreach cod_tanom $anomalie {
	    
	    db_dml ins_anom "insert into coimanom (
                                     cod_cimp_dimp
                                    ,prog_anom
                                    ,tipo_anom
                                    ,cod_tanom
                                    ,dat_utile_inter
                                    ,flag_origine)
                               values (
                                     cod_cimp
                                    ,:conta
                                    ,'2'
                                    ,:cod_tanom
                                    ,null
                                    ,'RV')"
	    
	    ns_log notice "prova dob inserita anomalia $cod_anom"
	    incr conta

	}

	db_dml upd_aimp "           update coimaimp
	      set potenza          = :pot_focolare_nom_upd
	        , potenza_utile    = :pot_utile_nom_upd
	        , cod_potenza      = :cod_potenza
                , data_ultima_dich = :data_ult_autocert 
                , data_mod         =  current_date
                , utente           = :id_utente
            where cod_impianto     = :cod_impianto"

	ns_log notice "prova dob aggiornato coimaimp $cod_impianto"
	
	#scrivo un record sul file di out con i controlli inseriti
	iter_put_csv $file_out_id file_out_col_list
	incr ctr_ins
    } else {
	#aggiungo la colonna dei motivi di scarto e 
	#scrivo un record sul file degli scarti
	lappend file_out_col_list $motivo_scarto
	iter_put_csv $file_err_id file_out_col_list
	incr ctr_err
	
    }
    
    # lettura del record successivo
    iter_get_csv $file_inp_id file_inp_col_list |
}

ns_log notice "prova dob scrive esito iter-controlli-cari"
# scrivo la pagina di esito
set page_title "Esito caricamento controlli da file esterno"
set context_bar [iter_context_bar \
		     [list "javascript:window.close()" "Chiudi finestra"] \
		     "$page_title"]

set pagina_esi [subst {
    <master   src="../../master">
    <property name="title">$page_title</property>
    <property name="context_bar">$context_bar</property>
    
    <center>
    
    <table>
    <tr><td valign=top class=form_title align=center colspan=4>
	    <b>ELABORAZIONE TERMINATA</b>
    </td>
    </tr>
    
    <tr><td valign=top class=form_title>Letti Controlli:</td>
    <td valign=top class=form_title>$ctr_inp</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
    
    <tr><td colspan=4>&nbsp;</td>
    
    <tr><td valign=top class=form_title>Caricati Controlli:</td>
    <td valign=top class=form_title>$ctr_out</td>
    <td>&nbsp;</td>
    <td valign=top class=form_title><a target="Controlli caricati" href="$file_out_url">Scarica CSV dei controlli/impianti caricati</a></td>
    </tr>
    
    <tr><td colspan=4>&nbsp;</td>
    
    <tr><td valign=top class=form_title>Scartati Controlli/Impianti:</td>
    <td valign=top class=form_title>$ctr_err</td>
    <td>&nbsp;</td>
    <td valign=top class=form_title><a target="Controlli scartati" href="$file_err_url">Scarica CSV dei controlli/impianti scartati</a></td>
    </tr>
}]

append pagina_esi [subst {
    <tr><td colspan=4>&nbsp;</td></tr>
    </table>
    </center>
}]

puts $file_esi_id $pagina_esi

close $file_inp_id
close $file_esi_id
close $file_out_id
close $file_err_id

# inserisco i link ai file di esito sulla tabella degli esiti
# ed aggiorno lo stato del batch a 'Terminato'
set     esit_list ""
lappend esit_list [list "Esito caricamento"  $file_esi_url $file_esi]
#iter_batch_upd_flg_sta -fine $cod_batc $esit_list
ns_log notice "prova dob aggiorna stato coimbatc iter-controlli-cari"


# fine db_transaction ed ora fine with_catch

ad_returnredirect "$file_esi_url"
return

