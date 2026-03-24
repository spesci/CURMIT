<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="cod_impianto">
<formwidget   id="url_list_aimp">
<formwidget   id="cons_prod_chimici_id">
<formwidget   id="url_aimp">

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=@func_i;noquote@>
       <a href="coimaimp-altre-schede-list?@link_gest;noquote@" class=@func_i;noquote@>Ritorna</a>
   </td>
   <if @funzione@ ne I>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimcons-prod-chimici-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimcons-prod-chimici-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimcons-prod-chimici-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
      </td>
   </if>
   <else>
      <td width="25%" nowrap class=func-menu>Visualizza</td>
      <td width="25%" nowrap class=func-menu>Modifica</td>
      <td width="25%" nowrap class=func-menu>Cancella</td>
   </else>
</tr>
</table>

<table width="80%">
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td align="center" class="func-menu-yellow2"><b>14.4 Consumo di prodotti chimici per il trattamento acqua del circuito dell'Impianto termico</b>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
  
<table>
<tr>
    <td valign=top align=right class=form_title>Esercizio</td>
    <td valign=top align=left><formwidget id="esercizio1">
    / <formwidget id="esercizio2">
        <formerror  id="esercizio1"><br>
        <span class="errori">@formerror.esercizio1;noquote@</span>
        </formerror>
    </td>

<tr>
  <td valign=top align=right class=form_title>Circuito impianto termico</td>
  <td valign=top><formwidget id="circ_imp_term">
      <formerror  id="circ_imp_term"><br>
        <span class="errori">@formerror.circ_imp_term;noquote@</span>
      </formerror>
  </td>
  <td valign=top align=right class=form_title>Circuito ACS</td>
  <td valign=top colspan=3><formwidget id="circ_acs">
    <formerror  id="circ_acs"><br>
      <span class="errori">@formerror.circ_acs;noquote@</span>
    </formerror>
  </td>
  <td valign=top align=right class=form_title>Altri circuiti ausiliari</td>
  <td valign=top><formwidget id="altri_circ_ausi">
    <formerror  id="altri_circ_ausi"><br>
      <span class="errori">@formerror.altri_circ_ausi;noquote@</span>
    </formerror>
  </td>
</tr>

<tr>
  <td valign=top align=right class=form_title>Nome prodotto</td>
  <td valign=top><formwidget id="nome_prodotto">
    <formerror  id="nome_prodotto"><br>
      <span class="errori">@formerror.nome_prodotto;noquote@</span>
    </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Quantit&agrave; consumata</td>
  <td valign=top><formwidget id="qta_cons">
    <formerror  id="qta_cons"><br>
      <span class="errori">@formerror.qta_cons;noquote@</span>
    </formerror>
   <td valign=top align=right class=form_title>Unit&agrave; di misura</td>
   <td valign=top><formwidget id="unita_misura">
     <formerror  id="unita_misura"><br>
       <span class="errori">@formerror.unita_misura;noquote@</span>
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

