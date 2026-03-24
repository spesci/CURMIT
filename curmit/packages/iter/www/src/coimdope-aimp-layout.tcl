ad_page_contract {

    @author Antonio Pisano
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================================================
    mat02 17/03/2026 Aggiunta la gestione delle deleghe e aggiunto il tecnico.

    mat01 15/12/2025 Corretta la gestione del salvataggio dei file nella cartella permanenti

    ric01 03/10/2025 Punto 4 MEV 2025 Marche, aggiunto union per lettura storico ditta di manutenzione a seconda della data della dichiarazione.

    rom03 21/12/2020 Corretta gestione delle img_unchecked e img_checked.

    rom02 17/01/2019 Fatte modifiche per il freddo richieste dalla Regione Marche

    rom01 16/11/2018 Aggiunte modifiche per il logo nell'intestazione e il combustibile dei singoli generatrori su
    rom01            richiesta della Regione Marche.

    gac01 29/11/2017 modificato potenza termica nominale utile, nella seconda pagina di stampa metto la pot. termica 
    gac01            nominale utile al posto della potenza termica nominale complessiva

} {
    {cod_dope_aimp ""}
    
    {nome_funz ""}
    {flag_ins ""}
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
  # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

#rom01 spostato in alto
# Estraggo i dati dell'ente per la stampa
iter_get_coimtgen
set flag_viario  $coimtgen(flag_viario)
set flag_ente    $coimtgen(flag_ente)
set cod_prov     $coimtgen(cod_provincia)
set sigla_prov   $coimtgen(sigla_prov)
set denom_comune $coimtgen(denom_comune)
iter_get_coimdesc;#rom01
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)


set img_url [iter_set_logo_dir]
set img_checked   "${img_url}/checked.bmp"
set img_unchecked "${img_url}/unchecked.bmp"
#rom03set img_checked "<img src=\"$img_url/checked.bmp\" height=12 width=12>";#rom02
#rom03set img_unchecked "<img src=\"$img_url/unchecked.bmp\" height=12 width=12>";#rom02


set logo_dir      [iter_set_logo_dir];#rom01
set stampe_logo_in_tutte_le_stampe [parameter::get_from_package_key -package_key iter -parameter stampe_logo_in_tutte_le_stampe -default "0"];#rom01
set stampe_logo_height             [parameter::get_from_package_key -package_key iter -parameter stampe_logo_height];#rom01
set stampe_logo_nome               [parameter::get_from_package_key -package_key iter -parameter stampe_logo_nome];#rom01

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#rom01: Aggiunta if e suo contenuto
    if {$stampe_logo_height ne ""} {
	if {$coimtgen(regione) eq "MARCHE"} {
	    set height_logo "height=28"
	} else {
	    set height_logo "height=$stampe_logo_height"
	}
    } else {
        set height_logo ""
    }
    set logo "<img src=$logo_dir/$stampe_logo_nome $height_logo>"

    if {$coimtgen(regione) eq "MARCHE"} {
	if {$coimtgen(ente) ne "CANCONA"} {
	    set logo_dx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome   -default ""]
	    set logo_dx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"]
	    set logo_dx "<img src=$logo_dir/logo_dx_nome.png height=15>"

	} else {
	    set logo_dx "<img src=$logo_dir/logo-comune-ancona.png width=32 height=32>"
	}
    } else {
	set logo_dx ""
    }

	if {$coimtgen(ente) eq "PRC"} {
	
	set master_logo_dx_nome [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome]
	set logo_dx "<img src=$logo_dir/$master_logo_dx_nome $height_logo align=right>"
	
    }
} else {
    set logo_dx ""
    set logo ""
}


# Estraggo i dati della dichiarazione
if {![db_0or1row query "
  select 
      cod_dope_aimp,
      cod_documento,
      cod_impianto,
      flag_tipo_impianto,
      cognome_dichiarante,
      nome_dichiarante,
      flag_dichiarante,
      cod_manutentore,
      flag_tipo_tecnico,
      (select descr_utgi from coimutgi
        where cod_utgi = d.cod_utgi) as utilizzo,
      pot_nom_risc,
      pot_nom_raff,
      num_generatori,
      (select descr_comb from coimcomb
        where cod_combustibile = d.cod_combustibile) as combustibile,
      cod_combustibile,
      toponimo,
      indirizzo,
      cod_via,
      localita,
      numero,
      esponente,
      scala,
      piano,
      interno,
      cod_comune,
      cod_distr,
      cod_responsabile,
      flag_resp,
      flag_doc_tecnica,
      flag_istr_tecniche,
      flag_man_tecnici,
      flag_reg_locali,
      flag_norme_uni_cei,
      altri_doc,
      data_dich as data_dich_db,
      iter_edit_data(data_dich) as data_dich
     , cod_opma      --mat02
     , cod_opma_dele --mat02
     , cod_manu_dele --mat02
    from coimdope_aimp d
  where cod_dope_aimp = :cod_dope_aimp
"]} {
    iter_return_complaint "Dati Dichiarazione non trovati"
    return
}

# Voglio salvare il documento...
if {$flag_ins eq "S"} {
    # non esiste, lo salvo come nuovo
    if {$cod_documento eq ""} {
        set sw_insert_coimdocu "t"
    # dovrebbe esistere. Lo verifico e nel caso lo salvo
    } else {
        if {[db_0or1row query "
            select 1
              from coimdocu
             where cod_documento = :cod_documento"]
	} {
	    set sw_insert_coimdocu "f"
    	} else {
	    set sw_insert_coimdocu "t"
	}
    }
}

# Dati dell'impianto
db_1row query "
    select cod_impianto_est
    from coimaimp
    where cod_impianto = :cod_impianto"

# Nome del fornitore di energia
set fornitore_energia ""
if {[db_0or1row query "
    select ragione_01, ragione_02
    from coimdist where cod_distr = :cod_distr"]} {
    set fornitore_energia "$ragione_01 $ragione_02"
}

# Nominativo del responsabile
db_1row query "
    select cognome as cognome_resp,
           nome as nome_resp
    from coimcitt
    where cod_cittadino = :cod_responsabile"

# Dati topografici dell'impianto
db_1row query "
    select i.indirizzo     as indirizzo_imp,
           numero          as numero_imp,
           esponente       as esponente_imp,
           scala           as scala_imp,
           piano           as piano_imp,
           interno         as interno_imp,
           c.denominazione as comune_imp,
           p.sigla         as provincia_imp
        from coimaimp i,
             coimcomu c,
             coimprov p
        where i.cod_comune = c.cod_comune
          and p.cod_provincia = c.cod_provincia
          and i.cod_impianto = :cod_impianto"

# Altri dati del manutentore/dichiarante
db_1row query "
select * 
from (
    select nome    as nome_manu,
           cognome as cognome_manu,
           cod_piva,
           localita_reg,
           reg_imprese,
           indirizzo as indirizzo_manu,
           telefono,
           fax,
           email,
           comune    as comune_manu,
           provincia as provincia_manu,
           flag_a,
           flag_b,
           flag_c,
           flag_d,
           flag_e,
           flag_f,
           flag_g,
           current_date as data_validita  --ric01
        from coimmanu
    where cod_manutentore = :cod_manutentore

    union --ric01 aggiunta union
  
    select nome    as nome_manu,
           cognome as cognome_manu,
           cod_piva,
           localita_reg,
           reg_imprese,
           indirizzo as indirizzo_manu,
           telefono,
           fax,
           email,
           comune    as comune_manu,
           provincia as provincia_manu,
           flag_a,
           flag_b,
           flag_c,
           flag_d,
           flag_e,
           flag_f,
           flag_g,
           st_data_validita as data_validita  
        from coimmanu_st
    where cod_manutentore = :cod_manutentore
) as st
where st.data_validita >= :data_dich_db
order by st.data_validita 
limit 1
"
set nome_manu_dele "";#mat02
set cognome_manu_dele "";#mat02

db_0or1row query "
    select * 
      from (
    select nome    as nome_manu_dele
         , cognome as cognome_manu_dele
         , current_date as data_validita
        from coimmanu
    where cod_manutentore = :cod_manu_dele
    union
    select nome    as nome_manu_dele
         , cognome as cognome_manu_dele
         , st_data_validita as data_validita
        from coimmanu_st
    where cod_manutentore = :cod_manu_dele
    ) as st

where st.data_validita >= :data_dich_db
order by st.data_validita 
limit 1
";#mat02

set nome_op "";#mat02
set cognome_op "";#mat02
set nome_op_dele "";#mat02
set cognome_op_dele "";#mat02

db_0or1row q "
                select nome    as nome_op
	             , cognome as cognome_op
		  from coimopma
		 where cod_opma        = :cod_opma";#mat02
db_0or1row q "
	        select nome    as nome_op_dele
		     , cognome as cognome_op_dele
 		  from coimopma
		 where cod_opma        = :cod_opma_dele";#mat02
           
#rom01db_1row sel_desc "
#  select nome_ente, 
#         indirizzo    as indirizzo_ente, 
#         tipo_ufficio as tipo_ufficio_ente
#    from coimdesc"

set html ""
# Codice per creare l'HTML di una pagina
set create_page_cmd {
    set code [template::adp_compile -file [ad_conn file]]
    append html [template::adp_eval code]
    append html "<!-- PAGE BREAK -->"
}

set pagina_corrente 1

set rows_per_page 32
set rows 0
set key ""
# Queste sono tutte le operazioni sull'impianto.
# Per poter mostrare il numero di pagine in cui siamo, prima mi 
# scorro tutte le righe calcolandomi quante pagine usciranno.
db_multirow operazioni_tot query "
    select 
          o.gen_prog, 
          iter_edit_data(data_installaz) as data_installaz, 
          flag_attivo,
          iter_edit_num(oi.pot_nom_raff,2) as pot_nom_raff,
          iter_edit_num(oi.pot_nom_risc,2) as pot_nom_risc,
          iter_edit_num(g.pot_utile_nom,2) as pot_utile_nom, --gac01
          modello,
          matricola,
          (select descr_cost 
            from coimcost 
          where cod_cost = g.cod_cost) as fabbricante,
          operazione,
          frequenza,
          (select sigla from coimflre
            where cod_flre = g.cod_flre) as fluido_refrigerante,
          (select descr_comb
             from coimcomb
            where cod_combustibile = g.cod_combustibile) as combustibile_gen --rom01
         , g.cod_tpco --rom02
      from coimdope_gend o,
           coimdope_aimp oi,
           coimgend g
  where o.gen_prog       = g.gen_prog
    and oi.cod_dope_aimp = o.cod_dope_aimp
    and oi.cod_impianto  = g.cod_impianto
    and o.cod_dope_aimp = :cod_dope_aimp
   order by gen_prog asc" {
   # Considero che per l'intestazione di ogni generatore...
   if {$key ne $gen_prog} {
        set key $gen_prog
        # ...mi vadano 2 righe per il caldo
        if {$flag_tipo_impianto eq "R"} {
            incr rows 2
        # ...e 4 per il freddo
        } else {
            incr rows 4
        }
    }
    
    # ...e 1 riga per ogni operazione.
    incr rows
    
    if {$rows >= $rows_per_page} {
        incr pagina_corrente
        set rows 0
    }
   
   if {$coimtgen(regione) eq "MARCHE"} {#rom02 aggiunta if e contenuto
       set img_compr_mot_elet "<img src=\"$img_unchecked\" height=12 width=12>"
       set img_compr_mot_endo "<img src=\"$img_unchecked\" height=12 width=12>"
       set img_assor_fia_dire "<img src=\"$img_unchecked\" height=12 width=12>"
       set img_assor_rec_calo "<img src=\"$img_unchecked\" height=12 width=12>"
       set label_combustibile ""
       if {$cod_tpco eq "2"} {
	   set img_compr_mot_elet "<img src=\"$img_checked\" height=12 width=12>"
       }
       if {$cod_tpco eq "4"} {
	   set img_compr_mot_endo "<img src=\"$img_checked\" height=12 width=12>"
       }
       if {$cod_tpco eq "1"} {
	   set img_assor_fia_dire "<img src=\"$img_checked\" height=12 width=12>"
	   set label_combustibile "con combustibile: $combustibile_gen"
       }
       if {$cod_tpco eq "3"} {
	   set img_assor_rec_calo "<img src=\"$img_checked\" height=12 width=12>"
       }
   }

}

# pagine di interventi + la prima pagina
set tot_pagine [expr {$pagina_corrente + 1}]

set pagina_corrente 1
set rows 0

# Creo la prima pagina, contenente la dichiarazione
eval $create_page_cmd
incr pagina_corrente

# Da qui creero' le pagine contenenti l'elenco operazioni

# Dopo aver calcolato il numero totale di pagine, procedo
# a travasarle una per una in una multirow temporanea,
# che conterra' solo le righe stampate nella pagina
# corrente.
set colonne [template::multirow columns operazioni_tot]
set variabili \$[join $colonne " \$"]
# La creo dalla definizione di quella grossa...
eval "template::multirow create operazioni $colonne"
template::multirow foreach operazioni_tot {
    # ...e la riempio con valori di quella grossa...
    eval "multirow append operazioni $variabili"
    incr rows
    if {$rows >= $rows_per_page} {
        # ...creo l'html di questa pagina e lo accodo al resto
        eval $create_page_cmd
        # ...quindi azzero la multirow temporanea.
        eval "template::multirow create operazioni $colonne"
        incr pagina_corrente
        set rows 0
    }
}

# Accodo l'ultima pagina
eval $create_page_cmd


set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]

set permanenti_dir_url [iter_set_permanenti_dir_url] ;#mat01

# save rml in a temporary file
set filename "coimdope-aimp-${id_utente}"
set filename [iter_temp_file_name $filename]
set file_html "$spool_dir/$filename.html"
set file_pdf  "$spool_dir/$filename.pdf"

set wfd [open $file_html w]
fconfigure $wfd -encoding "iso8859-15"
set html [encoding convertto "iso8859-15" $html]
puts $wfd $html
close $wfd

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --fontsize 8 --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]
ns_unlink $file_html

if {$flag_ins eq "S"} {
    db_transaction {
        # Se e' un nuovo documento
        if {$sw_insert_coimdocu eq "t"} {
            set contenuto     ""
            set cod_documento [db_string query "select nextval('coimdocu_s')"]
            # DE = 'Dich. freq. ed elenco oper.'
            set tipo_documento "DE"
            db_dml query "
               insert
                 into coimdocu
                    ( cod_documento
                    , tipo_documento
                    , cod_impianto
                    , data_documento
                    , data_stampa
                    , protocollo_02
                    , data_prot_02
                    , tipo_soggetto
                    , cod_soggetto
                    , data_ins
                    , utente
           ) values ( :cod_documento
                    , :tipo_documento
                    , :cod_impianto
                    , :data_dich_db
                    , current_date
                    , null
                    , null
                    , 'C'
                    , :cod_responsabile
                    , current_date
                    , :id_utente
                )"

            # Inserisco il riferimento al documento sulla dichiarazione
            db_dml query "
            update coimdope_aimp
               set cod_documento = :cod_documento 
             where cod_dope_aimp = :cod_dope_aimp"
        } else {
	    # E' un documento gia' esistente

            db_dml query "
            update coimdocu
               set data_documento = :data_dich_db
                 , data_stampa    = current_date
                 , data_mod       = current_date
                 , utente         = :id_utente
             where cod_documento  = :cod_documento"

            db_1row query "
            select contenuto
              from coimdocu
             where cod_documento = :cod_documento"

	    # Se avevo del contenuto salvato, 
	    # prima lo elimino dai large objects
	    if {$contenuto ne ""} {
		db_dml query "
                update coimdocu
                   set contenuto     = lo_unlink(coimdocu.contenuto)
                 where cod_documento = :cod_documento"
	    }
        }

	if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {	    

	    set tipo_contenuto [ns_guesstype $file_pdf];#mat01

	    set filename_perm [string range $filename [expr {[string first "/" $filename] + 1}] end];#mat01

	    set filename_perm "$filename_perm.pdf";#mat01
	    
	    set path_file [iter_permanenti_file_salva $file_pdf $filename_perm];#mat01 cambiato da filename a filename_perm

	    db_dml q "update coimdocu
                         set tipo_contenuto = :tipo_contenuto
                           , path_file      = :path_file
                       where cod_documento  = :cod_documento"

	    set spool_dir_url $permanenti_dir_url ;#mat01
	    set current_date [clock format [clock seconds] -f "%Y-%m-%d"];#mat01
	    set current_time [clock format [clock seconds] -f "%H-%M-%S"];#mat01
	    set nome_file_perm  "$current_date/$current_date-$current_time-$filename_perm";#mat01
	    set spool_dir_perm [iter_set_permanenti_dir];#mat01
	    set spool_dir_url $permanenti_dir_url ;#mat01
	    set filename $nome_file_perm ;#mat01
	    set filename [string range $filename 0 end-4];#mat01
	    
	} else {
	  
	    # Ed infine salvo il nuovo pdf nella tabella
	    set tipo_contenuto [ns_guesstype $file_pdf]
	    db_dml query "
        update coimdocu
           set tipo_contenuto = :tipo_contenuto
             , contenuto      = lo_import(:file_pdf)
         where cod_documento  = :cod_documento"
	}
    }
}


ad_returnredirect "$spool_dir_url/$filename.pdf"
ad_script_abort
