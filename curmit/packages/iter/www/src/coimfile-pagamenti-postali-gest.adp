<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href="coimfile-pagamenti-postali-list?@link_list;noquote@" class=func-menu>Ritorna</a>
   </td>
   <td width="75%" nowrap class=@func_m;noquote@>
      &nbsp;
   </td>
</tr>
</table>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_cod_file">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<if @flag_elaborazione_terminata@ eq "N">
    <tr><td colspan=2>&nbsp;</td></tr>

    <tr>
	<td valign=top align=right class=form_title>File da importare</td>
	<td valign=top align=left><formwidget id="file_name">
	    <formerror  id="file_name"><br>
	    <span class="errori">@formerror.file_name;noquote@</span>
	    </formerror>
	</td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>

    <if @funzione@ ne "V">
    	<tr><td colspan=2 align=center><formwidget id="submit"></td></tr>
    </if>
</if>
<else>
    <tr><td colspan=5>&nbsp;</td></tr>

    <tr>
        <td valign=top class=form_title align=center colspan=5><b>ELABORAZIONE TERMINATA</b></td>
    </tr>

    <tr>
        <td valign=top class=form_title align=right>Letti Pagamenti:</td>
        <td valign=top class=form_title align=right>@ctr_inp;noquote@</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td valign=top class=form_title align=left>Euro @totale_letti_pretty;noquote@</td>
    </tr>

    <tr><td colspan=5>&nbsp;</td></tr>

    <tr>
        <td valign=top class=form_title align=right width="40%">Caricati Pagamenti:</td>
        <td valign=top class=form_title align=right width="5%">@ctr_out;noquote@</td>
        <td valign=top class=form_title align=right width="5%">&nbsp;</td>
        <td valign=top class=form_title width=30%><a target="Valori caricati" href="@file_out_url;noquote@">Scarica CSV dei pagamenti caricati</a></td>
        <td valign=top class=form_title align=left">Euro @totale_pagato_pretty;noquote@</td>
    </tr>

    <tr>
        <td valign=top class=form_title align=right>Scartati Pagamenti:</td>
        <td valign=top class=form_title align=right>@ctr_err;noquote@</td>
        <td valign=top class=form_title align=right width="5%">&nbsp;</td>
        <td valign=top class=form_title><a target="Valori scartati" href="@file_err_url;noquote@">Scarica CSV dei pagamenti non caricati</a></td>
        <td valign=top class=form_title align=left>Euro @totale_scartato_pretty;noquote@</td>
    </tr>

    <multiple name=multiple_scarti>
    <tr>
        <td valign=top class=form_title align=right>&nbsp;&nbsp;&nbsp;Per @multiple_scarti.motivo_scarto@:</td>
	<td valign=top class=form_title align=right>@multiple_scarti.ctr_scarto@</td>
        <td colspan=3>&nbsp;</td>
    </tr>
    </multiple>
</else>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>


