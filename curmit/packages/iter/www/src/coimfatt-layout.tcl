ad_page_contract {

    @author          Valentina Catte
    @creation-date   13/10/2005

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimfatt-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    rom01 23/05/2023 Resa standard una modifica per il Comune di Salerno sul logo.

} {

    {nome_funz         ""}
    {nome_funz_caller  ""}
    {cod_fatt          ""}
    {cod_sogg          ""}
    {tipo_sogg         ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}


set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# Controllo se il Database e' Oracle o Postgres
set id_db     [iter_get_parameter database]

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)
set cod_comu $coimtgen(cod_comu)

set var_fatt ""

if {$cod_comu == "54018"} {
   set var_fatt "FL"
} 

if {$cod_comu == "41044"} {
   set var_fatt "PS"
} 


# imposto variabili usate nel programma:
set sysdate_edit  [iter_edit_date [iter_set_sysdate]]

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file     "stampa fattura"
set nome_file     [iter_temp_file_name $nome_file]
set file_html     "$spool_dir/$nome_file.html"
set file_pdf      "$spool_dir/$nome_file.pdf"
set file_pdf_url  "$spool_dir_url/$nome_file.pdf"

set file_id       [open $file_html w]
fconfigure $file_id -encoding iso8859-1

# Personalizzo la pagina
set titolo       "Stampa fattura bollini"
set page_title   "Stampa fattura bollini"

if {[db_0or1row sel_boll ""] == 0} {
    set num_fatt ""
    set data_fatt ""
}

if {$flag_ente eq "CSALERNO"} {#rom01 Aggiunte if, else e il loro contenuto
    set logo_stmp "$logo_dir/LogoSinergia.jpg"
} else {
    set logo_stmp "$logo_dir/stpt_fattura.jpg"
}

set testata "
<table width=100% > 
    <tr>
       <td> </td>
    </tr>
    <tr>
       <td> </td>
    </tr>
    <tr>   
      <td align=center width=100%>
        <img height=90 src=$logo_stmp>
      </td>
      <td valign=center align=center width=90%>
         <b><i></i><i></></b>
         <br>
         <br>
         <br>
      </td>
      <td valign=top align=right width=10%>
          
      </td>
   </tr>
    <tr>
       <td></td>
    </tr>
    <tr>
       <td></td>
    </tr>
   <tr>
      <td></td>
   </tr>
</table>"

puts $file_id $testata

if {$tipo_sogg == "M"} {
    if {[db_0or1row sel_manu ""] == 0} {
	set m_nome ""
	set m_cognome ""
	set m_indirizzo ""
	set m_cap ""
        set m_localita ""
	set m_comune ""
	set m_piva ""
	set m_cod_fiscale ""
    }
} 

if {$tipo_sogg == "C"} {
    if {[db_0or1row sel_citt ""] == 0} {
	set c_nome ""
	set c_cognome ""
	set c_indirizzo ""
	set c_cap ""
        set c_localita ""
	set c_comune ""
	set c_piva ""
	set c_cod_fiscale ""
    }
}

puts $file_id "
<table width=100%>
   <tr> <br> </tr>  <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> 
      <td align=left width=50%><big>FATTURA</big><br>Numero Fattura: $num_fatt /$var_fatt
                                                 <br>Data: $data_fatt</td>
      <td width=20%></td>
      <td align=left width=30%></td>
   </tr>"
if {$tipo_sogg == "M"} {
    puts $file_id "
<table width=100%>
      <tr> <br> </tr>  <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> 
    <tr>
       <td align=left width=50%>&nbsp;<td/>
       <td valign=top align=left>Spett.le &nbsp;&nbsp;</td>
       <td align=left>$m_cognome $m_nome
                     <br>$m_indirizzo
                     <br>$m_cap $m_localita $m_comune
                     <br>$m_piva
                     <br>$m_cod_fiscale
     </tr>
    "
}
if {$tipo_sogg == "C"} {
    puts $file_id "
     <tr> <br> </tr>  <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> 
     <tr>
       <td valign=top align=right >Spett.le &nbsp;&nbsp;</td>
       <td valign=top colspan=2 align=left >$c_cognome $c_nome
                                       <br>$c_indirizzo
                                       <br>$c_cap $c_localita $c_comune
                                       <br>$c_piva
                                       <br>$c_cod_fiscale
     </tr>
"
}
puts $file_id "
    <tr>
    <tr> <br> </tr>  <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> 
    <tr> <br> </tr>  <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> <tr> <br> </tr> 
     <td></td>
    </tr>
    <tr>
    <td></td>
    </tr>
    <tr>
</table> 
"
if {[db_0or1row sel_boll ""] == 0} {
    set matr_da ""
    set matr_a ""
    set n_bollini ""
    set imponibile 0
    set perc_iva 0
    set perc_iva_edit ""
    set flag_pag ""
} 

if {$spe_postali == ""} {
set spe_postali 0
}

if {$spe_legali == ""} {
set spe_legali 0
}


set imp_iva [expr 100 + $perc_iva] 
#set iva [expr $imponibile * $perc_iva / 100]
set totale $imponibile
set imponibile [expr $imponibile / $imp_iva * 100]
set iva [expr $totale - $imponibile]
set imponibile [iter_edit_num $imponibile 2]
set perc_iva [iter_edit_num $perc_iva 2]
set iva_edit [iter_edit_num $iva 2]
#set totale [iter_edit_num $totale 2]
set spe_legali [iter_check_num $spe_legali 2]
set spe_postali [iter_check_num $spe_postali 2]
set totale_edit [expr $totale + $spe_postali + $spe_legali]

set testo ""
if {$desc_fatt == ""} {
set testo "Si emette fattura per l 'aquisto di Bollini verdi  da n. $matr_da al n. $matr_a. per i quali è stato effettuato il  relativo versamento - $mod_pag"
} else {
set testo $desc_fatt
}


puts $file_id  "
<table width=100% border=1>
    <tr>
        <td align=center valign=center width=15%>QUANTIT&Agrave;</td>
        <td align=center valign=center width=65%>DESCRIZIONE</td>
        <td align=center valign=center width=20%>IMPORTO</td>
    </tr>
    <tr>
        <td align=center valign=center>$n_bollini</td>
        <td align=center valign=center>$testo</td>
        <td align=right valign=center>&#8364; $totale_edit</td>
    </tr>
    <tr>
        <td></td>
        <td align=right valign=top >IMPONIBILE
                                    <br>
                                    <br>
                                    IVA $perc_iva_edit %
        </td>
        <td align=right valign=top>&#8364; $imponibile
                                           <br>
                                           <br>
                                           &#8364; $iva_edit
        </td>
    </tr>
    <tr>
             <td></td>
        <td align=right valign=top >SPESE POSTALI (Es.art.10)
         
        </td>
        <td align=right valign=top>&#8364; $spe_postali
                                         
        </td>
    </tr>
<tr>
             <td></td>
        <td align=right valign=top >SPESE LEGALI (Es.art.10)
         
        </td>
        <td align=right valign=top>&#8364; $spe_legali
                                         
        </td>
    </tr>


    <tr>
        <td></td>
        <td align=right valign=center><b>TOTALE FATTURA</b></td>
        <td align=right valign=top>&#8364; $totale_edit</td>
    </tr>
</table> 
"

puts $file_id "
 
<table width=100%>  
     <tr>
      <td>&nbsp;</td>
   </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>
   <tr>
      <td>&nbsp;</td>
   </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>
   <tr>
      <td>&nbsp;</td>
   </tr>
</table>
"

switch $flag_pag {
    "S" {set pag_edit   "PAGATO"}
    "N" {set pag_edit   ""}
    default {set pag_edit   ""}
}

if {$flag_pag == "S"} {
    puts $file_id "
 
    <table width=100%>  
         <tr>
            #<td valign=center align=left>Modalit&agrave;  Pagamento:</td>
            #<td valign=center align=left><b><u><big>$pag_edit</big></u></b></td>
            <td valign=center align=right> </td> 
         </tr>
    </table>

    "
} else {
    puts $file_id "
 
    <table width=100%>  
         <tr>
           <td valign=center align=right> </td> 
         </tr>
    </table>

    "
}
puts $file_id "

<table width=100%>
      <tr>
       <td>&nbsp;</td>
    </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>    
    <tr>
       <td>&nbsp;</td>
    </tr>    
    <tr>
       <td>&nbsp;</td>
    </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>
<tr>
       <td>&nbsp;</td>
    </tr>
    <tr>
       <td>&nbsp;</td>
    </tr>    
    <tr>
       <td>&nbsp;</td>
    </tr>    
    <tr>
       <td>&nbsp;</td>
    </tr>
  
</table>
"

puts $file_id "

<table width=100%>
    <tr>
      <td align=center width=30%>
        <img height=60 src=$logo_dir/stpp_fattura.jpg>
      </td>
    </tr>
</table>

"

close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --footer ... --bottom 0cm  -f $file_pdf $file_html]

ns_unlink $file_html
ad_returnredirect $file_pdf_url
ad_script_abort
