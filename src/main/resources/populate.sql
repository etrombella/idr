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
SELECT DataLista
      ,MagazziniID
      ,PrecodiceID
      ,ArticoloID
      ,MagazzinoCodice
      ,Esistenza
FROM  Vision.dbo._Maurizio_Giacenza_Alla_Data_Per_Magazzino
WHERE ESISTENZA > 0;

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
			Vision.dbo.Contatti.CodiceFiscale			
FROM   		Vision.dbo.ClientiFornitori,
            Vision.dbo.ContattiContabili ,
            Vision.dbo.Contatti ,
            Vision.dbo.Clienti ,
            Vision.dbo.Agenti,
			Vision.dbo.Regioni,
			Vision.dbo.PaesiCee
WHERE	Vision.dbo.ClientiFornitori.ContattiContabiliID 	= Vision.dbo.ContattiContabili.ID
AND 	Vision.dbo.ContattiContabili.ContattoID 			= Vision.dbo.Contatti.ID
AND 	Vision.dbo.ClientiFornitori.ID 						= Vision.dbo.Clienti.ClientiFornitoriID
AND 	Vision.dbo.Clienti.AgenteID 						= Vision.dbo.Agenti.ID /*anche questa va cambiata in dbo.Clienti.AgenteID = AGENTE.AGENTE*/
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
	,PRECODICE
	,CODICE
	,ID_CLIENTE
	,ID_MAGAZZINO
	,TIPO_RIGA
	,QTA_INEVASA 
	,QTA_FORZATA 
	,BACK_ORDER 
	,PROVENIENZA 
) 
SELECT   Vision.dbo.ListeRighe.id                    
        ,Vision.dbo.Liste.id                     
        ,Vision.dbo.Liste.Data AS [Data_Impegno]
		,Vision.dbo.Liste.Numero AS [Numero_Impegno]
        ,Vision.dbo.ListeRighe.Quantita 
		,Vision.dbo.ListeRighe.ListinoCosto
        ,Vision.dbo.ListeRighe.PREZZO                     
        ,Vision.dbo.ListeRighe.Dataconsegna             
        ,Vision.dbo.ListeRighe.Articoloid                 
        ,Vision.dbo.ListeRighe.Precodice                 
        ,Vision.dbo.ListeRighe.Codice                     
        ,opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID   
		,Vision.dbo.Liste.MagazziniID
		,Vision.dbo.CausaliMagazzino.Descrizione,
		Vision.dbo.ListeRighe.Quantita - ISNULL(
													(SELECT SUM(Quantita) AS QuantitaEvasa 
													 FROM   Vision.dbo.ListeRighe AS ListeRighe_1
													 WHERE  (ParentListeRigheID = Vision.dbo.ListeRighe.ID)
												), 0) AS [Quantita_Inevasa],
		Vision.dbo.ListeRighe.QuantitaForzata,
		Vision.dbo.ListeEvasioneTipo.Descrizione AS BackOrder, 
		Vision.dbo.ListeProvenienzaTipo.Descrizione AS Provenienza
from     Vision.dbo.Liste
        ,Vision.dbo.ListeRighe
        ,opper.dbo.IDIR_CLIENTE
		,Vision.dbo.CausaliMagazzino
		,Vision.dbo.ListeEvasioneTipo
		,Vision.dbo.ListeProvenienzaTipo
where   Vision.dbo.Liste.ID                   	=   Vision.dbo.ListeRighe.ListeID
AND     Vision.dbo.Liste.ClientiFornitoriID  	=   opper.dbo.IDIR_CLIENTE.CLIENTIFORNITORIID 
AND     Vision.dbo.Liste.CausaliMagazzinoID    	in  (35,36,38)
AND 	Vision.dbo.Liste.CausaliMagazzinoID   	= 	Vision.dbo.CausaliMagazzino.ID
AND 	Vision.dbo.Liste.ListeEvasioneTipoID 	= 	Vision.dbo.ListeEvasioneTipo.ID
AND 	Vision.dbo.ListeProvenienzaTipo.ID 		= 	Vision.dbo.Liste.ListeProvenienzaTipoID;


TRUNCATE TABLE opper.dbo.IDIR_VENDITE;

insert into opper.dbo.IDIR_VENDITE 
(  
	LISTA_RIGA_ID 
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
) 
SELECT                  
Vision.dbo.ListeRighe.ID AS ListeRigheID, 
Vision.dbo.Liste.ID AS ListeID, 
Vision.dbo.ListeRighe.ParentListeRigheID AS ParentListeRigheID, 
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
                         
FROM            
                 
                         Vision.dbo.ClientiFornitori INNER JOIN
                         Vision.dbo.ListeDocumenti AS ListeDocumenti INNER JOIN
                         Vision.dbo.Liste ON ListeDocumenti.ListeID = Vision.dbo.Liste.ID INNER JOIN
                         Vision.dbo.ListeRighe ON Vision.dbo.Liste.ID = Vision.dbo.ListeRighe.ListeID INNER JOIN
                         Vision.dbo.CausaliMagazzinoListeRigheTipo ON Vision.dbo.ListeRighe.CausaliMagazzinoListeRigheTipoID = Vision.dbo.CausaliMagazzinoListeRigheTipo.ID INNER JOIN
                         Vision.dbo.Documenti ON ListeDocumenti.DocumentiID = Vision.dbo.Documenti.ID INNER JOIN
                         Vision.dbo.DocumentiClassiRaggruppamenti ON Vision.dbo.Documenti.ID = Vision.dbo.DocumentiClassiRaggruppamenti.DocumentiID INNER JOIN
                         Vision.dbo.DocumentiTipo ON Vision.dbo.Documenti.DocumentiTipoID = Vision.dbo.DocumentiTipo.ID INNER JOIN
                         Vision.dbo.ListeRigheTipo ON Vision.dbo.CausaliMagazzinoListeRigheTipo.ListeRigheTipoID = Vision.dbo.ListeRigheTipo.ID INNER JOIN
                         Vision.dbo.Magazzini ON Vision.dbo.Liste.MagazziniID = Vision.dbo.Magazzini.ID INNER JOIN
                         Vision.dbo.CausaliMagazzino ON Vision.dbo.Liste.CausaliMagazzinoID = Vision.dbo.CausaliMagazzino.ID ON Vision.dbo.ClientiFornitori.ID = Vision.dbo.Liste.ClientiFornitoriID INNER JOIN
                         Vision.dbo.ListiniCondizioni ON Vision.dbo.ListeRighe.ListiniCondizioniID = Vision.dbo.ListiniCondizioni.ID LEFT OUTER JOIN
                             (SELECT        Vision.dbo.ListeDocumentiVettori.ListeDocumentiID, ContattiVettori.Cognome + ' - ' + Vision.dbo.Vettori.Codice AS Vettore, Vision.dbo.Contatti.Cognome + ' - ' + CAST(ContattiContabili_1.Codice AS varchar) AS VettoreFornitore, Vision.dbo.Vettori.ID
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

TRUNCATE TABLE opper.dbo.IDIR_FATTO_ORDINE_ACQUISTO;


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
		,Vision.dbo.Liste.Numero
		,Vision.dbo.ListeRighe.Quantita - ISNULL   ((SELECT     SUM(Quantita) AS QuantitaEvasa           FROM         Vision.dbo.ListeRighe AS ListeRighe_1        WHERE     (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0) AS [Quantit� Inevasa]
		,ISNULL((SELECT     SUM(Quantita) AS QuantitaEvasa       FROM         Vision.dbo.ListeRighe AS ListeRighe_1 WHERE     (ParentListeRigheID = Vision.dbo.ListeRighe.ID)), 0) AS [Quantit� Evasa]
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
) 
SELECT  Vision.dbo.ListeRighe.id                                 
		,Vision.dbo.Liste.id                                      
		,Vision.dbo.ListeRighe.DATAinserimento                   
		,Vision.dbo.ListeRighe.Quantita                   
		,Vision.dbo.ListeRighe.PREZZO                    
		,Vision.dbo.ListeRighe.Listinocosto                
		,Vision.dbo.Liste.DataRiferimento                
		,Vision.dbo.ListeRighe.Dataconsegna              
		,Vision.dbo.ListeRighe.Articoloid                
		,opper.dbo.IDIR_FORNITORI.ID                     
		,Vision.dbo.Liste.MagazziniID  
		,Vision.dbo.CausaliMagazzino.Descrizione
		,Vision.dbo.ListeDocumenti.DataDocumento
		,Vision.dbo.ListeRighe.Importo
		,Vision.dbo.ListeRighe.ParentListeRigheID
from     Vision.dbo.Liste,     
		opper.dbo.IDIR_FORNITORI,    
		Vision.dbo.ListeRighe,      
		Vision.dbo.CausaliMagazzino,
		Vision.dbo.ListeDocumenti		
where  	Vision.dbo.Liste.ID      				= Vision.dbo.ListeRighe.ListeID
AND    	Vision.dbo.Liste.CausaliMagazzinoID     = 10
AND 	Vision.dbo.Liste.CausaliMagazzinoID   	= Vision.dbo.CausaliMagazzino.ID
AND     Vision.dbo.Liste.ClientiFornitoriID     = opper.dbo.IDIR_FORNITORI.ID_CLIENTEFORNITORE
AND		Vision.dbo.Liste.ID 					= Vision.dbo.ListeDocumenti.ListeID;

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
) 
SELECT 	Vision.dbo.Vettori.id 								as ID
		,Vision.dbo.Vettori.Codice							as CODICE
		,Vision.dbo.Contatti.Nome							AS NOME
		,Vision.dbo.Contatti.Cognome 						AS COGNOME
		,Vision.dbo.Contatti.Indirizzo 						AS INDIRIZZO
		,LogisticaDWH.dbo._DimVettori.TimeAltKeyPreCutOff
	    ,LogisticaDWH.dbo._DimVettori.TimeAltKeyCutOff
from 	Vision.dbo.Vettori,
		Vision.dbo.Contatti,
		LogisticaDWH.dbo._DimVettori
where 	Vision.dbo.Vettori.ContattiID = Vision.dbo.Contatti.ID
AND		LogisticaDWH.dbo._DimVettori.VettoreKey COLLATE SQL_Latin1_General_CP1_CI_AS = Vision.dbo.Vettori.Codice COLLATE SQL_Latin1_General_CP1_CI_AS;

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
) 
SELECT  Vision.dbo.ArticoliCodifiche.ArticoloID,
		Vision.dbo.Precodici.Codice AS Precodice, 
		Vision.dbo.Precodici.Descrizione AS DescrizionePrecodice,
		Vision.dbo.ArticoliCodifiche.Articolo AS Codice,
		Vision.dbo.Fornitori.ID AS FornitoreID, /*SOSTITUIRE CON IL NOSTRO ID FORNITORE. COLLEGAMENTO: dbo.ClientiFornitori.ID = IDIR_FORNITORI.ID_CLIENTEFORNITORE*/


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
		Vision.dbo.Precodici.GiorniConsegna

FROM   Vision.dbo.ArticoliCodifiche INNER JOIN
       Vision.dbo.Precodici ON Vision.dbo.ArticoliCodifiche.PrecodiceID = Vision.dbo.Precodici.ID INNER JOIN
       Vision.dbo.Articoli ON Vision.dbo.ArticoliCodifiche.ArticoloID = Vision.dbo.Articoli.ID INNER JOIN
       Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID INNER JOIN
       Vision.dbo.Famiglie ON Vision.dbo.Articoli.FamigliaID = Vision.dbo.Famiglie.ID INNER JOIN
       Vision.dbo.Fornitori ON Vision.dbo.Precodici.FornitoriID = Vision.dbo.Fornitori.ID INNER JOIN
       Vision.dbo.ClientiFornitori ON Vision.dbo.Fornitori.ClientiFornitoriID = Vision.dbo.ClientiFornitori.ID INNER JOIN
       Vision.dbo.ContattiContabili ON Vision.dbo.ClientiFornitori.ContattiContabiliID = Vision.dbo.ContattiContabili.ID INNER JOIN
       Vision.dbo.Contatti ON Vision.dbo.ContattiContabili.ContattoID = Vision.dbo.Contatti.ID INNER JOIN
       Vision.dbo.SottoClassi ON Vision.dbo.Articoli.SottoClasseID = Vision.dbo.SottoClassi.ID INNER JOIN
       Vision.dbo.Classi ON Vision.dbo.SottoClassi.ClasseID = Vision.dbo.Classi.ID
WHERE 	(Vision.dbo.ArticoliCodifiche.ArticoliCodificheTipoID = 1) AND (Vision.dbo.Precodici.AziendaID = 1);


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

FROM   Vision.dbo.ClientiFornitori INNER JOIN
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
        PowerBI.[dbo].[_PowerBI_RF_Fornitori_Anni_Precodici]
    GROUP BY
        [PrecodiceID]
) AS PrecodiciPercentuali ON PrecodiciPercentuali.[PrecodiceID] = Vision.dbo.Precodici.ID INNER JOIN
             Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID LEFT OUTER JOIN
                 (SELECT ContattiID, 'Si' AS ClienteAts
                 FROM    Vision.dbo.ContattiRecapiti
                 WHERE (Valore = 'ATS') AND (ContattiRecapitiTipoID = 100)) AS ClientiATS ON Vision.dbo.Contatti.ID = ClientiATS.ContattiID LEFT OUTER JOIN
                 (SELECT MagazziniID AS MagazzinoID
                 FROM    Vision.dbo.MagazziniClassiRaggruppamenti
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

FROM   Vision.dbo.ClientiFornitori INNER JOIN
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
        PowerBI.[dbo].[_PowerBI_RF_Fornitori_Anni_Precodici]
    GROUP BY
        [PrecodiceID]
) AS PrecodiciPercentuali ON PrecodiciPercentuali.[PrecodiceID] = Vision.dbo.Precodici.ID  INNER JOIN
             Vision.dbo.Categorie ON Vision.dbo.Articoli.CategoriaID = Vision.dbo.Categorie.ID LEFT OUTER JOIN
                 (SELECT ContattiID, 'Si' AS ClienteAts
                 FROM    Vision.dbo.ContattiRecapiti
                 WHERE (Valore = 'ATS') AND (ContattiRecapitiTipoID = 100)) AS ClientiATS ON Vision.dbo.Contatti.ID = ClientiATS.ContattiID LEFT OUTER JOIN
                 (SELECT MagazziniID AS MagazzinoID
                 FROM    Vision.dbo.MagazziniClassiRaggruppamenti
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
		Vision.dbo.Magazzini.ID,Vision.dbo.ListeRighe.Quantita,
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