<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 13/01/2021 Modificato intervento di gac01, il bottone deve essere visibile, per le
    rom01            Marche, solo se arrivo dal singolo impianto e non dalla consultazione
    rom01            dei rapporti di Ispezione.

    gac01 13/07/2018 Aggiunto bottone in alto "Torna a Scheda 11: RCEE e moduli regionali"
    gac01            solo per la Regione Marche.

-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

@link_inco;noquote@
@link_tab;noquote@
@dett_tab;noquote@
<if @flag_cimp@ ne S and @flag_inco@ ne S>
    <table width="25%" cellspacing=0 class=func-menu>
     <tr>
       <td width="25%" nowrap class=func-menu>
        <a href="coimcimp-filter?@link_filt;noquote@" class=func-menu>Ritorna</a>
      </td>
    </tr>
   </table>
</if>
<!--rom01 aggiunta  condizione su nome_funz_caller-->
<if @coimtgen.regione@ eq "MARCHE" and @nome_funz_caller@ eq "impianti"><!--gac01 aggiunta if e suo contenuto-->
  <table width="25%">
    <tr>
      <td width="25%" class=func-menu>
        <a href="coimaimp-warning?@link_scheda11;noquote@&caller=dimp&nome_funz_caller=impianti">Torna a Scheda 11: RCEE e moduli regionali</a>
      </td>
    </tr>
  </table>
</if><!--gac01-->

<if @flag_vis@ eq S>
<table align="center" width="35%" border="0" cellpadding="0" cellspacing="0">
<tr>
   <td width="34%" align="center"><a href="coimcimp-list-csv?@link_scar_csv;noquote@">Scarica CSV</a></td>
   <td width="33%" align="center">Numero <b>@conta;noquote@</b></td>
   <td width="34%" align="center"><a href="coimcimp-list-pdf?@link_scar_csv;noquote@" target="_blank">Stampa PDF</a></td> 
</tr>
</table>
</if>
@js_function;noquote@



<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@


<center>
<!-- genero la tabella -->
@table_result;noquote@

</center>

