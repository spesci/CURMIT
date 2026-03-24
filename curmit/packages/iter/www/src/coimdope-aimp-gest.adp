<!DOCTYPE html>
<!--

    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    mat01 16/03/2026 Aggiunta la gestione delle deleghe. Sandro ha detto di aggiungere il tecnico.

    mic01 24/08/2022 Ora viene mostrato l'utente che ha inserito la DFM e la data di inserimento.

    rom04 08/02/2022 Modifica di Regione Marche per Teleriscaldamento.

    rom03 12/02/2019 Ulteriori modifiche delle marche su impianti del freddo 

    rom02 16/01/2019 Modifiche fatte su richiesta della regione marche per impianti del freddo
    
    rom01 15/11/2018 FAtte diverse modifiche su impaginazione richieste da Regione Marche.

    gac01 24/08/2018 Modificata label frequenza


-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<script type="text/javascript">
  function onSearchClose() {
      document.@form_name@.__refreshing_p.value = '1';
      document.@form_name@.submit();
  }

Ext.require([ 
    'Ext.data.*',
    'Ext.form.*'
]);
@script_autocompletamento;noquote@
</script>

@link_tab;noquote@
@dett_tab;noquote@

<table width="100%" cellspacing=0 class=func-menu>
  <tr>
    <if @funzione@ ne I and @menu@ eq 1>
      <td width="20%" nowrap class=@func_v;noquote@>
        <a href="coimdope-aimp-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
      </td>

      <if @flag_modifica@ eq t>
        <td width="20%" nowrap class=@func_m;noquote@>
          <a href="coimdope-aimp-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
        </td>
        <td width="20%" nowrap class=@func_d;noquote@>
          <a href="coimdope-aimp-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
        </td>
      </if>
      <else>
        <td width="20%" nowrap class=func-menu>Modifica</td>
        <td width="20%" nowrap class=func-menu>Cancella</td>
      </else>

      <td width="20%" nowrap class=func-menu>
        <a href="coimdope-aimp-layout?@link_gest;noquote@&flag_ins=N" class=func-menu target="Stampa">Stampa</a>
      </td>
      <td width="20%" nowrap class=func-menu>
        <a href="coimdope-aimp-layout?@link_gest;noquote@&flag_ins=S" class=func-menu target="Stampa">Storicizza stampa DFM</a><!--rom01 modificata label su ricihiesta della Regione Marche-->
      </td>
    </if>
    <else>
      <td width="20%" nowrap class=func-menu>Visualizza</td>
      <td width="20%" nowrap class=func-menu>Modifica</td>
      <td width="20%" nowrap class=func-menu>Cancella</td>
      <td width="20%" nowrap class=func-menu>Stampa</td>
      <td width="20%" nowrap class=func-menu>Ins. Doc.</td>
    </else>
  </tr>
</table>

<center>
<formtemplate id="@form_name@">
<formwidget   id="cod_impianto">
<formwidget   id="flag_tipo_impianto">
<formwidget   id="cod_dope_aimp">

<formwidget   id="last_cod_dimp">

<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">

<formwidget   id="url_aimp">
<formwidget   id="url_list_aimp">

<formwidget   id="f_cod_via">
<formwidget   id="cod_manutentore">
<formwidget   id="cod_responsabile">
<formwidget   id="cod_legale_rapp">
<formwidget   id="cognome_legale">
<formwidget   id="nome_legale">
<formwidget   id="cod_opma"><!--mat01-->
<formwidget   id="cod_opma_dele"><!--mat01-->
<formwidget   id="cod_manu_dele"><!--mat01-->    
  
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<if @funzione@ eq "V"><!-- mic01 aggiunta if e suo contenuto -->
  <tr>
    <td align="right" colspan=10>Inserito da: @nome_utente_ins;noquote@</td>
  </tr>
  <tr>
    <td align="right" colspan=10>In data: @data_ins_edit;noquote@</td>
  </tr>
</if>

      <tr><td align="center" colspan="10">@delegation_warning;noquote@</td></tr><!--mat01-->
     
        <tr>
          <td colspan=10 align="center" class="errori">@errori;noquote@</td>
        </tr>
        <tr>
          <td align=right class=form_title width=20%>Cognome dichiarante</td>
          <td align=left colspan=9>
            <formwidget id="cognome_dichiarante">
            <formerror  id="cognome_dichiarante">
              <br>
              <span class="errori">@formerror.cognome_dichiarante;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr>
          <td align=right class=form_title>Nome dichiarante</td>
          <td align=left colspan=9>
            <formwidget id="nome_dichiarante">
            <formerror  id="nome_dichiarante">
              <br>
              <span class="errori">@formerror.nome_dichiarante;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr>
          <td align=right class=form_title>Data dichiarazione<font color="red">*</font></td><!--rom02 aggiunto *-->
          <td align=left colspan=9>
            <formwidget id="data_dich">
            <formerror  id="data_dich">
              <br>
              <span class="errori">@formerror.data_dich;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr>
          <td align=right class=form_title>In qualita' di</td>
          <td align=left colspan=9>
            <formwidget id="flag_dichiarante">
            <formerror  id="flag_dichiarante">
              <br>
              <span class="errori">@formerror.flag_dichiarante;noquote@</span>
            </formerror>
          </td>
        </tr>

        <tr>
          <td align=right nowrap class=form_title>della Ditta</td>
          <td align=left colspan=9>
            <formwidget id="cognome_manu"><formwidget id="nome_manu">@cerca_manu;noquote@
            <formerror  id="cognome_manu"><br>
              <span class="errori">@formerror.cognome_manu;noquote@</span>
            </formerror>
          </td>
	</tr>
	<tr>  
	  <td valign="top" align="right" nowrap class="form_title">tecnico</td>
	  <td valign="top" align="left" colspan=9><formwidget id="cognome_opma"><!--mat01-->
	      <formwidget id="nome_opma">@cerca_opma;noquote@
		<formerror  id="cognome_opma"><br>
		  <span class="errori">@formerror.cognome_opma;noquote@</span>
		</formerror>
           </td>
        </tr>

        <tr>
	  <td align=right class=form_title width=21% nowrap>iscritta alla CCIAA di</td>
          <td><formwidget id="localita_reg">
             <formerror   id="localita_reg"><br>
               <span class="errori">@formerror.localita_reg;noquote@</span>
             </formerror>
          </td>
          <td align=right nowrap>al numero</td>
          <td colspan=7><formwidget id="reg_imprese">
             <formerror   id="reg_imprese"><br>
               <span class="errori">@formerror.reg_imprese;noquote@</span>
             </formerror>
          </td>
        </tr>

        <tr>
          <td align=right>abilitata ad operare per gli impianti di cui alle lettere:</td>
          <td colspan=5>
            <table width=100%>
              <tr>
                <td>a)<formgroup id="flag_a">@formgroup.widget;noquote@</formgroup></td>
    <!--rom01   <td>b)<formgroup id="flag_b">@formgroup.widget;noquote@</formgroup></td>  -->
                <td>c)<formgroup id="flag_c">@formgroup.widget;noquote@</formgroup></td>
    <!--rom01   <td>d)<formgroup id="flag_d">@formgroup.widget;noquote@</formgroup></td>  -->
                <td>e)<formgroup id="flag_e">@formgroup.widget;noquote@</formgroup></td>
    <!--rom01   <td>f)<formgroup id="flag_f">@formgroup.widget;noquote@</formgroup></td>  -->
    <!--rom01   <td>g)<formgroup id="flag_g">@formgroup.widget;noquote@</formgroup></td> -->
		<td colspan=2>dell'articolo 1 del D.M. 37/08</td><!--rom01-->
              </tr>
            </table>
          </td>
        </tr>
        <tr>
	  <td></td>
	</tr>
        <tr>
          <td align=right nowrap class=form_title>in qualità di<font color="red">*</font></td><!--rom02 aggiunto *-->
          <td align=left colspan=9>
            <formwidget id="flag_tipo_tecnico">
            <formerror  id="flag_tipo_tecnico">
              <br>
              <span class="errori">@formerror.flag_tipo_tecnico;noquote@</span>
            </formerror>
          </td>
        </tr>

        <tr>
          <td align=right class=form_title valign=top>Dell'impianto adibito a</td>
          <td align=left colspan=9><formwidget id="cod_utgi">
            <formerror  id="cod_utgi"><br>
              <span class="errori">@formerror.cod_utgi;noquote@</span>
            </formerror> <a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=dfm', 'help', 'scrollbars=yes, esizable=ye\
s, width=450, height=220').moveTo(110,140)"><b>vedi nota</b></a><!--rom01-->
          </td>
        </tr>

        <tr>
          <td align=right class=form_title valign=top>Catasto impianti/codice </td>
          <td align=left colspan=9><formwidget id="cod_impianto_est">
            <formerror  id="cod_impianto_est"><br>
              <span class="errori">@formerror.cod_impianto_est;noquote@</span>
            </formerror>
          </td>
        </tr>

        <tr>
          <td valign=top align=right class=form_title width=21%>Indirizzo</td>
          <td valign=top width=28%><formwidget id="toponimo">
            <formwidget id="indirizzo">
            <formerror  id="indirizzo"><br>
              <span class="errori">@formerror.indirizzo;noquote@</span>
            </formerror>
            <formerror  id="toponimo"><br>
              <span class="errori">@formerror.toponimo;noquote@</span>
            </formerror>
          </td>
          <td valign=top align=right class=form_title width=7%>N&deg; Civ.</td>
          <td valign=top width=6% nowrap>
            <formwidget id="numero">/<formwidget id="esponente">
            <formerror  id="numero"><br>
              <span class="errori">@formerror.numero;noquote@</span>
            </formerror>
          </td>
          <td valign=top align=right class=form_title width=4%>Scala</td>
          <td valign=top width=3%><formwidget id="scala">
            <formerror  id="scala"><br>
              <span class="errori">@formerror.scala;noquote@</span>
            </formerror>
          </td>
          <td valign=top align=right class=form_title width=4%>Piano</td>
          <td valign=top width=3%><formwidget id="piano">
            <formerror  id="piano"><br>
              <span class="errori">@formerror.piano;noquote@</span>
            </formerror>
          </td>
          <td valign=top align=right class=form_title width=3%>Int.</td>
          <td valign=top><formwidget id="interno">
            <formerror  id="interno"><br>
              <span class="errori">@formerror.interno;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr>
          <td valign=top align=right class=form_title>Comune</td>
          <if @flag_ente@ eq P>
            <td valign=top colspan=9><formwidget id="cod_comune">
              <formerror  id="cod_comune"><br>
                <span class="errori">@formerror.cod_comune;noquote@</span>
              </formerror>
            </td>
          </if>
          <else>
            <td valign=top colspan=9><formwidget id="descr_comune"></td>
          </else>
        </tr>
      <!--rom04 Aggiunta condizione su Teleriscaldamento -->
      <if @flag_tipo_impianto@ eq "R" or @flag_tipo_impianto@ eq "T">
        <tr>
          <% if {$flag_tipo_impianto eq "R"} {#rom04 Aggiunte if, else e loro contenuto
	     set label_pot_nom_risc "Di potenza termica nominale utile complessiva"
	     } else {
	     set label_pot_nom_risc "Di potenza termica nominale complessiva pari a"
	     }
	     %><!--rom100-->
          <td valign=top align=right class=form_title>@label_pot_nom_risc;noquote@</td><!--rom01 aggiunto complessiva-->
          <td colspan=9>
            <formwidget id="pot_nom_risc">kW
            <formerror  id="pot_nom_risc"><br>
              <span class="errori">@formerror.pot_nom_risc;noquote@</span>
            </formerror>
          </td>
        </tr>
      </if>
      <else>
        <tr>
	  <!--rom02 aggiunto complessiva in raffrescamento-->
          <td valign=top align=right class=form_title>Della potenza frigorifera nominale complessiva in raffrescamento</td>
          <td colspan=9>
            <formwidget id="pot_nom_raff">kW
            <formerror  id="pot_nom_raff"><br>
              <span class="errori">@formerror.pot_nom_raff;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr>
	  <!--rom02 aggiunto complessiva in riscaldamento-->
          <td valign=top align=right class=form_title>Della potenza termica nominale complessiva in riscaldamento</td>
          <td colspan=9>
             <formwidget id="pot_nom_risc">kW
             <formerror  id="pot_nom_risc"><br>
               <span class="errori">@formerror.pot_nom_risc;noquote@</span>
             </formerror>
          </td>
        </tr>
      </else>

      <tr>
	<% if {$flag_tipo_impianto eq "R"} {
	   set label_num_generatori "N&deg; gruppi termici presenti"
	   } elseif {$flag_tipo_impianto eq "F"} {
	   set label_num_generatori "N&deg; Gruppi frigo/PDC presenti"
	   } elseif {$flag_tipo_impianto eq "T"} {
	   set label_num_generatori "N&deg; Scambiatori presenti"
	   } elseif {$flag_tipo_impianto eq "C"} {
	   set label_num_generatori "N&deg; Cogeneratori presenti"
	   }
	   %><!--rom02-->
        <td valign=top align=right class=form_title>@label_num_generatori;noquote@</td><!--rom02 ora uso la variabile label_num_generatori-->
        <td colspan=9>
          <formwidget id="num_generatori">
          <formerror  id="num_generatori"><br>
            <span class="errori">@formerror.num_generatori;noquote@</span>
          </formerror>
        </td>
      </tr>
<!--rom01
      <if @flag_tipo_impianto@ eq "R">
      <tr>
        <td valign=top align=right class=form_title>Combustibile</td>
        <td colspan=9>
          <formwidget id="cod_combustibile">
          <formerror  id="cod_combustibile"><br>
            <span class="errori">@formerror.cod_combustibile;noquote@</span>
          </formerror>
        </td>
      </tr>
      </if>
-->
<!--rom01
      <tr>
        <td valign=top align=right class=form_title>Nominativo fornitore di energia</td>
        <td colspan=9>
          <formwidget id="fornitore_energia">
          <formerror  id="fornitore_energia"><br>
            <span class="errori">@formerror.fornitore_energia;noquote@</span>
          </formerror>
        </td>
      </tr>      
-->
      <tr>
        <td align=right class=form_title>Responsabile dell'impianto </td>
        <td align=left colspan=9>
          <formwidget id="cognome_resp">
          <formwidget id="nome_resp">@cerca_prop;noquote@ @link_ins_prop;noquote@
          <formerror  id="cognome_resp"><br>
            <span class="errori">@formerror.cognome_resp;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td align=right class=form_title>In qualit&agrave; di</td>
        <td align=left>
          <formwidget id="flag_resp">
          <formerror  id="flag_resp"><br>
            <span class="errori">@formerror.flag_resp;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td colspan=2>&nbsp;</td>
      </tr>

      <tr><td colspan=10 align=center><b>Visti</b></td></tr>
      <tr>
        <td align=right colspan=2 class="form_title">La documentazione tecnica rilasciata dal progettista dell'impianto</td>
        <td align=left colspan=8>
          <formwidget id="flag_doc_tecnica">
          <formerror  id="flag_doc_tecnica"><br>
            <span class="errori">@formerror.flag_doc_tecnica;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td align=right colspan=2 class=form_title>Le istr. tecniche per l'uso e la manut. rese disponibili dall'impresa installatrice</td>
        <td align=left colspan=8>
          <formwidget id="flag_istr_tecniche">
          <formerror  id="flag_istr_tecniche"><br>
            <span class="errori">@formerror.flag_istr_tecniche;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td align=right colspan=2 class=form_title>I manuali tecnici di uso e manut. elaborati dal costruttore degli apparecchi</td>
        <td align=left colspan=8>
          <formwidget id="flag_man_tecnici">
          <formerror  id="flag_man_tecnici"><br>
            <span class="errori">@formerror.flag_man_tecnici;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td align=right colspan=2 class=form_title>I regolamenti locali</td>
        <td align=left colspan=8>
          <formwidget id="flag_reg_locali">
          <formerror  id="flag_reg_locali"><br>
            <span class="errori">@formerror.flag_reg_locali;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td align=right colspan=2 class=form_title>Le norme UNI e CEI applicabili per lo specifico elemento o tipo di apparecchio</td>
        <td align=left colspan=8>
          <formwidget id="flag_norme_uni_cei">
          <formerror  id="flag_norme_uni_cei"><br>
            <span class="errori">@formerror.flag_norme_uni_cei;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr>
        <td align=right colspan=2 class=form_title>Altro</td>
        <td align=left colspan=8>
          <formwidget id="altri_doc">
          <formerror  id="altri_doc"><br>
            <span class="errori">@formerror.altri_doc;noquote@</span>
          </formerror>
        </td>
      </tr>

      <tr><td>&nbsp;</td></tr>
      <tr><td>&nbsp;</td></tr>

</table>
<% if {$flag_tipo_impianto eq "R"} {
   set label_operazioni " e il contenimento delle emissioni "
   } else {
   set label_operazioni "&nbsp;"
   }%><!--rom02-->
<table width="100%"><!--rom01 aggiunta table e contenuto-->
  <tr>
    <td align="center">Dichiara che l'elenco e la frequenza delle operazioni di controllo e manutenzione da effettuare per garantire la sicurezza@label_operazioni;noquote@sono i seguenti:</td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table>
<table  align="center" border=0>
      <tr><td colspan=8 align=center><b>Operazioni</b></td></tr>

      <multiple name="campi_operazioni">
        <tr><td align=center colspan="8">&nbsp;</td></tr>
        <tr>
	  <% if {$flag_tipo_impianto eq "R"} {
	     set label_generatori "Gruppo termico"
	     } elseif {$flag_tipo_impianto eq "F"} {
	     set label_generatori "Gruppo frigo/PDC"
	     } elseif {$flag_tipo_impianto eq "T"} {
	     set label_generatori "Scambiatore di calore"
	     } elseif {$flag_tipo_impianto eq "C"} {
	     set label_generatori "Cogeneratore"
	     }
	     %><!--rom03-->
	  <td align="right" class="form_title" nowrap><b>@label_generatori;noquote@</b></td>
	  <td align="left"  class="form_title" >@campi_operazioni.gen_prog@</td>
	  <td align="right" class="form_title"><b>Data Installazione:</b></td>
	  <td align="left"  class="form_title">@campi_operazioni.data_installaz@</td>
	  <!--per il freddo visualizzo il Fluido frigorigeno, per gli altri impianti il combustibile e la potenza termica nominale utile-->
	  <if @flag_tipo_impianto@ ne "F">
	    <td align="right" class="form_title"><b>Combustibile</b></td>
	    <td align="left"  class="form_title">@campi_operazioni.combustibile@</td><!--rom01-->
	    <td align="right" class="form_title"><b>Potenza termica nominale utile:</b></td><!--rom01 rinominata label-->
	    <td align="left"  class="form_title" width=15%>@campi_operazioni.pot_utile_nom@ kW</td>
	  </if> <else>
	    <td align="right" class="form_title"><b>Fluido frigorigeno</b></td>
	    <td align="left"  class="form_title">@campi_operazioni.fluido_frigorigeno@</td>
	  </else>
	</tr>

        <tr>	  
	  <td align="right" class="form_title"><b>Fabbricante:</b></td>
	  <td align="left"  class="form_title">@campi_operazioni.fabbricante@</td>
	  
	  <td align="right" class="form_title"><b>Modello:</b></td>
	  <td align="left"  class="form_title">@campi_operazioni.modello@</td>
	  
	  <td align="right" class="form_title"><b>Matricola:</b></td>
	  <td align="left"  class="form_title">@campi_operazioni.matricola@</td>
        </tr>

	<if @flag_tipo_impianto@ eq "F"><!--per il freddo visualizzo il campo sistema di azionamento, eventualmente il combustibile e le potenze nominali di raffrescamento e riscaldamento-->
	  <tr>
	    <td align="right" class="form_title"><b>Sistema di azionamento:</b></td>
	    <td align="left"  class="form_title">@campi_operazioni.sistema_azionamento@</td>
	    <if @campi_operazioni.cod_tpco@ eq "1">
	      <td align="right" class="form_title"><b>con combustibile:</td>
	      <td align="left"  class="form_title">@campi_operazioni.combustibile@</td>
	    </if>
	  </tr>
	  <tr>
	    <td align="right" class="form_title"><b>Potenza frigorifera nominale in raffrescamento:</b></td>
	    <td align="left"  class="form_title">@campi_operazioni.pot_focolare_nom@ (KW)</td>
	    <td align="right" class="form_title"><b>Potenza termica nominale in riscaldamento:</b></td>
	    <td align="left"  class="form_title">@campi_operazioni.pot_focolare_lib@ (KW)</td>
	  </tr>
	  </if>
        <group column="gen_prog">
            <tr>
                <td align="right" class="form_title">Operazione</td>
                <td align="left" colspan=3>
                    <formwidget  id="@campi_operazioni.campo_operazione@">
                    <span class="errori"><br>
                        <formerror id="@campi_operazioni.campo_operazione@"></formerror>
                    </span>
                </td>
                <td align="right" class="form_title">Frequenza in mesi</td><!--gac01 modificata label-->
                <td align="left" colspan="3">
                    <formwidget id="@campi_operazioni.campo_frequenza@">
                    <span class="errori"><br>
                        <formerror id="@campi_operazioni.campo_frequenza@"></formerror>
                    </span>
                </td>
            </tr>
        </group>
      </multiple>
      <if @delegation_active_p@ eq "t"><!--mat01 aggiunta if e contenuto -->
	<td align="center">
	  <table border="0">
	    <tr>
	      <td valign="top" align="left" nowrap class="form_title">Ditta delegante</td>
	    </tr>
	    <tr>
	      <td valign="top" align="left"> <formwidget id="rag_sociale_delegato">@cerca_manu_dele;noquote@
		  <formerror  id="rag_sociale_delegato"><br>
		    <span class="errori">@formerror.rag_sociale_delegato;noquote@</span>
		  </formerror>
	      </td>
	    </tr>
	    <tr>
	      <td valign="top" align="left" nowrap class="form_title">Tecnico che ha effettuato il controllo su delega</td>
	    </tr>
	    <tr>
	      <td valign="top" align="left">
		<formwidget id="cognome_opma_delegato">
		  <formwidget id="nome_opma_delegato">@cerca_opma_dele;noquote@
		    <formerror  id="nome_opma_delegato"><br>
		      <span class="errori">@formerror.nome_opma_delegato;noquote@</span>
		    </formerror>
	      </td>
	    </tr>
	  </table>
	</td>
      </if>
<tr><td colspan=8>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan="8" align=center><formwidget id="submit_btn"></td></tr>
</if>


<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

<!-- Fine della form colorata -->
</formtemplate>
<p>
</center>
