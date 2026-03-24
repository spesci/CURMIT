<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>


<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget id="f_cod_comune">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<if @flag_ente@ eq P>
    <tr>
        <td valign=top align=right class=form_title>Comune</td>
        <td valign=top colspan=3><formwidget id="comune">@link_comune;noquote@
            <formerror  id="comune"><br>
            <span class="errori">@formerror.comune;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>

<!-- dpr74 -->
<tr><td valign=top align=right class=form_title>Tipoologia impianti</td>
    <td valign=top colspan=2 nowrap><formwidget id="flag_tipo_impianto">
        <formerror id="flag_tipo_impianto"><br>
        <span class="errori">@formerror.flag_tipo_impianto;noquote@</span>
        </formerror>
    </td>
</tr>
<!-- dpr74 -->

<tr><td valign=top align=right class=form_title>Tipologia</td>
    <td valign=top colspan=1><formwidget id="f_tipologia">
        <formerror  id="f_tipologia"><br>
        <span class="errori">@formerror.f_tipologia;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Attivit&agrave;</td>
    <td valign=top><formwidget id="f_evaso">
        <formerror id="f_evaso"><br>
        <span class="errori">@formerror.f_evaso;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Da data occorrenza</td>
    <td valign=top><formwidget id="f_data_evas_da">
        <formerror id="f_data_evas_da"><br>
        <span class="errori">@formerror.f_data_evas_da;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>A data occorrenza</td>
    <td valign=top><formwidget id="f_data_evas_a">
        <formerror id="f_data_evas_a"><br>
        <span class="errori">@formerror.f_data_evas_a;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Da data controllo</td>
    <td valign=top><formwidget id="f_data_controllo_da">
        <formerror id="f_data_controllo_da"><br>
        <span class="errori">@formerror.f_data_controllo_da;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>A data controllo</td>
    <td valign=top><formwidget id="f_data_controllo_a">
        <formerror id="f_data_controllo_a"><br>
        <span class="errori">@formerror.f_data_controllo_a;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Da potenza (kW)</td>
    <td valign=top><formwidget id="f_potenza_da">
        <formerror id="f_potenza_da"><br>
        <span class="errori">@formerror.f_potenza_da;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>A potenza (kW)</td>
    <td valign=top><formwidget id="f_potenza_a">
        <formerror id="f_potenza_a"><br>
        <span class="errori">@formerror.f_potenza_a;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Combustibile</td>
    <td valign=top><formwidget id="f_cod_combustibile">
        <formerror id="f_cod_combustibile"><br>
        <span class="errori">@formerror.f_cod_combustibile;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Tipologia impianto</td>
    <td valign=top><formwidget id="f_cod_tpim">
        <formerror id="f_cod_tpim"><br>
        <span class="errori">@formerror.f_cod_tpim;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Ente verificatore</td>
    <td valign=top><formwidget id="f_enve">
        <formerror id="f_enve"><br>
        <span class="errori">@formerror.f_enve;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<tr><td colspan=4 align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

