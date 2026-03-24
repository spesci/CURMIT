<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>

<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">

<table width=100% cellspacing=0 class=func-menu>
<%=[iter_form_iniz]%>

<tr><td colspan=2 align=center><formwidget id="submit"></td></tr>

<tr><td colspan=2 align=center>&nbsp;</td></tr>
<tr><td colspan=2 align=center>&nbsp;</td></tr>
<tr><td colspan=2 align=center>&nbsp;</td></tr>

<tr><td colspan=2 align=center><big><b><a href="@impiantiA;noquote@">Scarico impianti attivi</a></b></big></td></tr>
<tr><td colspan=2 align=center><big><b><a href="@verificheA;noquote@">Scarico verifiche impianti attivi</a></b></big></td></tr>
<tr><td colspan=2 align=center><big><b><a href="@autocertificazioniA;noquote@">Scarico Allegati impianti attivi</a></b></big></td></tr>

<tr><td colspan=2 align=center><big><b><a href="@impiantiD;noquote@">Scarico impianti non attivi</a></b></big></td></tr>
<tr><td colspan=2 align=center><big><b><a href="@verificheD;noquote@">Scarico verifiche impianti non attivi</a></b></big></td></tr>
<tr><td colspan=2 align=center><big><b><a href="@autocertificazioniD;noquote@">Scarico Allegati impianti non attivi</a></b></big></td></tr>

<tr><td colspan=2 align=center>&nbsp;</td></tr>
<tr><td colspan=2 align=center>&nbsp;</td></tr>
<tr><td colspan=2 align=center>&nbsp;</td></tr>


<%=[iter_form_fine]%>
</formtemplate>

<big><b>Dati aggiornati al @last_update_pretty;noquote@.</b></big><br><!--ric01 aggiunto frase -->
<big><b>Per aggiornare i file csv contenenti gli impianti e le verifiche presenti nel DB cliccare sul tasto in alto.</b></big><br> <br>
Per scaricare le ultime copie estratte su PC cliccare sugli appositi link.  <br>
Attenzione il programma non puo' essere rilanciato piu' volte e si deve attendere la fine prima di eventuali rielaborazioni. <br>
Se per errore si dovesse ricliccare sul tasto prima della fine
comparira' una segnalazione di errore e in questo caso si potrà rientrare nel
programma solo al suo termine e si potranno comunque scaricare i file senza
doverlo rielaborare.

</center>


