<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="flag_cod_tecn">
<formwidget   id="flag_cod_enve">
<if @flag_cod_enve@ eq t>
    <formwidget id="cod_enve">
</if>
<if @flag_cod_tecn@ eq t>
    <formwidget id="cod_opve">
</if>
<if @flag_ente@ eq C>
    <formwidget id="cod_comune">
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
<tr><td valign=top width="45%" align=right class=form_title>Campagna di controllo</td>
    <td valign=top width="55%" colspan=3><formwidget id="cod_cinc">
        <formerror  id="cod_cinc"><br>
        <span class="errori">@formerror.cod_cinc;noquote@</span>
        </formerror>
    </td>
</tr>
<if @flag_ente@ eq P>
<tr><td valign=top align=right class=form_title>Comune</td>
    <td valign=top colspan=3><formwidget id="cod_comune">
        <formerror  id="cod_comune"><br>
        <span class="errori">@formerror.cod_comune;noquote@</span>
        </formerror>
    </td>
</if>



<if @flag_cod_enve@ ne t or @flag_cod_tecn@ ne t and @flag_cod_enve@ ne t>
    <tr><td valign=top align=right class=form_title>Ente verificatore</td>
        <td valign=top colspan=3><formwidget id="cod_enve">
            <formerror  id="cod_enve"><br>
            <span class="errori">@formerror.cod_enve;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>
<if @flag_cod_tecn@ ne t >
    <tr><td valign=top align=right class=form_title>Ispettore</td>
        <td valign=top colspan=3><formwidget id="cod_opve">
            <formerror  id="cod_opve"><br>
            <span class="errori">@formerror.cod_opve;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>
<tr><td valign=top align=right class=form_title>Stato appuntamenti</td>
    <td valign=top colspan=3><formwidget id="flag_stato_appuntamento">
        <formerror  id="flag_stato_appuntamento"><br>
        <span class="errori">@formerror.flag_stato_appuntamento;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Motivo annullamento</td>
    <td valign=top colspan=3><formwidget id="f_cod_noin">
        <formerror  id="f_cod_noin"><br>
        <span class="errori">@formerror.f_cod_noin;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Da data appuntamento</td>
    <td valign=top colspan=1><formwidget id="da_data_app">
        <formerror  id="da_data_app"><br>
        <span class="errori">@formerror.da_data_app;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>A data appuntamento</td>
    <td valign=top colspan=1><formwidget id="a_data_app">
        <formerror  id="a_data_app"><br>
        <span class="errori">@formerror.a_data_app;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Da data spedizione</td>
    <td valign=top colspan=1><formwidget id="da_data_spe">
        <formerror  id="da_data_spe"><br>
        <span class="errori">@formerror.da_data_spe;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>A data spedizione</td>
    <td valign=top colspan=1><formwidget id="a_data_spe">
        <formerror  id="a_data_spe"><br>
        <span class="errori">@formerror.a_data_spe;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title>Area</td>
    <td valign=top colspan=1><formwidget id="cod_area">
        <formerror  id="cod_area"><br>
        <span class="errori">@formerror.cod_area;noquote@</span>
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

