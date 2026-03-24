ad_page_contract {
    @author dob

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    mic01 27/05/2022 Programma modificato e migliorato graficamente.

} {
    tipo_modello 
    cod_manutentore
    {nome_funz ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
}

#set form_name "ripristino"
set page_title   "Caricamenti interrotti ripristinati"
#mic01 aggiunti url per ritornare a lancia-ripristino tramite context bar e bottone
set url_ritorna "lancia-ripristino?[export_url_vars tipo_modello cod_manutentore nome_funz]"
set url "lancia-ripristino?[export_url_vars nome_funz]"

#mic01 modificata context bar
#set context_bar  [iter_context_bar -nome_funz lancia-ripristino]
set context_bar  [iter_context_bar \
		      [list "../main" "Home"] \
		      [list $url_ritorna "Lancio ripristino caricamenti interrotti"] \
		      [list "" "$page_title"] \ ]


db_dml del_manu "delete from coimcari_manu where cod_manutentore = :cod_manutentore"
#mic01 ora viene visualizzato il tipo di RCEE anziché modellog / modellof
if {$tipo_modello == "modellof"} {
    set iniz_tabella_dati [db_string query "select 'fcari_'||lower(:cod_manutentore)"]
    set label_tipo_mod "RCEE Tipo 2"
} else {
    set iniz_tabella_dati [db_string query "select 'gcari_'||lower(:cod_manutentore)"]
    set label_tipo_mod "RCEE Tipo 1"
}

set iniz_tabella_anom [db_string query "select 'anom_'||lower(:cod_manutentore)"]
set lista_tabelle [db_tables -pattern ${iniz_tabella_dati}%] 
set lista_tabanom [db_tables -pattern ${iniz_tabella_anom}%] 
foreach nome_tabella $lista_tabelle {
    set nome_sequence "${nome_tabella}_s"
    db_dml del_tabella "drop table $nome_tabella"
    db_dml del_seq "drop sequence $nome_sequence"
}
foreach nome_tabanom $lista_tabanom {
    db_dml del_tabanom "drop table $nome_tabanom"
}
#mic01 messaggio migliorato graficamente
set messaggio "Rimozione tabelle elaborazioni di caricamento interrotte <b>completata</b>.
                             <p> Tipo modello: $label_tipo_mod </p>
                             <p>Manutentore: $cod_manutentore.</p>
                             <p>Tabelle rimosse: $lista_tabelle $lista_tabanom</p>"

#ns_return 200 text/html "Rimozione tabelle elaborazioni di caricamento interrotte. <br> Tipo modello: $tipo_modello <br> Manutentore: $cod_manutentore.<br>Tabelle rimosse: $lista_tabelle $lista_tabanom"
return
