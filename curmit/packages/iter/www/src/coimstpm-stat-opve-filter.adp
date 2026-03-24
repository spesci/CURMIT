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
<formwidget   id="dummy">
<formwidget   id="f_cod_tecn">
<if @flag_ente@ eq C>
    <formwidget id="f_cod_comune">
</if>
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<!-- dpr74 -->
<tr><td valign=top align=right class=form_title>Tipologia impianti</td>
    <td valign=top colspan=2 nowrap><formwidget id="flag_tipo_impianto">
        <formerror id="flag_tipo_impianto"><br>
        <span class="errori">@formerror.flag_tipo_impianto;noquote@</span>
        </formerror>
    </td>
</tr>
<!-- dpr74 -->

<tr><td valign=top align=right class=form_title>Da data controllo</td>
    <td valign=top><formwidget id="f_data_da">
        <formerror  id="f_data_da"><br>
        <span class="errori">@formerror.f_data_da;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>A data controllo</td>
    <td valign=top nowrap><formwidget id="f_data_a">
        <formerror  id="f_data_a"><br>
        <span class="errori">@formerror.f_data_a;noquote@</span>
        </formerror>
    </td>
</tr>

<if @flag_ente@ ne C>
    <tr><td valign=top align=right class=form_title>Comune</td>
        <td valign=top><formwidget id="f_cod_comune">
            <formerror  id="f_cod_comune"><br>
            <span class="errori">@formerror.f_cod_comune;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>

<tr><td valign=top align=right class=form_title>Fascia di Potenza</td>
    <td valign=top><formwidget id="cod_potenza">
        <formerror  id="cod_potenza"><br>
        <span class="errori">@formerror.cod_potenza;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Combustibile</td>
    <td valign=top><formwidget id="cod_combustibile">
        <formerror  id="cod_combustibile"><br>
        <span class="errori">@formerror.cod_combustibile;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Ente Verificatore</td>
    <td valign=top><formwidget id="f_cod_enve">
        <formerror  id="f_cod_enve"><br>
        <span class="errori">@formerror.f_cod_enve;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top nowrap align=right class=form_title>Tecnico assegnato</td>
    <td valign=top colspan=3><formwidget id="f_cog_tecn">
        <formwidget id="f_nom_tecn">@cerca_opve;noquote@
        <formerror  id="f_cog_tecn"><br>
        <span class="errori">@formerror.f_cog_tecn;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<if @funzione@ eq "V">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

