ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdimp"
    @author          Adhoc
    @creation-date   03/05/2004

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
    but01 20/06/2023 Aggiunto la classe ah-jquery-date al campo data_dest.
    
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
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}


#set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

set current_date [iter_set_sysdate]

iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)
set link         [export_ns_set_vars "url"]

set page_title   "Modifica Data dichiarazione"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

set buttons [list "Aggiorna"]

# NOTE form name must not contains '-' or JavaScript gets confused
#but01 Aggiunto la classe ah-jquery-date al campo data_dest.
ad_form -name addedit \
        -edit_buttons $buttons \
        -has_edit 1 \
    -form {

	{cod_dimp:text
	    {label {Codice Dichiarazione}}
	    {html {length 20} }
	}
	{data_dest:text
	    {label {Data Corretta GG/MM/AAAA}}
	    {html {length 10 $jq_date} }
	}
    } -on_submit {

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}


set nome_funz            "coimdimp-data"
set id_utente    [lindex [iter_check_login $lvl $nome_funz] 1]
set errnum 0
     

	
 	if {![db_0or1row query "select 1 from coimdimp where cod_dimp = :cod_dimp"]} {
            template::form::set_error addedit cod_dimp "Dichiarazione inesistente."
            incr errnum
        }
 	
	
     


        if {[string equal $data_dest ""]} {
	    set flag_errore_data_controllo "t"
            template::form::set_error addedit data_dest "<font color=red>Inserire Data controllo</font>"
            incr errnum
        } else {
            set data_dest [iter_check_date $data_dest]
            if {$data_dest == 0} {
		 template::form::set_error addedit data_dest "<font color=red>Data controllo deve essere una data </font>"
                incr errnum
            } else {
		 if {$data_dest > $current_date} {
			set flag_errore_data_controllo "t"
			template::form::set_error addedit data_dest "<font color=red>Data controllo deve essere inferiore alla data odierna</font>"
			incr errnum
		    }
		}
		              
            }

        set cod_man [iter_check_uten_manu $id_utente]

        if {[string range $id_utente 0 1] == "MA"} {
	   if {![db_0or1row query "select 1 from coimdimp where cod_dimp = :cod_dimp and utente_ins <> :cod_man"]} {
              template::form::set_error addedit cod_dimp "<font color=red>Dichiarazione non inserita dall'utente collegato</font>"
               incr errnum
           }
	}
        	
        
	if {$errnum == 0 } {
          if {[db_0or1row query "select 1 from coimdimp where cod_dimp = :cod_dimp and data_controllo = :data_dest "]} {
            template::form::set_error addedit cod_dimp "<font color=red>Data dichiarazione già presente</font>."
            incr errnum
          }
       }

	if {$errnum > 0} {
	    break
	}
	db_transaction {
	    db_dml query "update coimdimp set data_controllo = :data_dest where cod_dimp = :cod_dimp"
	}

      } -after_submit {

	  ad_returnredirect "coimdimp-data"
	  
	  ad_script_abort
      }
