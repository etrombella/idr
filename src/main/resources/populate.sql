TRUNCATE TABLE opper.dbo.IDIR_AGENTE;

insert into opper.dbo.IDIR_AGENTE 
(  
	CODICE_AGENTE
	,AGENTE_ID
	,NOME
	,COGNOME
	,AREA_ID
	,AREA_DESCRIZIONE 
	,AREA_SUB_ID 
	,AREA_SUB_DESCRIZIONE 
) 
SELECT 	Vision.dbo.Agenti.Codice					
		,Vision.dbo.Agenti.ID						
		,Vision.dbo.Contatti.Nome					
		,Vision.dbo.Contatti.Cognome				
		,Vision.dbo._Maurizio_Agenti_Gruppi_1.ID					
		,Vision.dbo._Maurizio_Agenti_Gruppi_1.Gruppo1					
		,Vision.dbo._Maurizio_Agenti_Gruppo_2.ID					
		,Vision.dbo._Maurizio_Agenti_Gruppo_2.Gruppo2Ordine					
from 	Vision.dbo.Agenti
		,Vision.dbo.Contatti
		,Vision.dbo._Maurizio_Agenti_Gruppi_1
		,Vision.dbo._Maurizio_Agenti_Gruppo_2
		,Vision.dbo._Maurizio_AgentiID_Gruppi2ID
WHERE	Vision.dbo.Agenti.ContattiID 						= 	Vision.dbo.Contatti.ID
AND		Vision.dbo._Maurizio_Agenti_Gruppi_1.ID 			= 	Vision.dbo._Maurizio_Agenti_Gruppo_2.Gruppo1ID
AND		Vision.dbo._Maurizio_Agenti_Gruppo_2.ID 			= 	Vision.dbo._Maurizio_AgentiID_Gruppi2ID.AgenteGruppo2ID
AND		Vision.dbo._Maurizio_AgentiID_Gruppi2ID.AgenteID 	= 	Vision.dbo.Agenti.ID;

TRUNCATE TABLE opper.dbo.IDIR_FORNITORI;

insert into opper.dbo.IDIR_FORNITORI 
(  
	ID_CLIENTEFORNITORE 
	,CODICE_FORNITORE
	,NOME 
	,COGNOME 
	,INDIRIZZO 
	,CAP 
	,COMUNE 
	,PROVINCIA 
	,REGIONE 
	,NAZIONE_SIGLA 
	,NAZIONE 
	,PARTITAIVA 
	,CODICE_FISCALE 
) 
SELECT		Vision.dbo.ClientiFornitori.ID AS ClientiFornitoriID,
			Vision.dbo.ContattiContabili.Codice AS Codice_Fornitore,
			Vision.dbo.Contatti.Nome as Nome,
			Vision.dbo.Contatti.Cognome as Cognome,
			Vision.dbo.Contatti.Indirizzo, 
			Vision.dbo.Contatti.Cap, 
			Vision.dbo.Contatti.Comune, 
			Vision.dbo.Contatti.Provincia,
			Vision.dbo.Regioni.Descrizione,
			Vision.dbo.PaesiCee.Sigla,
			Vision.dbo.PaesiCee.Descrizione,
			Vision.dbo.Contatti.PartitaIVA,
			Vision.dbo.Contatti.CodiceFiscale
FROM   		Vision.dbo.ClientiFornitori,
            Vision.dbo.ContattiContabili ,
            Vision.dbo.Contatti ,
            Vision.dbo.Fornitori ,
			Vision.dbo.Regioni,
			Vision.dbo.PaesiCee
WHERE	Vision.dbo.ClientiFornitori.ContattiContabiliID 	= Vision.dbo.ContattiContabili.ID
AND 	Vision.dbo.ContattiContabili.ContattoID 			= Vision.dbo.Contatti.ID
AND 	Vision.dbo.ClientiFornitori.ID 						= Vision.dbo.Fornitori.ClientiFornitoriID
AND 	Vision.dbo.Contatti.RegioniID 						= Vision.dbo.Regioni.ID
AND 	Vision.dbo.Contatti.PaesiCeeID 						= Vision.dbo.PaesiCee.ID
AND 	Vision.dbo.ContattiContabili.ContattiTipoID 		IN (3,10);

TRUNCATE TABLE opper.dbo.IDIR_CLIENTE;

insert into opper.dbo.IDIR_CLIENTE 
(  
	CLIENTIFORNITORIID
	,ID_AGENTE 
	,NOME 
	,COGNOME 
	,CODICE_CLIENTE
	,INDIRIZZO 
	,CAP 
	,COMUNE 
	,PROVINCIA  
	,REGIONE 
	,NAZIONE_SIGLA 
	,NAZIONE 
	,PARTITAIVA 
	,CODICE_FISCALE 
	,BLOCCO_INSOLUTI
) 
SELECT		Vision.dbo.ClientiFornitori.ID AS ClientiFornitoriID,
			Vision.dbo.Agenti.ID AS ID_AGENTE, /*questa riga va cambiata per mettere l'ID AGENTE della nostra tabella AGENTI*/
			Vision.dbo.Contatti.Nome as Nome,
			Vision.dbo.Contatti.Cognome as Cognome,
			Vision.dbo.ContattiContabili.Codice AS Codice_Cliente,
			Vision.dbo.Contatti.Indirizzo, 
			Vision.dbo.Contatti.Cap, 
			Vision.dbo.Contatti.Comune, 
			Vision.dbo.Contatti.Provincia,
			Vision.dbo.Regioni.Descrizione,
			Vision.dbo.PaesiCee.Sigla,
			Vision.dbo.PaesiCee.Descrizione,
			Vision.dbo.Contatti.PartitaIVA,
			Vision.dbo.Contatti.CodiceFiscale,
			CASE BlocchiInsoluti.BloccoInsoluti WHEN 'S' THEN 'S' ELSE 'N' END as BloccoInsoluti
FROM   		Vision.dbo.ClientiFornitori LEFT JOIN
			(SELECT 
			DISTINCT 
				Vision.dbo.ClientiFornitoriBlocchi.ClientiFornitoriID, 
				CASE Vision.dbo.ClientiFornitoriBlocchi.BlocchiMotivazioniID WHEN 1 THEN 'S' END AS BloccoInsoluti
				FROM     Vision.dbo.ClientiFornitoriBlocchi INNER JOIN
						Vision.dbo.BlocchiMotivazioni ON Vision.dbo.ClientiFornitoriBlocchi.BlocchiMotivazioniID = Vision.dbo.BlocchiMotivazioni.ID
				WHERE  (Vision.dbo.ClientiFornitoriBlocchi.ClientiFornitoriID > 0) AND (Vision.dbo.ClientiFornitoriBlocchi.BlocchiMotivazioniID = 1)) as BlocchiInsoluti ON BlocchiInsoluti.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID,
            Vision.dbo.ContattiContabili ,
            Vision.dbo.Contatti ,
            Vision.dbo.Clienti ,
            Vision.dbo.Agenti,
			Vision.dbo.Regioni,
			Vision.dbo.PaesiCee
WHERE	Vision.dbo.ClientiFornitori.ContattiContabiliID 	= Vision.dbo.ContattiContabili.ID
AND 	Vision.dbo.ContattiContabili.ContattoID 			= Vision.dbo.Contatti.ID
AND 	Vision.dbo.ClientiFornitori.ID 						= Vision.dbo.Clienti.ClientiFornitoriID
AND 	Vision.dbo.Clienti.AgenteID 						= Vision.dbo.Agenti.ID
AND 	Vision.dbo.Contatti.RegioniID 						= Vision.dbo.Regioni.ID
AND 	Vision.dbo.Contatti.PaesiCeeID 						= Vision.dbo.PaesiCee.ID
AND 	Vision.dbo.ContattiContabili.ContattiTipoID 		IN(2,10);

TRUNCATE TABLE opper.dbo.IDIR_IMPEGNI_CLIENTI ;

insert into opper.dbo.IDIR_IMPEGNI_CLIENTI 
(  
	LISTA_RIGA_ID
	,LISTA_ID
	,DATA_IMPEGNO
	,NUMERO_IMPEGNO
	,QTA
	,COSTO_UNITARIO
	,PREZZO_BASE
	,DATA_CONSEGNA
	,ARTICOLO_ID
	,ID_CLIENTE
	,ID_MAGAZZINO
	,TIPO_RIGA
	,QTA_INEVASA 
	,INEV_QTA
	,IMP_VAL
	,INEV_VAL
	,QTA_FORZATA 
	,BACK_ORDER 
	,PROVENIENZA 
) 
SELECT  Vision.dbo.ListeRighe.id as ListeRigheID               
        ,Vision.dbo.Liste.id as ListeID                     
        ,Vision.dbo.Liste.Data AS [Data_Impegno]
		,Vision.dbo.Liste.Numero AS [Numero_Impegno]
        ,Vision.dbo.ListeRighe.Quantita as QTA_IMP
		,Vision.dbo.ListeRighe.ListinoCosto
        ,Vision.dbo.ListeRighe.PREZZO                     
        ,Vision.dbo.ListeRighe.Dataconsegna             
        ,Vision.dbo.ListeRighe.Articoloid       
        ,opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE   
		,Vision.dbo.Liste.MagazziniID
		,Vision.dbo.CausaliMagazzino.Descrizione,
		Vision.dbo.ListeRighe.Quantita - ISNULL(
													(SELECT SUM(Quantita) AS QuantitaEvasa 
													FROM   Vision.dbo.ListeRighe AS ListeRighe_1
													WHERE  (ParentListeRigheID = Vision.dbo.ListeRighe.ID)
												), 0) AS [Quantita_Inevasa],
		Vision.dbo.ListeRighe.Quantita - ISNULL
                          ((SELECT     SUM(Quantita) AS QuantitaEvasa
                              FROM         Vision.dbo.ListeRighe AS ListeRighe_1
                              WHERE     (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0) AS [Inev.Qta],
							  Vision.dbo.ListeRighe.Importo AS [Imp.Val],
		(Vision.dbo.ListeRighe.Importo / Vision.dbo.ListeRighe.Quantita) 
                      * (Vision.dbo.ListeRighe.Quantita - ISNULL
                          ((SELECT     SUM(Quantita) AS QuantitaEvasa

                              FROM         Vision.dbo.ListeRighe AS ListeRighe_1
                              WHERE     (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0)) AS [Inev.Val.],
		Vision.dbo.ListeRighe.QuantitaForzata,
		Vision.dbo.ListeEvasioneTipo.Descrizione AS BackOrder, 
		Vision.dbo.ListeProvenienzaTipo.Descrizione AS Provenienza
from    Vision.dbo.Magazzini INNER JOIN
                      Vision.dbo.ListeProvenienzaTipo INNER JOIN
                      Vision.dbo.Liste ON Vision.dbo.ListeProvenienzaTipo.ID = Vision.dbo.Liste.ListeProvenienzaTipoID ON Vision.dbo.Magazzini.ID = Vision.dbo.Liste.MagazziniID INNER JOIN
                      Vision.dbo.ListeEvasioneTipo ON Vision.dbo.Liste.ListeEvasioneTipoID = Vision.dbo.ListeEvasioneTipo.ID INNER JOIN
                      Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID INNER JOIN
                      Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
                      Vision.dbo.ListeDocumenti ON Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID LEFT JOIN 
					  opper.dbo.IDIR_CLIENTE ON Vision.dbo.Liste.ClientiFornitoriID								=	opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID 
where    (Vision.dbo.CausaliMagazzino.Impegni = 1) AND (Vision.dbo.ListeRighe.QuantitaForzata = 0) AND (Vision.dbo.ListeRighe.Quantita > 0) AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAB', 'SOVRAP'))) AND 
                      (Vision.dbo.Liste.DataConsegna <= GETDATE() - 1) AND (Vision.dbo.ListeRighe.ArticoloID > 0) AND (Vision.dbo.ListeRighe.Quantita - ISNULL
                          ((SELECT     SUM(Quantita) AS QuantitaEvasa
                              FROM         Vision.dbo.ListeRighe AS ListeRighe_1
                              WHERE     (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0) > 0);

TRUNCATE TABLE opper.dbo.IDIR_VENDITE;

insert into opper.dbo.IDIR_VENDITE 
(  
	LISTA_RIGA_ID 
	,LISTA_ID 
	,PARENTLISTARIGHEID 
	,DETTAGLIOKEY
	,QTA 
	,PREZZO 
	,COSTO_UNITARIO 
	,DATA 
	,DATA_RIFERIMENTO 
	,ARTICOLO_ID 
	,ID_CLIENTE 
	,ID_AGENTE 
	,ID_MAGAZZINO 
	,ID_AREA 
	,CAUSALE_MAGAZZINO 
	,ID_VETTORE 
	,VETTORE  
	,VETTORE_FORNITORE 
	,VALORE  
	,MARGINE  
	,LISTINO  
	,LISTINOCODICE  
	,TIPOOPERAZIONE 
	,TIPOMERCE 
	,TIPORIGA
) 

SELECT                  
Vision.dbo.ListeRighe.ID AS ListeRigheID, 
Vision.dbo.Liste.ID AS ListeID, 
Vision.dbo.ListeRighe.ParentListeRigheID AS ParentListeRigheID, 
LogisticaDWH.dbo._FactSales.DettaglioKey		as DettaglioKey,
Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita AS Quantita,
CASE WHEN Vision.dbo.ListeRighe.Importo <> 0 THEN (Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita) 
                         / Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita ELSE 0 END AS Prezzo,
Vision.dbo.ListeRighe.ListinoCosto,
ListeDocumenti.DataDocumento AS Data, 
Vision.dbo.Liste.Data AS ListaData, 
Vision.dbo.ListeRighe.ArticoloID,
opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE,                                           
opper.dbo.IDIR_AGENTE.ID as ID_AGENTE, 
Vision.dbo.Liste.MagazziniID ,
Vision.dbo._Maurizio_Agenti_Gruppi_1.ID  as ID_AREA,
Vision.dbo.CausaliMagazzino.Descrizione AS CausaleMagazzino, 
VettoreDocumento.ID as ID_VETTORE,  
VettoreDocumento.Vettore, 
VettoreDocumento.VettoreFornitore,
Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita AS Valore,
ISNULL(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita, 0) 
                         - ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0) AS Margine,
CAST(Vision.dbo.Listini.Codice AS varchar) + ' - ' + Vision.dbo.Listini.Descrizione AS Listino,
Vision.dbo.Listini.Codice AS ListinoCodice,
CASE WHEN DocumentiTipo.RettificheVendite = 0 THEN 'Fattura' ELSE 'Nota Credito' END AS TipoOperazione, 
CASE WHEN MagazziniDifettosi.MagazziniID > 0 THEN 'Difettosa' ELSE 'Nuova' END AS TipoMerce,
Vision.dbo.ListeRigheTipo.Descrizione + ' - ' + CAST(Vision.dbo.ListeRigheTipo.Codice AS varchar) AS TipoRiga			  
                         
FROM            Vision.dbo.TrasportoACura INNER JOIN
                         Vision.dbo.Porti INNER JOIN
                         Vision.dbo.ClientiFornitori INNER JOIN
                         Vision.dbo.ListeDocumenti AS ListeDocumenti INNER JOIN
                         Vision.dbo.Liste ON ListeDocumenti.ListeID = Vision.dbo.Liste.ID INNER JOIN
                         Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID LEFT JOIN
						LogisticaDWH.dbo._FactSales ON Vision.dbo.ListeRighe.ID = LogisticaDWH.dbo._FactSales.ListeRigaId INNER JOIN
                         Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
                         Vision.dbo.Documenti ON ListeDocumenti.DocumentiID = Vision.dbo.Documenti.ID INNER JOIN
                         Vision.dbo.DocumentiClassiRaggruppamenti ON Vision.dbo.Documenti.ID = Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiID INNER JOIN
                         Vision.dbo.DocumentiTipo ON Vision.dbo.Documenti.DocumentiTipoID = Vision.dbo.DocumentiTipo.ID INNER JOIN
                         Vision.dbo.ListeRigheTipo ON Vision.dbo.CausaliMagazzinoListeRigheTipo.ListeRigheTipoID = Vision.dbo.ListeRigheTipo.ID INNER JOIN
                         Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
                         Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID ON Vision.dbo.ClientiFornitori.ID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
                         Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID ON Vision.dbo.Porti.ID = ListeDocumenti.PortiID ON Vision.dbo.TrasportoACura.ID = ListeDocumenti.TrasportoACuraID LEFT OUTER JOIN
                         Vision.dbo.ListiniCondizioni ON Vision.dbo.ListeRighe.ListiniCondizioniID = Vision.dbo.ListiniCondizioni.ID LEFT OUTER JOIN
                             (SELECT        Vision.dbo.ListeDocumentiVettori.ListeDocumentiID, ContattiVettori.Cognome + ' - ' + Vision.dbo.Vettori.Codice AS Vettore, Vision.dbo.Contatti.Cognome + ' - ' + CAST(ContattiContabili_1.Codice AS varchar) AS VettoreFornitore,Vision.dbo.Vettori.ID
                               FROM            Vision.dbo.ContattiContabili AS ContattiContabili_1 LEFT OUTER JOIN
                                                         Vision.dbo.Contatti ON ContattiContabili_1.ContattoID = Vision.dbo.Contatti.ID RIGHT OUTER JOIN
                                                         Vision.dbo.ClientiFornitori AS ClientiFornitori_1 ON ContattiContabili_1.ID = ClientiFornitori_1.ContattiContabiliID RIGHT OUTER JOIN
                                                         Vision.dbo._PowerBI_Nexus_Fornitori ON ClientiFornitori_1.ID = Vision.dbo._PowerBI_Nexus_Fornitori.ClienteFornitoreID RIGHT OUTER JOIN
                                                         Vision.dbo._PowerBI_Nexus_Fornitori_Vettori ON Vision.dbo._PowerBI_Nexus_Fornitori.ID = Vision.dbo._PowerBI_Nexus_Fornitori_Vettori.Fornitore_ID RIGHT OUTER JOIN
                                                         Vision.dbo.ListeDocumentiVettori INNER JOIN
                                                         Vision.dbo.Vettori ON Vision.dbo.ListeDocumentiVettori.VettoriID = Vision.dbo.Vettori.ID INNER JOIN
                                                         Vision.dbo.Contatti AS ContattiVettori ON Vision.dbo.Vettori.ContattiID = ContattiVettori.ID ON Vision.dbo._PowerBI_Nexus_Fornitori_Vettori.VettoreID = Vision.dbo.ListeDocumentiVettori.VettoriID
                               WHERE        (Vision.dbo.ListeDocumentiVettori.VettoriID > 0) AND (Vision.dbo.ListeDocumentiVettori.Progressivo = 1) AND (Vision.dbo.ListeDocumentiVettori.ListeDocumentiID > 0)) AS VettoreDocumento ON 
                         ListeDocumenti.ID = VettoreDocumento.ListeDocumentiID LEFT OUTER JOIN
                         Vision.dbo.Listini ON Vision.dbo.ListiniCondizioni.ListinoID = Vision.dbo.Listini.ID LEFT OUTER JOIN
                         Vision.dbo.CausaliProgressivi RIGHT OUTER JOIN
                         Vision.dbo.CausaliMagazzinoProgressivi ON Vision.dbo.CausaliProgressivi.ID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliProgressiviID ON 
                         Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID LEFT OUTER JOIN
                             (SELECT        MagazziniID
                               FROM            Vision.dbo.MagazziniClassiRaggruppamenti
                               WHERE        (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazziniID
							   LEFT JOIN opper.dbo.IDIR_AGENTE ON Vision.dbo.ListeRighe.AgentiID								=	opper.dbo.IDIR_AGENTE.AGENTE_ID
						LEFT JOIN opper.dbo.IDIR_CLIENTE ON Vision.dbo.Liste.ClientiFornitoriID								=	opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID
						LEFT JOIN Vision.dbo._Maurizio_AgentiID_Gruppi2ID ON opper.dbo.IDIR_AGENTE.AGENTE_ID = Vision.dbo._Maurizio_AgentiID_Gruppi2ID.AgenteID   
						LEFT JOIN Vision.dbo._Maurizio_Agenti_Gruppo_2 ON Vision.dbo._Maurizio_AgentiID_Gruppi2ID.AgenteGruppo2ID    = Vision.dbo._Maurizio_Agenti_Gruppo_2.ID   
						LEFT JOIN Vision.dbo._Maurizio_Agenti_Gruppi_1 ON Vision.dbo._Maurizio_Agenti_Gruppo_2.Gruppo1ID = Vision.dbo._Maurizio_Agenti_Gruppi_1.ID   
WHERE        (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND (Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiClassiID = 10) AND (YEAR(ListeDocumenti.DataDocumento) BETWEEN YEAR(GETDATE()) - 3 AND 
                         YEAR(GETDATE())) AND (Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita <> 0) OR
                         (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND (Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiClassiID = 10) AND (YEAR(ListeDocumenti.DataDocumento) BETWEEN YEAR(GETDATE()) - 3 AND 
                         YEAR(GETDATE())) AND (ISNULL(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita, 0) 
                         - ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0) <> 0) OR
                         (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND (Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiClassiID = 10) AND (YEAR(ListeDocumenti.DataDocumento) BETWEEN YEAR(GETDATE()) - 3 AND 
                         YEAR(GETDATE())) AND (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita <> 0) OR
                         (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND (Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiClassiID = 10) AND (YEAR(ListeDocumenti.DataDocumento) BETWEEN YEAR(GETDATE()) - 3 AND 
                         YEAR(GETDATE())) AND (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.MoltiplicatoreConsumi <> 0);
                         
truncate table opper.dbo.IDIR_FATTO_ORDINE_ACQUISTO;

insert into opper.dbo.IDIR_FATTO_ORDINE_ACQUISTO
(  
	LISTA_RIGA_ID
	,LISTA_ID
	,DATA_ORDINE
	,QTA
	,NUMERO
	,QTA_INEVASA
	,QTA_EVASA
	,QTA_FORZATA
	,PREZZO_BASE
	,VALORE_ORDINE
	,COSTO_UNITARIO
	,DATA_CONSEGNA
	,ARTICOLO_ID
	,ID_FORNITORE
	,ID_MAGAZZINO
	,LEAD_TIME
	,TIPO_RIGA
	,PARENT_LISTE_RIGHE_ID
) 
SELECT	Vision.dbo.ListeRighe.ID
		,Vision.dbo.Liste.id                             
		,Vision.dbo.ListeDocumenti.DataDocumento    
		,Vision.dbo.ListeRighe.Quantita
		,Vision.dbo.ListeDocumenti.NumeroDocumento
		,Vision.dbo.ListeRighe.Quantita
		,0
		,Vision.dbo.ListeRighe.QuantitaForzata
		,Vision.dbo.ListeRighe.PREZZO      
		,Vision.dbo.ListeRighe.Importo AS [Valore Ordine]
		,Vision.dbo.ListeRighe.Listinocosto        
		,Vision.dbo.ListeRighe.Dataconsegna         
		,Vision.dbo.ListeRighe.Articoloid          
		,opper.dbo.IDIR_FORNITORI.ID                
		,Vision.dbo.Liste.MagazziniID       
		,Vision.dbo.Precodici.GiorniConsegna      
		,Vision.dbo.CausaliMagazzino.Descrizione   
		,Vision.dbo.ListeRighe.ParentListeRigheID
from     Vision.dbo.Liste,    
Vision.dbo.ListeRighe,       
Vision.dbo.CausaliMagazzino,     
opper.dbo.IDIR_FORNITORI,  
Vision.dbo.Precodici,
Vision.dbo.ListeDocumenti
where     Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID
AND      Vision.dbo.Liste.CausaliMagazzinoID                             IN (30,1030,1128)
AND Vision.dbo.Liste.CausaliMagazzinoID   = Vision.dbo.CausaliMagazzino.ID
AND        Vision.dbo.Liste.ClientiFornitoriID                        = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE
AND        Vision.dbo.ListeRighe.Precodice                                    = Vision.dbo.Precodici.Codice
AND Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID;

update opper.dbo.IDIR_FATTO_ORDINE_ACQUISTO
set QTA_INEVASA = QTA_INEVASA - ISNULL   (
(SELECT     SUM(ListeRighe_1.Quantita) AS QuantitaEvasa           
FROM         Vision.dbo.ListeRighe AS ListeRighe_1        
WHERE     (ListeRighe_1.ParentListeRigheID = LISTA_RIGA_ID))
, 0);


update opper.dbo.IDIR_FATTO_ORDINE_ACQUISTO
set QTA_EVASA = 
ISNULL(
(SELECT     SUM(ListeRighe_1.Quantita) AS QuantitaEvasa       
FROM         Vision.dbo.ListeRighe AS ListeRighe_1 
WHERE     (ListeRighe_1.ParentListeRigheID = LISTA_RIGA_ID))
, 0); 



TRUNCATE TABLE opper.dbo.IDIR_FATTO_CARICHI;

insert into opper.dbo.IDIR_FATTO_CARICHI 
(  
	LISTA_RIGA_ID 
	,LISTA_ID 
	,DATA_ORDINE 
	,QTA 
	,PREZZO_BASE 
	,COSTO_UNITARIO 
	,DATA_BOLLA 
	,DATA_CONSEGNA 
	,ARTICOLO_ID 
	,ID_FORNITORE 
	,ID_MAGAZZINO 
	,DESCRIZIONE
	,DATA_DOCUMENTO
	,IMPORTO
	,PARENT_LISTE_RIGHE_ID
	,TIPO_OPERAZIONE
	,TIPO_MERCE
) 

SELECT  Vision.dbo.ListeRighe.id                                 as listarigaid
		,Vision.dbo.Liste.id                                      as listaid
		,Vision.dbo.ListeRighe.DATAinserimento                  
		,Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita                   as QTA
		,Vision.dbo.ListeRighe.PREZZO                    
		,Vision.dbo.ListeRighe.Listinocosto                
		,Vision.dbo.Liste.DataRiferimento      as DataBolla          
		,Vision.dbo.ListeRighe.Dataconsegna              
		,Vision.dbo.ListeRighe.Articoloid         
		,opper.dbo.IDIR_FORNITORI.ID 
		,Vision.dbo.Liste.MagazziniID  
		,Vision.dbo.CausaliMagazzino.Descrizione
		,Vision.dbo.ListeDocumenti.DataDocumento as DataDocumento
		,Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquisto as IMPORTO
		,Vision.dbo.ListeRighe.ParentListeRigheID
		, 'Acquisti' AS TipoOperazione
		,'Nuova' AS TipoMerce
FROM            Vision.dbo.CausaliMagazzino INNER JOIN
                         Vision.dbo.Liste ON Vision.dbo.CausaliMagazzino.ID = Vision.dbo.Liste.CausaliMagazzinoID INNER JOIN
                         Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID LEFT JOIN
						opper.dbo.IDIR_FORNITORI ON Vision.dbo.Liste.ClientiFornitoriID     = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE INNER JOIN
                         Vision.dbo.ListeDocumenti ON Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID INNER JOIN
                         Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
                         Vision.dbo.ClientiFornitori ON Vision.dbo.Liste.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN
                         Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID LEFT OUTER JOIN
                             (SELECT        MagazziniID
                               FROM            Vision.dbo.MagazziniClassiRaggruppamenti
                               WHERE        (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazziniID
WHERE        (Vision.dbo.CausaliMagazzino.ID = 10) 
AND (MagazziniDifettosi.MagazziniID IS NULL) 
AND (Vision.dbo.ListeRighe.ArticoloID > 0) AND 
                         (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita > 0)

UNION
SELECT  Vision.dbo.ListeRighe.id                                 as listarigaid
		,Vision.dbo.Liste.id                                      as listaid
		,Vision.dbo.ListeRighe.DATAinserimento                  
		,Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita                   as QTA
		,Vision.dbo.ListeRighe.PREZZO                    
		,Vision.dbo.ListeRighe.Listinocosto                
		,Vision.dbo.Liste.DataRiferimento      as DataBolla          
		,Vision.dbo.ListeRighe.Dataconsegna              
		,Vision.dbo.ListeRighe.Articoloid  
		,opper.dbo.IDIR_FORNITORI.ID 
		,Vision.dbo.Liste.MagazziniID  
		,Vision.dbo.CausaliMagazzino.Descrizione
		,Vision.dbo.ListeDocumenti.DataDocumento as DataDocumento
		,Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquisto as IMPORTO
		,Vision.dbo.ListeRighe.ParentListeRigheID
		, 'Acquisti' AS TipoOperazione
		,'Difettosa' AS TipoMerce
FROM            Vision.dbo.CausaliMagazzino INNER JOIN
                         Vision.dbo.Liste ON Vision.dbo.CausaliMagazzino.ID = Vision.dbo.Liste.CausaliMagazzinoID INNER JOIN
                         Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID LEFT JOIN
						opper.dbo.IDIR_FORNITORI ON Vision.dbo.Liste.ClientiFornitoriID     = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE INNER JOIN
                         Vision.dbo.ListeDocumenti ON Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID INNER JOIN
                         Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
                         Vision.dbo.ClientiFornitori ON Vision.dbo.Liste.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN
                         Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
                             (SELECT        MagazziniID
                               FROM            Vision.dbo.MagazziniClassiRaggruppamenti
                               WHERE        (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazziniID
WHERE        (Vision.dbo.CausaliMagazzino.ID = 10) AND (Vision.dbo.ListeRighe.ArticoloID > 0) AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND 
                         (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita > 0)

						 

UNION
SELECT  Vision.dbo.ListeRighe.id                                 as listarigaid
		,Vision.dbo.Liste.id                                      as listaid
		,Vision.dbo.ListeRighe.DATAinserimento                  
		,Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita                   as QTA
		,Vision.dbo.ListeRighe.PREZZO                    
		,Vision.dbo.ListeRighe.Listinocosto                
		,Vision.dbo.ListeDocumenti.DataDocumento         as DataDocumento    
		,Vision.dbo.ListeRighe.Dataconsegna              
		,Vision.dbo.ListeRighe.Articoloid       
		,opper.dbo.IDIR_FORNITORI.ID 
		,Vision.dbo.Liste.MagazziniID  
		,Vision.dbo.CausaliMagazzino.Descrizione
		,Vision.dbo.ListeDocumenti.DataDocumento  as DataBolla
		,Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquisto as IMPORTO
		,Vision.dbo.ListeRighe.ParentListeRigheID
		, 'Resi' AS TipoOperazione
		,'Nuova' AS TipoMerce
FROM            Vision.dbo.CausaliMagazzino INNER JOIN
                         Vision.dbo.Liste ON Vision.dbo.CausaliMagazzino.ID = Vision.dbo.Liste.CausaliMagazzinoID INNER JOIN
                         Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID LEFT JOIN
						opper.dbo.IDIR_FORNITORI ON Vision.dbo.Liste.ClientiFornitoriID     = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE INNER JOIN
                         Vision.dbo.ListeDocumenti ON Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID INNER JOIN
                         Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
                         Vision.dbo.ClientiFornitori ON Vision.dbo.Liste.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN
                         Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID LEFT OUTER JOIN
                             (SELECT        MagazziniID
                               FROM            Vision.dbo.MagazziniClassiRaggruppamenti
                               WHERE        (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazziniID
WHERE        (Vision.dbo.CausaliMagazzino.ID = 15) 
AND (Vision.dbo.ListeRighe.ArticoloID > 0) 
AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) 
AND (MagazziniDifettosi.MagazziniID IS NULL) AND 
                         (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita < 0)

						UNION
SELECT  Vision.dbo.ListeRighe.id                                 as listarigaid
		,Vision.dbo.Liste.id                                      as listaid
		,Vision.dbo.ListeRighe.DATAinserimento                  
		,Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita                   as QTA
		,Vision.dbo.ListeRighe.PREZZO                    
		,Vision.dbo.ListeRighe.Listinocosto                
		,Vision.dbo.ListeDocumenti.DataDocumento         as DataDocumento          
		,Vision.dbo.ListeRighe.Dataconsegna              
		,Vision.dbo.ListeRighe.Articoloid    
		,opper.dbo.IDIR_FORNITORI.ID 
		,Vision.dbo.Liste.MagazziniID  
		,Vision.dbo.CausaliMagazzino.Descrizione
		,Vision.dbo.ListeDocumenti.DataDocumento as DataBolla
		,Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquisto as IMPORTO
		,Vision.dbo.ListeRighe.ParentListeRigheID
		, 'Resi' AS TipoOperazione
		,'Difettosa' AS TipoMerce
FROM            Vision.dbo.CausaliMagazzino INNER JOIN
                         Vision.dbo.Liste ON Vision.dbo.CausaliMagazzino.ID = Vision.dbo.Liste.CausaliMagazzinoID INNER JOIN
                         Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID LEFT JOIN
						opper.dbo.IDIR_FORNITORI ON Vision.dbo.Liste.ClientiFornitoriID     = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE INNER JOIN
                         Vision.dbo.ListeDocumenti ON Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID INNER JOIN
                         Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
                         Vision.dbo.ClientiFornitori ON Vision.dbo.Liste.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN
                         Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
                             (SELECT        MagazziniID
                               FROM            Vision.dbo.MagazziniClassiRaggruppamenti
                               WHERE        (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazziniID
WHERE        (Vision.dbo.CausaliMagazzino.ID = 15) AND (Vision.dbo.ListeRighe.ArticoloID > 0) AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB'))) AND 
                        (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheAcquistoQuantita < 0);


TRUNCATE TABLE opper.dbo.IDIR_VETTORI;

insert into opper.dbo.IDIR_VETTORI 
(  
	ID_VETTORE 
	,CODICE 
	,NOME 
	,COGNOME 
	,INDIRIZZO 
	,TIME_ALT_KEY_PRE_CUT_OFF   
	,TIME_ALT_KEY_CUT_OFF   
	,VETTORE
	,VETTORE_FORNITORE
) 
SELECT DISTINCT
	Vision.dbo.Vettori.id 								as ID
		,Vision.dbo.Vettori.Codice							as CODICE
		,Vision.dbo.Contatti.Nome							AS NOME
		,Vision.dbo.Contatti.Cognome 						AS COGNOME
		,Vision.dbo.Contatti.Indirizzo 						AS INDIRIZZO
		,LogisticaDWH.dbo._DimVettori.TimeAltKeyPreCutOff
	    ,LogisticaDWH.dbo._DimVettori.TimeAltKeyCutOff
		,ContattiVettori.Cognome + ' - ' + Vision.dbo.Vettori.Codice AS Vettore
		,Vision.dbo.Contatti.Cognome + ' - ' + CAST(ContattiContabili_1.Codice AS varchar) AS VettoreFornitore
FROM            Vision.dbo.ContattiContabili AS ContattiContabili_1 LEFT OUTER JOIN
         Vision.dbo.Contatti ON ContattiContabili_1.ContattoID = Vision.dbo.Contatti.ID RIGHT OUTER JOIN
         Vision.dbo.ClientiFornitori AS ClientiFornitori_1 ON ContattiContabili_1.ID = ClientiFornitori_1.ContattiContabiliID RIGHT OUTER JOIN
         Vision.dbo._PowerBI_Nexus_Fornitori ON ClientiFornitori_1.ID = Vision.dbo._PowerBI_Nexus_Fornitori.ClienteFornitoreID RIGHT OUTER JOIN
         Vision.dbo._PowerBI_Nexus_Fornitori_Vettori ON Vision.dbo._PowerBI_Nexus_Fornitori.ID = Vision.dbo._PowerBI_Nexus_Fornitori_Vettori.Fornitore_ID RIGHT OUTER JOIN
         Vision.dbo.ListeDocumentiVettori INNER JOIN
         Vision.dbo.Vettori ON Vision.dbo.ListeDocumentiVettori.VettoriID = Vision.dbo.Vettori.ID INNER JOIN
         Vision.dbo.Contatti AS ContattiVettori ON Vision.dbo.Vettori.ContattiID = ContattiVettori.ID ON Vision.dbo._PowerBI_Nexus_Fornitori_Vettori.VettoreID = Vision.dbo.ListeDocumentiVettori.VettoriID LEFT JOIN
		LogisticaDWH.dbo._DimVettori ON LogisticaDWH.dbo._DimVettori.VettoreKey = Vision.dbo.Vettori.Codice;
		
TRUNCATE TABLE opper.dbo.IDIR_LISTINO;

insert into opper.dbo.IDIR_LISTINO 
(  
	ID_LISTINO 
	,CODICE 
	,SIGLA 
	,AZIENDAID 
	,DESCRIZIONE 
) 
SELECT 	Vision.dbo.Listini.id 							as ID
		,Vision.dbo.Listini.Codice						as CODICE
		,Vision.dbo.Listini.Sigla						AS SIGLA
		,Vision.dbo.Listini.AziendaID 					AS AZIENDAID
		,Vision.dbo.Listini.Descrizione					AS DESCRIZIONE
from 	Vision.dbo.Listini;

TRUNCATE TABLE opper.dbo.IDIR_AREE;

insert into opper.dbo.IDIR_AREE 
(  
	AREA_ID
	,AREA_DESCRIZIONE
) 
SELECT 	Vision.dbo._Maurizio_Agenti_Gruppi_1.ID					
		,Vision.dbo._Maurizio_Agenti_Gruppi_1.Gruppo1					
from 	Vision.dbo._Maurizio_Agenti_Gruppi_1;

TRUNCATE TABLE opper.dbo.IDIR_AREE_SUB;

insert into opper.dbo.IDIR_AREE_SUB 
(  
	AREA_SUB_ID
	,AREA_SUB_DESCRIZIONE
) 
SELECT 	Vision.dbo._Maurizio_Agenti_Gruppo_2.ID					
		,Vision.dbo._Maurizio_Agenti_Gruppo_2.Gruppo2					
from 	Vision.dbo._Maurizio_Agenti_Gruppo_2;

TRUNCATE TABLE opper.dbo.IDIR_AREE_AGENTI;

insert into opper.dbo.IDIR_AREE_AGENTI 
(  
	AGENTE_ID
	,AREA_SUB_ID
) 
SELECT 	Vision.dbo._Maurizio_AgentiID_Gruppi2ID.AgenteID					
		,Vision.dbo._Maurizio_AgentiID_Gruppi2ID.AgenteGruppo2ID					
from 	Vision.dbo._Maurizio_AgentiID_Gruppi2ID;

TRUNCATE TABLE opper.dbo.IDIR_ARTICOLI;

insert into opper.dbo.IDIR_ARTICOLI 
(  
	ARTICOLO_ID 
	,PRECODICE_STATISTICHE_ID
	,PRECODICE 
	,DESCRIZIONE_PRECODICE
	,CODICE 
	,ID_FORNITORE 
	,FORNITORE_CODICE 
	,FORNITORE 
	,CLIENTE_FORNITORE_ID 
	,CATEGORIA 
	,CATEGORIA_DESCRIZIONE 
	,CLASSE_CODICE 
	,CLASSE_DESCRIZIONE 
	,SOTTOCLASSE_CODICE 
	,SOTTOCLASSE_DESCRIZIONE 
	,FAMIGLIA 
	,FAMIGLIA_DESCRIZIONE 
	,GIORNI_CONSEGNA
	,PREZZO_LISTINO_92
	,PREZZO_LISTINO_800
	,PREZZO_LISTINO_90
	,PREZZO_LISTINO_PLATINUM_2073
	,BLOCCATO
	,SOSTITUITO
	,PRECODICISTATISTICHEDESCRIZIONE
	,PREZZO_LISTINO_900
	,ARTICOLO_DESCRIZIONE
	,QTA_MIN_ACQ
	,QTA_MIN_VEND
	,ARTICOLO_ID_WMS
) 
SELECT Vision.dbo.ArticoliCodifiche.ArticoloID,
Vision.dbo.Categorie.PrecodiciStatisticheID,
Vision.dbo.Precodici.Codice AS Precodice,
Vision.dbo.Precodici.Descrizione AS DescrizionePrecodice,
Vision.dbo.ArticoliCodifiche.Articolo AS Codice,
Vision.dbo.Fornitori.ID AS FornitoreID,
Vision.dbo.ContattiContabili.Codice AS FornitoreCodice,
Vision.dbo.Contatti.Cognome AS Fornitore,
Vision.dbo.ClientiFornitori.ID AS ClienteFornitoreID,
Vision.dbo.Categorie.Codice AS Categoria,
Vision.dbo.Categorie.Descrizione AS CategoriaDescrizione,
Vision.dbo.Classi.Codice AS ClasseCodice,
Vision.dbo.Classi.Descrizione AS ClasseDescrizione,
Vision.dbo.SottoClassi.Codice AS SottoClasseCodice,
Vision.dbo.SottoClassi.Descrizione AS SottoClasseDescrizione,
Vision.dbo.Famiglie.Codice AS Famiglia,
Vision.dbo.Famiglie.Descrizione AS FamigliaDescrizione,
Vision.dbo.Precodici.GiorniConsegna,
tabListino92.Prezzo AS PrezzoListino92,
tabListino800.Prezzo AS PrezzoListino800,
tabListino90.Prezzo AS PrezzoListino90,
tabListinoPlatinum2073.Prezzo as PrezzoListinoPlatinum2073,
articoli_bloccati.Bloccato as BLOCCATO,
articoli_sostituiti.Sostituito as SOSTITUITO,
Vision.dbo.PrecodiciStatistiche.Descrizione as PrecodiciStatisticheDescrizione,
tabListino900.Prezzo as PrezzoListino900,
Vision.dbo.ArticoliDescrizioni.Descrizione AS ARTICOLO_DESCRIZIONE,
Vision.dbo.Articoli.AcquistoQuantitaMin AS QTA_MIN_ACQ,
Vision.dbo.Articoli.VenditaQuantitaMin AS QTA_MIN_VEND,
tab_articoli_log.Id as ARTICOLO_ID_WMS
FROM Vision.dbo.ArticoliCodifiche
INNER JOIN Vision.dbo.Precodici
ON Vision.dbo.ArticoliCodifiche.PrecodiceID = Vision.dbo.Precodici.ID
INNER JOIN Vision.dbo.Articoli
ON Vision.dbo.ArticoliCodifiche.ArticoloID = Vision.dbo.Articoli.ID
INNER JOIN Vision.dbo.Categorie
ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID
INNER JOIN Vision.dbo.Famiglie
ON Vision.dbo.Articoli.FamigliaID = Vision.dbo.Famiglie.ID
INNER JOIN Vision.dbo.Fornitori
ON Vision.dbo.Precodici.FornitoriID = Vision.dbo.Fornitori.ID
INNER JOIN Vision.dbo.ClientiFornitori
ON Vision.dbo.Fornitori.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID
INNER JOIN Vision.dbo.ContattiContabili
ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID
INNER JOIN Vision.dbo.Contatti
ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID
INNER JOIN Vision.dbo.SottoClassi
ON Vision.dbo.Articoli.SottoClasseID = Vision.dbo.SottoClassi.ID
INNER JOIN Vision.dbo.Classi
ON Vision.dbo.SottoClassi.ClasseID = Vision.dbo.Classi.ID
LEFT JOIN Vision.dbo.PrecodiciStatistiche
ON Vision.dbo.PrecodiciStatistiche.ID = Vision.dbo.Categorie.PrecodiciStatisticheID
LEFT JOIN Vision.dbo.ArticoliDescrizioni
ON Vision.dbo.Articoli.ID = Vision.dbo.ArticoliDescrizioni.ArticoloID
LEFT JOIN (
SELECT al.Prezzo, al.ArticoloID,
ROW_NUMBER() OVER (PARTITION BY al.ArticoloID ORDER BY al.DataVigore DESC) AS rn
FROM Vision.dbo.ArticoliListini al
WHERE al.ListinoID = 92 AND al.DataVigore <= GETDATE() AND al.DataFineVigore >= GETDATE() AND al.Quantita = 1
) AS tabListino92 ON Vision.dbo.ArticoliCodifiche.ArticoloID = tabListino92.ArticoloID AND tabListino92.rn = 1
LEFT JOIN (
SELECT al.Prezzo, al.ArticoloID,
ROW_NUMBER() OVER (PARTITION BY al.ArticoloID ORDER BY al.DataVigore DESC) AS rn
FROM Vision.dbo.ArticoliListini al
WHERE al.ListinoID = 800 AND al.DataVigore <= GETDATE() AND al.DataFineVigore >= GETDATE() AND al.Quantita = 1
) AS tabListino800 ON Vision.dbo.ArticoliCodifiche.ArticoloID = tabListino800.ArticoloID AND tabListino800.rn = 1
LEFT JOIN (
SELECT al.Prezzo, al.ArticoloID,
ROW_NUMBER() OVER (PARTITION BY al.ArticoloID ORDER BY al.DataVigore DESC) AS rn
FROM Vision.dbo.ArticoliListini al
WHERE al.ListinoID = 2217 AND al.DataVigore <= GETDATE() AND al.DataFineVigore >= GETDATE() AND al.Quantita = 1
) AS tabListinoPlatinum2073 ON Vision.dbo.ArticoliCodifiche.ArticoloID = tabListinoPlatinum2073.ArticoloID AND tabListinoPlatinum2073.rn = 1
LEFT JOIN (
SELECT al.Prezzo, al.ArticoloID,
ROW_NUMBER() OVER (PARTITION BY al.ArticoloID ORDER BY al.DataVigore DESC) AS rn
FROM Vision.dbo.ArticoliListini al
WHERE al.ListinoID = 90 AND al.DataVigore <= GETDATE() AND al.DataFineVigore >= GETDATE() AND al.Quantita = 1
) AS tabListino90 ON Vision.dbo.ArticoliCodifiche.ArticoloID = tabListino90.ArticoloID AND tabListino90.rn = 1
LEFT JOIN (
SELECT al.Prezzo, al.ArticoloID,
ROW_NUMBER() OVER (PARTITION BY al.ArticoloID ORDER BY al.DataVigore DESC) AS rn
FROM Vision.dbo.ArticoliListini al
WHERE al.ListinoID = 900 AND al.DataVigore <= GETDATE() AND al.DataFineVigore >= GETDATE() AND al.Quantita = 1
) AS tabListino900 ON Vision.dbo.ArticoliCodifiche.ArticoloID = tabListino900.ArticoloID AND tabListino900.rn = 1
LEFT JOIN
(SELECT Vision.dbo.ArticoliBlocchi.ArticoliID, 'Si' AS Bloccato
FROM Vision.dbo.ArticoliBlocchi
WHERE (BlocchiMotivazioniID IN (8, 20, 21))
GROUP BY Vision.dbo.ArticoliBlocchi.ArticoliID) as articoli_bloccati ON Vision.dbo.ArticoliCodifiche.ArticoloID = articoli_bloccati.ArticoliID
LEFT JOIN
(SELECT Vision.dbo.ArticoliEquivalenzeRighe.ArticoliID, 'Si' AS Sostituito
FROM Vision.dbo.ArticoliEquivalenze INNER JOIN
Vision.dbo.ArticoliEquivalenzeRighe ON Vision.dbo.ArticoliEquivalenze.ID = Vision.dbo.ArticoliEquivalenzeRighe.ArticoliEquivalenzeID INNER JOIN
Vision.dbo.ArticoliEquivalenzeTipo ON Vision.dbo.ArticoliEquivalenze.ArticoliEquivalenzeTipoID = Vision.dbo.ArticoliEquivalenzeTipo.ID
WHERE (Vision.dbo.ArticoliEquivalenzeTipo.ID = 2) AND (Vision.dbo.ArticoliEquivalenzeRighe.Sostituito = 1)
GROUP BY Vision.dbo.ArticoliEquivalenzeRighe.ArticoliID) as articoli_sostituiti ON Vision.dbo.ArticoliCodifiche.ArticoloID = articoli_sostituiti.ArticoliID
LEFT JOIN
(
SELECT
Logistica.dbo.Articoli.Id,
Logistica.dbo.Articoli.ErpArtId
FROM
Logistica.dbo.Articoli) as tab_articoli_log ON Vision.dbo.ArticoliCodifiche.ArticoloID = tab_articoli_log.Id
WHERE (Vision.dbo.ArticoliCodifiche.ArticoliCodificheTipoID = 1)
AND (Vision.dbo.Precodici.AziendaID = 1);

TRUNCATE TABLE opper.dbo.IDIR_PRECODICI;

insert into opper.dbo.IDIR_PRECODICI 
(  
	ID_PRECODICE 
	,PRECODICE 
	,DESCRIZIONE 
	,FORNITORE_ID 
	,LT_CONSEGNA 
) 
SELECT 	Vision.dbo.Precodici.ID					
		,Vision.dbo.Precodici.CODICE
		,Vision.dbo.Precodici.Descrizione 
		,opper.dbo.IDIR_FORNITORI.ID
		,Vision.dbo.Precodici.GiorniConsegna
from 	Vision.dbo.Precodici
		,opper.dbo.IDIR_FORNITORI
where 	Vision.dbo.Precodici.FornitoriID = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE;


TRUNCATE TABLE opper.dbo.IDIR_CODICI;

insert into opper.dbo.IDIR_CODICI 
(  
	ID_CODICE 
	,ID_PRECODICE 
	,CODICE 
	,FORNITORE_ID 
) 
SELECT 	Vision.dbo.ArticoliCodifiche.ID				
		,Vision.dbo.ArticoliCodifiche.PrecodiceID					
		,Vision.dbo.ArticoliCodifiche.Articolo					
		,opper.dbo.IDIR_FORNITORI.ID
from 	Vision.dbo.ArticoliCodifiche
		,Vision.dbo.Precodici
		,opper.dbo.IDIR_FORNITORI
WHERE	Vision.dbo.ArticoliCodifiche.PrecodiceID = Vision.dbo.Precodici.ID
AND		Vision.dbo.Precodici.FornitoriID = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE;

TRUNCATE TABLE opper.dbo.IDIR_MAGAZZINI;

insert into opper.dbo.IDIR_MAGAZZINI 
(  
	ID_MAGAZZINO 
	,CODICE 
	,DESCRIZIONE 
	,AZIENDAID 
) 
SELECT 	Vision.dbo.Magazzini.ID					
		,Vision.dbo.Magazzini.Codice					
		,Vision.dbo.Magazzini.Descrizione					
		,Vision.dbo.Magazzini.AziendaID					
from 	Vision.dbo.Magazzini;

TRUNCATE TABLE opper.dbo.IDIR_CAUSALI_MAGAZZINO;

insert into opper.dbo.IDIR_CAUSALI_MAGAZZINO 
(  
	CAUSALI_MAGAZZINO_ID 
	,DESCRIZIONE 
	,ID_MAGAZZINO 
) 
SELECT 	Vision.dbo.CausaliMagazzino.ID					
		,Vision.dbo.CausaliMagazzino.Descrizione
		,Vision.dbo.CausaliMagazzino.MagazziniID
from 	Vision.dbo.CausaliMagazzino;

TRUNCATE TABLE opper.dbo.IDIR_BUDGET;

insert into opper.dbo.IDIR_BUDGET 
(  
	BUDGET_ID 
	,DESCRIZIONE 
	,ID_ESERCIZIO 
	,ANNO 
	,ID_CLIENTE 
	,ID_AGENTE 
	,ARTICOLO_ID 
	,QTA 
	,PREZZO 
) 
SELECT 	Vision.dbo.Budget.ID				
		,Vision.dbo.Budget.Descrizione
		,Vision.dbo.Budget.EserciziID
		,Vision.dbo.Esercizi.DataInizio
		,opper.dbo.IDIR_CLIENTE.ID
		,opper.dbo.IDIR_AGENTE.ID
		,Vision.dbo.BudgetRighe.ArticoliID
		,SUM(Vision.dbo.BudgetRighe.Quantita)
		,SUM(Vision.dbo.BudgetRighe.Valore)
from 	Vision.dbo.Budget
		,Vision.dbo.Esercizi
		,Vision.dbo.BudgetRighe	
		,opper.dbo.IDIR_CLIENTE
		,opper.dbo.IDIR_AGENTE
WHERE	Vision.dbo.Budget.EserciziID 				= Vision.dbo.Esercizi.ID
and		Vision.dbo.Budget.ID 						= Vision.dbo.BudgetRighe.BudgetID
and		Vision.dbo.BudgetRighe.AgentiID 			= opper.dbo.IDIR_AGENTE.AGENTE_ID
AND		Vision.dbo.BudgetRighe.ClientiFornitoriID 	= opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID
group by Vision.dbo.Budget.ID				
		,Vision.dbo.Budget.Descrizione
		,Vision.dbo.Budget.EserciziID
		,Vision.dbo.Esercizi.DataInizio
		,opper.dbo.IDIR_CLIENTE.ID
		,opper.dbo.IDIR_AGENTE.ID
		,Vision.dbo.BudgetRighe.ArticoliID;


TRUNCATE TABLE opper.dbo.ESISTENZE_ARTICOLI;

insert into opper.dbo.ESISTENZE_ARTICOLI 
(  
	ARTICOLO_ID 
	,ES_TOT 
	,ES_CENTR 
	,ES_MECC 
	,ES_CARR 
	,ES_EXP 
	,ES_RESI_N 
	,ES_OLIO 
	,ES_COD_S 
	,ES_TRANS 
	,ES_TRASF ) 
SELECT 	Vision.dbo.ListeRighe.ArticoloID
		,SUM(Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore) AS [Es.Tot.]
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 1 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Centr.]
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 4 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Mecc.]
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 23 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Carr.]
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 36 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Exp.] 
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 108 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Resi N.] 
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 15 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Olio]
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID = 102 	THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Cod.S] 
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID IN (100, 24, 40) THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Trans.]
		,SUM(CASE WHEN Vision.dbo.Liste.MagazziniID IN (26, 27) THEN Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore ELSE 0 END) AS [Es.Trasf.]
FROM 	Vision.dbo.ListeRighe
		,Vision.dbo.Liste
		,Vision.dbo.CausaliMagazzinoProgressivi
		,Vision.dbo.CausaliProgressivi
WHERE	Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID 			= Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID
AND 	Vision.dbo.CausaliMagazzinoProgressivi.CausaliProgressiviID 	= Vision.dbo.CausaliProgressivi.ID
AND 	Vision.dbo.ListeRighe.ListeID 									= Vision.dbo.Liste.ID 
GROUP BY Vision.dbo.ListeRighe.ArticoloID;


TRUNCATE TABLE opper.dbo.IDIR_RESI;

INSERT INTO opper.dbo.IDIR_RESI
(  
	LISTA_RIGA_ID 
	,LISTA_ID 
	,DOCUMENTO_DATE 
	,LISTA_DATI  
	,CAUSALE_MAGAZZINO 
	,DOCUMENTO 
	,TIPO_MERCE 
	,ID_MAGAZZINO 
	,ID_CLIENTE 
	,DOCUMENTO_NUMERO 
	,CAUZIONE  
	,ARTICOLO_ID 
	,PEZZI 
	,VALORE 
	,COSTO  
	,MARGINE  
	,PARENT_LISTA_RIGA_ID 
	,RICONOSCIUTA
	,PM_RESO
	,PM_VENDITE
	,SCONTO
)
SELECT
Vision.dbo.ListeRighe.ID AS ListaRigaID,
Vision.dbo.Liste.ID AS ListaID,
ListeDocumenti.DataDocumento AS DocumentoData,
Vision.dbo.Liste.Data as ListaData,
Vision.dbo.CausaliMagazzino.Descrizione AS CausaleMagazzino,
Vision.dbo.Documenti.Descrizione AS Documento,
CASE WHEN MagazziniDifettosi.MagazzinoID > 0 THEN 'Difettoso' ELSE 'Nuovo' END AS TipoMerce,
Vision.dbo.Liste.MagazziniID AS ID_MAGAZZINO,
opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE,
ListeDocumenti.NumeroDocumento AS DocumentoNumero,
CASE WHEN Vision.dbo.Precodici.PrecodiceCauzioni = - 1 THEN 'Si' ELSE 'No' END AS Cauzione,
Vision.dbo.ListeRighe.ArticoloID,
Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1 AS Pezzi,
Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1 AS Valore,
ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0) * - 1 AS Costo,
(ISNULL(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita, 0) - ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0)) * - 1 AS Margine,
Vision.dbo.ListeRighe.ParentListeRigheID,
PrecodiciPercentuali.p_Riconosciuta as '% Riconosciuta',
(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1) / (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1) AS PmReso,
CASE WHEN Vision.dbo.ListeRighe.ParentListeRigheID > 0 THEN ListeRigheVendite.Importo / ListeRigheVendite.Quantita ELSE 0 END AS PmVendite,
Vision.dbo.vCondizioniSconto.CondizioniScontoPercentuale AS Sconto

FROM Vision.dbo.ClientiFornitori INNER JOIN
Vision.dbo.ListeDocumenti AS ListeDocumenti INNER JOIN
Vision.dbo.Liste ON ListeDocumenti.ListeID = Vision.dbo.Liste.ID INNER JOIN
Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
Vision.dbo.Documenti ON ListeDocumenti.DocumentiID = Vision.dbo.Documenti.ID INNER JOIN
Vision.dbo.DocumentiClassiRaggruppamenti ON Vision.dbo.Documenti.ID = Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiID INNER JOIN
Vision.dbo.DocumentiTipo ON Vision.dbo.Documenti.DocumentiTipoID = Vision.dbo.DocumentiTipo.ID INNER JOIN
Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID ON Vision.dbo.ClientiFornitori.ID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID INNER JOIN
Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID INNER JOIN
Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
Vision.dbo.CausaliMagazzinoProgressivi ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID INNER JOIN
Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
Vision.dbo.Precodici ON Vision.dbo.ListeRighe.Precodice = Vision.dbo.Precodici.Codice INNER JOIN
Vision.dbo.vCondizioniSconto ON Vision.dbo.ListeRighe.CondizioniScontoID = Vision.dbo.vCondizioniSconto.ID INNER JOIN
opper.dbo.IDIR_CLIENTE ON opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ListeRighe AS ListeRigheVendite ON Vision.dbo.ListeRighe.ParentListeRigheID = ListeRigheVendite.ID LEFT JOIN
(
SELECT
[PrecodiceID],
AVG([% Riconosciuta]) AS p_Riconosciuta
FROM
Vision.[dbo].[_PowerBI_RF_Fornitori_Anni_Precodici]
GROUP BY
[PrecodiceID]
) AS PrecodiciPercentuali ON PrecodiciPercentuali.[PrecodiceID] = Vision.dbo.Precodici.ID INNER JOIN
Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID LEFT OUTER JOIN
(SELECT ContattiID, 'Si' AS ClienteAts
FROM Vision.dbo.ContattiRecapiti
WHERE (Valore = 'ATS') AND (ContattiRecapitiTipoID = 100)) AS ClientiATS ON Vision.dbo.Contatti.ID = ClientiATS.ContattiID LEFT OUTER JOIN
(SELECT MagazziniID AS MagazzinoID
FROM Vision.dbo.MagazziniClassiRaggruppamenti
WHERE (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazzinoID
WHERE (Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiClassiID = 10)
AND (Vision.dbo.DocumentiTipo.RettificheVendite = 1)
AND (YEAR(ListeDocumenti.DataDocumento) >= 2021)
AND (Vision.dbo.ListeRighe.ArticoloID > 0)
AND (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1 > 0)
AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB')))

UNION

SELECT
Vision.dbo.ListeRighe.ID AS ListaRigaID,
Vision.dbo.Liste.ID AS ListaID,
ListeDocumenti.DataDocumento AS DocumentoData,
Vision.dbo.Liste.Data as ListaData,
Vision.dbo.CausaliMagazzino.Descrizione AS CausaleMagazzino,
Vision.dbo.Documenti.Descrizione AS Documento,
CASE WHEN MagazziniDifettosi.MagazzinoID > 0 THEN 'Difettoso' ELSE 'Nuovo' END AS TipoMerce,
Vision.dbo.Liste.MagazziniID AS ID_MAGAZZINO,
opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE, /*DA AGGIUNGERE JOIN*/
ListeDocumenti.NumeroDocumento AS DocumentoNumero,
CASE WHEN Vision.dbo.Precodici.PrecodiceCauzioni = - 1 THEN 'Si' ELSE 'No' END AS Cauzione,
Vision.dbo.ListeRighe.ArticoloID,
Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1 AS Pezzi,
Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1 AS Valore,
ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0) * - 1 AS Costo,
(ISNULL(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita, 0) - ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0)) * - 1 AS Margine,
Vision.dbo.ListeRighe.ParentListeRigheID,
PrecodiciPercentuali.p_Riconosciuta as '% Riconosciuta',
(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1) / (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1) AS PmReso,
CASE WHEN Vision.dbo.ListeRighe.ParentListeRigheID > 0 THEN ListeRigheVendite.Importo / ListeRigheVendite.Quantita ELSE 0 END AS PmVendite,
Vision.dbo.vCondizioniSconto.CondizioniScontoPercentuale AS Sconto

FROM Vision.dbo.ClientiFornitori INNER JOIN
Vision.dbo.ListeDocumenti AS ListeDocumenti INNER JOIN
Vision.dbo.Liste ON ListeDocumenti.ListeID = Vision.dbo.Liste.ID INNER JOIN
Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
Vision.dbo.Documenti ON ListeDocumenti.DocumentiID = Vision.dbo.Documenti.ID INNER JOIN
Vision.dbo.DocumentiTipo ON Vision.dbo.Documenti.DocumentiTipoID = Vision.dbo.DocumentiTipo.ID INNER JOIN
Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID ON Vision.dbo.ClientiFornitori.ID =Vision. dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID INNER JOIN
Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID INNER JOIN
Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
Vision.dbo.CausaliMagazzinoProgressivi ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID INNER JOIN
Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
Vision.dbo.Precodici ON Vision.dbo.ListeRighe.Precodice = Vision.dbo.Precodici.Codice INNER JOIN
Vision.dbo.vCondizioniSconto ON Vision.dbo.ListeRighe.CondizioniScontoID = Vision.dbo.vCondizioniSconto.ID INNER JOIN
opper.dbo.IDIR_CLIENTE ON opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ListeRighe AS ListeRigheVendite ON Vision.dbo.ListeRighe.ParentListeRigheID = ListeRigheVendite.ID LEFT JOIN
(
SELECT
[PrecodiceID],
AVG([% Riconosciuta]) AS p_Riconosciuta
FROM
Vision.[dbo].[_PowerBI_RF_Fornitori_Anni_Precodici]
GROUP BY
[PrecodiceID]
) AS PrecodiciPercentuali ON PrecodiciPercentuali.[PrecodiceID] = Vision.dbo.Precodici.ID INNER JOIN
Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID LEFT OUTER JOIN
(SELECT ContattiID, 'Si' AS ClienteAts
FROM Vision.dbo.ContattiRecapiti
WHERE (Valore = 'ATS') AND (ContattiRecapitiTipoID = 100)) AS ClientiATS ON Vision.dbo.Contatti.ID = ClientiATS.ContattiID LEFT OUTER JOIN
(SELECT MagazziniID AS MagazzinoID
FROM Vision.dbo.MagazziniClassiRaggruppamenti
WHERE (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazzinoID
WHERE (YEAR(ListeDocumenti.DataDocumento) >= 2021)
AND (Vision.dbo.ListeRighe.ArticoloID > 0)
AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB')))
AND (Vision.dbo.Documenti.ID = 73);

INSERT INTO opper.dbo.IDIR_RESI_UPDATE(LISTA_RIGA_ID, DOCUMENTO_OLD, DOCUMENTO_NEW  ,LAST_UPDATE)
select A.LISTA_RIGA_ID, A.DOCUMENTO, B.DOCUMENTO, CURRENT_TIMESTAMP
from opper.dbo.IDIR_RESI_APP A,
opper.dbo.IDIR_RESI B
where A.LISTA_RIGA_ID = B.LISTA_RIGA_ID
and 
(
A.DOCUMENTO 	!= B.DOCUMENTO
);


TRUNCATE TABLE opper.dbo.IDIR_RESI_APP;

INSERT INTO opper.dbo.IDIR_RESI_APP
(  
	LISTA_RIGA_ID 
	,LISTA_ID 
	,DOCUMENTO_DATE 
	,LISTA_DATI  
	,CAUSALE_MAGAZZINO 
	,DOCUMENTO 
	,TIPO_MERCE 
	,ID_MAGAZZINO 
	,ID_CLIENTE 
	,DOCUMENTO_NUMERO 
	,CAUZIONE  
	,ARTICOLO_ID 
	,PEZZI 
	,VALORE 
	,COSTO  
	,MARGINE  
	,PARENT_LISTA_RIGA_ID 
	,RICONOSCIUTA
	,PM_VENDITE
	,PM_RESO
	,SCONTO
)
SELECT
Vision.dbo.ListeRighe.ID AS ListaRigaID,
Vision.dbo.Liste.ID AS ListaID,
ListeDocumenti.DataDocumento AS DocumentoData,
Vision.dbo.Liste.Data as ListaData,
Vision.dbo.CausaliMagazzino.Descrizione AS CausaleMagazzino,
Vision.dbo.Documenti.Descrizione AS Documento,
CASE WHEN MagazziniDifettosi.MagazzinoID > 0 THEN 'Difettoso' ELSE 'Nuovo' END AS TipoMerce,
Vision.dbo.Liste.MagazziniID AS ID_MAGAZZINO,
opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE,
ListeDocumenti.NumeroDocumento AS DocumentoNumero,
CASE WHEN Vision.dbo.Precodici.PrecodiceCauzioni = - 1 THEN 'Si' ELSE 'No' END AS Cauzione,
Vision.dbo.ListeRighe.ArticoloID,
Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1 AS Pezzi,
Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1 AS Valore,
ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0) * - 1 AS Costo,
(ISNULL(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita, 0) - ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0)) * - 1 AS Margine,
Vision.dbo.ListeRighe.ParentListeRigheID,
PrecodiciPercentuali.p_Riconosciuta as '% Riconosciuta',
(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1) / (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1) AS PmReso,
CASE WHEN Vision.dbo.ListeRighe.ParentListeRigheID > 0 THEN ListeRigheVendite.Importo / ListeRigheVendite.Quantita ELSE 0 END AS PmVendite,
Vision.dbo.vCondizioniSconto.CondizioniScontoPercentuale AS Sconto

FROM Vision.dbo.ClientiFornitori INNER JOIN
Vision.dbo.ListeDocumenti AS ListeDocumenti INNER JOIN
Vision.dbo.Liste ON ListeDocumenti.ListeID = Vision.dbo.Liste.ID INNER JOIN
Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
Vision.dbo.Documenti ON ListeDocumenti.DocumentiID = Vision.dbo.Documenti.ID INNER JOIN
Vision.dbo.DocumentiClassiRaggruppamenti ON Vision.dbo.Documenti.ID = Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiID INNER JOIN
Vision.dbo.DocumentiTipo ON Vision.dbo.Documenti.DocumentiTipoID = Vision.dbo.DocumentiTipo.ID INNER JOIN
Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID ON Vision.dbo.ClientiFornitori.ID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID INNER JOIN
Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID INNER JOIN
Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
Vision.dbo.CausaliMagazzinoProgressivi ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID INNER JOIN
Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
Vision.dbo.Precodici ON Vision.dbo.ListeRighe.Precodice = Vision.dbo.Precodici.Codice INNER JOIN
Vision.dbo.vCondizioniSconto ON Vision.dbo.ListeRighe.CondizioniScontoID = Vision.dbo.vCondizioniSconto.ID INNER JOIN
opper.dbo.IDIR_CLIENTE ON opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ListeRighe AS ListeRigheVendite ON Vision.dbo.ListeRighe.ParentListeRigheID = ListeRigheVendite.ID LEFT JOIN
(
SELECT
[PrecodiceID],
AVG([% Riconosciuta]) AS p_Riconosciuta
FROM
Vision.[dbo].[_PowerBI_RF_Fornitori_Anni_Precodici]
GROUP BY
[PrecodiceID]
) AS PrecodiciPercentuali ON PrecodiciPercentuali.[PrecodiceID] = Vision.dbo.Precodici.ID INNER JOIN
Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID LEFT OUTER JOIN
(SELECT ContattiID, 'Si' AS ClienteAts
FROM Vision.dbo.ContattiRecapiti
WHERE (Valore = 'ATS') AND (ContattiRecapitiTipoID = 100)) AS ClientiATS ON Vision.dbo.Contatti.ID = ClientiATS.ContattiID LEFT OUTER JOIN
(SELECT MagazziniID AS MagazzinoID
FROM Vision.dbo.MagazziniClassiRaggruppamenti
WHERE (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazzinoID
WHERE (Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiClassiID = 10)
AND (Vision.dbo.DocumentiTipo.RettificheVendite = 1)
AND (YEAR(ListeDocumenti.DataDocumento) >= 2021)
AND (Vision.dbo.ListeRighe.ArticoloID > 0)
AND (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1 > 0)
AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB')))

UNION

SELECT
Vision.dbo.ListeRighe.ID AS ListaRigaID,
Vision.dbo.Liste.ID AS ListaID,
ListeDocumenti.DataDocumento AS DocumentoData,
Vision.dbo.Liste.Data as ListaData,
Vision.dbo.CausaliMagazzino.Descrizione AS CausaleMagazzino,
Vision.dbo.Documenti.Descrizione AS Documento,
CASE WHEN MagazziniDifettosi.MagazzinoID > 0 THEN 'Difettoso' ELSE 'Nuovo' END AS TipoMerce,
Vision.dbo.Liste.MagazziniID AS ID_MAGAZZINO,
opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE, /*DA AGGIUNGERE JOIN*/
ListeDocumenti.NumeroDocumento AS DocumentoNumero,
CASE WHEN Vision.dbo.Precodici.PrecodiceCauzioni = - 1 THEN 'Si' ELSE 'No' END AS Cauzione,
Vision.dbo.ListeRighe.ArticoloID,
Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1 AS Pezzi,
Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1 AS Valore,
ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0) * - 1 AS Costo,
(ISNULL(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita, 0) - ISNULL(Vision.dbo.ListeRighe.Quantita * Vision.dbo.ListeRighe.ListinoCosto * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheCosto, 0)) * - 1 AS Margine,
Vision.dbo.ListeRighe.ParentListeRigheID,
PrecodiciPercentuali.p_Riconosciuta as '% Riconosciuta',
(Vision.dbo.ListeRighe.Importo * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVendita * - 1) / (Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliMagazzinoListeRigheTipo.StatisticheVenditaQuantita * - 1) AS PmReso,
CASE WHEN Vision.dbo.ListeRighe.ParentListeRigheID > 0 THEN ListeRigheVendite.Importo / ListeRigheVendite.Quantita ELSE 0 END AS PmVendite,
Vision.dbo.vCondizioniSconto.CondizioniScontoPercentuale AS Sconto

FROM Vision.dbo.ClientiFornitori INNER JOIN
Vision.dbo.ListeDocumenti AS ListeDocumenti INNER JOIN
Vision.dbo.Liste ON ListeDocumenti.ListeID = Vision.dbo.Liste.ID INNER JOIN
Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
Vision.dbo.Documenti ON ListeDocumenti.DocumentiID = Vision.dbo.Documenti.ID INNER JOIN
Vision.dbo.DocumentiTipo ON Vision.dbo.Documenti.DocumentiTipoID = Vision.dbo.DocumentiTipo.ID INNER JOIN
Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID ON Vision.dbo.ClientiFornitori.ID =Vision. dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID INNER JOIN
Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID INNER JOIN
Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
Vision.dbo.CausaliMagazzinoProgressivi ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID INNER JOIN
Vision.dbo.Articoli ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
Vision.dbo.Precodici ON Vision.dbo.ListeRighe.Precodice = Vision.dbo.Precodici.Codice INNER JOIN
Vision.dbo.vCondizioniSconto ON Vision.dbo.ListeRighe.CondizioniScontoID = Vision.dbo.vCondizioniSconto.ID INNER JOIN
opper.dbo.IDIR_CLIENTE ON opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
Vision.dbo.ListeRighe AS ListeRigheVendite ON Vision.dbo.ListeRighe.ParentListeRigheID = ListeRigheVendite.ID LEFT JOIN
(
SELECT
[PrecodiceID],
AVG([% Riconosciuta]) AS p_Riconosciuta
FROM
Vision.[dbo].[_PowerBI_RF_Fornitori_Anni_Precodici]
GROUP BY
[PrecodiceID]
) AS PrecodiciPercentuali ON PrecodiciPercentuali.[PrecodiceID] = Vision.dbo.Precodici.ID INNER JOIN
Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID LEFT OUTER JOIN
(SELECT ContattiID, 'Si' AS ClienteAts
FROM Vision.dbo.ContattiRecapiti
WHERE (Valore = 'ATS') AND (ContattiRecapitiTipoID = 100)) AS ClientiATS ON Vision.dbo.Contatti.ID = ClientiATS.ContattiID LEFT OUTER JOIN
(SELECT MagazziniID AS MagazzinoID
FROM Vision.dbo.MagazziniClassiRaggruppamenti
WHERE (MagazziniClassiID = 409)) AS MagazziniDifettosi ON Vision.dbo.Liste.MagazziniID = MagazziniDifettosi.MagazzinoID
WHERE (YEAR(ListeDocumenti.DataDocumento) >= 2021)
AND (Vision.dbo.ListeRighe.ArticoloID > 0)
AND (NOT (Vision.dbo.ListeRighe.Precodice IN ('SOVRAP', 'SOVRAB')))
AND (Vision.dbo.Documenti.ID = 73);

TRUNCATE TABLE opper.dbo.IDIR_INTERCOMPANY;

insert into opper.dbo.IDIR_INTERCOMPANY
(  
	LISTA_RIGA_ID 
	,LISTA_ID 
	,ARTICOLO_ID 
	,INTERCOMPANY 
	,INTERCOMPANY_CODICE 
	,LIST_DATA 
	,LISTA_NUMERO 
	,MAGAZZINO_ID
	,QTA 
	,QTA_EVASA 
	,QTA_INEVASA 
	,QTA_FORZATA 
	,CAUSALE_MAGAZZINO 
)
SELECT	Vision.dbo.ListeRighe.ID,
		Vision.dbo.Liste.ID,
		Vision.dbo.ListeRighe.ArticoloID, 
		Vision.dbo.Contatti.Cognome,
		Vision.dbo.ContattiContabili.Codice,
		Vision.dbo.Liste.Data, 
		Vision.dbo.Liste.Numero, 
		Vision.dbo.Magazzini.ID,Vision.dbo.ListeRighe.Quantita AS Quantita,
		Vision.dbo.ListeRighe.Quantita - (Vision.dbo.ListeRighe.Quantita - ISNULL((SELECT   SUM(Quantita) AS QuantitaEvasa          FROM        Vision.dbo.ListeRighe AS ListeRighe_1     WHERE        (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0)),
		Vision.dbo.ListeRighe.Quantita - ISNULL((SELECT        SUM(Quantita) AS QuantitaEvasa         FROM            Vision.dbo.ListeRighe AS ListeRighe_1      WHERE        (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0),
		Vision.dbo.ListeRighe.QuantitaForzata,
		Vision.dbo.CausaliMagazzino.Descrizione 
FROM 	Vision.dbo.Liste INNER JOIN
		Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
		Vision.dbo.ListeDocumenti ON Vision.dbo.Liste.ID = Vision.dbo.ListeDocumenti.ListeID INNER JOIN
		Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID INNER JOIN
		Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
		Vision.dbo.ListeEvasioneTipo ON Vision.dbo.Liste.ListeEvasioneTipoID = Vision.dbo.ListeEvasioneTipo.ID INNER JOIN
		Vision.dbo.ListeProvenienzaTipo ON Vision.dbo.Liste.ListeProvenienzaTipoID = Vision.dbo.ListeProvenienzaTipo.ID INNER JOIN
		Vision.dbo.ClientiFornitori ON Vision.dbo.Liste.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN
		Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID INNER JOIN
		Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID
WHERE 	Vision.dbo.CausaliMagazzino.Impegni = 1 
AND 	Vision.dbo.ContattiContabili.ContattiTipoID = 7;


TRUNCATE TABLE opper.dbo.IDIR_GIACENZA;


insert into opper.dbo.IDIR_GIACENZA
(  
	DATA_LISTA 
	,MAGAZZINI_ID 
	,PRECODICE_ID 
	,ARTICOLO_ID 
	,MAGAZZINO_CODICE
	,ESISTENZA 
)
SELECT Vision.dbo.Liste.Data AS DATA_LISTA, Vision.dbo.Liste.MagazziniID as MAGAZZINI_ID, Vision.dbo.ArticoliCodifiche.PrecodiceID as PRECODICE_ID, Vision.dbo.ArticoliCodifiche.ArticoloID as ARTICOLO_ID, Vision.dbo.Magazzini.Codice AS MAGAZZINO_CODICE, 
                   SUM(Vision.dbo.ListeRighe.Quantita * Vision.dbo.CausaliProgressivi.Moltiplicatore) AS ESISTENZA
FROM     Vision.dbo.ListeRighe INNER JOIN
                  Vision.dbo.Liste ON Vision.dbo.ListeRighe.ListeID = Vision.dbo.Liste.ID INNER JOIN
                  Vision.dbo.CausaliMagazzinoProgressivi ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoProgressivi.CausaliMagazzinoListeRigheTipoID INNER JOIN
                  Vision.dbo.CausaliProgressivi ON Vision.dbo.CausaliMagazzinoProgressivi.CausaliProgressiviID = Vision.dbo.CausaliProgressivi.ID INNER JOIN
                  Vision.dbo.ArticoliCodifiche ON Vision.dbo.ListeRighe.ArticoloID = Vision.dbo.ArticoliCodifiche.ArticoloID INNER JOIN
                  Vision.dbo.Precodici ON Vision.dbo.ArticoliCodifiche.PrecodiceID = Vision.dbo.Precodici.ID INNER JOIN
                  Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
                  Vision.dbo.MagazziniClassiRaggruppamenti ON Vision.dbo.Magazzini.ID = Vision.dbo.MagazziniClassiRaggruppamenti.MagazziniID INNER JOIN
                  Vision.dbo.MagazziniClassi ON Vision.dbo.MagazziniClassiRaggruppamenti.MagazziniClassiID = Vision.dbo.MagazziniClassi.ID
WHERE  (Vision.dbo.ArticoliCodifiche.ArticoliCodificheTipoID = 1) AND Vision.dbo.ListeRighe.Precodice not in ('SOVRAP','SOVRAB')
AND (Vision.dbo.MagazziniClassi.ID IN (498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 512, 516, 517, 518, 519, 520))
AND (Vision.dbo.Liste.Data <= Convert(date, Getdate()-1))
GROUP BY Vision.dbo.ArticoliCodifiche.ArticoloID, Vision.dbo.Precodici.Codice, Vision.dbo.ArticoliCodifiche.Articolo, Vision.dbo.Liste.Data, Vision.dbo.ArticoliCodifiche.PrecodiceID, Vision.dbo.Liste.MagazziniID, Vision.dbo.Magazzini.Codice, Vision.dbo.Magazzini.Descrizione;


TRUNCATE TABLE opper.dbo.IDIR_ABC_ARTICOLI;

INSERT INTO opper.dbo.IDIR_ABC_ARTICOLI
(  
	ARTICOLO_ID 
	,PRECODICE
    ,CODICE
    ,VALORE_TOT
	,RANK
	,VENDUTO_TOTALE
	,TOTALE
	,VENDUTO_CUMULATO
	,CUMULATA
	,ABC
	,ABC_PRECODICE
)
SELECT
    tabella_ABC_tot.ARTICOLO_ID,
    tabella_ABC_tot.PRECODICE,
    tabella_ABC_tot.CODICE,
    tabella_ABC_tot.ValoreTot,
    tabella_ABC_tot.Rank,
    tabella_ABC_tot.VendutoTot,
    tabella_ABC_tot.[% su Tot],
    tabella_ABC_tot.VendutoCumulato,
    tabella_ABC_tot.[% Cumulata],
    tabella_ABC_tot.ABC,
    tabella_ABC_Precodice.ABC as "ABC_PRECODICE"
FROM
(
    SELECT
        opper.dbo.[IDIR_VENDITE].ARTICOLO_ID,
        opper.dbo.IDIR_ARTICOLI.PRECODICE,
        opper.dbo.IDIR_ARTICOLI.CODICE,
        SUM(CAST([VALORE] AS DECIMAL(18, 2))) AS ValoreTot,
        ROW_NUMBER() OVER (ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 2))) DESC) AS [Rank],
        SUM(SUM(CAST([VALORE] AS DECIMAL(18, 2)))) OVER () AS VendutoTot,
        CAST(
            CAST(SUM(CAST([VALORE] AS DECIMAL(18, 8))) AS NUMERIC(18, 8)) /
            CAST(SUM(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER () AS NUMERIC(18, 8)) 
            AS NUMERIC(18, 8)
        ) AS [% su Tot],
        Sum(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) [VendutoCumulato],
        CAST(Sum(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER () AS numeric(18,8)) [% Cumulata],
        CASE
            WHEN  CAST(Sum(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER () AS numeric(18,8))<= 0.60 THEN 'A'
            WHEN  CAST(Sum(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER () AS numeric(18,8))<= 0.85 THEN 'B'
            WHEN  CAST(Sum(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST([VALORE] AS DECIMAL(18, 8)))) OVER () AS numeric(18,8))<= 0.95 THEN 'C'
            ELSE 'D'
        END AS ABC
    FROM
        [Opper].[dbo].[IDIR_VENDITE],
        Opper.dbo.IDIR_ARTICOLI
    WHERE 
        [Opper].[dbo].[IDIR_VENDITE].[DATA] >= DATEADD(YEAR, -1, GETDATE())
        AND CAST([VALORE] AS DECIMAL(18, 8)) > 0
        AND opper.dbo.IDIR_VENDITE.ARTICOLO_ID = opper.dbo.IDIR_ARTICOLI.ARTICOLO_ID
    GROUP BY
        opper.dbo.idir_vendite.[ARTICOLO_ID],
        opper.dbo.IDIR_ARTICOLI.[PRECODICE],
        opper.dbo.IDIR_ARTICOLI.[CODICE]
) AS tabella_ABC_tot
LEFT JOIN
(
    SELECT
        r.ARTICOLO_ID,
        r.PRECODICE,
        r.CODICE,
        r.ValoreTot,
        r.[Rank],
        r.VendutoTot,
        CAST(
            CAST(r.ValoreTot AS NUMERIC(18, 8)) /
            CAST(r.VendutoTot AS NUMERIC(18, 8)) 
            AS NUMERIC(18, 8)
        ) AS [% su Tot],
        Sum(r.ValoreTot) OVER (PARTITION BY r.PRECODICE ORDER BY r.[Rank] ASC Rows BETWEEN unbounded preceding AND CURRENT row) [VendutoCumulato],
        CAST(Sum(r.ValoreTot) OVER (PARTITION BY r.PRECODICE ORDER BY r.[Rank] ASC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(r.VendutoTot AS numeric(18,8)) [% Cumulata],
        CASE
            WHEN f.FirstCodeClassA = 'A' OR f.FirstCodeClassA IS NULL THEN 'A'
            WHEN CAST(Sum(r.ValoreTot) OVER (PARTITION BY r.PRECODICE ORDER BY r.[Rank] ASC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(r.VendutoTot AS numeric(18,8)) <= 0.60 THEN 'A'
            WHEN CAST(Sum(r.ValoreTot) OVER (PARTITION BY r.PRECODICE ORDER BY r.[Rank] ASC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(r.VendutoTot AS numeric(18,8)) <= 0.85 THEN 'B'
            WHEN CAST(Sum(r.ValoreTot) OVER (PARTITION BY r.PRECODICE ORDER BY r.[Rank] ASC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(r.VendutoTot AS numeric(18,8)) <= 0.95 THEN 'C'
            ELSE 'D'
        END AS ABC
    FROM
        (
            SELECT
                opper.dbo.IDIR_VENDITE.ARTICOLO_ID,
                opper.dbo.IDIR_ARTICOLI.PRECODICE,
                opper.dbo.IDIR_ARTICOLI.CODICE,
                SUM(CAST([VALORE] AS DECIMAL(18, 2))) AS ValoreTot,
                ROW_NUMBER() OVER (PARTITION BY opper.dbo.IDIR_ARTICOLI.PRECODICE ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 2))) DESC) AS [Rank],
                SUM(SUM(CAST([VALORE] AS DECIMAL(18, 2)))) OVER (PARTITION BY opper.dbo.IDIR_ARTICOLI.PRECODICE) AS VendutoTot
            FROM
                [Opper].[dbo].[IDIR_VENDITE]
            JOIN
                Opper.dbo.IDIR_ARTICOLI ON opper.dbo.IDIR_VENDITE.ARTICOLO_ID = opper.dbo.IDIR_ARTICOLI.ARTICOLO_ID
            WHERE 
                [Opper].[dbo].[IDIR_VENDITE].[DATA] >= DATEADD(YEAR, -1, GETDATE())
                AND CAST([VALORE] AS DECIMAL(18, 8)) > 0
            GROUP BY
                opper.dbo.IDIR_VENDITE.ARTICOLO_ID,
                opper.dbo.IDIR_ARTICOLI.PRECODICE,
                opper.dbo.IDIR_ARTICOLI.CODICE
        ) AS r
    LEFT JOIN
        (
            SELECT
                ARTICOLO_ID,
                PRECODICE,
                CODICE,
                [Rank],
                CASE WHEN [Rank] = 1 THEN 'A' ELSE '' END AS FirstCodeClassA
            FROM
                (
                    SELECT
                        opper.dbo.IDIR_VENDITE.ARTICOLO_ID,
                        opper.dbo.IDIR_ARTICOLI.PRECODICE,
                        opper.dbo.IDIR_ARTICOLI.CODICE,
                        SUM(CAST([VALORE] AS DECIMAL(18, 2))) AS ValoreTot,
                        ROW_NUMBER() OVER (PARTITION BY opper.dbo.IDIR_ARTICOLI.PRECODICE ORDER BY SUM(CAST([VALORE] AS DECIMAL(18, 2))) DESC) AS [Rank],
                        SUM(SUM(CAST([VALORE] AS DECIMAL(18, 2)))) OVER (PARTITION BY opper.dbo.IDIR_ARTICOLI.PRECODICE) AS VendutoTot
                    FROM
                        [Opper].[dbo].[IDIR_VENDITE]
                    JOIN
                        Opper.dbo.IDIR_ARTICOLI ON opper.dbo.IDIR_VENDITE.ARTICOLO_ID = opper.dbo.IDIR_ARTICOLI.ARTICOLO_ID
                    WHERE 
                        [Opper].[dbo].[IDIR_VENDITE].[DATA] >= DATEADD(YEAR, -1, GETDATE())
                        AND CAST([VALORE] AS DECIMAL(18, 8)) > 0
                    GROUP BY
                        opper.dbo.IDIR_VENDITE.ARTICOLO_ID,
                        opper.dbo.IDIR_ARTICOLI.PRECODICE,
                        opper.dbo.IDIR_ARTICOLI.CODICE
                ) AS RankedData
        ) AS f ON r.ARTICOLO_ID = f.ARTICOLO_ID AND r.PRECODICE = f.PRECODICE AND r.CODICE = f.CODICE
) AS tabella_ABC_Precodice ON tabella_ABC_tot.ARTICOLO_ID = tabella_ABC_Precodice.ARTICOLO_ID;


TRUNCATE TABLE opper.dbo.IDIR_VENDITE_TIME;

insert into opper.dbo.IDIR_VENDITE_TIME 
(  
	ID_VENDITA
	,LISTA_RIGA_ID 
	,LISTA_ID 
	,PARENTLISTARIGHEID 
	,QTA 
	,PREZZO 
	,COSTO_UNITARIO 
	,DATA 
	,DATA_RIFERIMENTO 
	,ARTICOLO_ID 
	,ID_CLIENTE 
	,ID_AGENTE 
	,ID_MAGAZZINO 
	,ID_AREA 
	,CAUSALE_MAGAZZINO 
	,ID_VETTORE 
	,VETTORE  
	,VETTORE_FORNITORE 
	,VALORE  
	,MARGINE  
	,LISTINO  
	,LISTINOCODICE  
	,TIPOOPERAZIONE 
	,TIPOMERCE 
	,TIPORIGA
	,ORDINEDATAKEY
	,ORDINETIMEATLKEY
	,RIGAORDINETIMEATLKEY
	,RIGAORDINEWMSDATAKEY
	,RIGAORDINEWMSTIMEATLKEY
	,TIMEALTKEYCUTOFF
	,DETTAGLIOKEY
) 
SELECT [ID]
	  ,[LISTA_RIGA_ID]
      ,[LISTA_ID]
      ,[PARENTLISTARIGHEID]
      ,[QTA]
      ,[PREZZO]
      ,[COSTO_UNITARIO]
      ,[DATA]
      ,[DATA_RIFERIMENTO]
      ,[ARTICOLO_ID]
      ,[ID_CLIENTE]
      ,[ID_AGENTE]
      ,[ID_MAGAZZINO]
      ,[ID_AREA]
      ,[CAUSALE_MAGAZZINO]
      ,[ID_VETTORE]
      ,[VETTORE]
      ,[VETTORE_FORNITORE]
      ,[VALORE]
      ,[MARGINE]
      ,[LISTINO]
      ,[LISTINOCODICE]
      ,[TIPOOPERAZIONE]
      ,[TIPOMERCE]
      ,[TIPORIGA]
	  ,STUFF(STUFF( LogisticaDWH.dbo._FactSales.OrdineDataKey,5, 0, '-'), 8, 0, '-') as OrdineDataKey
	  ,case WHEN LEN(LogisticaDWH.dbo._FactSales.OrdineTimeAtlkey) < 6 THEN 
	   	   STUFF(STUFF(CONCAT('0', LogisticaDWH.dbo._FactSales.OrdineTimeAtlkey) , 3, 0, ':'), 6, 0, ':')
	   ELSE	   STUFF(STUFF( LogisticaDWH.dbo._FactSales.OrdineTimeAtlkey , 3, 0, ':'), 6, 0, ':') END as OrdineTimeAtlkey
	   ,case WHEN LEN(LogisticaDWH.dbo._FactSales.RigaOrdineTimeAtlkey) < 6 THEN 
	   	   STUFF(STUFF(CONCAT('0', LogisticaDWH.dbo._FactSales.RigaOrdineTimeAtlkey) , 3, 0, ':'), 6, 0, ':')
	   ELSE	   STUFF(STUFF( LogisticaDWH.dbo._FactSales.RigaOrdineTimeAtlkey , 3, 0, ':'), 6, 0, ':') END as RigaOrdineTimeAtlkey
	  ,STUFF(STUFF( LogisticaDWH.dbo._FactSales.RigaOrdineWmsDataKey,5, 0, '-'), 8, 0, '-') as RigaOrdineWmsDataKey
	  ,case WHEN LEN(LogisticaDWH.dbo._FactSales.RigaOrdineWmsTimeAtlkey) < 6 THEN 
	   	   STUFF(STUFF(CONCAT('0', LogisticaDWH.dbo._FactSales.RigaOrdineWmsTimeAtlkey) , 3, 0, ':'), 6, 0, ':')
	   ELSE	   STUFF(STUFF( LogisticaDWH.dbo._FactSales.RigaOrdineWmsTimeAtlkey , 3, 0, ':'), 6, 0, ':') END as RigaOrdineWmsTimeAtlkey
	   ,case WHEN LEN(LogisticaDWH.dbo._FactSales.TimeAltKeyCutOff) < 6 THEN 
	   	   STUFF(STUFF(CONCAT('0', LogisticaDWH.dbo._FactSales.TimeAltKeyCutOff) , 3, 0, ':'), 6, 0, ':')
	   ELSE	   STUFF(STUFF( LogisticaDWH.dbo._FactSales.TimeAltKeyCutOff , 3, 0, ':'), 6, 0, ':') END as TimeAltKeyCutOff
	  ,LogisticaDWH.dbo._FactSales.DettaglioKey
  FROM [Opper].[dbo].[IDIR_VENDITE] LEFT JOIN 
  LogisticaDWH.dbo._FactSales ON [Opper].[dbo].[IDIR_VENDITE].[LISTA_RIGA_ID] = LogisticaDWH.dbo._FactSales.ListeRigaId;
  
TRUNCATE TABLE opper.dbo.IDIR_COMPORTAMENTO_CLIENTE;

insert into opper.dbo.IDIR_COMPORTAMENTO_CLIENTE
(
	ID_CLIENTE 
	,LISTA_ID 
	,DATA 
	,VETTORE 
	,NumRighe 
	,DeltaDataConsegnaDataMax 
	,DeltaDataConsegnaDataMin 
	,DeltaDataDataMinDataMax 
	,ScoreCutoff 
	,ScoreGruppo 
)
SELECT
ID_CLIENTE,
LISTA_ID,
DATA,
VETTORE,
NumRighe,
case when CAST(DATEDIFF(MINUTE,DataWMSMax,DataConsegna) / 60.0 AS DECIMAL(10,2))<0 then 0 else CAST(DATEDIFF(MINUTE,DataWMSMax,DataConsegna) / 60.0 AS DECIMAL(10,2)) end AS DeltaDataConsegnaDataMax,
case when CAST(DATEDIFF(MINUTE,DataWMSMin,DataConsegna) / 60.0 AS DECIMAL(10,2))<0 then 0 else CAST(DATEDIFF(MINUTE,DataWMSMin,DataConsegna) / 60.0 AS DECIMAL(10,2)) end AS DeltaDataConsegnaDataMin,
case when CAST(DATEDIFF(MINUTE,DataWMSMin,DataWMSMax) / 60.0 AS DECIMAL(10,2))<0 then 0 else CAST(DATEDIFF(MINUTE,DataWMSMin,DataWMSMax) / 60.0 AS DECIMAL(10,2)) end AS DeltaDataDataMinDataMax,
CASE WHEN DATEDIFF
(
   MINUTE,DataWMSMax,DataConsegna
)
/ 60.0 < 1 THEN 0 WHEN DATEDIFF(MINUTE,DataWMSMax,DataConsegna) / 60.0 >= 2
AND DATEDIFF
(
   MINUTE,DataWMSMax,DataConsegna
)
/ 60.0 < 2 THEN 0 WHEN DATEDIFF(MINUTE,DataWMSMax,DataConsegna) / 60.0 >= 3
AND DATEDIFF
(
   MINUTE,DataWMSMax,DataConsegna
)
/ 60.0 < 3 THEN 0.25 WHEN DATEDIFF(MINUTE,DataWMSMax,DataConsegna) / 60.0 >= 4
AND DATEDIFF(MINUTE,DataWMSMax,DataConsegna) / 60.0 < 4 THEN 0.75 ELSE 1 END AS ScoreCutoff,
CASE WHEN DATEDIFF
(
   MINUTE,DataWMSMin,DataWMSMax
)
/ 60.0 < 1 THEN 1 WHEN DATEDIFF(MINUTE,DataWMSMin,DataWMSMax) / 60.0 >= 1
AND DATEDIFF
(
   MINUTE,DataWMSMin,DataWMSMax
)
/ 60.0 < 2 THEN 0.75 WHEN DATEDIFF(MINUTE,DataWMSMin,DataWMSMax) / 60.0 >= 2
AND DATEDIFF
(
   MINUTE,DataWMSMin,DataWMSMax
)
/ 60.0 < 3 THEN 0.25 WHEN DATEDIFF(MINUTE,DataWMSMin,DataWMSMax) / 60.0 >= 3
AND DATEDIFF
(
   MINUTE,DataWMSMin,DataWMSMax
)
/ 60.0 < 4 THEN 1 ELSE 0 END AS ScoreGruppo
FROM
(
   SELECT
   ID_CLIENTE,
   LISTA_ID,
   VETTORE,
   DATA,
   MAX(TRY_CONVERT(DATETIME,RIGAORDINEWMSDATAKEY + ' ' + RIGAORDINEWMSTIMEATLKEY,121)) AS DataWMSMax,
   MIN(TRY_CONVERT(DATETIME,RIGAORDINEWMSDATAKEY + ' ' + RIGAORDINEWMSTIMEATLKEY,121)) AS DataWMSMin,
   MAX(TRY_CONVERT(DATETIME,CONVERT(VARCHAR,DATA,23) + ' ' + TIMEALTKEYCUTOFF,121)) AS DataConsegna,
   sum(1) as NumRighe
   FROM Opper.dbo.IDIR_VENDITE_TIME
   WHERE ORDINEDATAKEY IS NOT NULL
   AND TIMEALTKEYCUTOFF IS NOT NULL
   AND TIMEALTKEYCUTOFF <> ''
   GROUP BY ID_CLIENTE,LISTA_ID,DATA,VETTORE
)
AS AggregatedData;

		
TRUNCATE TABLE opper.dbo.IDIR_KPI_FORNITORI;

INSERT INTO opper.dbo.IDIR_KPI_FORNITORI
(
	ANNO 
	,CLIENTEFORNITOREID 
	,FORNITORE 
	,OBIETTIVO 
	,PREMIO_PREVISTO 
	,ACQUISTATO 
)
SELECT  
Vision.dbo._PowerBI_PF_Sintesi.Anno,
Vision.dbo._PowerBI_PF_Sintesi.ClienteFornitoreID,
Vision.dbo._PowerBI_PF_Sintesi.Fornitore,
Vision.dbo._PowerBI_PF_Sintesi.Obiettivo,
Vision.dbo._PowerBI_PF_Sintesi.[Premio Previsto],
Vision.dbo._PowerBI_PF_Sintesi.Acquistato
FROM 
Vision.dbo._PowerBI_PF_Sintesi;

TRUNCATE TABLE opper.dbo.IDIR_KPI_GIACENZA;

INSERT INTO opper.dbo.IDIR_KPI_GIACENZA
(
	ANNO
	,PRECODICISTATISTICHEID
	,OBIETTIVOMAGAZZINO
)
SELECT 
Vision.dbo.IDIR_Timone_PrecodiciStatistiche.Anno,
Vision.dbo.IDIR_Timone_PrecodiciStatistiche.PrecodiciStatisticheID,
Vision.dbo.IDIR_Timone_PrecodiciStatistiche.ObiettivoMagazzino
FROM
Vision.dbo.IDIR_Timone_PrecodiciStatistiche;

TRUNCATE TABLE opper.dbo.IDIR_KPI_BUDGET;

INSERT INTO opper.dbo.IDIR_KPI_BUDGET
(
	BUDGETRIGHE_ID
	,DESCRIZIONE
	,BUDGETID
    ,MESIID
    ,AGENTIID
	,PRECODICISTATISTICHEID
	,PRECODICESTATISTICHE
    ,QUANTITA
    ,VALORE
    ,APPROVATO
)
SELECT  [Vision].[dbo].[BudgetRighe].[ID]
		,[Vision].dbo.Budget.Descrizione
      ,[BudgetID]
      ,[MesiID]
      ,[AgentiID]
	  ,[PrecodiciID] as PrecodiciStatisticheID
	  ,[Vision].dbo.PrecodiciStatistiche.Descrizione as PrecodiceStatistiche
      ,[Quantita]
      ,[Valore]	
      ,[Approvato]
  FROM [Vision].[dbo].[BudgetRighe] LEFT JOIN
		[Vision].dbo.PrecodiciStatistiche ON [Vision].[dbo].[BudgetRighe].PrecodiciID = vision.dbo.PrecodiciStatistiche.ID LEFT JOIN
		[Vision].dbo.Budget ON [Vision].[dbo].[BudgetRighe].BudgetID = [Vision].dbo.Budget.ID;
		
TRUNCATE TABLE opper.dbo.IDIR_CAPOAREA_AGENTI;
  
INSERT INTO opper.dbo.IDIR_CAPOAREA_AGENTI
(
	CAPO_AREA
	,CONTATTO_ID
	,Agente
	,AGENTE_ID
)
SELECT 
Contatti_CapoArea.Cognome AS CapoArea,
vision.dbo.ContattiAssociazioni.ContattiIDParent AS ContattoID, 
vision.dbo.Contatti.Cognome AS Agente,
vision.dbo.Agenti.ID as AgenteID
FROM     vision.dbo.ContattiAssociazioni INNER JOIN
                  vision.dbo.Contatti ON vision.dbo.ContattiAssociazioni.ContattiID = vision.dbo.Contatti.ID INNER JOIN
                  vision.dbo.Contatti AS Contatti_CapoArea ON vision.dbo.ContattiAssociazioni.ContattiIDParent = Contatti_CapoArea.ID LEFT JOIN
				  vision.dbo.Agenti ON vision.dbo.Agenti.ContattiID = vision.dbo.Contatti.ID
WHERE  (vision.dbo.ContattiAssociazioni.ContattiAssociazioniTipoID = 2);

TRUNCATE TABLE opper.dbo.IDIR_GIACENZA_ALLA_DATA;

INSERT INTO opper.dbo.IDIR_GIACENZA_ALLA_DATA
(
	ARTICOLO_ID
	,DATA_LISTA
	,ESISTENZA
	,GIACENZAALLADATA
)
SELECT 
    ARTICOLO_ID,
    DATA_LISTA,
    ESISTENZA,
    SUM(ESISTENZA) OVER (PARTITION BY ARTICOLO_ID ORDER BY DATA_LISTA ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS GiacenzaAllaData
FROM opper.dbo.IDIR_GIACENZA;

TRUNCATE TABLE opper.dbo.IDIR_ABC_PRELIEVI;

INSERT INTO opper.dbo.IDIR_ABC_PRELIEVI
(
	ARTICOLO_ID 
	,SOTTOCLASSE_CODICE 
	,PRELEVATOCODICE
	,PRELEVATOTOT
	,PRELEVATOCUMULATO		
	,CUMULATA 
	,SU_TOT 
	,ABC_CODICE 
	,ABC_SOTTOCLASSE_CODICE 
)
SELECT
ABC_codice.ARTICOLO_ID,
ABC_codice.SOTTOCLASSE_CODICE,
ABC_codice.PrelevatoCodice,
ABC_codice.PrelevatoTot,
ABC_codice.PrelevatoCumulato,
ABC_codice.[% Cumulata],
ABC_codice.[% su Tot],
ABC_codice.ABC,
ABC_sottoclasse.ABC_sottoclasse
FROM
(
    SELECT
        opper.dbo.IDIR_ARTICOLI.ARTICOLO_ID,
		opper.dbo.IDIR_ARTICOLI.SOTTOCLASSE_CODICE,
        COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) AS PrelevatoCodice,
        ROW_NUMBER() OVER (ORDER BY  COUNT(CAST([FACT_PRELIEVI_ID] AS DECIMAL(18, 2))) DESC) AS [Rank],
        SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS PrelevatoTot,
        CAST(
            CAST( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) AS NUMERIC(18, 8)) /
            CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS NUMERIC(18, 8)) 
            AS NUMERIC(18, 8)
        ) AS [% su Tot],
        SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) [PrelevatoCumulato],
        CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8)) [% Cumulata],
        CASE
            WHEN  CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8))<= 0.60 THEN 'A'
            WHEN  CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8))<= 0.85 THEN 'B'
            WHEN  CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8))<= 0.95 THEN 'C'
            ELSE 'D'
        END AS ABC
    FROM
        [Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI],
        Opper.dbo.IDIR_ARTICOLI
    WHERE 
        CONVERT(DATE, CAST([Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI].[PRELIEVO_DATA_KEY] as varchar), 112) >= DATEADD(YEAR, -1, GETDATE())
        AND CAST([QUANTITA] AS DECIMAL(18, 8)) > 0
        AND [Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI].[ARTICOLO_KEY] = CONCAT(opper.dbo.IDIR_ARTICOLI.PRECODICE, '|', opper.dbo.IDIR_ARTICOLI.CODICE)
    GROUP BY
        opper.dbo.IDIR_ARTICOLI.[ARTICOLO_ID],
		opper.dbo.IDIR_ARTICOLI.SOTTOCLASSE_CODICE
		) as ABC_codice
LEFT JOIN
(
	    SELECT
        opper.dbo.IDIR_ARTICOLI.SOTTOCLASSE_CODICE,
          COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) AS PrelevatoSottoClasse,
        ROW_NUMBER() OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC) AS [Rank],
        SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS PrelevatoTot,
        CAST(
            CAST( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) AS NUMERIC(18, 8)) /
            CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS NUMERIC(18, 8)) 
            AS NUMERIC(18, 8)
        ) AS [% su Tot],
        SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) [PrelevatoCumulato],
        CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8)) [% Cumulata],
        CASE
            WHEN  CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8))<= 0.60 THEN 'A'
            WHEN  CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8))<= 0.85 THEN 'B'
            WHEN  CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER (ORDER BY  COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY])) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM( COUNT(DISTINCT CONCAT([DETTAGLIO_KEY],[PRELIEVO_DATA_KEY],[OPERATORE_KEY]))) OVER () AS numeric(18,8))<= 0.95 THEN 'C'
            ELSE 'D'
        END AS ABC_sottoclasse
    FROM
        [Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI],
        Opper.dbo.IDIR_ARTICOLI
    WHERE 
        CONVERT(DATE, CAST([Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI].[PRELIEVO_DATA_KEY] as varchar), 112) >= DATEADD(YEAR, -1, GETDATE())
        AND CAST([QUANTITA] AS DECIMAL(18, 8)) > 0
        AND [Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI].[ARTICOLO_KEY] = CONCAT(opper.dbo.IDIR_ARTICOLI.PRECODICE, '|', opper.dbo.IDIR_ARTICOLI.CODICE)
    GROUP BY
		opper.dbo.IDIR_ARTICOLI.SOTTOCLASSE_CODICE
) as ABC_sottoclasse ON ABC_codice.SOTTOCLASSE_CODICE = ABC_sottoclasse.SOTTOCLASSE_CODICE
ORDER BY ABC_codice.[% Cumulata];

TRUNCATE TABLE opper.dbo. IDIR_IMPEGNI_ESTERO;

INSERT INTO opper.dbo. IDIR_IMPEGNI_ESTERO
(
	LISTARIGAID
	,LISTEID
	,ARTICOLO_ID
	,QUANTITA
	,PREZZO
	,IMPORTO
	,DATAULTIMAMODIFICA
	,PARENTLISTERIGHEID
	,QUANTITAFORZATA
	,AGENTIID
	,LISTINICONDIZIONIID
	,MAGAZZINIID
	,PROVVIGIONICONDIZIONIID
	,LISTINOBASE
	,LISTINOCOSTO
	,CLIENTIFORNITORIID
	,ID_CLIENTE
	,DATACONSEGNA
	,DATACONSEGNAEFFETTIVA
	,TEMPO
	,DATAINSERIMENTO
	,DATA
)
SELECT [Vision].[dbo].[ListeRighe].[ID] as ListaRigaID
      ,[ListeID]
      ,[ArticoloID] as ARTICOLO_ID
      ,[Quantita]
      ,[Prezzo]
      ,[Importo]
      ,[DataUltimaModifica]
      ,[ParentListeRigheID]
      ,[QuantitaForzata]
      ,[AgentiID]
      ,[ListiniCondizioniID]
      ,[Vision].[dbo].[ListeRighe].[MagazziniID]
      ,[ProvvigioniCondizioniID]
      ,[ListinoBase]
      ,[ListinoCosto]
      ,[Vision].[dbo].[Liste].[ClientiFornitoriID]
	  ,opper.dbo.IDIR_CLIENTE.ID as ID_CLIENTE
      ,[Vision].[dbo].[ListeRighe].[DataConsegna]
      ,[DataConsegnaEffettiva]
       ,datediff(day,[Vision].[dbo].[Liste].[DataInserimento],[Data]) as 'TEMPO'
       ,[Vision].[dbo].[Liste].[DataInserimento],
	   [Data]
FROM [Vision].[dbo].[ListeRighe]
left join [Vision].[dbo].[Liste] on [Vision].[dbo].[Liste].id=[Vision].[dbo].[ListeRighe].[ListeID]
left join opper.[dbo].IDIR_ARTICOLI on opper.[dbo].IDIR_ARTICOLI.ARTICOLO_ID=[Vision].[dbo].[ListeRighe].ArticoloID
left join opper.dbo.IDIR_CLIENTE on opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID = [Vision].[dbo].[Liste].[ClientiFornitoriID];

TRUNCATE TABLE opper.dbo.IDIR_CARRELLO_DELETE;

INSERT INTO opper.dbo.IDIR_CARRELLO_DELETE
(
	ArticoloID
	,Tipo
	,DataImpegno
	,ClienteFornitoreID
	,RigheTotali
	,RigheEvase
	,Importo
	,ImportoEvaso
)
SELECT
carrello_delete.ArticoloID,
'Carrello Delete' AS Tipo,
carrello_delete.Data as DataImpegno,
carrello_delete.ClientiFornitoriCodice as ClienteFornitoreID,
COUNT(carrello_delete.AziendaID) AS RigheTotali, 
SUM(carrello_delete.Evaso) AS RigheEvase, 
SUM(carrello_delete.Importo) AS Importo, 
SUM(carrello_delete.ChildImporto) AS ImportoEvaso
FROM
(
SELECT        
Vision.dbo.WebCarrelloDelete.AziendaID, 
Vision.dbo.WebCarrelloDelete.ClientiFornitoriID AS ClientiFornitoriCodice, 
Vision.dbo.Articoli.VenditaQuantitaMin AS Quantita,                            
(Vision.dbo.Articoli.VenditaQuantitaMin * (((Vision.dbo.WebCarrelloDelete.Prezzo * (1 + Vision.dbo.WebCarrelloDelete.Aumento / 100)) * (1 - Vision.dbo.WebCarrelloDelete.Sconto1 / 100)) * (1 - Vision.dbo.WebCarrelloDelete.Sconto2 / 100)))* (1 - Vision.dbo.WebCarrelloDelete.Sconto3 / 100) AS Importo, 
Vision.dbo.WebCarrelloDelete.ArticoloID, 
Vision.dbo.Articoli.SottoClasseID, 
Vision.dbo.Clienti.AgenteID, 
Vision.dbo.WebCarrelloDelete.Precodice AS ListeRighePrecodice,                            
Vision.dbo.WebCarrelloDelete.Codice AS ListeRigheCodice, 
Vision.dbo.WebCarrelloDelete.Descrizione AS ListeRigheDescrizione, 
Vision.dbo.Articoli.CategoriaID AS CategorieID, 
Vision.dbo.Precodici.Descrizione AS PrecodiciDescrizione,                            
Vision.dbo.Classi.Descrizione AS ClassiDescrizione, 
Vision.dbo.Contatti.Provincia AS ContattiProvincia, 
Vision.dbo.Categorie.PrecodiciStatisticheID, 
Vision.dbo.Contatti.SegmentazioneID, 
Vision.dbo.Precodici.ID AS PrecodiciID, 
Vision.dbo.Articoli.FamigliaID,                            
Vision.dbo.SottoClassi.ClasseID, 
Vision.dbo.SottoClassi.Descrizione AS SottoClassiDescrizione, 
Vision.dbo.SottoClassi.PrecodiciStatisticheID AS PrecodiciStatisticheID2, 
0 AS ListeRigheID, 
0 AS ListeNumero, 
Vision.dbo.WebCarrelloDelete.Data,                            
Vision.dbo.WebCarrelloDelete.Data AS DataConsegna, 
0 AS CausaliMagazzinoID, 
0 AS ListeStatiID, 
0 AS ChildListeRigheID, 
0 AS ChildImporto, 
NULL AS ListeDocumentiDataDocumento, 
0 AS Evaso, 
0 AS Ritardo  
FROM
Vision.dbo.Precodici WITH (READUNCOMMITTED) INNER JOIN                           
Vision.dbo.WebCarrelloDelete INNER JOIN 
Vision.dbo.ContattiContabili INNER JOIN                           
Vision.dbo.ClientiFornitori WITH (READUNCOMMITTED) INNER JOIN                           
Vision.dbo.Clienti WITH (READUNCOMMITTED) ON Vision.dbo.ClientiFornitori.ID = Vision.dbo.Clienti.ClientiFornitoriID ON Vision.dbo.ContattiContabili.ID = Vision.dbo.ClientiFornitori.ContattiContabiliID INNER JOIN                           
Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID ON Vision.dbo.WebCarrelloDelete.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN                           
Vision.dbo.SottoClassi INNER JOIN                          
Vision.dbo.Categorie INNER JOIN                       
Vision.dbo.Articoli ON Vision.dbo.Categorie.ID = Vision.dbo.Articoli.CategoriaID ON Vision.dbo.SottoClassi.ID = Vision.dbo.Articoli.SottoClasseID ON Vision.dbo.WebCarrelloDelete.ArticoloID = Vision.dbo.Articoli.ID AND           
Vision.dbo.WebCarrelloDelete.Giacenza - Vision.dbo.WebCarrelloDelete.Transito < Vision.dbo.Articoli.VenditaQuantitaMin ON Vision.dbo.Precodici.Codice = Vision.dbo.WebCarrelloDelete.Precodice INNER JOIN       
Vision.dbo.Classi ON Vision.dbo.SottoClassi.ClasseID = Vision.dbo.Classi.ID 
WHERE        (Vision.dbo.WebCarrelloDelete.ArticoloID > 0) AND (Vision.dbo.WebCarrelloDelete.Precodice <> 'IDP') 
AND (NOT (Vision.dbo.Clienti.AgenteID IN (182, 159, 201, 177, 180, 145, 153, 202, 155, 200, 152, 208, 199, 154, 213, 181, 206, 158, 184, 119, 120,117, 128))) 
AND (Vision.dbo.WebCarrelloDelete.Acquistato = 0)  
GROUP BY Vision.dbo.WebCarrelloDelete.AziendaID, 
Vision.dbo.WebCarrelloDelete.ClientiFornitoriID, 
Vision.dbo.Articoli.VenditaQuantitaMin,
(Vision.dbo.Articoli.VenditaQuantitaMin * (((Vision.dbo.WebCarrelloDelete.Prezzo * (1 + Vision.dbo.WebCarrelloDelete.Aumento / 100)) * (1 - Vision.dbo.WebCarrelloDelete.Sconto1 / 100)) * (1 - Vision.dbo.WebCarrelloDelete.Sconto2 / 100))) * (1 - Vision.dbo.WebCarrelloDelete.Sconto3 / 100),
Vision.dbo.WebCarrelloDelete.ArticoloID,
Vision.dbo.Articoli.SottoClasseID, 
Vision.dbo.Clienti.AgenteID,                 
Vision.dbo.WebCarrelloDelete.Precodice, 
Vision.dbo.WebCarrelloDelete.Codice, 
Vision.dbo.WebCarrelloDelete.Descrizione,
Vision.dbo.Articoli.CategoriaID,
Vision.dbo.Precodici.Descrizione,
Vision.dbo.Classi.Descrizione,
Vision.dbo.Contatti.Provincia, 
Vision.dbo.Categorie.PrecodiciStatisticheID,
Vision.dbo.Contatti.SegmentazioneID, 
Vision.dbo.Precodici.ID,
Vision.dbo.Articoli.FamigliaID, 
Vision.dbo.SottoClassi.ClasseID,
Vision.dbo.SottoClassi.Descrizione,
Vision.dbo.SottoClassi.PrecodiciStatisticheID,  
Vision.dbo.WebCarrelloDelete.Data ) as carrello_delete
GROUP BY		carrello_delete.Data,
				carrello_delete.ClientiFornitoriCodice, 
				carrello_delete.ArticoloID;
				
TRUNCATE TABLE opper.dbo.IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI;

INSERT INTO opper.dbo.IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI
(
      ARTICOLO_ID_WMS
	  ,PRECODICE
      ,CODICE
      ,ID_UBICAZIONE
	  ,CODICE_UBICAZIONE
	  ,MAGAZZINO
      ,LUNGHEZZA_MM
      ,LARGHEZZA_MM
      ,ALTEZZA_MM
      ,PESO_GR	  
)
SELECT 
      [ArticoloId] as ARTICOLO_ID_WMS
	  ,[Logistica].[dbo].[Articoli].[PreCodice] as PRECODICE
      ,[Logistica].[dbo].[Articoli].[Codice] as CODICE
      ,[UbicazioneId] as ID_UBICAZIONE
	  ,[Logistica].[dbo].[Containers].[Codice] as CODICE_UBICAZIONE
	  ,LEFT([Logistica].[dbo].[Containers].[Codice],1) as 'MAGAZZINO'
      ,[Logistica].[dbo].[Articoli].[Lunghezza] as LUNGHEZZA_MM
      ,[Logistica].[dbo].[Articoli].[Larghezza] as LARGHEZZA_MM
      ,[Logistica].[dbo].[Articoli].[Altezza] as ALTEZZA_MM
      ,[Logistica].[dbo].[Articoli].[Peso] as PESO_GR
  FROM [Logistica].[dbo].[Articoli_Ubicazioni]
  LEFT JOIN [Logistica].[dbo].[Containers] ON [Logistica].[dbo].[Containers].Id=[Logistica].[dbo].[Articoli_Ubicazioni].[UbicazioneId]
  LEFT JOIN [Logistica].[dbo].[Articoli] on [Logistica].[dbo].[Articoli].id=[Logistica].[dbo].[Articoli_Ubicazioni].[ArticoloId];

TRUNCATE TABLE  opper.dbo.IDIR_ABC_GIACENZA;

INSERT INTO opper.dbo.IDIR_ABC_GIACENZA
(
      ARTICOLO_ID
	  ,ABC
)
SELECT
tabella_ABC.ARTICOLO_ID,
tabella_ABC.ABC
FROM(
SELECT 
    tabella_giacenza.ARTICOLO_ID,
	tabella_giacenza.GIACENZA,
	tabella_listini.Costo,
	tabella_listini.Costo*tabella_giacenza.GIACENZA  as Giacenza_Valore,
	ROW_NUMBER() OVER (ORDER BY SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 2))) DESC) AS [Rank],
	SUM(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 2)))) OVER () AS Giacenza_Valore_Tot,
	CAST(
            CAST(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8))) AS NUMERIC(18, 8)) /
            CAST(SUM(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER () AS NUMERIC(18, 8)) 
            AS NUMERIC(18, 8)
        ) AS [% su Tot],
	Sum(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) as [GiacenzaValoreCumulata],
CAST(Sum(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER () AS numeric(18,8)) [% Cumulata],
CASE
            WHEN  CAST(Sum(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER () AS numeric(18,8))<= 0.60 THEN 'A'
            WHEN  CAST(Sum(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER () AS numeric(18,8))<= 0.85 THEN 'B'
            WHEN  CAST(Sum(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER (ORDER BY SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8))) DESC Rows BETWEEN unbounded preceding AND CURRENT row) AS numeric(18,8))/ CAST(SUM(SUM(CAST(tabella_listini.Costo*tabella_giacenza.GIACENZA AS DECIMAL(18, 8)))) OVER () AS numeric(18,8))<= 0.95 THEN 'C'
            ELSE 'D'
        END AS ABC
FROM (
    SELECT 
        Opper.dbo.IDIR_GIACENZA.ARTICOLO_ID,
        SUM(Opper.dbo.IDIR_GIACENZA.ESISTENZA) AS GIACENZA
    FROM 
        Opper.dbo.IDIR_GIACENZA
    GROUP BY 
        Opper.dbo.IDIR_GIACENZA.ARTICOLO_ID
) AS tabella_giacenza
LEFT JOIN (
    SELECT
        Opper.dbo.IDIR_ARTICOLI.ARTICOLO_ID,
        CASE 
            WHEN Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_92 > 0 THEN ROUND(Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_92, 2)
            WHEN Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_90 > 0 THEN ROUND(Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_90, 2) 
            WHEN Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_800 > 0 THEN ROUND(Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_800, 2)
            WHEN Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_900 > 0 THEN ROUND(Opper.dbo.IDIR_ARTICOLI.PREZZO_LISTINO_900, 2)
            ELSE 0 
        END AS Costo
    FROM 
        Opper.dbo.IDIR_ARTICOLI
) AS tabella_listini 
ON tabella_giacenza.ARTICOLO_ID = tabella_listini.ARTICOLO_ID
WHERE tabella_giacenza.GIACENZA>=0
GROUP BY tabella_giacenza.ARTICOLO_ID,tabella_giacenza.GIACENZA,
	tabella_listini.Costo
) as tabella_ABC;

TRUNCATE TABLE  opper.dbo.IDIR_CLASSE_M_VENDUTO;

INSERT INTO opper.dbo.IDIR_CLASSE_M_VENDUTO
(
      ARTICOLO_ID
	  ,CLASSE_M
)
SELECT
tabella_finale.ARTICOLO_ID,
tabella_finale.STATUS as CLASSE_M
FROM(
SELECT 
    ARTICOLI.ARTICOLO_ID,
    GIACENZA.TOTAL_ESISTENZA,
    ORDERS.FIRST_ORDER_DATE,
    CASE 
        WHEN GIACENZA.TOTAL_ESISTENZA > 0 
             AND (ORDERS.FIRST_ORDER_DATE IS NULL 
                  OR ORDERS.FIRST_ORDER_DATE < DATEADD(MONTH, -12, GETDATE())) 
        THEN 'M' 
        ELSE NULL 
    END AS STATUS
FROM 
    opper.dbo.IDIR_ARTICOLI AS ARTICOLI

-- Join with IDIR_ABC_ARTICOLI to find missing ARTICOLO_IDs
LEFT JOIN 
    opper.dbo.IDIR_ABC_ARTICOLI AS ABC_ARTICOLI
    ON ARTICOLI.ARTICOLO_ID = ABC_ARTICOLI.ARTICOLO_ID

-- Join with a subquery to get the sum of ESISTENZA from IDIR_GIACENZA
LEFT JOIN (
    SELECT 
        ARTICOLO_ID, 
        SUM(ESISTENZA) AS TOTAL_ESISTENZA
    FROM 
        opper.dbo.IDIR_GIACENZA
    GROUP BY 
        ARTICOLO_ID
) AS GIACENZA
    ON ARTICOLI.ARTICOLO_ID = GIACENZA.ARTICOLO_ID
-- Join with a subquery to find the first order date from IDIR_FATTO_CARICHI
LEFT JOIN (
    SELECT 
        ARTICOLO_ID, 
        MIN(DATA_DOCUMENTO) AS FIRST_ORDER_DATE
    FROM 
        opper.dbo.IDIR_FATTO_CARICHI
    GROUP BY 
        ARTICOLO_ID
) AS ORDERS
    ON ARTICOLI.ARTICOLO_ID = ORDERS.ARTICOLO_ID
-- Apply the filtering conditions
WHERE 
    ABC_ARTICOLI.ARTICOLO_ID IS NULL
	) as tabella_finale
	WHERE tabella_finale.STATUS = 'M';

TRUNCATE TABLE  opper.dbo.IDIR_ARTICOLI_DIMENSIONI_NEW_UBICATI;

INSERT INTO opper.dbo. IDIR_ARTICOLI_DIMENSIONI_NEW_UBICATI
(
	ARTICOLO_ID_VISION 
	,ARTICOLO_ID_WMS
	,PRECODICE
	,CODICE
	,MAGAZZINO
	,LUNGHEZZA_MM
	,LARGHEZZA_MM
	,ALTEZZA_MM
	,PESO_GR
)
SELECT 
DISTINCT
      ErpArtId as ARTICOLO_ID_VISION,
      [ARTICOLO_ID_WMS],
      [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[PRECODICE],
      [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[CODICE],
      [MAGAZZINO],
      CASE 
          WHEN [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[LUNGHEZZA_MM] = 0 AND [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].lunghezza_mm > 0 
          THEN [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].lunghezza_mm
          ELSE [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[LUNGHEZZA_MM]
      END as LUNGHEZZA_MM,
      CASE 
          WHEN [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[LARGHEZZA_MM] = 0 AND [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].larghezza_mm > 0 
          THEN [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].larghezza_mm
          ELSE [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[LARGHEZZA_MM]
      END as LARGHEZZA_MM,
      CASE 
          WHEN [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[ALTEZZA_MM] = 0 AND [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].altezza_mm > 0 
          THEN [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].altezza_mm
          ELSE [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[ALTEZZA_MM]
      END as ALTEZZA_MM,
      CASE 
          WHEN [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[PESO_GR] = 0 AND [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].peso_kg * 1000 > 0 
          THEN [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].peso_kg * 1000
          ELSE [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].[PESO_GR]
      END as PESO_GR
FROM [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI]
LEFT JOIN [Logistica].[dbo].[Articoli] ON [Logistica].[dbo].[Articoli].Id = [Opper].[dbo].[IDIR_ARTICOLI_DIMENSIONI_UBICAZIONI].ARTICOLO_ID_WMS
LEFT JOIN [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI] ON [Opper].[dbo].[IDIR_PESI_MISURE_LISTINI].articolo_id = [Logistica].[dbo].[Articoli].ErpArtId;


TRUNCATE TABLE  opper.dbo.IDIR_CLIENTI_DATE_NASCITA;

INSERT INTO opper.dbo. IDIR_CLIENTI_DATE_NASCITA
(
    CLIENTIFORNITOREID
    ,VALORE
)
SELECT        Vision.dbo.ClientiFornitori.ID AS ClientiFornitoriID,
            Vision.dbo.ContattiRecapiti.Valore
FROM           Vision.dbo.ClientiFornitori LEFT JOIN
            (SELECT
            DISTINCT
                Vision.dbo.ClientiFornitoriBlocchi.ClientiFornitoriID,
                CASE Vision.dbo.ClientiFornitoriBlocchi.BlocchiMotivazioniID WHEN 1 THEN 'S' END AS BloccoInsoluti
                FROM     Vision.dbo.ClientiFornitoriBlocchi INNER JOIN
                        Vision.dbo.BlocchiMotivazioni ON Vision.dbo.ClientiFornitoriBlocchi.BlocchiMotivazioniID = Vision.dbo.BlocchiMotivazioni.ID
                WHERE  (Vision.dbo.ClientiFornitoriBlocchi.ClientiFornitoriID > 0) AND (Vision.dbo.ClientiFornitoriBlocchi.BlocchiMotivazioniID = 1)) as BlocchiInsoluti ON BlocchiInsoluti.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID,
            Vision.dbo.ContattiContabili ,
            Vision.dbo.Contatti ,
            Vision.dbo.Clienti ,
            Vision.dbo.ContattiRecapiti
WHERE    Vision.dbo.ClientiFornitori.ContattiContabiliID     = Vision.dbo.ContattiContabili.ID
AND     Vision.dbo.ContattiContabili.ContattoID             = Vision.dbo.Contatti.ID
AND     Vision.dbo.ClientiFornitori.ID                         = Vision.dbo.Clienti.ClientiFornitoriID
AND     Vision.dbo.ContattiContabili.ContattiTipoID         IN(2,10)
AND        Vision.dbo.Contatti.ID = Vision.dbo.ContattiRecapiti.ContattiID
AND        Vision.dbo.ContattiRecapiti.ContattiRecapitiTipoID = 113;


TRUNCATE TABLE  opper.dbo.IDIR_ScorteMinMax;

INSERT INTO opper.dbo.IDIR_ScorteMinMax
(  
    ARTICOLO_ID,
    ID_MAGAZZINO,
    SCORTA_MIN_CALCOLATA,
    SCORTA_MAX_CALCOLATA,
    SCORTA_MIN_IMPUTATA,
    SCORTA_MAX_IMPUTATA
)
SELECT 	ArticoliID as ARTICOLO_ID,
		MagazziniID as ID_MAGAZZINO,
		ScortaMinimaCalcolata as SCORTA_MIN_CALCOLATA,
		ScortaMaxCalcolata as SCORTA_MAX_CALCOLATA,
		ScortaMinima as SCORTA_MIN_IMPUTATA,
		ScortaMax as SCORTA_MAX_IMPUTATA
FROM 	Vision.dbo.ArticoliMagazzino;

TRUNCATE TABLE  opper.dbo.IDIR_KPI_ACQUISTI_DETTAGLIO;

INSERT INTO opper.dbo.IDIR_KPI_ACQUISTI_DETTAGLIO
(  
	ID,
	[FornitoreAnnoGruppoID],
	[Anno],
	[Gruppo],
	[Precodice],
	[CLIENTEFORNITOREID],
	[FORNITORE],
	[Tipo Premio],
	[Data Iniziale],
	[Data Finale],
	[Scaglione Iniziale],
	[Scaglione Finale],
	[Obiettivo Primario],
	[Obiettivo Crescita],
	[Acquistato],
	[Premio %],
	[Premio Valore],
	[Premio da Obiettivi %],
	[Premio da Obiettivi Valore],
	[Premio Fisso],
	[Premio Fisso Valore],
	[Crescita],
	[Premio Crescita],
	[Premio Totale %],
	[Premio Totale Valore],
	[Premio Incassato]
)
SELECT premi.[ID]
,premi.[FornitoreAnnoGruppoID]
,tab_info.Anno
,tab_info.Gruppo
,tab_info.Precodice
,Vision.[dbo].[_PowerBI_PF_Fornitori].ClienteFornitoreID as CLIENTEFORNITOREID
,Vision.[dbo].[_PowerBI_PF_Fornitori].Fornitore as FORNITORE
,premi.[Tipo Premio]
,premi.[Data Iniziale]
,premi.[Data Finale]
,premi.[Scaglione Iniziale]
,premi.[Scaglione Finale]
,premi.[Obiettivo Primario]
,premi.[Obiettivo Crescita]
,premi.[Acquistato]
,premi.[Premio %]
,premi.[Premio Valore]
,premi.[Premio da Obiettivi %]
,premi.[Premio da Obiettivi Valore]
,premi.[Premio Fisso]
,premi.[Premio Fisso Valore]
,premi.[Crescita]
,premi.[Premio Crescita]
,premi.[Premio Totale %]
,premi.[Premio Totale Valore]
,premi.[Premio Incassato]
FROM [Vision].[dbo].[_PowerBI_PF_Fornitori_Anni_Gruppi_Premi] as premi
LEFT JOIN
(
SELECT DISTINCT
a.Anno,
g.Gruppo,
c.Precodice,
g.ID
FROM Vision.dbo._PowerBI_PF_Fornitori_Anni_Gruppi_Categorie AS c
LEFT JOIN Vision.dbo._PowerBI_PF_Fornitori_Anni_Gruppi AS g
ON c.FornitoreAnnoGruppoID = g.ID
LEFT JOIN Vision.dbo._PowerBI_PF_Fornitori_Anni as a ON g.FornitoreAnnoID = a.ID
) as tab_info ON premi.[FornitoreAnnoGruppoID] = tab_info.ID
LEFT JOIN vision.dbo._PowerBI_PF_Fornitori_Anni_Gruppi ON
premi.FornitoreAnnoGruppoID = vision.dbo._PowerBI_PF_Fornitori_Anni_Gruppi.ID
LEFT JOIN vision.dbo._PowerBI_PF_Fornitori_Anni ON
vision.dbo._PowerBI_PF_Fornitori_Anni_Gruppi.FornitoreAnnoID = vision.dbo._PowerBI_PF_Fornitori_Anni.ID
LEFT JOIN Vision.[dbo].[_PowerBI_PF_Fornitori] ON
vision.dbo._PowerBI_PF_Fornitori_Anni.[FornitoreID] = Vision.[dbo].[_PowerBI_PF_Fornitori].ID;

