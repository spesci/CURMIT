<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    gac02 13/07/2018 Aggiunto bottone in alto "Torna a Scheda 1.2: Ubicazione" solo per la
    gac02            Regione Marche.

    rom01 11/07/2018 Aggiunto bottone in alto "Passa a Scheda 1Bis: Dati Generali" solo per
    rom01            la Regione Marche.

    gac01 02/07/2018 Modificate label

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
<formwidget   id="last_cod_impianto">
<formwidget   id="cod_impianto">
<formwidget   id="cod_intestatario">
<formwidget   id="cod_proprietario">
<formwidget   id="cod_occupante">
<formwidget   id="cod_amministratore">
<formwidget   id="cod_terzi">
<formwidget   id="data_fin_valid">
<formwidget   id="url_list_aimp">
<formwidget   id="url_aimp">
<formwidget   id="dummy">
<formwidget   id="nome_funz_new">

<if @funzione@ ne D>
   <if @funzione@ ne M>
      <formwidget   id="data_ini_valid">
   </if>
</if>

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%" cellspacing=0  class=func-menu>
<tr>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
     <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimaimp-sogg?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimaimp-sogg?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=func-menu>
         <a href="coimrifs-list?@link_rife;noquote@" class=func-menu>Storico soggetti</a>
      </td>
   </else>
      <if @coimtgen.regione@ eq "MARCHE"> <!--rom01 aggiunta if e contenuto -->
        <td width="25%" nowrap class=@func_d;noquote@>
            <a href="coimaimp-ubic?funzione=V&@link_gest;noquote@" class=@func_d;noquote@>Torna a Scheda 1.2: Ubicazione</a><!--gac02-->
          </td>
	  <td width="25%" nowrap class=@func_d;noquote@>
            <a href="coim_as_resp-list?funzione=V&@link_scheda3;noquote@&nome_funz=asresp&nome_funz_caller=impianti" class=@func_d;noquote@>Passa a Scheda 3: Nomina Terzo Responsabile</a>
          </td>
      </if><!--rom01 -->
</tr>
</table>

<%=[iter_form_iniz]%>
<!-- Inizio della form colorata -->
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 1.6: Soggetti che operano sull'impianto</b></td></tr><!--gac01-->
<tr><td colspan=6>&nbsp;</td></tr>
 <tr><td valign=top align=right>Responsabile</td>

     <td valign=top colspan=2><formwidget id="flag_responsabile">
        <formerror id="flag_responsabile"><br>
        <span class="errori">@formerror.flag_responsabile;noquote@</span>
        </formerror>
    </td>
 </tr>

 <tr>
     <td>&nbsp;</td>
     <td valign=top align=left>Cognome 
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         &nbsp;&nbsp;&nbsp;
         Nome</td>
 </tr> 
 <tr><td valign=top align=right>@label_intestatario;noquote@</td>
     <td valign=top nowrap><formwidget id="cognome_inte">
        <valign=top><formwidget id="nome_inte"><if @funzione@ eq I or @funzione@ eq M>@cerca_inte;noquote@ | @ins_inte;noquote@</if>
        <if @funzione@ eq V>
           <td valign=top nowrap><formwidget id="cod_fiscale_inte">
        </if>
        <formerror id="cognome_inte"><br>
        <span class="errori">@formerror.cognome_inte;noquote@</span>
        </formerror>
     </td>
 </tr>


 <tr><td valign=top align=right>@label_proprietario;noquote@</td>
     <td valign=top nowrap><formwidget id="cognome_prop">
        <valign=top><formwidget id="nome_prop"><if @funzione@ eq I or @funzione@ eq M>@cerca_prop;noquote@ | @ins_prop;noquote@</if>
        <if @funzione@ eq V>
            <td valign=top nowrap><formwidget id="cod_fiscale_prop">
        </if>
        <formerror id="cognome_prop"><br>
        <span class="errori">@formerror.cognome_prop;noquote@</span>
        </formerror>
     </td>
</tr>
<tr>
     <td valign=top align=right>@label_occupante;noquote@</td>
     <td valign=top nowrap><formwidget id="cognome_occ">
        <valign=top><formwidget id="nome_occ"><if @funzione@ eq I or @funzione@ eq M>@cerca_occ;noquote@ | @ins_occ;noquote@</if>
        <if @funzione@ eq V>
            <td valign=top nowrap><formwidget id="cod_fiscale_occ">
        </if>
        <formerror  id="cognome_occ"><br>
        <span class="errori">@formerror.cognome_occ;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right>@label_amministratore;noquote@</td>
    <td valign=top nowrap><formwidget id="cognome_amm">
        <valign=top><formwidget id="nome_amm"><if @funzione@ eq I or @funzione@ eq M>@cerca_amm;noquote@ | @ins_amm;noquote@</if>
        <if @funzione@ eq V>
            <td valign=top nowrap><formwidget id="cod_fiscale_amm">
        </if>
        <formerror  id="cognome_amm"><br>
        <span class="errori">@formerror.cognome_amm;noquote@</span>
        </formerror>
    </td>
</tr><tr>
    <td valign=top align=right>@label_terzi;noquote@</td>
    <td valign=top nowrap><formwidget id="cognome_terzi">
        <valign=top><formwidget id="nome_terzi"><if @funzione@ eq I or @funzione@ eq M>@cerca_terzi;noquote@ | @ins_terzi;noquote@</if>
        <if @funzione@ eq V>
            <td valign=top nowrap><formwidget id="cod_fiscale_terzi">
        </if>
        <formerror  id="cognome_terzi"><br>
        <span class="errori">@formerror.cognome_terzi;noquote@</span>
        </formerror>
    </td>
</tr>

<if @dittamanut@ ne "">
   <tr>
        <td align=right>Ditta man. terzo resp.</td>  
        <td align=left>@dittamanut;noquote@</td>
   </tr>
</if>

<tr>
  <td>&nbsp;</td>
</tr>

<tr>
    <td valign=top align=right>Ultima variazione</td>
    <td valign=top nowrap><formwidget id="data_variaz">
       <formerror  id="data_variaz"><br>
       <span class="errori">@formerror.data_variaz;noquote@</span>
       </formerror>
    </td>
</tr>

<tr>
    <if @funzione@ ne V>
       <if @funzione@ ne I>
         <td valign=top align=right>Data inizio validit&agrave;</td>
         <td valign=top nowrap><formwidget id="data_ini_valid">
             <formerror  id="data_ini_valid"><br>
             <span class="errori">@formerror.data_ini_valid;noquote@</span>
             </formerror>
         </td>
       </if>
     </if>
</tr>


<tr><td colspan=2>&nbsp;</td></tr>
<if @funzione@ ne "V">
<tr>
    <td  colspan=3 align=center><table><tr>
    <td align=center><formwidget id="submit"></td>
    </tr></table></td> 
</tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

