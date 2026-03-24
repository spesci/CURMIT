<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_cod_impianto">
<formwidget   id="cod_impianto">
<formwidget   id="cod_manutentore">
<formwidget   id="cod_installatore">
<formwidget   id="cod_progettista">
<formwidget   id="url_list_aimp">
<formwidget   id="url_aimp">

<if @funzione@ eq "V">
   <formwidget   id="data_ini_valid">
</if>

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%" cellspacing=0  class=func-menu>
<tr>
    <td width="25%" nowrap class=@func_d;noquote@>
       <a> &nbsp; </a>
    </td>
    <td width="25%" nowrap class=@func_v;noquote@>
       <a href="coimaimp-tecn?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
    </td>
    <td width="25%" nowrap class=@func_m;noquote@>
       <a href="coimaimp-tecn?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
    </td>
    <td width="25%" nowrap class=func-menu>
       <a href="coimrift-list?@link_rife;noquote@" class=func-menu>Storico tecnici</a>
    </td>
</tr>
</table>

<%=[iter_form_iniz]%>
<!-- Inizio della form colorata -->
    <tr>
        <td valign=top align=right class=form_title>Manutentore</td>
        <td valign=top><formwidget id="cognome_manu"><formwidget id="nome_manu">@cerca_manu;noquote@
            <formerror  id="cognome_manu"><br>
            <span class="errori">@formerror.cognome_manu;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr>
        <td valign=top align=right class=form_title>Installatore</td>
        <td valign=top ><formwidget id="cognome_inst"><formwidget id="nome_inst">@cerca_inst;noquote@
            <formerror  id="cognome_inst"><br>
            <span class="errori">@formerror.cognome_inst;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr>
        <td valign=top align=right class=form_title>Fornitore di energia termica </td>
        <td valign=top ><formwidget id="cod_distributore">
            <formerror  id="cod_distributore"><br>
            <span class="errori">@formerror.cod_distributore;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr>
        <td valign=top align=right class=form_title>Codice utenza termica</td>
        <td valign=top><formwidget id="cod_amag">
            <formerror  id="cod_amag"><br>
            <span class="errori">@formerror.cod_amag;noquote@</span>
            </formerror>
        </td>
    </tr>
<if @coimtgen.regione@ ne "MARCHE"> <!-- rom01 aggiunta if -->
    <tr>
        <td valign=top align=right class=form_title>PDR</td>
        <td valign=top><formwidget id="pdr">
            <formerror  id="pdr"><br>
            <span class="errori">@formerror.pdr;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>
    <tr>
        <td valign=top align=right class=form_title>Fornitore di energia elettrica </td>
        <td valign=top ><formwidget id="cod_distributore_el">
            <formerror  id="cod_distributore_el"><br>
            <span class="errori">@formerror.cod_distributore_el;noquote@</span>
            </formerror>
        </td>
    </tr>
<if @coimtgen.regione@ ne "MARCHE"> <!-- rom01 aggiunta if -->
    <tr>
        <td valign=top align=right class=form_title>POD</td>
        <td valign=top><formwidget id="pod">
            <formerror  id="pod"><br>
            <span class="errori">@formerror.pod;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>
    <tr>
        <td valign=top align=right class=form_title>Progettista</td>
        <td valign=top colspan=3><formwidget id="cognome_prog"><formwidget id="nome_prog">@cerca_prog;noquote@
            <formerror  id="cognome_prog"><br>
            <span class="errori">@formerror.cognome_prog;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr>
        <td valign=top align=right>Ultima variazione</td>
        <td valign=top nowrap ><formwidget id="data_variaz">
           <formerror  id="data_variaz"><br>
           <span class="errori">@formerror.data_variaz;noquote@</span>
           </formerror>
        </td>
    </tr>

    <tr>
    <if @funzione@ eq "M">
        <td valign=top align=right>Data inizio validit&agrave;</td>
        <td valign=top nowrap><formwidget id="data_ini_valid">
            <formerror  id="data_ini_valid"><br>
            <span class="errori">@formerror.data_ini_valid;noquote@</span>
            </formerror>
        </td>
    </if>
    </tr>

<tr><td colspan=2>&nbsp;</td></tr>
<if @funzione@ ne "V">
<tr>
    <td colspan=4 align=center>
       <formwidget id="submit"></td>
    </td> 
</tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

