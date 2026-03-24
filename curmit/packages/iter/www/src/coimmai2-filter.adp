<!--
    USER  DATA       MODIFICHE
    ===== ========== =================================================================================
    ric02 09/09/2025 Aggiunto campo f_cod_fiscale solo per regione Marche (punto 28 MEV).
    
    ric01 16/03/2023 Aggiunto campo f_targa solo se gestito dall'ente (flag_gest_targa).
    ric01            Al momento le Marche e Friuli non vedono la modifica. 

    rom01 21/06/2018 Agguinto campo f_numero_bollino

-->


<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="f_cod_via">
<formwidget   id="dummy">
<if @flag_ente@ eq "C">
    <formwidget id="f_comune">
</if>
<!-- Inizio della form colorata -->

<%=[iter_form_iniz]%>

<if @flag_risultato@ ne t>
<tr>
   <td>
   <table>
      <tr>
         <td valign=top colspan=2 nowrap align=left class=form_title>
             <b>Ricerca per Indirizzo (obbligatorio)</b>
         </td>
      </tr>

      <tr>
      <if @flag_ente@ eq "P">
         <td valign=top align=right class=form_title>Comune</td>
         <td valign=top><formwidget id="f_comune">
            <formerror  id="f_comune"><br>
            <span class="errori">@formerror.f_comune;noquote@</span>
            </formerror>
         </td>
      </if>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Indirizzo</td>
         <td valign=top><formwidget id="f_desc_topo">
             <formwidget id="f_desc_via">@cerca_viae;noquote@
             <formerror  id="f_desc_via"><br>
             <span class="errori">@formerror.f_desc_via;noquote@</span>
             </formerror>
         </td>
      </tr>

      <tr>
         <td valign=top colspan=2 align=left class=form_title>
             <b>Indicare almeno @num_min_parametri@ dei seguenti parametri</b>
         </td>
      </tr>
      <tr>
         <td valign=top align=right class=form_title>Civico</td>
         <td valign=top><formwidget id="f_civico">/<formwidget id="f_esponente"> <!--but01 -->
             <formerror  id="f_civico"><br>
             <span class="errori">@formerror.f_civico;noquote@</span>
             </formerror>
         </td>
      </tr>

      <tr>
         <td valign=top align=right class=form_title>Codice impianto</td>
         <td valign=top><formwidget id="f_cod_impianto_est">
            <formerror  id="f_cod_impianto_est"><br>
            <span class="errori">@formerror.f_cod_impianto_est;noquote@</span>
            </formerror>
         </td>
      </tr>
      <tr>
         <td valign=top align=right class=form_title>Cognome</td>
         <td valign=top><formwidget id="f_resp_cogn">
            <formerror  id="f_resp_cogn"><br>
            <span class="errori">@formerror.f_resp_cogn;noquote@</span>
            </formerror>
         </td>
      </tr>
      <tr>
         <td valign=top align=right class=form_title>Nome</td>
         <td valign=top><formwidget id="f_resp_nome">
            <formerror  id="f_resp_nome"><br>
            <span class="errori">@formerror.f_resp_nome;noquote@</span>
            </formerror>
         </td>
      </tr>
      <if @coimtgen.regione@ eq "MARCHE"> <!-- ric02 aggiunta if e contenuto -->
      	  <tr> 
	       <td valign=top align=right class=form_title>Codice fiscale</td>
               <td valign=top nowrap><formwidget id="f_cod_fiscale">
	       	   <formerror  id="f_cod_fiscale"><br>
	    	   	       <span class="errori">@formerror.f_cod_fiscale;noquote@</span>
	    	   </formerror>
	       </td>
      	 </tr>
      </if>
      <tr>
         <td valign=top align=right class=form_title>Matricola</td>
         <td valign=top><formwidget id="f_matricola">
             <formerror  id="f_matricola"><br>
             <span class="errori">@formerror.f_matricola;noquote@</span>
             </formerror>
         </td>
      </tr>
      <tr>
         <td valign=top align=right class=form_title>Modello</td>
         <td valign=top><formwidget id="f_modello">
             <formerror  id="f_modello"><br>
             <span class="errori">@formerror.f_modelloa;noquote@</span>
             </formerror>
         </td>
      </tr>
      <tr>
         <td valign=top align=right class=form_title>Costruttore</td>
         <td valign=top><formwidget id="f_costruttore">
             <formerror  id="f_costruttore"><br>
             <span class="errori">@formerror.f_costruttore;noquote@</span>
             </formerror>
         </td>
      </tr>
<!--   </td> -->
      <tr>
         <td valign=top align=right class=form_title>PDR</td>
         <td valign=top><formwidget id="f_pdr">
             <formerror  id="f_pdr"><br>
             <span class="errori">@formerror.f_pdr;noquote@</span>
             </formerror>
         </td>
      </tr>
      <tr> <!-- rom01 aggiunto tr e contenuto -->
         <td valign=top align=right class=form_title>Numero Bollino</td>
         <td valign=top><formwidget id="f_numero_bollino">
             <formerror  id="f_numero_bollino"><br>
             <span class="errori">@formerror.f_numero_bollino;noquote@</span>
             </formerror>
         </td>
      </tr>
<!--   </td> -->

<if @coimtgen.regione@ ne "MARCHE" and @coimtgen.regione@ ne "FRIULI-VENEZIA GIULIA"><!-- ric01 aggiunta if e suo contenuto -->
      <if @flag_gest_targa@ eq "T"><!--ric01 Aggiunto if  e suo contenuto -->
            <tr><td>&nbsp;</td></tr>
	    <tr><td colspan=2>
	    <b>Impianto gi&agrave; targato, si può procedere all'acquisizione<br>indicando obbligatoriamente solo la targa:</b></td></tr>  
    	  <tr>
              <td valign=top align=right class=form_title>Numero di Targa</td>
              <td valign=top><formwidget id="f_targa">
             	    <formerror  id="f_targa"><br>
             	    	<span class="errori">@formerror.f_targa;noquote@</span>
             	    </formerror>
         	</td>
      	  </tr>
      </if>
</if>

   </table>
</tr>

<tr><td>&nbsp;</td>
<tr><td align=center><formwidget id="submit"></td></tr>
</if>
<else>
    <tr><td align=center><br><br><br>@error_mex;noquote@</td></tr>
</else>
<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

