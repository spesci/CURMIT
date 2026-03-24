<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom01 12/03/2024 Aggiunto filtro f_con_data_app

    nic01 22/06/2015 Sandro vuole che tutti gli utenti abbiano il filtro campagna, che venga
    nic01            prevalorizzato con la campagna aperta e che siano obbligati a sceglierne
    nic01            una.
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="dummy">
<formwidget   id="flag_cod_tecn">
<formwidget   id="flag_cod_enve">
<formwidget   id="f_cod_via">
<if @flag_cod_enve@ eq t>
    <formwidget id="f_cod_enve">
</if>

<if @flag_ente@ eq C>
   <formwidget id="f_cod_comune">
</if>

<table width=100% cellspacing=0 class=func-menu>

<br>
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr>
   <td align=right colspan=4><a href="#" onclick="javascript:window.open('coiminco-help', 'help', 'scrollbars=yes, resizable=yes, width=570, height=320').moveTo(110,140)"><b>Help</b></a>
    </td>
</tr>



<!-- dpr74 -->
<tr><td valign=top align=right class=form_title>Tipoologia impianti</td>
    <td valign=top colspan=2 nowrap><formwidget id="flag_tipo_impianto">
        <formerror id="flag_tipo_impianto"><br>
        <span class="errori">@formerror.flag_tipo_impianto;noquote@</span>
        </formerror>
    </td>
</tr>
<!-- dpr74 -->
<tr>
    <td valign=top align=right class=form_title>Data </td>
    <td valign=top colspan=3><formwidget id="f_tipo_data">
                             Da <formwidget id="f_da_data">
        <formerror  id="f_da_data"><br>
        <span class="errori">@formerror.f_da_data;noquote@</span>
        </formerror>
                             A <formwidget id="f_a_data">
        <formerror  id="f_a_data"><br>
        <span class="errori">@formerror.f_a_data;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Cod. impianto</td>
    <td valign=top colspan=3><formwidget id="f_cod_impianto">
        <formerror  id="f_cod_impianto"><br>
        <span class="errori">@formerror.f_cod_impianto;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Responsabile</td>
    <td valign=top colspan=3><formwidget id="f_resp_cogn">
                             <formwidget id="f_resp_nome">
        <formerror  id="f_resp_cogn"><br>
        <span class="errori">@formerror.f_resp_cogn;noquote@</span>
        </formerror>
</tr>

<!--nic01 if @flag_cod_tecn@ eq t -->
<tr><td valign=top align=right class=form_title>Campagna</td>
    <td valign=top colspan=3><formwidget id="f_campagna">
        <formerror  id="f_campagna"><br>
        <span class="errori">@formerror.f_campagna;noquote@</span>
        </formerror>
    </td>
</tr>
<!--nic01 /if -->

<tr><td valign=top align=right class=form_title>Criterio estrazione</td>
    <td valign=top colspan=3><formwidget id="f_tipo_estrazione">
        <formerror  id="f_tipo_estrazione"><br>
        <span class="errori">@formerror.f_tipo_estrazione;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top nowrap align=right class=form_title>Da Anno installazione</td>
    <td valign=top width="17%"><formwidget id="f_anno_inst_da">
        <formerror  id="f_anno_inst_da"><br>
        <span class="errori">@formerror.f_anno_inst_da;noquote@</span>
        </formerror>
    </td>
    <td valign=top width="15%" nowrap align=right class=form_title>Ad Anno installazione</td>
    <td valign=top><formwidget id="f_anno_inst_a">
        <formerror  id="f_anno_inst_a"><br>
        <span class="errori">@formerror.f_anno_inst_a;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Combustibile</td>
    <td valign=top colspan=3><formwidget id="f_cod_comb">
        <formerror  id="f_cod_comb"><br>
        <span class="errori">@formerror.f_cod_comb;noquote@</span>
        </formerror>
    </td>
</tr>

<if @nome_funz@ ne "inco-asse">
    <if @flag_cod_tecn@ ne t and @flag_cod_enve@ ne t>
    <tr><td valign=top align=right class=form_title>Ente Verificatore</td>
        <td valign=top colspan=3><formwidget id="f_cod_enve">
            <formerror  id="f_cod_enve"><br>
            <span class="errori">@formerror.f_cod_enve;noquote@</span>
            </formerror>
        </td>
    </tr>
    </if>
    <else>
    <tr><td valign=top align=right class=form_title>Ente Verificatore</td>
        <td valign=top colspan=3><formwidget id="desc_enve"></td>
    </tr>
    </else>
<tr>
    <td valign=top align=right class=form_title>Tecnico assegnato</td>
    <td valign=top colspan=3><formwidget id="f_cog_tecn">
                             <formwidget id="f_nom_tecn">@cerca_opve;noquote@
        <formerror  id="f_cog_tecn"><br>
        <span class="errori">@formerror.f_cog_tecn;noquote@</span>
        </formerror>
</tr>
</if>

<if @flag_ente@ eq "P">
    <tr><td valign=top align=right class=form_title>Comune</td>
       <td valign=top colspan=3><formwidget id="f_cod_comune">
           <formerror  id="f_cod_comune"><br>
           <span class="errori">@formerror.f_cod_comune;noquote@</span>
           </formerror>
       </td>
   </tr>
</if>

<tr><td valign=top align=right class=form_title>Indirizzo</td>
    <td valign=top colspan=3><formwidget id="f_descr_topo">
                             <formwidget id="f_descr_via">@cerca_viae;noquote@
        <formerror  id="f_descr_via"><br>
        <span class="errori">@formerror.f_descr_via;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Da civico a civico</td>
    <td valign=top colspan=3><formwidget id="f_civico_da">
                             <formwidget id="f_civico_a">
        <formerror  id="f_civico_da"><br>
        <span class="errori">@formerror.f_civico_da;noquote@</span>
        </formerror>
</tr>




<if @nome_funz@ eq "inco-cimp"
 or @nome_funz@ eq "incontro">

<tr><td valign=top align=right class=form_title>Stato</td>
    <td valign=top colspan=3><formwidget id="f_stato">
        <formerror  id="f_stato"><br>
        <span class="errori">@formerror.f_stato;noquote@</span>
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

</if>

<tr><td valign=top align=right class=form_title>Con data appuntamento?</td>
    <td valign=top colspan=3><formwidget id="f_con_data_app">
        <formerror  id="f_con_data_app"><br>
        <span class="errori">@formerror.f_con_data_app;noquote@</span>
        </formerror>
    </td>
</tr>


<if @flag_ente@ eq P>
    <tr><td valign=top align=right class=form_title>Area</td>
        <td valign=top colspan=3><formwidget id="f_cod_area">
            <formerror  id="f_cod_area"><br>
            <span class="errori">@formerror.f_cod_area;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>
<if @flag_ente@ eq P and @sigla_prov@ eq LI>
    <tr><td valign=top align=right class=form_title>Tipo estrazione</td>
        <td valign=top colspan=3><formwidget id="f_tipo_lettera">
            <formerror  id="f_tipo_lettera"><br>
            <span class="errori">@formerror.f_tipo_lettera;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>

<tr><td colspan=4>&nbsp;</td></tr>

<tr><td colspan=4 align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

