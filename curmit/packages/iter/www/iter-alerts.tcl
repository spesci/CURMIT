ad_page_contract {
    Menu principale.
    
    @author Luca Romitti
    @date   28/03/2024

    @cvs_id iter-alerts.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 31/10/2024 Aggiunta riga per attività in scadenza. 

    QUA FARE INCLUDE PER PROGRAMMA DI LISTA ATTIVITA' IN SPOSPESO:
    IMPIANTI IN SCADENZA NEI PROSSIMI 30 GG.
    
    RICORDARSI DI MODIFICARE LA CLASS PER OGNI RIGA, DEVONO ESSERE EVEN OPPURE ODD

} {
}

set base_url [ad_conn url]
set ctr 0
set alerts ""

#set db_name [db_get_database_pretty]
db_1row get_date_scad "select current_date as da_data_scad
                            , (current_date+ interval '1 month')::date as a_data_scad"

set num_aimp_in_scad [db_string q "select count(cod_impianto)
                                     from coimaimp
                                    where data_scad_dich >= current_date
                                      and data_scad_dich <= (current_date+ interval '1 month')::date
                                      $where_manu"]
if {$num_aimp_in_scad > 0 } {
    set num_aimp_in_scad_pretty [iter_edit_num $num_aimp_in_scad 0]
    set url_aimp_in_scad [export_vars -base "src/coimaimp-list" {{nome_funz "impianti"} {f_da_data_scad $da_data_scad} {f_a_data_scad $a_data_scad} {f_cod_manu $cod_manu}}]
    append alerts "<tr class=odd><td width=\"90%\"><b>$num_aimp_in_scad_pretty impianti</b> con RCEE in scadenza nei prossimi 30 giorni</td><td><a class=link-button-2 href=$url_aimp_in_scad>Vedi</a></td></tr>"

} else {
    append alerts ""
}


if {$where_manu ne ""} {#rom01 if, else e loro contenuto
    set ls_aimp_todo_in_scad ""
} else {

set ls_aimp_todo_in_scad [db_list_of_lists q "select count(c.cod_impianto)
                                                   , c.cod_impianto
                                                from coimaimp c
                                               where c.stato = 'A' 
                                                 and exists (
                                                     select 1
                                                       from coimtodo t
                                                      where t.cod_impianto = c.cod_impianto
                                                        and (t.data_evasione is null or t.flag_evasione ='N')
                                                        and t.data_scadenza between current_date and current_date + interval '1 month'
                                                     )
                                               group by c.cod_impianto"]
}
set num_tot_aimp_todo_in_scad 0
set ls_cod_impianto_td       [list ""]
foreach aimp_todo_in_scad $ls_aimp_todo_in_scad {

    lassign $aimp_todo_in_scad  num_aimp_todo_in_scad cod_impianto_td
    
    set num_tot_aimp_todo_in_scad [expr $num_tot_aimp_todo_in_scad + $num_aimp_todo_in_scad]

    lappend ls_cod_impianto_td $cod_impianto_td
}

if {$num_tot_aimp_todo_in_scad > 0} {
    set num_tot_aimp_todo_in_scad_pretty [iter_edit_num $num_tot_aimp_todo_in_scad 0]
    #set ls_cod_impianto_td "'[join $ls_cod_impianto_td\',\']\'"
    
    set url_aimp_todo_in_scad  [export_vars -base "src/coimaimp-list" {{nome_funz "impianti"} {f_ls_cod_aimp $ls_cod_impianto_td}}]
    append alerts "<tr class=even><td width=\"90%\"><b>$num_tot_aimp_todo_in_scad_pretty impianti</b> con <b>Attivit&agrave; in sospeso</b> in scadenza nei prossimi 30 giorni</td><td><a class=link-button-2 href=$url_aimp_todo_in_scad>Vedi</a></td></tr>"
}

if {[string equal $alerts ""]} {
    set alerts "<tr class=even><td width=\"90%\"><b>Nessuna scadenza da monitorare al momento.</b></td></tr>"
}
