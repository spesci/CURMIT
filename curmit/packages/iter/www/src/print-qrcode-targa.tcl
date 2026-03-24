ad_page_contract {

    @author         Gacalin Lufi
    @creation-date  02/03/2018
 

    USER  DATA       MODIFICHE
    ===== ========== ================================================================================================
    rom04 07/12/2023 Per regione Friuli modificata variabile logo_regione.

    ric01 02/03/2023 Modifiche per loghi e diciture per UCIT.

    rom03 10/01/2022 Su richiesta di Regione Marche oltre al logo vado anche a scrivere il nome dell'ente di riferimento
    rom03            che sta stampando la targa.

    rom02 03/07/2020 Sul server OASI-AMAZON-09 la versione di zint e' più aggiornata rispetto a qella degli altri
    rom02            server, passa dalla versione 2.4.2 alla versione 2.7.0. La versione 2.7.0 non supporta piu' 
    rom02            il comando --directeps, bisogna usare invece --filetype=EPS. Per ovviare il problema delle versioni 
    rom02            differenti tra i vari server utlizziamo il comando with_catch error_msg.

    rom01 19/06/2020 Tolta cablatura presente che faceva comparire sempre il logo del comune di Ancona.
    rom01            Ora utilizzo il parametro master_logo_sx_nome.
    
} {
    cod_impianto   
}


# Controlla lo user
set id_utente [iter_get_id_utente]

db_1row q "select targa
                , cod_impianto_est 
             from coimaimp 
            where cod_impianto=:cod_impianto"

#aggiorno il flag targa stampata
db_dml q "update coimaimp set flag_targa_stampata = 't' where cod_impianto=:cod_impianto"
# save rml in a temporary file

set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set filename "stampa_targa"
set file_html "$spool_dir/$filename.html"
set file_pdf  "$spool_dir/$filename.pdf"
set file_pdf_url "$spool_dir_url/$filename.pdf"

#imposto il logo

#creo il qrcode da usare nella stampa
set bar_eps_output "$spool_dir/test_qrcode.eps" 
set bar_jpg_output "$spool_dir/test_qrcode.jpg"
set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale]  
set url  "$url_portale/iter-portal/plants-filter?targa=$targa"
#rom02exec zint --directeps --barcode=58 --notext --data=$url > $bar_eps_output
with_catch error_msg {
    #rom02 la versione di Zint 2.4.2 supporta il comando --directeps
    exec zint --directeps --barcode=58 --notext --data=$url > $bar_eps_output
    exec eps2png -jpggray -scale=3 -o=$bar_jpg_output $bar_eps_output
} {
    #rom02 In alcuni server Zint e' piu' aggiornato con la versione 2.7.0
    #rom02 Questa versione non supporta il comando --directeps
    exec zint --direct --filetype=EPS --barcode=58 --notext --data=$url > $bar_eps_output
    exec eps2png -jpggray -scale=1 -height=130 -width=130  -o=$bar_jpg_output $bar_eps_output
}

set qrcode "<img src=$bar_jpg_output>"    

set logo_dir      [iter_set_logo_dir]
set logo_regione  [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome]
set logo_ente     [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome]
set master_logo_dx_height  [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_height -default "32"]
set master_logo_sx_height  [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"]
set logo_regione "<img src=$logo_dir/$logo_regione height=$master_logo_dx_height>"
set logo_ente    "<img src=$logo_dir/$logo_ente height=$master_logo_sx_height>"
#set logo_ente "<img src=$logo_dir/$logo_ente width=32 height=32>"
set master_logo_sx_titolo_sopra [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_titolo_sopra];#rom03
set master_logo_sx_titolo_sotto [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_titolo_sotto];#rom03
set dicitura_ente "$master_logo_sx_titolo_sopra $master_logo_sx_titolo_sotto";#rom03

#ric01 aggiunte modifiche loghi e diciture per UCIT
set intestazione_bassa "";#ric01

iter_get_coimtgen;#ric01

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#ric01 aggiunta if e suo contenuto
    #rom01set logo_regione "<img src=$logo_dir/ucit-sfondo-bianco.jpg height=34>"
    set logo_regione "<img src=$logo_dir/fvg_energia_spa.png  height=23>"
    set logo_ente    "<img src=$logo_dir/friuli-ve-giu-new.jpg  height=23>"
    set intestazione_bassa "<tr><td>&nbsp;</td></tr>
            <tr><td colspan=3 align=center><font size=1><b>Targa impianto stampata dal CRIT-FVG Catasto Regionale Impianti Termici Friuli Venezia Giulia</b></font></td></tr>"
}

set etichetta "
<table width=100% border=0>
   <tr>
     <td width=11%>$logo_ente</td>
     <td width=78%><b>$dicitura_ente</b></td><!--rom03 Aggiunta variabile dicitura_ente al posto di &nbsp; -->
     <td width=11%>$logo_regione</td>
   </tr>
   <tr>
     <td colspan=3 align=center><b><big>$targa</big></b></td>
   </tr>
   <tr>
     <td colspan=3 align=center>$qrcode</td>
   </tr> 
$intestazione_bassa
</table>"

set html "
<table width=100% border=1>
<tr>
 <td width=50% height=50%>$etichetta</td>
 <td width=50% height=50% align=right>$etichetta</td>
</tr>
<tr>
 <td width=50% height=50%>$etichetta</td>
 <td width=50% height=50% align=right>$etichetta</td>
</tr>
</table>
"

set wfd [open $file_html w]
fconfigure $wfd -encoding "iso8859-15"

puts $wfd $html
close $wfd

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --landscape --bodyfont arial --fontsize 10  --left 0cm --right 0cm --top 0cm --bottom 0cm -f $file_pdf $file_html]



ns_unlink $file_html
ad_returnredirect "$file_pdf_url"
ad_script_abort
