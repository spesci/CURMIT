ad_page_contract {
    @autore     dob gennaio 2013
} {
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {f_data_inizio    ""}
    {f_data_fine      ""}
    {f_cod_manu       ""}
    {f_clas_funz      ""}
    {f_tiraggio       ""}
    {f_tipo_a_c       ""}



} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

ns_log notice "prova dob inizio coimscar-anom-gest nome_funz = $nome_funz nome_funz_caller $nome_funz_caller $f_data_inizio $f_data_fine"

#imposto parametri

if {$f_cod_manu == ""} {
    set where_manutentore ""
} else {
    set where_manutentore "and b.cod_manutentore = :f_cod_manu" 
} 
if {$f_clas_funz == ""} {
    set where_clas ""
} else {
    set where_clas "and f.clas_funz = :f_clas_funz" 
} 

if {$f_tiraggio == ""} {
    set where_tiraggio ""
} else {
    set where_tiraggio "and h.tiraggio = :f_tiraggio" 
} 

if {$f_tipo_a_c == ""} {
    set where_tipo ""
} else {
    set where_tipo "and h.tipo_foco = :f_tipo_a_c" 
} 


switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars nome_funz nome_funz_caller caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# leggo la tabella dei dati generali
iter_get_coimtgen

# imposto la directory degli permanenti ed il loro nome.
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]


# imposto il nome dei file
set nome_file     "scaricoanomalie"
set nome_file     [iter_temp_file_name -permanenti $nome_file]

set file_csv      "$permanenti_dir/$nome_file.csv"
set file_csv_url  "$permanenti_dir_url/$nome_file.csv"

ns_log notice "prova dob 2 file_csv = $file_csv file_csv_url = $file_csv_url"

set file_id       [open $file_csv w]
fconfigure $file_id -encoding iso8859-15

set     head_cols ""
lappend head_cols "IMPIANTO"
lappend head_cols "DATA.DICH."
lappend head_cols "MANUTENTORE"
lappend head_cols "RESPONSABILE"
lappend head_cols "IND.RESPONSABILE"
lappend head_cols "UBIC.IMPIANTO"
lappend head_cols "UBIC.COMUNE"
lappend head_cols "COD.ANOM."
lappend head_cols "DESC.ANOM."
lappend head_cols "CL.ANOM."
lappend head_cols "TIRAGGIO"
lappend head_cols "TIPO FOC"
lappend head_cols "LOC.INS."
#scrivo riga testata
iter_put_csv $file_id head_cols ;



#imposto campi del record da scrivere
set     file_cols ""
lappend file_cols "impianto"             
lappend file_cols "data_dich"   
lappend file_cols "manutentore"
lappend file_cols "responsabile"
lappend file_cols "ind_resp"
lappend file_cols "ubic"      
lappend file_cols "denominazione"      
lappend file_cols "cod_anom" 
lappend file_cols "descr_tano"     
lappend file_cols "desc_anom"
lappend file_cols "tiraggio"
lappend file_cols "tipo_foco"
lappend file_cols "locale"


db_foreach query "select a.cod_impianto_est as impianto
                        ,to_char(b.data_controllo,'dd/mm/yyyy') as data_dich
                        ,c.cognome || ' ' || coalesce(c.nome,'') as manutentore
                        ,d.cognome || ' ' || coalesce(d.nome,'') as responsabile
                        ,coalesce(d.indirizzo,'') || ' ' || coalesce(d.cap, '') || ' '|| coalesce(d.comune,'') as ind_resp
                        ,coalesce(g.descr_topo, '') || ' '||coalesce(g.descrizione, '')||', '||coalesce(a.numero,'') as ubic
                        ,l.denominazione
                        ,e.cod_tanom as cod_anom
                        ,f.descr_tano 
                       ,i.clas_funz||0 as desc_anom
                        ,h.tiraggio
                        ,h.tipo_foco
                        ,locale
                   from coimaimp a
                       ,coimdimp b
                       ,coimmanu c
                       ,coimcitt d
                       ,coim_d_anom e
                       ,coim_d_tano f 
                       ,coimviae g
                       ,coimgend h
                       ,coim_d_clas i
                       ,coimcomu l
                  where b.cod_impianto = a.cod_impianto
                    and c.cod_manutentore = b.cod_manutentore
                    and d.cod_cittadino = a.cod_responsabile
                    and e.cod_cimp_dimp = b.cod_dimp
                    and f.cod_tano = e.cod_tanom
                    and a.cod_via = g.cod_via
                    and h.cod_impianto = a.cod_impianto
                    and h.gen_prog = b.gen_prog 
                    and l.cod_comune = g.cod_comune
                    and i.clas_funz = f.clas_funz
                    and data_controllo between :f_data_inizio and :f_data_fine
                   $where_manutentore
                   $where_clas
                   $where_tipo
                   $where_tiraggio 
               order by c.cognome,b.data_controllo,e.prog_anom
" {

    regsub -all \r $desc_anom "" desc_anom

    set file_col_list ""
    foreach column_name $file_cols {
	lappend file_col_list [set $column_name]
    }

    iter_put_csv $file_id file_col_list ;


} if_no_rows {
    set msg_err      "Nessuna anomalia trovata per la selezione richiesta"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_id msg_err_list |
}

ad_returnredirect $file_csv_url
ad_script_abort

