<!DOCTYPE html>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 29/09/2025 Aggiunto filtro ditta di manutenzione presente/assente (punto 33 MEV regione Marche 2025)

    but01 28/11/2024 Aggiunto il filtro per ditta manutenzione.
    
    rom01 19/03/2019 Aggiunti filtri per tipo_generatore, sistema_areazione e tipo_locale.

    san01 19/07/2016 Aggiunto filtro per cod_zona.
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="dummy">
<formwidget   id="f_cod_via">
<formwidget   id="f_cod_manu">

<if @flag_ente@ eq C>
   <formwidget id="cod_comune">
</if>

<table width="100%" cellspacing=0 class=func-menu>
    <tr>
        <td width="25%" class=func-menu>
           &nbsp;
        </td>
        <td width="50%" class=func-menu align=center>
            Campagna: <b>@desc_camp;noquote@</b>
        </td>
        <td width="25%" class=func-menu>
           &nbsp;
        </td>
    </tr>
</table>
<br>
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<!-- dpr74 -->
<tr><td valign=top align=right class=form_title>Tipologia impianti <font color=red>*</font></td>
    <td valign=top colspan=2 nowrap><formwidget id="flag_tipo_impianto">
        <formerror id="flag_tipo_impianto"><br>
        <span class="errori">@formerror.flag_tipo_impianto;noquote@</span>
        </formerror>
    </td>
</tr>
<!-- dpr74 -->
<tr><td valign=top align=right class=form_title>Tipo estrazione <font color=red>*</font></td>
    <td valign=top colspan=2 nowrap><formwidget id="tipo_estrazione">
        <formerror id="tipo_estrazione"><br>
        <span class="errori">@formerror.tipo_estrazione;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right class=form_title nowrap>Con dichiarazione scaduta</td>
    <td valign=top colspan=1 nowrap><formwidget id="flag_scaduto">
        <formerror id="flag_scaduto"><br>
        <span class="errori">@formerror.flag_scaduto;noquote@</span>
        </formerror>
</td>
   <td valign=top align=right class=form_title nowrap>Fino al</td>
    <td valign=top colspan=2 nowrap><formwidget id="data_scad">
        <formerror id="data_scad"><br>
        <span class="errori">@formerror.data_scad;noquote@</span>
        </formerror>
    </td>

</tr>
<tr><td valign=top align=right class=form_title width="30%">Da anno installazione</td>
    <td valign=top width="15%"><formwidget id="anno_inst_da">
        <formerror  id="anno_inst_da"><br>
        <span class="errori">@formerror.anno_inst_da;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title width="20%" nowrap>A anno installazione</td>
    <td valign=top width="35%"><formwidget id="anno_inst_a">
        <formerror  id="anno_inst_a"><br>
        <span class="errori">@formerror.anno_inst_a;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>Combustibile</td>
    <td valign=top colspan=3 nowrap><formwidget id="cod_combustibile">
        <formerror id="cod_combustibile"><br>
        <span class="errori">@formerror.cod_combustibile;noquote@</span>
        </formerror>
    </td>
</tr>

<if @flag_ente@ eq P>
   <tr><td valign=top align=right class=form_title>Comune</td>
       <td valign=top colspan=3 nowrap><formwidget id="cod_comune">
           <formerror  id="cod_comune"><br>
           <span class="errori">@formerror.cod_comune;noquote@</span>
           </formerror>
       </td>
   </tr>
</if>

<tr><td valign=top align=right class=form_title>Zona</td>
    <td valign=top colspan=3><formwidget id="cod_zona">
       <formerror  id="cod_zona"><br>
       <span class="errori">@formerror.cod_zona;noquote@</span>
       </formerror>
    </td>
</tr><!--san01: aggiunto tutto il tr -->

<tr><td valign=top align=right class=form_title>Indirizzo</td>
    <td valign=top colspan=3 nowrap><formwidget id="descr_topo">
        <formwidget id="descr_via">@cerca_viae;noquote@
        <formerror  id="descr_via"><br>
        <span class="errori">@formerror.descr_via;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><!-- but01 Aggiunta riga e contenuto -->
  <td>&nbsp;</td>
  <td valign=top nowrap align=left class=form_title><b>Ricerca per manutentore</b></td>
</tr>
<tr><!-- but01 Aggiunta riga e contenuto -->
  <td valign=top align=right class=form_title>Cognome</td>
  <td valign=top nowrap colspan=3><formwidget id="f_manu_cogn">
    <formerror  id="f_manu_cogn"><br>
    <span class="errori">@formerror.f_manu_cogn;noquote@</span>
    </formerror>
  Nome&nbsp;<formwidget id="f_manu_nome">@cerca_manu;noquote@
    <formerror  id="f_manu_nome"><br>
    <span class="errori">@formerror.f_manu_nome;noquote@</span>
    </formerror>
  </td>
</tr>
<tr><td> &nbsp;</td></tr><!--but01-->

<tr><td valign=top align=right class=form_title nowrap>Numero max di imp. da estr. <font color=red>*</font></td>
    <td valign=top colspan=3><formwidget id="num_max">
        <formerror  id="num_max"><br>
        <span class="errori">@formerror.num_max;noquote@</span>
        </formerror>
    </td>
</tr>

<if @flag_ente@ eq P and @sigla_prov@ ne TN>
    <tr><td valign=top align=right class=form_title>Area</td>
        <td valign=top colspan=3><formwidget id="cod_area">
            <formerror  id="cod_area"><br>
            <span class="errori">@formerror.cod_area;noquote@</span>
            </formerror>
        </td>
    </tr>
</if>

<tr><td colspan=4>&nbsp;</td></tr>


<if @tipo_estrazione@ eq 8>
           <tr><td valign=top align=right class=form_title>Annullamento</td>
               <td valign=top colspan=3><formwidget id="cod_noin">
                   <formerror  id="cod_noin"><br>
                   <span class="errori">@formerror.cod_noin;noquote@</span>
                   </formerror>
               </td>
           </tr>
</if>

<if @tipo_estrazione@ eq 10>
           <tr><td valign=top align=right class=form_title>Annullamento</td>
               <td valign=top colspan=3><formwidget id="cod_noin">
                   <formerror  id="cod_noin"><br>
                   <span class="errori">@formerror.cod_noin;noquote@</span>
                   </formerror>
               </td>
           </tr>
</if>


<if @tipo_estrazione@ eq 1 or @tipo_estrazione@ eq 3 or @tipo_estrazione@ eq 11 or @tipo_estrazione@ eq 12 or @tipo_estrazione@ eq 18 or @tipo_estrazione@ eq 15 or @tipo_estrazione@ eq 16 or @tipo_estrazione@ nil>

           <tr><td valign=top align=right class=form_title>Anomalia</td>
               <td valign=top colspan=3><formwidget id="cod_anom">
                   <formerror  id="cod_anom"><br>
                   <span class="errori">@formerror.cod_anom;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Con osservazioni</td>
               <td valign=top colspan=3><formwidget id="flag_oss">
                   <formerror  id="flag_oss"><br>
                   <span class="errori">@formerror.flag_oss;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Con raccomandazioni</td>
               <td valign=top  colspan=3><formwidget id="flag_racc">
                   <formerror  id="flag_racc"><br>
                   <span class="errori">@formerror.flag_racc;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Con prescrizioni</td>
               <td valign=top colspan=3><formwidget id="flag_pres">
                   <formerror  id="flag_pres"><br>
                   <span class="errori">@formerror.flag_pres;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>L'impianto pu&ograve; funzionare</td>
               <td valign=top colspan=3><formwidget id="flag_status">
                   <formerror  id="flag_status"><br>
                   <span class="errori">@formerror.flag_status;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Bacharach > di</td>
               <td valign=top colspan=3><formwidget id="bacharach">
                   <formerror  id="bacharach"><br>
                   <span class="errori">@formerror.bacharach;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Co > di</td>
               <td valign=top colspan=3><formwidget id="co">
                   <formerror  id="co"><br>
                   <span class="errori">@formerror.co;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Rend. combust. < di</td>
               <td valign=top colspan=3><formwidget id="rend_combust">
                   <formerror  id="rend_combust"><br>
                   <span class="errori">@formerror.rend_combust;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Tiraggio > di</td>
               <td valign=top colspan=3><formwidget id="tiraggio">
                   <formerror  id="tiraggio"><br>
                   <span class="errori">@formerror.tiraggio;noquote@</span>
                   </formerror>
               </td>
           </tr>
	   <!--rom02 inizio-->
	   <tr><td valign=top align=right class=form_title>Camera di combustione</td>
	     <td valign=top colpan=3><formwidget id="tipo_generatore">
		 <formerror id="tipo_generatore"><br>
		   <span class="errori">@formerror.tipo_generatore;noquote@</span>
		   </formerror>
	     </td>
	   </tr>
	   <tr><td valign=top align=right class=form_title>Evacuazione fumi</td>
	     <td valign=top colpan=3><formwidget id="sistema_areazione">
		 <formerror id="sistema_areazione"><br>
		   <span class="errori">@formerror.sistema_areazione;noquote@</span>
		 </formerror>
	     </td>
	   </tr>
	   <tr><td valign=top align=right class=form_title>Tipo locale</td>
	     <td valign=top colpan=3><formwidget id="tipo_locale">
		 <formerror id="tipo_locale">
		   <span class="errori">@formerror.tipo_locale;noquote@</span>
		   </formerror>
	     </td>
	   </tr>
	   <!--rom02 fine-->

           <if @flag_cind@ eq "T"> 
           <tr><td valign=top align=right class=form_title>Escludi impianti campagna</td>
               <td valign=top colspan=3 nowrap><formwidget id="cod_cind">
                   <formerror id="cod_cind"><br>
                   <span class="errori">@formerror.cod_cind;noquote@</span>
                   </formerror>
               </td>
           </tr>
           </if> 
</if>

<if @flag_pesi@ eq S>
<if @tipo_estrazione@ eq 7>
           <tr><td valign=top align=right class=form_title>Tipologia peso</td>
               <td valign=top colspan=3><formwidget id="cod_raggruppamento">
                   <formerror  id="cod_raggruppamento"><br>
                   <span class="errori">@formerror.cod_raggruppamento;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Somma di pesi > di</td>
               <td valign=top colspan=3><formwidget id="peso_min">
                   <formerror  id="peso_min"><br>
                   <span class="errori">@formerror.peso_min;noquote@</span>
                   </formerror>
               </td>
           </tr>
           <tr><td valign=top align=right class=form_title>Numero segnalazioni > di</td>
               <td valign=top colspan=3><formwidget id="n_anomalie">
                   <formerror  id="n_anomalie"><br>
                   <span class="errori">@formerror.n_anomalie;noquote@</span>
                   </formerror>
               </td>
           </tr>
</if>
</if>
<if @coimtgen.regione@ eq "MARCHE"> <!--ric01 aggiunta if e contenuto -->
  <tr>
     <td valign=top align=right class=form_title>Ditta di manutenzione</td>
     <td valign=top colpan=3><formwidget id="f_manu_present_p">
	 <formerror id="f_manu_present_p">
	   <span class="errori">@formerror.f_manu_present_p;noquote@</span>
	 </formerror>
     </td>
   </tr>
</if>

<tr><td colspan=4>&nbsp;</td></tr>

<tr><td colspan=4 align=center><formwidget id="submitbut"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

