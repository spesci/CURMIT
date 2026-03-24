ad_library {

    Proc per l'integrazione con Spid di Ucit

    @author Simone Pesci
    @cvs-id $Id:

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    rom01 06/10/2021 Modificato il controllo sul codice fiscale della proc call_decodifica_asserzioni_spid:
    rom01            in alcuni casi il token con lo username che ci viene restiuito non contiene
    rom01            il codice fiscale ma un valore diverso. Il controllo non va quindi fatto sul codice
    rom01            fiscale ma proprio sullo username del token e quello restiuito dalla chiamate del ws.

    sim01 25/03/2021 Create per gestire su UCIT l'autenticazione mediante spid la nuove proc
    sim01            iter::call_decodifica_asserzioni_spid e iter::get_service_name_spid.
    sim01            iter::get_service_name_spid restituisce il service name da richiamare in base
    sim01            alla istanza in cui ci troviamo
    

}

namespace eval iter {}

ad_proc -public iter::call_decodifica_asserzioni_spid {
    ls_token
    {show_xml "false"}
} {
    proc utilizzata da UCIT per verificare il login con lo spid.
    La proc chiama il WS di verifica della response tramite la lista di valori passata in input che contiene i seguenti 
    valori
    -username: codice fiscale da verificare
    -cod_domino: parametro necessario al ws di verifica accertazione passatomi in fase di login dallo spid
    -cod_applicazione: parametro necessario al ws di verifica accertazione passatomi in fase di login dallo spid
    -samlresponse: in formato base64 contiene la risposta completa dello spid (asserzione) che deve essere verificata
    Restituisce in output la lista return_esito che contiene
    i seguenti campi:
    -esito:          true o false. Viene restituito a true solo se è true il tag esito_idp
    -codice_fiscale: non viene valorizzato solo in caso di esito false a causa di errori.
    -error_message:  viene valorizzato se l'esito è false a causa di un'errore nella chiamata al ws o nella sua risposta. 
                     Quindi se il tag esito_servizio è valorizzato a false e non ho avuto eccezioni il campo resterà vuoto.
} {
    
    util_unlist $ls_token username cod_domino cod_applicazione samlresponse

    if {$username eq "null"} {

	ns_log notice "iter-spid-procs ls_token=$ls_token"

	set service_name [iter::get_service_name_spid]

	ad_returnredirect -allow_complete_url "https://loginfvg.regione.fvg.it/loginfvg/fvgaccountIdp/ServiceProviderLogoutSpid.jsp?ServiceName=$service_name&RESET_IDP_CALLBACK"
	ad_script_abort
    }
    
    set return_esito [list]
   
    set end_point "https://loginfvg.regione.fvg.it/loginfvg/services/WsExtLoginSAMLSP"

    set resp   $samlresponse
    set domain $cod_domino
    set appl   $cod_applicazione

    if {1==0} {#solo per test

	set domain "601";#solo per test
	set appl "108401";#solo per test
    set resp "PHNhbWwycDpSZXNwb25zZSB4bWxuczpzYW1sMnA9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpwcm90b2NvbCIgRGVzdGluYXRpb249Imh0dHBzOi8vbG9naW5mdmcucmVnaW9uZS5mdmcuaXQvbG9naW5mdmcvZnZnYWNjb3VudElkcC9TZXJ2aWNlUHJvdmlkZXJDYWxsYmFjay5qc3AiIElEPSJfY2FiMDViNjItYTgwZi00ODJkLTk1MWUtNzFiZmZkMjBkZDMwIiBJblJlc3BvbnNlVG89Il80QTE2NjZCM0ZGQjFEQzM2OThEREU2Q0FGODdDMDNFRDE2MTI4MDQzMjU5NjEiIElzc3VlSW5zdGFudD0iMjAyMS0wMi0wOFQxNzoxMjozNy40MDJaIiBWZXJzaW9uPSIyLjAiPjxzYW1sMjpJc3N1ZXIgeG1sbnM6c2FtbDI9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphc3NlcnRpb24iPmh0dHBzOi8vcG9zdGVpZC5wb3N0ZS5pdDwvc2FtbDI6SXNzdWVyPjxkczpTaWduYXR1cmUgeG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjxkczpTaWduZWRJbmZvPjxkczpDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PGRzOlNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48ZHM6UmVmZXJlbmNlIFVSST0iI19jYWIwNWI2Mi1hODBmLTQ4MmQtOTUxZS03MWJmZmQyMGRkMzAiPjxkczpUcmFuc2Zvcm1zPjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSIvPjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiPjxlYzpJbmNsdXNpdmVOYW1lc3BhY2VzIHhtbG5zOmVjPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiIFByZWZpeExpc3Q9ImRzIHNhbWwgc2FtbDIgc2FtbDJwICNkZWZhdWx0IHhzIHhzaSIvPjwvZHM6VHJhbnNmb3JtPjwvZHM6VHJhbnNmb3Jtcz48ZHM6RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjc2hhMjU2Ii8+PGRzOkRpZ2VzdFZhbHVlLz48L2RzOlJlZmVyZW5jZT48L2RzOlNpZ25lZEluZm8+PGRzOlNpZ25hdHVyZVZhbHVlLz48S2V5SW5mbyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFg1MDlEYXRhPjxYNTA5Q2VydGlmaWNhdGU+TUlJRUt6Q0NBeE9nQXdJQkFnSURFMlkwTUEwR0NTcUdTSWIzRFFFQkN3VUFNR0F4Q3pBSkJnTlZCQVlUQWtsVU1SZ3dGZ1lEVlFRSwpEQTlRYjNOMFpXTnZiU0JUTG5BdVFTNHhJREFlQmdOVkJBc01GME5sY25ScFptbGpZWFJwYjI0Z1FYVjBhRzl5YVhSNU1SVXdFd1lEClZRUUREQXhRYjNOMFpXTnZiU0JEUVRNd0hoY05NVFl3TWpJMk1UVTFNalEwV2hjTk1qRXdNakkyTVRVMU1qUTBXakJ4TVFzd0NRWUQKVlFRR0V3SkpWREVPTUF3R0ExVUVDQXdGU1hSaGJIa3hEVEFMQmdOVkJBY01CRkp2YldVeEhqQWNCZ05WQkFvTUZWQnZjM1JsSUVsMApZV3hwWVc1bElGTXVjQzVCTGpFTk1Bc0dBMVVFQ3d3RVUxQkpSREVVTUJJR0ExVUVBd3dMU1VSUUxWQnZjM1JsU1VRd2dnRWlNQTBHCkNTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFEWkZFdEpvRUhGQWpwQ2FaY2o1RFZXclJEeWFMWnl1MzFYQXBzbGJvODcKQ3lXejYxT0pNdHc2UVFVME1kQ3RyWWJ0U0o2dkp3eDcvNkVVanNaM3U0eDNFUExkbGt5aUdPcXVrUHdBVHY0YzdUVk9VVnM1b25JcQpUcGhNOWIrQUhSZzRlaGlNR2VzbS85ZDdSSWFMdU43OWlQVXZkTG42V1AzaWRBZkV3K3JoSi93WUVRMGgxWG01b3NOVWd0V2NCR2F2ClpJakxzc1dOckREZkpZeFhIM1FaMGtJNmZlRXZMQ0p3Z2pYTEdrQnVoRmVoTmhNNGZoYlg5aVVDV3d3a0ozSnNQMisrUmMvaVRBMEwKWmhpVXNYTk5xN2dCY0xBSjlVWDJWMWRXalR6QkhldmZIc3B6dDRlMFZnSUl3YkRScXNSdEY4VlVQU0RZWWJMb3F3Ykx0MThYQWdNQgpBQUdqZ2R3d2dka3dSZ1lEVlIwZ0JEOHdQVEF3QmdjclRBc0JBZ0VCTUNVd0l3WUlLd1lCQlFVSEFnRVdGMmgwZEhBNkx5OTNkM2N1CmNHOXpkR1ZqWlhKMExtbDBNQWtHQnl0TUN3RUJDZ0l3RGdZRFZSMFBBUUgvQkFRREFnU3dNQjhHQTFVZEl3UVlNQmFBRktjMFhQMkYKQnlZVTJsMGdGekdLRTh6VlN6Zm1NRDhHQTFVZEh3UTRNRFl3TktBeW9EQ0dMbWgwZEhBNkx5OXdiM04wWldObGNuUXVjRzl6ZEdVdQphWFF2Y0c5emRHVmpiMjFqWVRNdlkzSnNNeTVqY213d0hRWURWUjBPQkJZRUZFdnJpa1pRa2ZCanVpVHB4RXhTQmU4d0dnc3lNQTBHCkNTcUdTSWIzRFFFQkN3VUFBNElCQVFCTkF3OFVvZWlDRisxckZzMjdkM2JFZWY2Q0xlL1BKZ2E5RWZ3S0l0ak1ERDlRelQvRlNoUlcKS0xIbEs2OU1ITDFaTFBSUHZ1V1VUa0lPSFRwTnFCUElMdk8xdTEzYlNnKzZvKzJPZHFBa0NCa2JUcWJHaldTUExhVFVWTlY2TWJYbQp2dHREOFZkOXZJWmcxeEJCRzNGYWkxM2R3dlNqM2hBWmQ4dWc4YThmVzF5L2lEYlJDNUQxTytIbEhEdXZJVzRMYkowOTNqZGorb1p3ClN5ZDIxNmd0WEwwMFFBMEMxdU11RHY5V2Y5SXhuaVRiNzEwZFJTZ0ljTTQvZVI3ODMyZlpnZE9zb2FsRnpHWVd4U0NzOFdPWnJqcHUKYjFmZGFSU0V1Q1FrMitnbWRzaVJjVHM5RXFQQ0NOaU5sck5BaVdFeUd0TDhBNGFvM3BETXdDdHJiMnlyPC9YNTA5Q2VydGlmaWNhdGU+PC9YNTA5RGF0YT48L0tleUluZm8+PC9kczpTaWduYXR1cmU+PHNhbWwycDpTdGF0dXMgeG1sbnM6c2FtbDJwPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wiPjxzYW1sMnA6U3RhdHVzQ29kZSBWYWx1ZT0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnN0YXR1czpTdWNjZXNzIi8+PC9zYW1sMnA6U3RhdHVzPjxzYW1sMjpBc3NlcnRpb24geG1sbnM6c2FtbDI9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphc3NlcnRpb24iIElEPSJfZjQxZTIyNDYtNDc5NS00YTA4LTg3ZGMtODM4YTI1NmUwZDQ2IiBJc3N1ZUluc3RhbnQ9IjIwMjEtMDItMDhUMTc6MTI6MzYuNDAyWiIgVmVyc2lvbj0iMi4wIj48c2FtbDI6SXNzdWVyIEZvcm1hdD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOm5hbWVpZC1mb3JtYXQ6ZW50aXR5Ij5odHRwczovL3Bvc3RlaWQucG9zdGUuaXQ8L3NhbWwyOklzc3Vlcj48U2lnbmF0dXJlIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48U2lnbmVkSW5mbz48Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIvPjxTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNyc2Etc2hhMjU2Ii8+PFJlZmVyZW5jZSBVUkk9IiNfZjQxZTIyNDYtNDc5NS00YTA4LTg3ZGMtODM4YTI1NmUwZDQ2Ij48VHJhbnNmb3Jtcz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PC9UcmFuc2Zvcm1zPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48RGlnZXN0VmFsdWU+aFFzYUMrdDBXSXZJa2pmZGNGM283K1AzTW9wYTVscWZyUkM2MUV6ZVhhUT08L0RpZ2VzdFZhbHVlPjwvUmVmZXJlbmNlPjwvU2lnbmVkSW5mbz48U2lnbmF0dXJlVmFsdWU+Q2RpZXc4ckl4bnY3WlNNc1lyMDA0ayt4T3ZHMlpMV0lJSFFuQzNlL1dSaVRHWVpud0R3NWFhRkpUYXVTMzJJSjZBbFVIT3gyWXFvLwo1K3Brb2JTTUs2MWcxVnVLaGRFQXlTN040VHA2VTZwWklDNEt4bERkQTJqbk9PNndEelpWdmdrelJNclZyN09teUF4Y0d2WWhpNUpVClhTUDE0TU5UdHpqUlphV2xxazg0NzZUTlgxYklHZFpHUjROL0x0b1lhOEd4VWtra1BEU21CNXFXTEZUMEhkdmdQYndoMTczZ1BpbDQKeFpHNHQ1N3ptN2hPUU1IVWZFaWZkUTRieDdyam44SHJJV3lqL29sK3c3Wk0xMkZNNGwxendSYVczOFd2VFlFWGZSdDdKR1NndW1GeAoyN21rM1BVd3ZSYmdUdkxqVnFsVEtpZG01d3JkdCtPTjdzSDhWdz09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbz48WDUwOURhdGE+PFg1MDlDZXJ0aWZpY2F0ZT5NSUlFS3pDQ0F4T2dBd0lCQWdJREUyWTBNQTBHQ1NxR1NJYjNEUUVCQ3dVQU1HQXhDekFKQmdOVkJBWVRBa2xVTVJnd0ZnWURWUVFLCkRBOVFiM04wWldOdmJTQlRMbkF1UVM0eElEQWVCZ05WQkFzTUYwTmxjblJwWm1sallYUnBiMjRnUVhWMGFHOXlhWFI1TVJVd0V3WUQKVlFRRERBeFFiM04wWldOdmJTQkRRVE13SGhjTk1UWXdNakkyTVRVMU1qUTBXaGNOTWpFd01qSTJNVFUxTWpRMFdqQnhNUXN3Q1FZRApWUVFHRXdKSlZERU9NQXdHQTFVRUNBd0ZTWFJoYkhreERUQUxCZ05WQkFjTUJGSnZiV1V4SGpBY0JnTlZCQW9NRlZCdmMzUmxJRWwwCllXeHBZVzVsSUZNdWNDNUJMakVOTUFzR0ExVUVDd3dFVTFCSlJERVVNQklHQTFVRUF3d0xTVVJRTFZCdmMzUmxTVVF3Z2dFaU1BMEcKQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURaRkV0Sm9FSEZBanBDYVpjajVEVldyUkR5YUxaeXUzMVhBcHNsYm84NwpDeVd6NjFPSk10dzZRUVUwTWRDdHJZYnRTSjZ2Snd4Ny82RVVqc1ozdTR4M0VQTGRsa3lpR09xdWtQd0FUdjRjN1RWT1VWczVvbklxClRwaE05YitBSFJnNGVoaU1HZXNtLzlkN1JJYUx1Tjc5aVBVdmRMbjZXUDNpZEFmRXcrcmhKL3dZRVEwaDFYbTVvc05VZ3RXY0JHYXYKWklqTHNzV05yRERmSll4WEgzUVowa0k2ZmVFdkxDSndnalhMR2tCdWhGZWhOaE00ZmhiWDlpVUNXd3drSjNKc1AyKytSYy9pVEEwTApaaGlVc1hOTnE3Z0JjTEFKOVVYMlYxZFdqVHpCSGV2ZkhzcHp0NGUwVmdJSXdiRFJxc1J0RjhWVVBTRFlZYkxvcXdiTHQxOFhBZ01CCkFBR2pnZHd3Z2Rrd1JnWURWUjBnQkQ4d1BUQXdCZ2NyVEFzQkFnRUJNQ1V3SXdZSUt3WUJCUVVIQWdFV0YyaDBkSEE2THk5M2QzY3UKY0c5emRHVmpaWEowTG1sME1Ba0dCeXRNQ3dFQkNnSXdEZ1lEVlIwUEFRSC9CQVFEQWdTd01COEdBMVVkSXdRWU1CYUFGS2MwWFAyRgpCeVlVMmwwZ0Z6R0tFOHpWU3pmbU1EOEdBMVVkSHdRNE1EWXdOS0F5b0RDR0xtaDBkSEE2THk5d2IzTjBaV05sY25RdWNHOXpkR1V1CmFYUXZjRzl6ZEdWamIyMWpZVE12WTNKc015NWpjbXd3SFFZRFZSME9CQllFRkV2cmlrWlFrZkJqdWlUcHhFeFNCZTh3R2dzeU1BMEcKQ1NxR1NJYjNEUUVCQ3dVQUE0SUJBUUJOQXc4VW9laUNGKzFyRnMyN2QzYkVlZjZDTGUvUEpnYTlFZndLSXRqTUREOVF6VC9GU2hSVwpLTEhsSzY5TUhMMVpMUFJQdnVXVVRrSU9IVHBOcUJQSUx2TzF1MTNiU2crNm8rMk9kcUFrQ0JrYlRxYkdqV1NQTGFUVVZOVjZNYlhtCnZ0dEQ4VmQ5dklaZzF4QkJHM0ZhaTEzZHd2U2ozaEFaZDh1ZzhhOGZXMXkvaURiUkM1RDFPK0hsSER1dklXNExiSjA5M2pkaitvWncKU3lkMjE2Z3RYTDAwUUEwQzF1TXVEdjlXZjlJeG5pVGI3MTBkUlNnSWNNNC9lUjc4MzJmWmdkT3NvYWxGekdZV3hTQ3M4V09acmpwdQpiMWZkYVJTRXVDUWsyK2dtZHNpUmNUczlFcVBDQ05pTmxyTkFpV0V5R3RMOEE0YW8zcERNd0N0cmIyeXI8L1g1MDlDZXJ0aWZpY2F0ZT48L1g1MDlEYXRhPjwvS2V5SW5mbz48L1NpZ25hdHVyZT48c2FtbDI6U3ViamVjdD48c2FtbDI6TmFtZUlEIEZvcm1hdD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOm5hbWVpZC1mb3JtYXQ6dHJhbnNpZW50IiBOYW1lUXVhbGlmaWVyPSJodHRwczovL3Bvc3RlaWQucG9zdGUuaXQiPlNQSUQtYTc0M2UzMjYtMWEzOC00MGMwLWJkNDctMTUzOTk5YTUyYjkyPC9zYW1sMjpOYW1lSUQ+PHNhbWwyOlN1YmplY3RDb25maXJtYXRpb24gTWV0aG9kPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6Y206YmVhcmVyIj48c2FtbDI6U3ViamVjdENvbmZpcm1hdGlvbkRhdGEgSW5SZXNwb25zZVRvPSJfNEExNjY2QjNGRkIxREMzNjk4RERFNkNBRjg3QzAzRUQxNjEyODA0MzI1OTYxIiBOb3RPbk9yQWZ0ZXI9IjIwMjEtMDItMDhUMTc6MTM6MzYuNDAyWiIgUmVjaXBpZW50PSJodHRwczovL2xvZ2luZnZnLnJlZ2lvbmUuZnZnLml0L2xvZ2luZnZnL2Z2Z2FjY291bnRJZHAvU2VydmljZVByb3ZpZGVyQ2FsbGJhY2suanNwIi8+PC9zYW1sMjpTdWJqZWN0Q29uZmlybWF0aW9uPjwvc2FtbDI6U3ViamVjdD48c2FtbDI6Q29uZGl0aW9ucyBOb3RCZWZvcmU9IjIwMjEtMDItMDhUMTc6MTI6MzYuNDAyWiIgTm90T25PckFmdGVyPSIyMDIxLTAyLTA4VDE3OjEzOjM2LjQwMloiPjxzYW1sMjpBdWRpZW5jZVJlc3RyaWN0aW9uPjxzYW1sMjpBdWRpZW5jZT5odHRwczovL2xvZ2luZnZnLnJlZ2lvbmUuZnZnLml0L2xvZ2luZnZnL01ldGFkYXRhUHVibGlzaGVyU2VydmxldD9tZXRhPVNQbWV0YWRhdGE8L3NhbWwyOkF1ZGllbmNlPjwvc2FtbDI6QXVkaWVuY2VSZXN0cmljdGlvbj48L3NhbWwyOkNvbmRpdGlvbnM+PHNhbWwyOkF1dGhuU3RhdGVtZW50IEF1dGhuSW5zdGFudD0iMjAyMS0wMi0wOFQxNzoxMjozNi40MDJaIiBTZXNzaW9uSW5kZXg9Implc1FwUURpc0RleWFPKys3OEhoYWZvMWxlak5mSlc2QVFWb0FDSlNDbGp3SlZ4M21icTVDcG4yMXVpSlVjUlYiPjxzYW1sMjpBdXRobkNvbnRleHQ+PHNhbWwyOkF1dGhuQ29udGV4dENsYXNzUmVmPmh0dHBzOi8vd3d3LnNwaWQuZ292Lml0L1NwaWRMMTwvc2FtbDI6QXV0aG5Db250ZXh0Q2xhc3NSZWY+PC9zYW1sMjpBdXRobkNvbnRleHQ+PC9zYW1sMjpBdXRoblN0YXRlbWVudD48c2FtbDI6QXR0cmlidXRlU3RhdGVtZW50PjxzYW1sMjpBdHRyaWJ1dGUgRnJpZW5kbHlOYW1lPSJOb21lIiBOYW1lPSJuYW1lIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6dHlwZT0ieHM6c3RyaW5nIj5TSU1PTkU8L3NhbWwyOkF0dHJpYnV0ZVZhbHVlPjwvc2FtbDI6QXR0cmlidXRlPjxzYW1sMjpBdHRyaWJ1dGUgRnJpZW5kbHlOYW1lPSJDb2dub21lIiBOYW1lPSJmYW1pbHlOYW1lIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6dHlwZT0ieHM6c3RyaW5nIj5QRVNDSTwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PHNhbWwyOkF0dHJpYnV0ZSBGcmllbmRseU5hbWU9IkNvZGljZSBmaXNjYWxlIiBOYW1lPSJmaXNjYWxOdW1iZXIiPjxzYW1sMjpBdHRyaWJ1dGVWYWx1ZSB4bWxuczp4cz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEiIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTp0eXBlPSJ4czpzdHJpbmciPlRJTklULVBTQ1NNTjg5UjE0QTQ3MEk8L3NhbWwyOkF0dHJpYnV0ZVZhbHVlPjwvc2FtbDI6QXR0cmlidXRlPjxzYW1sMjpBdHRyaWJ1dGUgRnJpZW5kbHlOYW1lPSJJbmRpcml6em8gZGkgcG9zdGEgZWxldHRyb25pY2EiIE5hbWU9ImVtYWlsIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6dHlwZT0ieHM6c3RyaW5nIj5wZXNjaS5zaW1vbmVAZ21haWwuY29tPC9zYW1sMjpBdHRyaWJ1dGVWYWx1ZT48L3NhbWwyOkF0dHJpYnV0ZT48L3NhbWwyOkF0dHJpYnV0ZVN0YXRlbWVudD48L3NhbWwyOkFzc2VydGlvbj48c2FtbDpBc3NlcnRpb24geG1sbnM6c2FtbD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmFzc2VydGlvbiIgSUQ9Il81REUxNUJFMTUyRjQ1QUE0NTNGMDdCMzVBNDA4OTIzNjE2MTI4MDQzNTY4NDkiIElzc3VlSW5zdGFudD0iMjAyMS0wMi0wOFQxNzoxMjozNi4wMDBaIiBWZXJzaW9uPSIyLjAiPjxzYW1sOklzc3Vlcj5odHRwczovL2xvZ2luZnZnLnJlZ2lvbmUuZnZnLml0L2xvZ2luZnZnL01ldGFkYXRhUHVibGlzaGVyU2VydmxldD9tZXRhPUFBbWV0YWRhdGE8L3NhbWw6SXNzdWVyPjxkczpTaWduYXR1cmUgeG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjxkczpTaWduZWRJbmZvPjxkczpDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PGRzOlNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48ZHM6UmVmZXJlbmNlIFVSST0iI181REUxNUJFMTUyRjQ1QUE0NTNGMDdCMzVBNDA4OTIzNjE2MTI4MDQzNTY4NDkiPjxkczpUcmFuc2Zvcm1zPjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSIvPjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiPjxlYzpJbmNsdXNpdmVOYW1lc3BhY2VzIHhtbG5zOmVjPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiIFByZWZpeExpc3Q9ImRzIHNhbWwiLz48L2RzOlRyYW5zZm9ybT48L2RzOlRyYW5zZm9ybXM+PGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPjxkczpEaWdlc3RWYWx1ZT5RTzMyL2FGa2Zvb3NqcktZaXU4VkJQNDdXdFlDWXFtalY3aWxYVmhnSWVNPTwvZHM6RGlnZXN0VmFsdWU+PC9kczpSZWZlcmVuY2U+PC9kczpTaWduZWRJbmZvPjxkczpTaWduYXR1cmVWYWx1ZT5FVFJYNXY1SlN0eGh3Wk9VN3d3TVdPUTNIajdIZWF5aEJ4a3g4ZXJ5bG5yd1I2Y2QwQVFrZkp6ZzBZQTlzay95ZDUwa2N2S0plMml1SXZiamEzR0srSGdRRTV4ZUhZTWhxRklibUwybXRjVDcyYmtXYTlub1FvWms0T2E1N0pWZUx6YlZNNDhKV0dMK0xSdlkzL1pCWkNkV2x6WnBUaEc1SnlYeEFnZ1Q3UHZHTGRUeVBGYThZdW5XNlkxT1NOTzYrRzNjbTRMK0g5alFNREpERjRPbHlKWTRvTmlqRFFQME5wVkRCa21JQ0RtcW56NU54RmlPcnI5VWZlTTU4UGxBY2tVYjNxbU45MkxsNzR5aHdrejUxc3QzNUdpY2JFdmxPZHlEdFlFcVRPdDNObHh4ZHNEenVpUkoxS1JUc1lIK2FLdVBJakxpZU1Rd1BpZnlLNXFJbUE9PTwvZHM6U2lnbmF0dXJlVmFsdWU+PGRzOktleUluZm8+PGRzOlg1MDlEYXRhPjxkczpYNTA5Q2VydGlmaWNhdGU+TUlJRldqQ0NCRUtnQXdJQkFnSVFERnI2SW9SVXFpVk0vMTRVTitVYW96QU5CZ2txaGtpRzl3MEJBUXNGQURCd01Rc3dDUVlEVlFRR0V3SlZVekVWTUJNR0ExVUVDaE1NUkdsbmFVTmxjblFnU1c1ak1Sa3dGd1lEVlFRTEV4QjNkM2N1WkdsbmFXTmxjblF1WTI5dE1TOHdMUVlEVlFRREV5WkVhV2RwUTJWeWRDQlRTRUV5SUVocFoyZ2dRWE56ZFhKaGJtTmxJRk5sY25abGNpQkRRVEFlRncweE5EQTVNVFl3TURBd01EQmFGdzB4TnpFd01ESXhNakF3TURCYU1HOHhDekFKQmdOVkJBWVRBa2xVTVFzd0NRWURWUVFJRXdKVVV6RVFNQTRHQTFVRUJ4TUhWSEpwWlhOMFpURW1NQ1FHQTFVRUNoTWRVbVZuYVc5dVpTQkdjbWwxYkdrZ1ZtVnVaWHBwWVNCSGFYVnNhV0V4R1RBWEJnTlZCQU1NRUNvdWNtVm5hVzl1WlM1bWRtY3VhWFF3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRREdkRHNtUVBOWkhrRlZlWkdOMGg1eG5mY1pOOHFSblNYZy9obnZjbmJjSzJBOXdxbjQxclNtMEFMWHJaU2U5MTYzWCs2N2dEMHppd0NvNHZZOURpcTRkUU80Vjh5WkhGczdPeEVZbnNhcHNsYWR4RWpqWml2dDBMakZoSTBPeGtKKzU1V3RIS0tlYlFoRXl0VTJnRDN3Qk95aWFqN1pXS3RjMDg0cUtlVnJ1QVg3YkRvVWl5K2h5aVJhVDg1aTh5N2RpQ1U5THZIakFYbFloNG5ZOXJyYVNlOFlnWHE1OGJZUzJvZk5QcGtVTS9ia3ZtTGVOaUU4elUrL0plMEtzVHFNdzJHMmlRNXBvVXlYV055eHFtMXVpSVl0TXZqby9Wd2JOZEc4bXQ1WGRBNU4xR2gwL2dyZHhiWnhDdFJDSmtiUjZEU05TWkNnMnNBTVlyUnkyU3k3QWdNQkFBR2pnZ0h2TUlJQjZ6QWZCZ05WSFNNRUdEQVdnQlJSYVArUXJ3SUhkVHpNMldWa1lxSVN1Rmx5T3pBZEJnTlZIUTRFRmdRVXA0eHA3M0FKa0FkR3Q4aWk1Y2NFcE5mV05LWXdLd1lEVlIwUkJDUXdJb0lRS2k1eVpXZHBiMjVsTG1aMlp5NXBkSUlPY21WbmFXOXVaUzVtZG1jdWFYUXdEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHQVFVRkJ3TUJCZ2dyQmdFRkJRY0RBakIxQmdOVkhSOEViakJzTURTZ01xQXdoaTVvZEhSd09pOHZZM0pzTXk1a2FXZHBZMlZ5ZEM1amIyMHZjMmhoTWkxb1lTMXpaWEoyWlhJdFp6SXVZM0pzTURTZ01xQXdoaTVvZEhSd09pOHZZM0pzTkM1a2FXZHBZMlZ5ZEM1amIyMHZjMmhoTWkxb1lTMXpaWEoyWlhJdFp6SXVZM0pzTUVJR0ExVWRJQVE3TURrd053WUpZSVpJQVliOWJBRUJNQ293S0FZSUt3WUJCUVVIQWdFV0hHaDBkSEJ6T2k4dmQzZDNMbVJwWjJsalpYSjBMbU52YlM5RFVGTXdnWU1HQ0NzR0FRVUZCd0VCQkhjd2RUQWtCZ2dyQmdFRkJRY3dBWVlZYUhSMGNEb3ZMMjlqYzNBdVpHbG5hV05sY25RdVkyOXRNRTBHQ0NzR0FRVUZCekFDaGtGb2RIUndPaTh2WTJGalpYSjBjeTVrYVdkcFkyVnlkQzVqYjIwdlJHbG5hVU5sY25SVFNFRXlTR2xuYUVGemMzVnlZVzVqWlZObGNuWmxja05CTG1OeWREQU1CZ05WSFJNQkFmOEVBakFBTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFDcXhOeXdIR0pxZis2NVMzTTZCMlQxc3o4bTNYYk56QVlRM0ltRGhUTWVWNU5pWVZVaVFka3d6ejFjak54UFhETEFrb2RMU0xrVnpxZDdDSUVWZXlxcTNyNjJnQk42MlBXNWRCaDdWcUFLajhLY1RrVWh0YVVXK3NwTENvR0tqU083bVc4YW9SZm9OT1V1TmxpQis3K2JmY3p5NnRqVWlCdmNRbzR0Y0Zxd3JBL3N3N3R2OFBmWUE1bWlHQTl3NS81SDdqc1RnRXV4TWVKcGtDN1lQM095djZrb0QvVnJQVlY5WU9ncDhCQmMyTitGUWpmVGVyNGd0Qy9WNHVWWStXS1J2cjZRdjF4dlU2ZUNmTFZySHVKMXZkS2hUenFpZVhPRDBsNGEvcDNhWmxrRmtJK2psUUpJZzBUVlJFTWt4YkxTVVFJY2x5TkVSSml1Y1pWN1hvZUo8L2RzOlg1MDlDZXJ0aWZpY2F0ZT48L2RzOlg1MDlEYXRhPjxkczpLZXlWYWx1ZT48ZHM6UlNBS2V5VmFsdWU+PGRzOk1vZHVsdXM+eG5RN0prRHpXUjVCVlhtUmpkSWVjWjMzR1RmS2taMGw0UDRaNzNKMjNDdGdQY0twK05hMHB0QUMxNjJVbnZkZXQxL3V1NEE5TTRzQXFPTDJQUTRxdUhVRHVGZk1tUnhiT3pzUkdKN0dxYkpXbmNSSTQyWXI3ZEM0eFlTTkRzWkNmdWVWclJ5aW5tMElSTXJWTm9BOThBVHNvbW8rMlZpclhOUE9LaW5sYTdnRisydzZGSXN2b2Nva1drL09Zdk11M1lnbFBTN3g0d0Y1V0llSjJQYTYya252R0lGNnVmRzJFdHFIelQ2WkZEUDI1TDVpM2pZaFBNMVB2eVh0Q3JFNmpNTmh0b2tPYWFGTWwxamNzYXB0Ym9pR0xUTDQ2UDFjR3pYUnZKcmVWM1FPVGRSb2RQNEszY1cyY1FyVVFpWkcwZWcwalVtUW9OckFER0swY3Rrc3V3PT08L2RzOk1vZHVsdXM+PGRzOkV4cG9uZW50PkFRQUI8L2RzOkV4cG9uZW50PjwvZHM6UlNBS2V5VmFsdWU+PC9kczpLZXlWYWx1ZT48L2RzOktleUluZm8+PC9kczpTaWduYXR1cmU+PHNhbWw6U3ViamVjdD48c2FtbDpOYW1lSUQgRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6bmFtZWlkLWZvcm1hdDp0cmFuc2llbnQiIE5hbWVRdWFsaWZpZXI9Imh0dHBzOi8vbG9naW5mdmcucmVnaW9uZS5mdmcuaXQvbG9naW5mdmcvTWV0YWRhdGFQdWJsaXNoZXJTZXJ2bGV0P21ldGE9QUFtZXRhZGF0YSI+UFNDU01OODlSMTRBNDcwSTwvc2FtbDpOYW1lSUQ+PHNhbWw6U3ViamVjdENvbmZpcm1hdGlvbiBNZXRob2Q9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpjbTpiZWFyZXIiPjxzYW1sOlN1YmplY3RDb25maXJtYXRpb25EYXRhIE5vdE9uT3JBZnRlcj0iMjAyMS0wOC0wOFQxNjoxMjozNi4wMDBaIi8+PC9zYW1sOlN1YmplY3RDb25maXJtYXRpb24+PC9zYW1sOlN1YmplY3Q+PHNhbWw6Q29uZGl0aW9ucyBOb3RCZWZvcmU9IjIwMjEtMDItMDhUMTc6MTI6MzYuMDAwWiIgTm90T25PckFmdGVyPSIyMDIxLTA4LTA4VDE2OjEyOjM2LjAwMFoiLz48c2FtbDpBdHRyaWJ1dGVTdGF0ZW1lbnQvPjwvc2FtbDpBc3NlcnRpb24+PC9zYW1sMnA6UmVzcG9uc2U+";#solo per test

	}


    set buffer "
<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><soapenv:Body>
<verifySAMLResposeSpid>
<resp>$resp</resp>
<domain>$domain</domain>
<appl>$appl</appl>
</verifySAMLResposeSpid>
</soapenv:Body></soapenv:Envelope>
"
    
    if {$username eq ""} {

	#caso in cui l'utente ha fatto il login allo spid ma non ha accettato di fornire i propri dati

	set error_msg "<ERRORE><CODE>username errato</CODE><DESCRIPTION>Non è stato fornito in input un username</DESCRIPTION></ERRORE>"
	
	set return_esito [list false "" $error_msg] 
	
	return $return_esito
	
    }

    set soapaction "soapAction: verifySAMLResposeSpidRequest"
    set buffer [regsub -all \r $buffer ""]
    set buffer [regsub -all \n $buffer ""]
    
    set spool_dir     [iter_set_spool_dir]

    set nome_file_temp     "spid-login"
    set nome_file_temp      [iter_temp_file_name $nome_file_temp]
    set path_file_input    "$spool_dir/${nome_file_temp}-input.xml"
    set path_file_response "$spool_dir/${nome_file_temp}-response.xml"
    set path_file_trace    "$spool_dir/${nome_file_temp}-trace.txt"
        
    set         file_id [open $path_file_input w]
    puts       $file_id "$buffer"
    close      $file_id

    exec curl \
	-vs \
        -k \
        -d @$path_file_input \
        -X POST \
	-H $soapaction \
        --connect-timeout 100 \
        --trace-ascii $path_file_trace \
        $end_point > $path_file_response
      
    set error_num 0
    set xml_responce ""
    if {![file exists $path_file_response]} {
	
	set error_msg "<ERRORE><CODE>Errore interno</CODE><DESCRIPTION>iter::call_decodifica_asserzioni_spid: Non e' stata ottenuta una risposta dal web service chiamato</DESCRIPTION></ERRORE>"
	
	incr error_num
	
    } else {
	
	set         file_id  [open $path_file_response r]
	fconfigure $file_id -encoding utf-8
	set response [read $file_id]
	close      $file_id
	
	set codice_errore      ""
	regexp {<faultcode>(.*)</faultcode>}     $response match codice_errore
	
	set descrizione_errore ""
	regexp {<faultstring>(.*)</faultstring>} $response match descrizione_errore
        
	if {   (   ![string is space $codice_errore]
		   || ![string is space $descrizione_errore])
	       &&  $codice_errore ne ""
	   } {
	    
	    set error_msg "<ERRORE><CODE>$codice_errore</CODE><DESCRIPTION>$descrizione_errore</DESCRIPTION></ERRORE>"
	    incr error_num
	}        
    }
    
    if {$error_num == 0} {
	
	set xml_responce ""
	regexp {<verifySAMLResposeSpidReturn>(.*)</verifySAMLResposeSpidReturn>} $response match xml_responce
	
	if {[string is space $xml_responce]} {

	    regexp {<ns1:verifySAMLResposeSpidReturn xmlns:ns1=\"http://loginfvg.regione.fvg.it/loginfvg/services/WsExtLoginSAMLSP\">(.*)</ns1:verifySAMLResposeSpidReturn>} $response match xml_responce

	}

	if {[string is space $xml_responce]} {

	    regexp {<ns1:verifySAMLResposeSpidReturn xmlns:ns1=\"https://loginfvg.regione.fvg.it/loginfvg/services/WsExtLoginSAMLSP\">(.*)</ns1:verifySAMLResposeSpidReturn>} $response match xml_responce

	}

	if {[string is space $xml_responce]} {
	    
	    set error_msg "<ERRORE><CODE>Errore xml</CODE><DESCRIPTION>Il tag verifySAMLResposeSpidReturn è vuoto. Vedere il file $path_file_response</DESCRIPTION></ERRORE>"
	    incr error_num

	} else {

	    set xml_responce [ad_unquotehtml $xml_responce]
	
	    #in caso di idresp non corretto, mi viene restituito il seguente xml: <?xml version="1.0" encoding="UTF-8"?><XML_RESPONSE>
	    
	    if {$xml_responce eq "<?xml version=\"1.0\" encoding=\"UTF-8\"?><XML_RESPONSE>"} {
		
		set error_msg "<ERRORE><CODE>Errore xml</CODE><DESCRIPTION>La response del ws di verifica contiene solo <?xml version=\"1.0\" encoding=\"UTF-8\"?><XML_RESPONSE>. Avviene in caso di idresp di input non valido</DESCRIPTION></ERRORE>"
		incr error_num

	    } else {

#		set root_id [ah_xml_get_root_id $xml_responce]

#		ah_dom_explorer -node $root_id

		set esito_idp "false"
		regexp {<ESITO_IDP>(.*)</ESITO_IDP>} $xml_responce match esito_idp

		set codice_fiscale ""
		regexp {<CODICE_FISCALE tipo="globale">(.*)</CODICE_FISCALE>} $xml_responce match codice_fiscale

		set username_controllo "";#rom01
		regexp {<USERNAME tipo="globale">(.*)</USERNAME>} $xml_responce match username_controllo;#rom01

		#rom01 if {$codice_fiscale ne $username} {}
		if {$username_controllo ne $username} {
		    #rom01 set error_msg "<ERRORE><CODE>Errore di incogruenza dei CF</CODE><DESCRIPTION>Il CF salvato nel token ($username) non coincide con quello restituito dal ws ($codice_fiscale)</DESCRIPTION></ERRORE>"
		    set error_msg "<ERRORE><CODE>Errore di incogruenza dei CF</CODE><DESCRIPTION>l'utente CF salvato nel token ($username) non coincide con quello restituito dal ws ($username_controllo)</DESCRIPTION></ERRORE>"

		    incr error_num
		}

	    }   	    
	}	

    } 

    if {$error_num !=0} {
	set return_esito [list false "" $error_msg] 
    } else {
	set return_esito [list $esito_idp $codice_fiscale ""]
	
	#pulisco i file della chiamata al ws
	exec rm $path_file_input
	exec rm $path_file_response
	exec rm $path_file_trace
    }

    if {$show_xml eq true} {
	#usato solo per i test
	lappend return_esito $xml_responce
    }

    return $return_esito

}

ad_proc -public iter::get_service_name_spid {
} {

	set db_name [db_get_database]
	set service_name ""

	if {$db_name eq "iterprud-dev"} {
	    set service_name "ITERColl"
	} elseif {$db_name eq "iterprud"} {
	    set service_name "ITERUd"
	} elseif {$db_name eq "iterprts"} {
	    set service_name "ITERTs"
	} elseif {$db_name eq "iterprpn"} {
	    set service_name "ITERPn"
	} elseif {$db_name eq "iterprgo"} {
	    set service_name "ITERGo"
	} elseif {$db_name eq "itercmtrieste"} {
	    set service_name "ITERTsCom"
	} elseif {$db_name eq "itercmpordenone"} {
	    set service_name "ITERPnCom"
	} else {

	}
	
	return $service_name
}
