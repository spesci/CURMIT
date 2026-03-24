<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mat01 06/03/2026 Aggiunto campo note_ubic per le Marche

    rom06 28/04/2023 Aggiunto il campo unita_immobiliari_servite su segnalazione di Belluzzo, reso visibile per
    rom06            tutti tranne che le Marche perche' lo gestiscono in coimaimp-bis-gest.

    rom05 19/01/2019 Modifiche per gli impianto del freddo richieste dalla regione marche

    gac02 10/12/2018 Modificato link "Passa a scheda 1.6" in "Passa a Scheda 3: Nomina Terzo 
    gac02            Responsabile" perche la scheda 1.6 ora è unita alla scheda 1bis 

    rom04 29/11/2018 Aggiunto campo cod_cted.

    rom03 05/11/2018 La Regione Marche non devono più visualizzare i campi "Ultima variazione"
    rom03            e "Destinaz d'uso:"

    rom02 02/08/2018 Su richiesta di Sandro ho reso invisibile il campo "Denominatore" per le
    rom02            Marche e ho aggiunto il campo "Sezione" per tutti.
    rom02bis         Rinominato campo cat_catastale da "Categoria Catastale" a "Tipo Catasto"
    rom02bis         su richiesta della Regione Maeche.

    gac01 13/07/2018 Aggiunto bottone in alto "Torna a "Scheda 1Bis: Dati Generali" solo per
    gac01            la Regione Marche.
    
    rom01 11/07/2018 Aggiunto bottone in alto "Passa a Scheda 1.6: Soggetti che operano 
    rom01            sull'impianto" solo per la Regione Marche.

-->
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
<formwidget   id="data_fin_valid">
<formwidget   id="url_list_aimp">
<formwidget   id="url_aimp">
<formwidget   id="dummy">
<formwidget   id="f_cod_via">

<if @funzione@ ne D>
   <if @funzione@ ne M>
      <formwidget   id="data_ini_valid">
   </if>
</if>

<if @flag_ente@ ne P>
    <formwidget   id="cod_comune">
</if>

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%"  cellspacing=0 class=func-menu>
<tr>
   <if @funzione@ eq "I">
      <td width="75%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
      <td width="25%" nowrap class=@func_d;noquote@>
         <a href="/iter/maps/one-position?cod_impianto=@cod_impianto;noquote@">Mappe</a>
      </td>
      <td width="25%" nowrap class=@func_v;noquote@>
         <a href="coimaimp-ubic?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>
      <td width="25%" nowrap class=@func_m;noquote@>
         <a href="coimaimp-ubic?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
      </td>
      <td width="25%" nowrap class=func-menu>
         <a href="coimstub-list?@link_stub;noquote@" class=func-menu>Storico ubicazioni</a>
      </td>
   </else>
</tr>
<if @flag_multivie@ eq "T">
<if @funzione@ ne "I">
    <td width="25%" colspan=1 nowrap class=func-menu>
         <a href="coim_multiubic-list?@link_gest;noquote@" class=func-menu>Altre ubicazioni</a>
    </td>
</if>
</if>
<if @coimtgen.regione@ eq "MARCHE"> <!--rom01 aggiunta if e contenuto -->
  <td width="25%" nowrap class=func-menu>
    <a href="coimaimp-bis-gest?funzione=V&@link_gest;noquote@" class=func-menu>Torna a Scheda 1Bis: Dati Generali</a>
  </td>
    
  <td width="25%" nowrap class=func-menu>
    <!--gac02    <a href="coimaimp-sogg?funzione=V&@link_gest;noquote@" class=func-menu>Passa a Scheda 1.6: Soggetti che operano sull'impianto</a>-->
    <a href="coim_as_resp-list?funzione=V&@link_scheda3;noquote@&nome_funz=asresp&nome_funz_caller=impianti" class=@func_d;noquote@>Passa a Scheda 3: Nomina Terzo Responsabile</a><!--gac02-->
  </td>
    <td width="75%" colspan=2 class=func-menu>&nbsp;</td>
</if><!--rom01-->
</table>



<%=[iter_form_iniz]%>
<!-- Inizio della form colorata -->
<table border=0>
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 1.2: ubicazione</b></td></tr>
<tr><td colspan=6>&nbsp;</td></tr>
<tr>
        <td valign=top align=right class=form_title>Comune</td>

        <if @flag_ente@ eq P>
            <td valign=top><formwidget id="cod_comune">
                <formerror  id="cod_comune"><br>
                <span class="errori">@formerror.cod_comune;noquote@</span>
            </formerror>
            </td>
        </if>
        <else>
            <td valign=top><formwidget id="descr_comune"></td>
	</else>
</tr><tr>
        <td valign=top align=right class=form_title>Localit&agrave;</td>
        <td colspan=1 valign=top><formwidget id="localita">
            <formerror  id="localita"><br>
            <span class="errori">@formerror.localita;noquote@</span>
            </formerror>
        </td>
        <td valign=top align=right class=form_title>CAP</td>
        <td colspan=1 valign=top><formwidget id="cap">
            <formerror  id="cap"><br>
            <span class="errori">@formerror.cap;noquote@</span>
            </formerror>
        </td>
</tr>

<tr>
        <td valign=top align=right class=form_title>Unit&agrave; urbana</td>
        <td colspan=1 valign=top><formwidget id="cod_urb">
            <formerror  id="cod_urb"><br>
            <span class="errori">@formerror.cod_urb;noquote@</span>
            </formerror>
        </td>
        <td valign=top align=right class=form_title>Quartiere</td>
        <td colspan=1 valign=top><formwidget id="cod_qua">
            <formerror  id="cod_qua"><br>
            <span class="errori">@formerror.cod_qua;noquote@</span>
            </formerror>
        </td>
</tr>

<tr>
    <td valign=top align=right colspan=6><table width=100%><tr>
        <td valign=top align=right class=form_title>&nbsp; &nbsp; &nbsp; &nbsp;</td>
        <td valign=top align=right class=form_title>Indirizzo</td>
            <td valign=top nowrap colspan=2><formwidget id="descr_topo">
	    <formwidget id="descr_via">@cerca_viae;noquote@
            <formerror  id="descr_via"><br>
            <span class="errori">@formerror.descr_via;noquote@</span>
            </formerror>
            <formerror  id="descr_topo"><br>
            <span class="errori">@formerror.descr_topo;noquote@</span>
            </formerror>
        </td>
        <td valign=top align=right class=form_title>N&deg; Civ.</td>
        <td valign=top><formwidget id="numero">/<formwidget id="esponente">
            <formerror  id="numero"><br>
            <span class="errori">@formerror.numero;noquote@</span>
            </formerror>
        </td>
        <td valign=top align=right class=form_title>Scala</td>
        <td valign=top><formwidget id="scala">
            <formerror  id="scala"><br>
            <span class="errori">@formerror.scala;noquote@</span>
            </formerror>
        </td>
        <td valign=top align=right class=form_title>Piano</td>
        <td valign=top><formwidget id="piano">
            <formerror  id="piano"><br>
            <span class="errori">@formerror.piano;noquote@</span>
            </formerror>
        </td>
        <td valign=top align=right class=form_title>Int.</td>
        <td valign=top><formwidget id="interno">
            <formerror  id="interno"><br>
            <span class="errori">@formerror.interno;noquote@</span>
            </formerror>
        </td>
    </tr></table></td>
</tr>
<tr><!--rom04 aggiunto tr e contenuto-->
  <td valign=top align=right nowrap class=form_title>Cat. edificio</td>
  <td valign=top  colspan=5><formwidget id="cod_cted">
      <formerror  id="cod_cted"><br>
	<span class="errori">@formerror.cod_cted;noquote@</span>
      </formerror>
  </td>
</tr>
<if @coimtgen.regione@ ne "MARCHE"><!--rom03 aggiunta if; aggiunta else e contenuto-->
<tr>
        <td valign=top align=right class=form_title>Destinaz d'uso:</td>
        <td valign=bottom><formwidget id="cod_tpdu">
            <formerror  id="cod_tpdu"><br>
            <span class="errori">@formerror.cod_tpdu;noquote@</span>
            </formerror>
        </td>
</tr>
<tr><!-- rom06 Aggiunta tr e il suo contenuto -->
    <td valign=top align=right nowrap class=form_title>Unità immobiliari servite <font color=red>*</font></td>
    <td valign=top><formwidget id="unita_immobiliari_servite">
        <formerror  id="unita_immobiliari_servite"><br>
        <span class="errori">@formerror.unita_immobiliari_servite;noquote@</span>
        </formerror>
    </td>
</tr>
  <tr>
    <td valign=top align=right class=form_title>Ultima variazione</td>
    <td valign=top colspan=3><formwidget id="data_variaz">
        <formerror  id="data_variaz"><br>
          <span class="errori">@formerror.data_variaz;noquote@</span>
        </formerror>
    </td>
  </tr>
</if>
<else>
  <tr> 
    <td valign=top align=right class=form_title>Volume lordo riscaldato</td><!--rom05-->
    <td valign=top><formwidget id="volimetria_risc">
        <formerror  id="volimetria_risc"><br>
          <span class="errori">@formerror.volimetria_risc;noquote@</span>
        </formerror>
    </td>
  </tr>
  <if @flag_tipo_impianto@ eq "F"><!--rom05 aggiunta if e contenuto-->
    <tr>
      <td valign=top align=right class=form_title>Volume lordo raffrescato</td><!--rom05-->
      <td valign=top><formwidget id="volimetria_raff">
	  <formerror  id="volimetria_raff"><br>
	    <span class="errori">@formerror.volimetria_raff;noquote@</span>
	  </formerror>
      </td>
    </tr>
  </if>
<!--mat01   <tr>
    <td colspan="4">&nbsp;</td>
    </tr> -->
    <tr>
    <td valign=top align=right class=form_title>Note</td>
    <td valign=top colspan=3><formwidget id="note_ubic">
                <formerror  id="note_ubic"><br>
    		            <span class="errori">@note_ubic;noquote@</span>
                </formerror>
    </td>
    </tr><!--mat01 --> 

</else>
<if @flag_obbligo_dati_catastali;noquote@ ne "T">
<tr>
        <td valign=top align=right class=form_title><b>Dati non Obbligatori:</b></td>
      <td colspan=3></td>
</tr>
</if>
<tr>
        <if @funzione@ ne V>
          <if @funzione@ ne I>
            <td valign=top align=right class=form_title>Data validit&agrave;</td>
            <td valign=top colspan=3><formwidget id="data_ini_valid">
                <formerror  id="data_ini_valid"><br>
                <span class="errori">@formerror.data_ini_valid;noquote@</span>
                </formerror>
            </td>
          </if>
        </if>
</tr>
<tr>
     <td valign=top align=right class=form_title>Coordinate geografiche GB X</td>
     <td valign=top  colspan=3><formwidget id="gb_x">
        <formerror  id="gb_x"><br>
        <span class="errori">@formerror.gb_x;noquote@</span>
        </formerror>
     </td>
</tr>
<tr>
     <td valign=top align=right class=form_title>Coordinate geografiche GB Y</td>
     <td valign=top  colspan=3><formwidget id="gb_y">
        <formerror  id="gb_y"><br>
        <span class="errori">@formerror.gb_y;noquote@</span>
        </formerror>
     </td>
</tr>

<tr>
     <td valign=top align=right class=form_title>Tipo catasto</td><!--rom02bis rinominato campo, prima era "Categoria Catastale"-->
     <td valign=top  colspan=3><formwidget id="cat_catastale">
        <formerror  id="cat_catastale"><br>
        <span class="errori">@formerror.cat_catastale;noquote@</span>
        </formerror>
     </td>
</tr>

<tr><!--rom01 aggiunta tr e contenuto-->
  <td valign=top align=right class=form_title>Sezione</td>
  <td valign=top  colspan=3><formwidget id="sezione">
      <formerror  id="sezione"><br>
      <span class="errori">@formerror.sezione;noquote@</span>
      </formerror>
  </td>
</tr>

<tr>
    <td valign=top align=right colspan=6><table width=100%><tr>
     <td valign=top align=right class=form_title>Foglio</td>
     <td valign=top  colspan=6><formwidget id="foglio">
        <formerror  id="foglio"><br>
        <span class="errori">@formerror.foglio;noquote@</span>
        </formerror>
     </td>
      <td valign=top align=right class=form_title>Mappale</td>
     <td valign=top  ><formwidget id="mappale">
        <formerror  id="mappale"><br>
        <span class="errori">@formerror.mappale;noquote@</span>
        </formerror>
     </td>
          <td valign=top align=right class=form_title>Subalterno</td>
          <td valign=top><formwidget id="subalterno">
        <formerror  id="subalterno"><br>
        <span class="errori">@formerror.subalterno;noquote@</span>
        </formerror>
     </td>
<if @coimtgen.regione@ ne "MARCHE"><!--rom02 aggiunta if-->
      <td valign=top align=right class=form_title>Denominatore</td>
      <td valign=top><formwidget id="denominatore">
        <formerror  id="denominatore"><br>
        <span class="errori">@formerror.denominatore;noquote@</span>
        </formerror>
     </td>
</if>
<else><!--rom02 aggiunta else e contenuto-->
<td colspan=2>&nbsp;</td>
</else>
</tr>
    </tr></table></td>
<tr><td colspan=6>&nbsp;</td></tr>
<if @funzione@ ne "V">
<tr>
    <td colspan=6 align=center><formwidget id="submit"></td>
</tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

