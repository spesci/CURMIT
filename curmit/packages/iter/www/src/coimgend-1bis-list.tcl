ad_page_contract {
    Lista tabella "coimgend"

    @author                  Simone Pesci
    @creation-date           02/04/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  
    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu,
                             serve per la navigation bar
    @param receiving_element nomi dei campi di form che riceveranno gli
                             argomenti restituiti dallo script di zoom,
                             separati da '|' ed impostarli come segue:

    @cvs-id coimgend-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================================
    rom09 08/11/2024 Per gli impianti del freddo devo usare la maggiore tra la potenza in riscaldamento e
    rom09            raffrescamento per calcolare la periodicita' dell'RCEE.

    rom08 01/03/2023 Fatte modifiche a label e condizioni delle query per gli impianti del teleriscaldamento e
    rom08            cogenerazione sulla base di una richiesta di Mengucci di Ancona Parcheggi di Regione Marche.

    rom07 29/10/2021 Per gli impianti del freddo sotto ai 12 Kw non deve vedersi la lista periodicita' dell'RCEE

    gac01 25/02/2021 Su richiesta di Sandro ho modificato la case per fare in modo che gli impianti a
    gac01            metano e gpl con potenza utile nominale <= 100 avessero una periodicità di 4 anni al
    gac01            posto di 2 anni.

    rom06 21/02/2019 Aggiunte tabelle table_def_fr e table_def_tot_fr per gli impianti del freddo.
    rom06            Modificato intervento di rom05 e rom04 
    
    rom05 19/02/2019 Modifica alla tabella per gli impianti del freddo

    rom04 07/01/2019 Sdoppiata la tabella a seconda del tipo impianto.

    rom03 25/09/2018 Al posto di gen_prog faccio vedere gen_prog_est nella tabella.

    rom02 08/08/2018 Cambiata l'impostazione delle 2 tabelle su richiesta della Regione Marche.

    rom01 28/05/2018 Aggiunta dicitura prima della lista su richiesta di Sandro.

    sim00 17/04/2018 Programma clone di coimgend-list

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller       "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""} 
   {receiving_element ""}
    cod_impianto
   {url_list_aimp     ""}
   {url_aimp          ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

iter_get_coimtgen
set flag_gest_targa $coimtgen(flag_gest_targa)

set flag_tipo_impianto [db_string q "select flag_tipo_impianto
			               from coimaimp
			              where cod_impianto = :cod_impianto"];#rom06
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
#set nome_funz_context "impianti"
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
#    set nome_funz_caller "impianti"
}


set page_title      "Lista Generatori"


set context_bar [iter_context_bar -nome_funz $nome_funz_caller]


#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

set link_gest [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp caler]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimgend-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]



# imposto la struttura della tabella

# imposto la query SQL 
set ls_cod_impianto_padre_fr [list]
set ls_cod_impianto_padre_ca [list]

if {$flag_tipo_impianto eq "F"} {

    set ls_cod_impianto_padre_fr "$cod_impianto "
}

if {$flag_tipo_impianto ne "F"} {     
    set ls_cod_impianto_padre_ca "$cod_impianto "
}


if {$flag_gest_targa eq "T"} {
    
    db_1row q "select targa 
                 from coimaimp 
                where cod_impianto = :cod_impianto"

    set join_padre "inner join coimaimp f      on f.cod_impianto      = a.cod_impianto"
    set where_padre "    f.cod_impianto != :cod_impianto
                     and upper(f.targa)  = upper(:targa)"

    append ls_cod_impianto_padre_fr [db_list q "select f.cod_impianto
                                            from coimaimp f     
                                           where f.cod_impianto != :cod_impianto
                                            and upper(f.targa)  = upper(:targa)
                                            and flag_tipo_impianto='F'"]

    append ls_cod_impianto_padre_ca [db_list q "select f.cod_impianto
                                            from coimaimp f     
                                           where f.cod_impianto != :cod_impianto
                                            and upper(f.targa)  = upper(:targa)
                                            and flag_tipo_impianto!='F'"]				 
    
} else {

    set join_padre "left outer join coimaimp f on f.cod_impianto = a.cod_impianto
                         inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
                           and f.cod_impianto != h.cod_impianto"
    set where_padre "h.cod_impianto = :cod_impianto"

    append ls_cod_impianto_padre_fr [db_list q "select h.cod_impianto
                                            from coimaimp f
                                      inner join coimaimp h
                                              on f.cod_impianto = h.cod_impianto_princ
                                             and f.cod_impianto != h.cod_impianto
                                           where h.cod_impianto = :cod_impianto
                                             and h.flag_tipo_impianto='F'"]

    append ls_cod_impianto_padre_ca [db_list q "select h.cod_impianto
                                            from coimaimp f
                                      inner join coimaimp h
                                              on f.cod_impianto = h.cod_impianto_princ
                                             and f.cod_impianto != h.cod_impianto
                                           where h.cod_impianto = :cod_impianto
                                             and h.flag_tipo_impianto!='F'"]

    
}



if {$coimtgen(regione) eq "MARCHE"} {

    set select_anni "case when flag_tipo_impianto = 'T' then 'ogni 4 anni' 
                          when flag_tipo_impianto = 'C' then (case when potenza_num >= 50 then 'ogni 2 anni' else 'ogni 4 anni' end)
                          else  
                          (case --gac01 when potenza_num < 100  and combustibile in ('4','5') 
                               when potenza_num <= 100  and combustibile in ('4','5') --gac01
                               then 'ogni 4 anni' --metano e gpl con pot < 100
                          --gac01 when potenza_num < 100  and combustibile not in ('4','5')
                               when potenza_num <= 100  and combustibile not in ('4','5') --gac01
                               then 'ogni 2 anni' --altri comb con pot < 100
                           --gac01 when potenza_num >= 100 and combustibile     in ('4','5')
                           when potenza_num > 100 and combustibile     in ('4','5') --gac01
                               then 'ogni 2 anni' --metano e gpl con pot >= 100
                          --gac01 when potenza_num >= 100 and combustibile not in ('4','5')
                               when potenza_num > 100 and combustibile not in ('4','5') --gac01
                               then 'ogni 1 anno' -- altri comb con pot >= 100
                          else '' end) end as anni"

    set select_anni_tot "case when flag_tipo_impianto ='T' then 'ogni 4 anni'
                              when flag_tipo_impianto = 'C' then (case when sum(potenza_num) >= 50 then 'ogni 2 anni' else 'ogni 4 anni' end)
                              else  
                          (case --gac01 when sum(potenza_num) < 100  and combustibile in ('4','5')
                          when sum(potenza_num) <= 100  and combustibile in ('4','5') --gac01
                               then 'ogni 4 anni' --metano e gpl con pot < 100
                          --gac01 when sum(potenza_num) < 100  and combustibile not in ('4','5')
                          when sum(potenza_num) <= 100  and combustibile not in ('4','5') --gac01
                               then 'ogni 2 anni' --altri comb con pot < 100
                          --gac01 when sum(potenza_num) > 100 and combustibile     in ('4','5')                          
                          when sum(potenza_num) > 100 and combustibile     in ('4','5') --gac01
                               then 'ogni 2 anni' --metano e gpl con pot >= 100
                          --gac01 when sum(potenza_num) >= 100 and combustibile not in ('4','5')
                          when sum(potenza_num) >= 100 and combustibile not in ('4','5') --gac01
                               then 'ogni 1 anno' -- altri comb con pot >= 100
                          else '' end) end as anni"

    

#    if {$flag_tipo_impianto eq "T" || $flag_tipo_impianto eq "C"} {#rom06 aggiunta if e suo contenuto
#	set select_anni "'ogni 4 anni' as anni"
#    }

    set select_anni_fr "case when cod_tpco in ('1','2') and potenza_num < 100
                                  then 'ogni 4 anni' --pompe di calore a compressione e a fiamma diretta con pot < 100
                             when cod_tpco in ('1','2') and potenza_num >= 100
                                  then 'ogni 2 anni' --pompe di calore a compressione e a fiamma diretta con pot >= 100
                             when cod_tpco = '4'
                                  then 'ogni 4 anni' --pompe di calore a motore endotermico
                             when cod_tpco = '3'
                                  then 'ogni 2 anni' --pompe di calore a energia termica
                             else '' end as anni";#rom06

    
    set select_anni_tot_fr "case when cod_tpco in ('1','2') and sum(potenza_num_fr) < 100
                                  then 'ogni 4 anni' --pompe di calore a compressione e a fiamma diretta con pot < 100
                             when cod_tpco in ('1','2') and sum(potenza_num_fr) >= 100
                                  then 'ogni 2 anni' --pompe di calore a compressione e a fiamma diretta con pot >= 100
                             when cod_tpco = '4'
                                  then 'ogni 4 anni' --pompe di calore a motore endotermico
                             when cod_tpco = '3'
                                  then 'ogni 2 anni' --pompe di calore a energia termica
                             else '' end as anni"


} else {

    set anni [expr $coimtgen(valid_mod_h)/12]
    set select_anni "$anni as anni"

}

set html_tabelle ""

foreach cod_impianto $ls_cod_impianto_padre_ca {
    
    set sel_gend [db_map sel_gend]

    set fl_tp_imp [db_string q "select flag_tipo_impianto
		                  from coimaimp
			              where cod_impianto = :cod_impianto"];#rom06

    if {$fl_tp_imp eq "T"} {#rom08 Aggiunta if, elseif,else e il loro contenuto
	set lbl_tab_gen  "SC"
	set lbl_tab_rcee "tipo 3"
    } elseif {$fl_tp_imp eq "C"} {
	set lbl_tab_gen  "CG"
	set lbl_tab_rcee "tipo 4"
    } else {
	set lbl_tab_gen  "GT"
	set lbl_tab_rcee "tipo 1"
    }
    
set table_def [list \
		   [list cod_impianto_est "Impianto"                              no_sort {c}] \
		   [list gen_prog_est     "$lbl_tab_gen"                          no_sort {c}] \
		   [list descrizione      "Descrizione"                           no_sort {c}] \
		   [list potenza          "Potenza termica<br>
                                           nominale complessiva"                  no_sort {c}] \
		   [list descr_comb       "Combustibile"                          no_sort {c}] \
		   [list flag_attivo      "Attivo"                                no_sort {c}]
	      ]


set table_def_tot [list \
		       [list tipo_combustibile   "Tipo Combustibile"                    no_sort {c}] \
		       [list tot_potenza         "Tot. Potenza"                         no_sort {c}] \
		       [list tot_importo         "Costo del segno<br>
                                                 identificativo"                        no_sort {c}] \
		       [list anni                "Periodicità invio del<br>
                                                 Rapporto di Efficienza Energetica<br>
                                                 munito di segno identificativo"        no_sort {c}] \
		      ]

    
    set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_impianto gen_prog gen_prog_est last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par} go $sel_gend $table_def]
    
    set sel_tot_gend [db_map sel_tot_gend]

    set table_tot_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {} go $sel_tot_gend $table_def_tot]

    db_1row q "select cod_impianto_est
             from coimaimp
            where cod_impianto = :cod_impianto";#rom01
   
    set html_tabelle "$html_tabelle <br><br>
<table width=90% align=center> <!-- rom01 aggiunta table e contenuto -->
      <tr>
         <td align=center><b><big>Rapporto di controllo dell'efficienza energetica $lbl_tab_rcee per l'impianto $cod_impianto_est</big></b></td>
      </tr>
</table>
$table_result<br><br>
$table_tot_result"
    
    
}

foreach cod_impianto $ls_cod_impianto_padre_fr {

    set sel_gend_fr [db_map sel_gend_fr];#rom06

    db_1row q "select cod_impianto_est
                    , flag_tipo_impianto as flag_tipo_impianto_1bis
            --rom09 , potenza as potenza_1bis
                    , greatest(potenza,potenza_utile) as potenza_1bis --rom09
                 from coimaimp
                where cod_impianto = :cod_impianto";#rom07 Spostata in alto la query

set table_def_fr [list \
		      [list cod_impianto_est "Codice Impianto"                       no_sort {c}] \
		      [list gen_prog_est     "GF"                                    no_sort {c}] \
		      [list potenza          "Potenza nominale<br>
                                               utile del GF"                          no_sort {c}] \
		      [list tipo_climatizzazione "Tipo di 
                                                   climatizzazione"                   no_sort {l}] \
		      [list descr_tpco       "Sistema di
                                               azionamento"                           no_sort {c}] \
		      [list flag_attivo      "Attivo"                                no_sort {c}]
		 ]
set table_def_tot_fr [list \
			  [list tot_descr_tpco "Sistema di
                                                 azionamento"                         no_sort {c}] \
			  [list tot_tipo_climatizzazione "Tipo di
                                                           climatizzazione"           no_sort {l}] \
			  [list tot_potenza    "Potenza nominale<br>
                                                 utile complessiva"                   no_sort {c}] \
			  [list tot_importo    "Costo del segno<br>
                                                 identificativo"                      no_sort {c}] \
			  [list anni           "Periodicità invio del<br>
                                                 Rapporto di Efficienza Energetica<br>
                                                 munito di segno identificativo"      no_sort {c}] \
			 ]

    
    set table_result_fr [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_impianto gen_prog gen_prog_est last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par} go $sel_gend_fr $table_def_fr];#rom06

    if {$flag_tipo_impianto_1bis eq "F" && $potenza_1bis < 12} {#rom07 Aggiunta if e contenuto
	set table_tot_result_fr ""
    } else {#rom07 Aggiunta else ma non il suo contenuto
    
	set sel_tot_gend_fr [db_map sel_tot_gend_fr];#rom06
	set table_tot_result_fr [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {} go $sel_tot_gend_fr $table_def_tot_fr];#rom06

	ns_log notice "coimgend-1bis-list.tcl sel_tot_gend_fr $sel_tot_gend_fr"
    };#rom07


    
    
#rom07    db_1row q "select cod_impianto_est 
#rom07             from coimaimp
#rom07            where cod_impianto = :cod_impianto";#rom01

    set html_tabelle "$html_tabelle <br><br>
<table width=90% align=center> <!-- rom01 aggiunta table e contenuto -->
      <tr>
         <td align=center><b><big>Rapporto di controllo dell'efficienza energetica tipo 2 per l'impianto $cod_impianto_est</big></b></td>
      </tr>
</table>
$table_result_fr<br><br>
$table_tot_result_fr<br><br>"

}


db_release_unused_handles
ad_return_template 
