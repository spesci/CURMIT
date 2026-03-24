<!--
    USER  DATA       MODIFICHE
    ====  ========== =========================================================================
    rom04 09/08/2024 Aggiunto messaggio per PO dismessa.

    rom03 21/12/2018 Aggiunto campo num_po_sostituente

    rom02 08/11/2018 Cambiate diciture label; gestito il ritorno a coimaimp-sist-distribuz-gest
    rom02            in base alla funzione con cui vengo chiamato.

    rom01 03/09/2018 Aggiunto campo flag_sostituito
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="funzione_caller">    <!--rom02-->
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="cod_impianto">
<formwidget   id="url_list_aimp">
<formwidget   id="cod_pomp_circ_aimp">
<formwidget   id="url_aimp">

@link_tab;noquote@
@dett_tab;noquote@
<!--rom02 aggiunta variabile funzione_caller a tutte le url-->
<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=@func_i;noquote@>
       <a href="coimaimp-sist-distribuz-gest?@link_gest;noquote@&funzione=@funzione_caller;noquote@" class=@func_i;noquote@>Ritorna</a>
   </td>
   <if @funzione@ ne I>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimpomp-circ-aimp-gest?funzione=V&@link_gest;noquote@&funzione_caller=@funzione_caller;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimpomp-circ-aimp-gest?funzione=M&@link_gest;noquote@&funzione_caller=@funzione_caller;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimpomp-circ-aimp-gest?funzione=D&@link_gest;noquote@&funzione_caller=@funzione_caller;noquote@" class=@func_d;noquote@>Cancella</a>
      </td>
   </if>
   <else>
      <td width="25%" nowrap class=func-menu>Visualizza</td>
      <td width="25%" nowrap class=func-menu>Modifica</td>
      <td width="25%" nowrap class=func-menu>Cancella</td>
   </else>
</tr>
</table>

<table>
<tr><td valign=top align=right class=form_title>PO n.</td><!--rom02 Modificata dicitura da "Numero" a "PO n."-->
    <td valign=top><formwidget id="num_po"> &nbsp; @msg_pomp_dism;noquote@<!-- rom04 -->
        <formerror  id="num_po"><br>
        <span class="errori">@formerror.num_po;noquote@</span>
        </formerror>
    </td>
  <td></td>
  <td></td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Sostituito?</td><!--rom01 aggiunta td e contenuto-->
    <td valign=top><formwidget id="flag_sostituito">
        <formerror id="flag_sostituito"><br>
          <span class="errori">@formerror.flag_sostituito;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>PO Sostituente</td><!--rom03-->
    <td valign=top><formwidget id="num_po_sostituente">
	<formerror id="num_po_sostituente"><br>
	  <span class="errori">@formerror.num_po_sostituente;noquote@</span>
	</formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Data installazione</td>
    <td valign=top><formwidget id="data_installaz">
        <formerror  id="data_installaz"><br>
        <span class="errori">@formerror.data_installaz;noquote@</span>
        </formerror>
    </td>
  <td valign=top align=right class=form_title>Data dismissione</td>
  <td valign=top colspan=3><formwidget id="data_dismissione">
      <formerror  id="data_dismissione"><br>
        <span class="errori">@formerror.data_dismissione;noquote@</span>
      </formerror>
  </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Costruttore</td>
    <td valign=top><formwidget id="cod_cost">
        <formerror  id="cod_cost"><br>
        <span class="errori">@formerror.cod_cost;noquote@</span>
        </formerror>
    </td>

    <td valign=top align=right class=form_title>Modello</td>
    <td valign=top><formwidget id="modello">
        <formerror  id="modello"><br>
        <span class="errori">@formerror.modello;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Giri Variabili</td>
    <td valign=top><formwidget id="flag_giri_variabili">
        <formerror  id="flag_giri_variabili"><br>
        <span class="errori">@formerror.flag_giri_variabili;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Potenza Nominale (kW)</td>
    <td valign=top><formwidget id="pot_nom">
        <formerror  id="pot_nom"><br>
        <span class="errori">@formerror.pot_nom;noquote@</span>
        </formerror>
    </td>
</tr>   

<if @funzione@ ne "V">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>

</table>

</formtemplate>
<p>
</center>

