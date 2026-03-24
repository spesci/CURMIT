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
<formwidget   id="cons_comb_id">
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
         <a href="coimcons-comb-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimcons-comb-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="coimcons-comb-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
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
    <td align="center" class="func-menu-yellow2"><b>14.1 Consumo di combustibile nel circuito dell'Impianto termico</b>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
  
<table>
<tr>
    <td valign=top align=right class=form_title>Esercizio</td>
    <td valign=top align=left><formwidget id="esercizio">
        <formerror  id="esercizio"><br>
        <span class="errori">@formerror.esercizio;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Acquisti</td>
    <td valign=top align=left><formwidget id="acquisti">
        <formerror  id="acquisti"><br>
        <span class="errori">@formerror.acquisti;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Lettura Iniziale</td>
  <td valign=top><formwidget id="lett_iniziale">
      <formerror  id="lett_iniziale"><br>
        <span class="errori">@formerror.lett_iniziale;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Lettura finale</td>
  <td valign=top><formwidget id="lett_finale">
    <formerror  id="lett_finale"><br>
      <span class="errori">@formerror.lett_finale;noquote@</span>
    </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Consumo totale</td>
  <td valign=top><formwidget id="consumo_tot">
    <formerror  id="consumo_tot"><br>
      <span class="errori">@formerror.consumo_tot;noquote@</span>
    </formerror>
  </td>
</tr>

<if @funzione@ ne "V">
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><td colspan=2 align=center><formwidget id="submit"></td></tr>
</if>

</table>

</formtemplate>
<p>
</center>

