ad_page_contract {
    @autore oasi
    @data gennaio 2012

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 14/07/2023 Aggiunta class"link-button-2" nel actions"vedi"

} { 
    {search_word ""}
}

set page_title "Lista verbali scansionati non collegati a impianto"
set title "lista verbali scansionati"
set form_di_ricerca [iter_search_form "coimalle-list" $search_word]
set col_di_ricerca  "Nome file"
set rows_per_page   100

set lvl        1
set id_utente [lindex [iter_check_login $lvl "coimalle"] 1]
set context_bar [iter_context_bar -nome_funz "coimalle"]
set js_function ""
set link "\[export_url_vars alle_id\]"
set actions "<td nowrap><a href=\"coimalle-view?funzione=V&$link\" class=\" link-button-2\" target=stampa>Vedi</a></td>"

# imposto la struttura della tabella
set table_def [list [list actions "Azione" no_sort $actions] \
                    [list tabella "Tipo documento" no_sort {l}] \
                    [list codice  "Codice interno" no_sort {l}] \
                    [list allegato "File scansionato" no_sort {l}] \
              ]

if {$search_word != ""} {
    set where_word "and tabella||codice like '%$search_word%'"

} else {
    set where_word ""
}

set sel_scan  "
        select alle_id,
               case when tabella = 'coimdimp' then 'Dichiarazione' 
                    when tabella = 'coimcimp' then 'Controllo'
                    else '?' 
                end  as tabella,
               codice,
               allegato
            from coimallegati
            where 1=1 $where_word and not exists (select 1 from coimdimp where cod_dimp = codice)
            order by tabella,
                     codice
            "

set table_result [ad_table -Tmax_rows 1000 -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {} go $sel_scan $table_def]

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
		   "" "" "" ""]

db_release_unused_handles
ad_return_template
