<!DOCTYPE html>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mat01 09/10/2025 Impostato readonly il campo stato per i manutentori

    rom04 07/06/2023 MEV "Impianti condominiali con pompa di calore": Resi visibili i campi Unita'
    rom04            immobiliari servite e Tipologia impianto.

    mic01 23/06/2022 Integrata la nota che fa riferimento al volume lordo raffrescato/riscaldato,
    	  	     come richiesto da Regione Marche.

    rom03 26/02/2019 Aggiunto * sul proprietaro che e' diventato un campo obbligatorio.
    
    gac02 18/12/2018 Aggiunti campi data_installaz e anno_costruzione

    rom02 17/12/2018 Aggiunti campi cognome_inst e nome_inst.

    gac01 13/07/2018 Aggiunto bottone in alto "Torna a Scheda 1: Dati tecnici" solo per 
    gac01            la Regione Marche

    rom01 11/07/2018 Aggiunto bottone in alto "Passa a Scheda 1.2: Ubicazione" solo per
    rom01            la Regione Marche.
    rom01.bis        aggiunto asterisco rosso dopo i campi obbligatori:
    rom01.bis        "cod_tpim"  "unita_immobiliari_servite" "pod" "pdr"
-->

<script type="text/javascript" src="../javascript/conferma_copia_impianto.js"></script>

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>


<!-- inizio sezione 1.6 -->

<center>
<formtemplate id="@form_name@">
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
         <a href="coimaimp-bis-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimaimp-bis-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=func-menu>
         <a href="coimrifs-list?@link_rife;noquote@" class=func-menu>Storico soggetti</a>
      </td>
   </else>
      <if @coimtgen.regione@ eq "MARCHE"> <!--rom01 aggiunta if e contenuto -->
	  <td width="25%" nowrap class=@func_d;noquote@>
            <a href="coimaimp-gest?funzione=V&@link_gest;noquote@" class=@func_d;noquote@>Torna a Scheda 1: Dati Tecnici</a><!--gac01-->
          </td>
        <td width="25%" nowrap class=@func_d;noquote@>
            <a href="coimaimp-ubic?funzione=V&@link_gest;noquote@" class=@func_d;noquote@>Passa a Scheda 1.2: Ubicazione</a><!--gac01-->
          </td>
      </if><!--rom01 -->
</tr>
</table>

<%=[iter_form_iniz]%>
<!-- Inizio della form colorata -->
<br><br>
<table width=60% border=0>
  <tr align=center><td colspan=4 class=func-menu-yellow2><b>Scheda 1.6: Soggetti che operano sull'impianto</b></td></tr><!--gac01-->
  <tr><td valign=top align=right>Responsabile</td>
    <td valign=top colspan=2><formwidget id="flag_responsabile">
        <formerror id="flag_responsabile"><br>
          <span class="errori">@formerror.flag_responsabile;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign=top align=left>Cognome</td>
    <td valign=top align=left>Nome</td>
    <if @funzione@ eq V> 
      <td valign=top align=left>Codice Fiscale</td>
      </if>
  </tr>
  <tr>
    <td valign=top align=left colspan=3 nowrap>
      <formerror id="cognome">
	<span class="errori">@formerror.cognome;noquote@</span>
      </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right>@label_proprietario;noquote@<font color="red">*</font></td><!--rom03 aggiunto *-->
    <td valign=top nowrap><formwidget id="cognome_prop"></td>
    <td valign=top nowrap><formwidget id="nome_prop">
	<if @funzione@ eq I or @funzione@ eq M>@cerca_prop;noquote@ | @ins_prop;noquote@</if>
	<formerror id="cognome_prop"><br>
	  <span class="errori">@formerror.cognome_prop;noquote@</span>
	</formerror>
    </td>
    <if @funzione@ eq V>
      <td valign=top nowrap><formwidget id="cod_fiscale_prop"></td>
    </if>
  </tr>
  <tr>
    <td valign=top align=right>@label_occupante;noquote@</td>
    <td valign=top nowrap><formwidget id="cognome_occ"></td>
    <td valign=top nowrap><formwidget id="nome_occ">
    <if @funzione@ eq I or @funzione@ eq M>@cerca_occ;noquote@ | @ins_occ;noquote@</if>
      <formerror  id="cognome_occ"><br>
	<span class="errori">@formerror.cognome_occ;noquote@</span>
      </formerror>
    </td>
    <if @funzione@ eq V>
      <td valign=top nowrap><formwidget id="cod_fiscale_occ"></td>
    </if>
  </tr>
  <tr>
    <td valign=top align=right>@label_amministratore;noquote@</td>
    <td valign=top nowrap><formwidget id="cognome_amm"></td>
    <td valign=top nowrap><formwidget id="nome_amm">
	<if @funzione@ eq I or @funzione@ eq M>@cerca_amm;noquote@ | @ins_amm;noquote@</if>
	<formerror  id="cognome_amm"><br>
	  <span class="errori">@formerror.cognome_amm;noquote@</span>
	</formerror>
    </td>
    <if @funzione@ eq V>
      <td valign=top nowrap><formwidget id="cod_fiscale_amm"></td>
    </if>
  </tr>
  <tr>
    <td valign=top align=right>@label_terzi;noquote@</td>
    <td valign=top nowrap><formwidget id="cognome_terzi"></td>
    <td valign=top nowrap><formwidget id="nome_terzi">
    <if @funzione@ eq I or @funzione@ eq M>@cerca_terzi;noquote@ | @mod_terzi;noquote@ @ins_terzi;noquote@</if>
      <formerror  id="cognome_terzi"><br>
	<span class="errori">@formerror.cognome_terzi;noquote@</span>
      </formerror>
    </td>
    <if @funzione@ eq V>
      <td valign=top nowrap><formwidget id="cod_fiscale_terzi"></td>
    </if>
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
  
</table>


<!-- fine sezione 1.6 -->

<center>
  <formwidget   id="cod_cittadino">
    
    <table border=0>
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 1bis: Dati Generali</b></td></tr>
<tr>
  <td valign=top align=right nowrap class=form_title>PDR @ast_pdr;noquote@</td>
  <td valign=top><formwidget id="pdr">
      <formerror  id="pdr"><br>
        <span class="errori">@formerror.pdr;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>POD <font color=red>*</font></td>
    <td valign=top><formwidget id="pod">
        <formerror  id="pod"><br>
        <span class="errori">@formerror.pod;noquote@</span>
        </formerror>
    </td>
</tr>
<!--rom03 commento i campi del responsabile dell'impianto che non mi servono più qua 
<tr><td colspan=6 class=func-menu-yellow2><b>Responsabile d'impianto</b></td></tr>
<tr>
    <td valign=top align=right nowrap class=form_title>Tipo persona</td>
    <td class=form_title><formwidget id="natura_giuridica">
        <formerror  id="natura_giuridica"><br>
        <span class="errori">@formerror.natura_giuridica;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Ruolo</td>
    <td valign=top class=form_title><formwidget id="flag_resp">
        <formerror  id="flag_resp"><br>
        <span class="errori">@formerror.flag_resp;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right nowrap class=form_title>Nome</td>
    <td valign=top><formwidget id="nome">
        <formerror  id="nome"><br>
        <span class="errori">@formerror.nome;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Cognome</td>
    <td valign=top><formwidget id="cognome"><if @funzione@ eq I or @funzione@ eq M>@mod_prop;noquote@</if>
        <formerror  id="cognome"><br>
        <span class="errori">@formerror.cognome;noquote@</span>
        </formerror>
    </td>
</tr>
-->
<!-- rom04 Tolta if  @flag_tipo_impianto@ ne "F"-->
<tr>
    <td valign=top align=right nowrap class=form_title>Tipologia impianto <font color=red>*</font></td>
    <td valign=top><formwidget id="cod_tpim">
        <formerror  id="cod_tpim"><br>
        <span class="errori">@formerror.cod_tpim;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Unità immobiliari servite <font color=red>*</font></td>
    <td valign=top><formwidget id="unita_immobiliari_servite">
        <formerror  id="unita_immobiliari_servite"><br>
        <span class="errori">@formerror.unita_immobiliari_servite;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
  <!--non vogliono più vedere il campo
  <td valign=top align=right class=form_title>Data di costruzione dell'impianto<font color=red>*</font></td><!--gac0
    <td valign=top><formwidget id="anno_costruzione">
        <formerror  id="anno_costruzione"><br>
        <span class="errori">@formerror.anno_costruzione;noquote@</span>
        </formerror>
    </td> 
    -->
    <td valign=top align=right class=form_title>Data di installazione dell'Impianto<font color=red>*</font></td><!--gac02-->
    <td valign=top><formwidget id="data_installaz">
        <formerror  id="data_installaz"><br>
        <span class="errori">@formerror.data_installaz;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
  <if @flag_tipo_impianto@ ne "F">
     <td valign=top align=right class=form_title>Volume lordo riscaldato</td>
     <td valign=top><formwidget id="volimetria_risc">
      <formerror  id="volimetria_risc"><br>
       <span class="errori">@formerror.volimetria_risc;noquote@</span>
      </formerror>
     </td>
  </if><else>
     <td valign=top align=right class=form_title>Volume lordo raffrescato</td>
     <td valign=top><formwidget id="volimetria_raff">
      <formerror  id="volimetria_raff"><br>
      <span class="errori">@formerror.volimetria_raff;noquote@</span>
      </formerror>
    </td>
  </else>				    
</tr>
<tr>
  <td>&nbsp;</td>
  <td valign=top colspan=5><i>Riportare il volume lordo @nota_volimetria_risc;noquote@ dell'intero sistema edificio-impianto (non solo quello relativo al presente impianto).<br> N.B.: se ci sono più impianti nello stesso libretto, il dato va inserito in un solo codice impianto.</i><!-- mic01 Integrata nota come richiesto da Giuliodori.-->
  </td>
  </tr>
<tr>
    <td valign=top align=right class=form_title>Data dismissione/Disattivazione</td>
    <td valign=top><formwidget id="data_rottamaz">
        <formerror  id="data_rottamaz"><br>
        <span class="errori">@formerror.data_rottamaz;noquote@</span>
        </formerror>
    </td>
    <td valign=top nowrap align=right class=form_title>Data dell'eventuale<br> riattivazione</td><!--gac03-->
    <td valign=top><formwidget id="data_attivaz">
        <formerror  id="data_attivaz"><br>
        <span class="errori">@formerror.data_attivaz;noquote@</span>
        </formerror>
    </td>
</tr>
<if @cod_manutentore@ eq ""><!-- mat01 Aggiunta if ma non il contenuto -->
  <tr>
    <td valign=top align=right class=form_title>Stato</td>
    <td valign=top colspan=3>
      <table width=100%>
        <tr>
          <td valign=top width=5% bgcolor=@color;noquote@ bordercolor=000000>&nbsp;</td>
          <td valign=top width=95%><formwidget id="stato">
              <formerror  id="stato"><br>
		<span class="errori">@formerror.stato;noquote@</span>
              </formerror>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</if>
<else><!-- mat01 Aggiunta else e il suo contenuto -->
  <tr>
    <td valign=top align=right class=form_title>Stato</td>
    <td valign=top colspan=3>
      <table width=100%>
        <tr>
          <td valign="top" width="5%" bgcolor=@color;noquote@ bordercolor=000000>&nbsp;</td>
          <td valign="top" width="95%" ><formwidget id="stato_edit">
              <formerror  id="stato_edit"><br>
		<span class="errori">@formerror.stato_edit;noquote@</span>
              </formerror>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</else>

<tr><td colspan=6 class=fotm_title align=left><b>@label_intestatario;noquote@</b></td></tr>
<tr>
    <td valign=top align=right nowrap class=form_title>Nome</td>
    <td valign=top><formwidget id="nome_inte">
        <formerror  id="nome_inte"><br>
        <span class="errori">@formerror.nome_inte;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Cognome</td>
    <td valign=top><formwidget id="cognome_inte"><if @funzione@ eq I or @funzione@ eq M><br>@cerca_inte;noquote@ | @mod_inte;noquote@</if>
        <formerror  id="cognome_inte"><br>
        <span class="errori">@formerror.cognome_inte;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td colspan=6>&nbsp;</td></tr>
<tr><td colspan=6 class=fotm_title align=left><b>Ulteriori dati dell'Impianto:</b></td></tr>
<tr><td colspan=6 class=fotm_title align=left><b>Conduttore</b></td></tr>
<tr>
    <td valign=top align=right nowrap class=form_title>Nome</td>
    <td valign=top><formwidget id="nome_condu">
        <formerror  id="nome_condu"><br>
        <span class="errori">@formerror.nome_condu;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Cognome</td>
    <td valign=top><formwidget id="cognome_condu"><if @funzione@ eq I or @funzione@ eq M><br>@cerca_cod_condu;noquote@|@ins_cod_condu;noquote@</if>
        <formerror  id="cognome_condu"><br>
        <span class="errori">@formerror.cognome_condu;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
  <td colspan=6 class=fotm_title align=left><b>Installatore iniziale</b></td></tr><!--rom02-->
<tr>
  <td valign=top align=right nowrap class=form_title>Nome</td><!--rom02-->
  <td valign=top><formwidget id="nome_inst">
      <formerror  id="nome_inst">
	<span class="errori">@formerror.nome_inst;noquote@</span>
      </formerror>
  </td>
  <td valign=top align=right nowrap class=form_title>Cognome</td><!--rom02-->
  <td valign=top><formwidget id="cognome_inst">
	<formerror  id="cognome_inst">
	  <span class="errori">@formerror.cognome_inst;noquote@</span>
	</formerror>
  </td>
</tr>
<tr><td colspan=6>&nbsp;</td></tr>
<if @coimtgen.regione@ eq "MARCHE"><!--rom06 aggiunta if-->
  <tr>
    <td valign=top align=right nowrap class=form_title><b>Presenza dell'attestato APE<b></td><!--gac03 -->
    <td valign=top><formwidget id="pres_certificazione">
        <formerror  id="pres_certificazione"><br>
          <span class="errori">@formerror.pres_certificazione;noquote@</span>
        </formerror>
    </td>
    
    <td valign=top align=right nowrap class=form_title><b>Codice identificativo dell'APE</b></td>
    <td valign=top><formwidget id="certificazione">
        <formerror  id="certificazione"><br>
          <span class="errori">@formerror.certificazione;noquote@</span>
        </formerror>
    </td>
  </tr>
</if><!--rom06-->
<tr>
  <td colspan=8 align=center>@link_generatori;noquote@</td>
</tr>

<if @funzione@ ne "V">
<tr>
    <td colspan=8 align=center><br><formwidget id="submit"></td>
</tr>
</if>

<!-- Fine della form colorata -->
</table>



</formtemplate>



<p>
</center>

