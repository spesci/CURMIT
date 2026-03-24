ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcimp"
    @author          Riccardo Vesentini
    @creation-date   16/06/2023

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimcimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 30/06/2023 Corretto ls_gen_dis, veniva creata la lista dei generatori disattivi con
    ric01            la virgola come separatore perciò andava in errore quando era presente
    ric01            più di un generatore disattivo. 

} {

    {cod_dimp         ""}
    {funzione        "M"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {cod_impianto     ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
    {gen_prog         ""}
    {flag_cimp        ""}
    {extra_par_inco   ""}
    {cod_inco         ""}
    {flag_inco        ""}
    {flag_tracciato   ""}
    {mode "edit"}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

#set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)
set link         [export_ns_set_vars "url"]

set page_title   "Riattivazione generatore";#rom01
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

set buttons [list "Riattiva"]

# NOTE form name must not contains '-' or JavaScript gets confused
ad_form -name addedit \
        -edit_buttons $buttons \
        -has_edit 1 \
    -form {

	{cod_impianto_est:text
	    {label {Codice impianto}}
	    {html {length 20} }
	}
	{gen_prog_est:text
	    {label {Numero generatore}}
	    {html {length 20} }
	}

	{submit:text(submit)
	    {label {Riattiva}}
	}
	
    } -on_submit {

	set errnum 0
	
	#controllo che il codice impianto sia corretto
	if {![db_0or1row q "select cod_impianto 
                     from coimaimp 
                    where cod_impianto_est=:cod_impianto_est"]} {
	    template::form::set_error addedit gen_prog_est "Impianto non presente a catalogo"
            incr errnum
	}

	#controllo che il numero del generatore sia un numero
	if {[string match "Error" [ah::check_num $gen_prog_est]]} {
            template::form::set_error addedit gen_prog_est "Numero generatore errato"
            incr errnum
	    set gen_prog_est 0
	}

	#ricavo la lista dei generatori non attivi sull'impianto
#ric01	set ls_gen_dis [join [db_list q "select distinct gen_prog_est 
#ric01                                        from coimgend 
#ric01                                       where cod_impianto = :cod_impianto 
#ric01                                         and flag_attivo = 'N'"] \
#ric01 		    ,]

	#ric01 rimosso join che separava la lista con la virgola
	set ls_gen_dis [db_list q "select distinct gen_prog_est
                                    from coimgend
                                   where cod_impianto = :cod_impianto
                                     and flag_attivo = 'N'"];#ric01

	if {$gen_prog_est ni $ls_gen_dis} {
	     template::form::set_error addedit gen_prog_est "Il generatore non esiste o è già attivo"
            incr errnum
	}
	
 	if {![db_0or1row query "select 1 
                                  from coimgend 
                                 where cod_impianto = :cod_impianto
                                 --  and gen_prog_est = :gen_prog_est
                                    limit 1
				    	  "]} {

            template::form::set_error addedit cod_impianto_est "Impianto non trovato"
            incr errnum
        }

	db_1row num_generatori "select count(*) as num_generatori
                              from coimgend 
                             where gen_prog_est = :gen_prog_est
                          --   and flag_attivo = 'N'
                               and cod_impianto = :cod_impianto"


	if {$num_generatori > 1} {

	    template::form::set_error addedit gen_prog_est "Più di un generatore numero $gen_prog_est presente sull'impianto.<br>Per procedere alla riattivazione <a href=\"coimgend-list?cod_impianto=$cod_impianto&nome_funz_caller=datigen&nome_funz=datigen\">verifica i generatori.</a>"
	    incr errnum
	}
	
	if {$errnum > 0} {
	    break
	}
	
	db_transaction {
	    db_dml upd_gend_sost "update coimgend
                   set flag_sostituito  = 'N'
                     , flag_attivo      = 'S'
                     , data_mod         = current_timestamp
                 where cod_impianto     = :cod_impianto
                   and gen_prog_est     = :gen_prog_est"
	}

      } -after_submit {

	  #o ritornare alla lista generatori?
	  ad_returnredirect "coimgend-list?cod_impianto=$cod_impianto&nome_funz_caller=datigen&nome_funz=datigen"
	  
	  ad_script_abort
      }
