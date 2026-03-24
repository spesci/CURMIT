<!--
    gia01 05/11/2021 Rimosso dalla stampa "Allegato 8 (articolo 4, commi 4 e 5, L.R. 19/2015)"
    gia01            perchè Sandro ha richiesto così

    gac01 16/11/2018 Fatte diverse modifiche alla stampa su richiesta della Regione Marche.
  -->
<br>
<if @coimtgen.regione@ ne "MARCHE"><!--gac01 aggiunta if-->
  <table border="0">
    <tr>
        <td align="center" width="35%">
        <b>
            @nome_ente@<br>
            @tipo_ufficio_ente@
        </b>
        </td>

        <td width="65%">
        <table width="100%" border="1" cellspacing="3" cellpadding="3">
            <tr>
            <td rowspan="2" valign="top">
                <b>Luogo di emissione</b><br>
                <br>
                @denom_comune@
            </td>
            <td>
                <b>Numero</b>
            </td>
            <td rowspan="2" valign="top">
                <b>Pagine</b><br>
                <br>
                @tot_pagine@
            </td>
            </tr>
            <tr>
            <td valign="top">
                <b>Data</b> @data_dich@
            </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
</if>
  <if @coimtgen.regione@ eq "MARCHE"><!--gac01 aggiunta if -->
  <table width=100% border=0>
    <tr>
      <td width=100% align=center>
	<table width=100% border=0>
	  <tr>
	    <td width=20%>@logo;noquote@</td>
	    <td width=60% align=center>
	      <table>
		<tr><td align=center><b>@nome_ente@</b></td></tr>
		<tr><td align=center><b>@tipo_ufficio_ente@</b></td></tr>
		<tr><td align=center>@assessorato@</td></tr>
		<tr><td align=center>@indirizzo_ente@</td></tr>
		<tr><td align=center>@telefono_ente@</td></tr>
	      </table>
	    </td>
	    <td align=center width=20%>@logo_dx;noquote@</td>
	  </tr>
	</table>
      </td>
    </tr>
  </table>
</if>

<if @pagina_corrente@ eq "1" and @coimtgen.regione@ ne "MARCHE">
  <!-- gia01
    <table width="100%">
        <tr>
            <td align="right">
                <b>Allegato 8 (articolo 4, commi 4 e 5, L.R. 19/2015)</b>
            </td>
        </tr>
    </table>    
  -->
</if>
<br>

<if @pagina_corrente@ eq "1">
    <center>
        <h2>Dichiarazione di Avvenuta Manutenzione</h2>
    </center>

    <h4>
        Oggetto: comunicazione di avvenuta manutenzione
    </h4>
    <p>
        <b>Il/La Sottoscritto/a:</b> @dam_nome_dichiarante@ @dam_cognome_dichiarante@
    </p>
    <p><b>Tecnico della ditta</b> @nome_manu@ @cognome_manu@ <b>Partita IVA</b> @cod_piva@</p>
    <p><b>Iscritta alla CCIAA di</b> @localita_reg@ <b>al numero</b> @reg_imprese@</p>
    <p>
        <b>Abilitata ad operare per gli impianti di cui alle lettere:</b><br>
        <table width="100%">
            <tr>
                <td>
                    <if @flag_a@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> a
                </td>
<!--                <td>
                    <if @flag_b@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> b
                </td>-->
                <td>
                    <if @flag_c@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> c
                </td>
<!--                <td>
                    <if @flag_d@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> d
                </td>-->
                <td>
                    <if @flag_e@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> e
                </td>
<!--                <td>
                    <if @flag_f@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> f
                </td>
                <td>
                    <if @flag_g@ true>
                        <img src="@img_checked@" height="12" width="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" height="12" width="12">
                    </else> g
                </td>-->
                <td>dell'articolo 1 del D.M. 37/08</td>
            </tr>
        </table>
    </p>
    <p>
        <b>In qualità di </b> 
        <if @dam_tipo_tecnico@ eq "A">
            Affidatario della manutenzione
        </if> 
        <if @dam_tipo_tecnico@ eq "T">
            Terzo responsabile
        </if>
    </p>
    <p><i>In conformità con quanto stabilito dall'articolo 4, commi 4 e 5 e dall'articolo 9, comma 3 della legge regionale n. 19 del 20 aprile 2015,</i></p>
    <center>
        <h4><u>DICHIARA</u></h4>
    </center>
    <p>Di avere effettuato in data <b>@data_dich@</b> le operazioni di controllo e manutenzione dell'impianto termico <!--<b><if @flag_impianto@ eq "R">Gruppo termico (GT)</if><else>Gruppo frigo/pompa di calore (GF)</else></b>--> con codice catasto impianti <b>@cod_impianto_est@</b></p>
    <p><b>sito in via/strada/piazza </b> @indirizzo_imp@ @numero_imp@ @esponente_imp@ @scala_imp@ @piano_imp@ @interno_imp@</p>
    <p><b>Comune</b> @comune_imp@ <b>Provincia</b> @provincia_imp@</p>
    <p><b>Responsabile dell'impianto:</b> cognome @cognome_resp@ nome @nome_resp@</p>
<!--    <p>
        Il controllo è stato effettuato in seguito a
        <b><if @dam_tipo_manutenzione@ eq "M">
            manutenzione programmata
        </if>
        <if @dam_tipo_manutenzione@ eq "N">
            nuova installazione / ristrutturazione
        </if>
        <if @dam_tipo_manutenzione@ eq "R">
            riattivazione impianto / generatore
        </if></b>
    </p>-->

    <p>
      <br>
      <br>
      In particolare il controllo ha riguardato i seguenti generatori:
    </p>
</if>

<table border="0" width="100%">
  <multiple name="righe">
      <tr>
          <td><ul><li>&nbsp;</li></ul></td>
          <td><b>Gruppo termico:</b>  @righe.gen_prog@</td>
          <td><b>Costruttore:</b>     @righe.fabbricante@</td>
          <td><b>Modello:</b>         @righe.modello@</td>
          <td><b>Matricola:</b>       @righe.matricola@</td>
      </tr>
      <tr>
          <td>&nbsp;</td>
          <td colspan="3"><b>Data dell'ultima manutenzione o della disattivazione:</b> @righe.data_ult_man_o_disatt@</td>
          <td colspan="1"><b>Data Installazione:</b>                                   @righe.data_installaz@</td>
      </tr>
      <tr>
          <td>&nbsp;</td>
          <td colspan="4"><b>Installatore (ragione sociale):</b> @righe.installatore@</td>
      </tr>
      <tr>
          <td>&nbsp;</td>
      </tr>
  </multiple>
</table>

<if @pagina_corrente@ eq "1">
  <p>
        <b>Sono presenti </b> 
        <if @dam_flag_osservazioni@ true>
            <img src="@img_checked@" width="12" height="12">
        </if>
        <else>
            <img src="@img_unchecked@" width="12" height="12">
        </else> Osservazioni 
        <if @dam_flag_raccomandazioni@ true>
            <img src="@img_checked@" width="12" height="12">
        </if>
        <else>
            <img src="@img_unchecked@" width="12" height="12">
        </else> Raccomandazioni
        <if @dam_flag_prescrizioni@ true>
            <img src="@img_checked@" width="12" height="12">
        </if>
        <else>
            <img src="@img_unchecked@" width="12" height="12">
        </else> Prescrizioni
    </p>
</if>

<!-- gac01 aggiunta table e suo contenuto-->
<table width="100%">
<tr>
  <td valign=top align=center  colspan=10 class=form_title><b>Consumi di combustibile</b></td>
</tr>
<tr>    
  <td valign=top align=left  class=form_title>Stagione di riscaldamento attuale</td>
  <td valign=top align=left  class=form_title>@stagione_risc@</td>
  <td valign=top align=left  class=form_title>Acquisti</td>
  <td valign=top align=left  class=form_title>@acquisti@</td>
  <td valign=top align=left  class=form_title>Scorta o lett. iniziale</td>
  <td valign=top align=left  class=form_title>@scorta_o_lett_iniz@</td>
  <td valign=top align=left  class=form_title>Scorta o lett. finale</td>
  <td valign=top align=left  class=form_title>@scorta_o_lett_fin@</td>
  <td valign=top align=left  class=form_title>Consumi stagione</td>
  <td valign=top align=left  class=form_title>@consumo_annuo@</td>
</tr>
<tr>
  <td valign=top align=left  class=form_title>Stagione di riscaldamento precedente</td>
  <td valign=top align=left  class=form_title>@stagione_risc2@</td>
  <td valign=top align=left  class=form_title>Acquisti</td>
  <td valign=top align=left  class=form_title>@acquisti2@</td>
  <td valign=top align=left  class=form_title>Scorta o lett. iniziale</td>
  <td valign=top align=left  class=form_title>@scorta_o_lett_iniz2@</td>
  <td valign=top align=left  class=form_title>Scorta o lett. finale</td>
  <td valign=top align=left  class=form_title>@scorta_o_lett_fin2@</td>
  <td valign=top align=left  class=form_title>Consumi stagione</td>
  <td valign=top align=left  class=form_title>@consumo_annuo2@</td>
</tr>
</table>
<table width="100%">
  <if @rows_remaining@ defined>
    <multiple name="cont">
      <tr><td colspan="2">&nbsp;</td></tr>
    </multiple>
  </if>
  <tr>
    <td>Data @data_dich@</td>
  </tr>
  <tr>
    <td><b>Tecnico che ha effettuato il controllo </b> @cognome_opma@ @nome_opma@</td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
      <td align="center">
          <h6>Firma leggibile del tecnico</h6><br>
          ..............................................................................
      </td>
      <td align="center">
          <h6>Firma leggibile, per presa visione, del responsabile dell'impianto</h6><br>
          ..............................................................................
      </td>
  </tr>
</table>
