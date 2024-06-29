TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_PRELIEVI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_PRELIEVI
(  
	FACT_PRELIEVI_ID	
	,OPERATORE_KEY		
	,ASSEGNAZIONE_DATA_KEY
	,ASSEGNAZIONE_TIME_KEY
	,PRELIEVO_DATA_KEY	
	,PRELIEVO_TIME_ATL_KEY
	,ATTIVITA_KEY		
	,DETTAGLIO_KEY		
	,ARTICOLO_KEY		
	,QUANTITA			
	,UBICAZIONE			
)
SELECT [FactPrelieviID]
      ,[OperatoreKey] as OperatoreID
      ,[AssegnazioneDataKey]
      ,[AssegnazioneTimeKey]
      ,[PrelievoDataKey]
      ,[PrelievoTimeAtlkey]
      ,[AttivitaKey] as AttivitaID
      ,[DettaglioKey]
      ,[ArticoloKey] as ArticoloID
      ,[Quantita]
      ,[Ubicazione]
FROM [LogisticaDWH].[dbo].[_FactOperatoriPrelievi];

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_POSIZIONATURA;

INSERT INTO opper.dbo.LOGISTICA_IDIR_POSIZIONATURA
(  
	FACT_POSIZIONATURA_ID	
	,OPERATORE_KEY		 	
	,ATTIVITA_KEY			
	,POSIZIONATURA_DATA_KEY 
	,POSIZIONATURA_TIME_KEY 
	,UNITA_CARICO_KEY		
	,CESTA_KEY			 	
	,ARTICOLO_KEY			
	,QUANTITA			 	
	,UBICAZIONE			 	
)
SELECT [FactPosizionaturaID]
    ,[OperatoreKey] as OperatoreID
    ,[AttivitaKey] as AttivitaID
    ,[PosizionaturaDataKey]
    ,[PosizionaturaTimeKey]
    ,[UnitaCaricoKey]
    ,[CestaKey]
    ,[ArticoloKey] as ArticoloID
    ,[Quantita]
    ,[Ubicazione]
FROM [LogisticaDWH].[dbo].[_FactOperatoriPosizionatura];

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_IMBALLO;

INSERT INTO opper.dbo.LOGISTICA_IDIR_IMBALLO
(  
	FactImballiID 	
	,DettaglioKey
	,OperatoreKey  	
	,ImballoDataKey	
	,ImballoTimeAtlkey	
	,AttivitaKey 		
	,ArticoloKey 		
	,ColloKey 	
	,Quantita 	
)
SELECT  [FactImballiID]
		,[DettaglioKey]
		,[OperatoreKey] as OperatoreID
		,[ImballoDataKey]
		,[ImballoTimeAtlkey]
		,[AttivitaKey] as AttivitaID
		,[ArticoloKey] as ArticoloID
		,[ColloKey] as ColloID
		,[Quantita]
FROM	[LogisticaDWH].[dbo].[_FactOperatoriImballi];



TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_DISIMBALLO;

INSERT INTO opper.dbo.LOGISTICA_IDIR_DISIMBALLO
(  
	FactDisimballoID 	
	,OperatoreKey  		
	,AttivitaKey 		
	,DisimballoDataKey 	
	,DisimballoTimeKey 	
	,UnitaCaricoKey 		
	,CestaKey 			
	,ArticoloKey 		
	,Quantita 			
)
SELECT	FactDisimballoID,
		OperatoreKey,
		AttivitaKey,
		DisimballoDataKey,
		DisimballoTimeKey,
		UnitaCaricoKey,
		CestaKey,
		ArticoloKey,
		Quantita 
FROM [LogisticaDWH].[dbo].[_FactOperatoriDisimballo];

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_COLLI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_COLLI
(  
	FactColloId,
	ColloKey,
	Tracking,
	StatoCollo,
	DataColloKey,
	TimeAltColloKey,
	TipoCollo,
	TipologiaCollo,
	PesoKG,
	CostoCollo,
	LunghezzaCM,
	LarghezzaCM,
	AltezzaCM,
	ListaId,
	ListeNumero,
	ClienteKey,
	CliRagioneSociale,
	CliIndirizzo,
	CliComune,
	CliCap,
	CliProvincia,
	CliRegione,
	DestRagionesociale,
	DestIndirizzo,
	DestCap,
	DestComune,
	DestProvincia,
	DestRegione,
	DestNazione,
	VettoreKey,
	TimeAltKeyPreCutOff,
	TimeAltKeyCutOff,
	PackingListCode,
	DataColloChiusuraKey,
	TimeAltColloChiusuraKey,
	DataColloCaricatoKey,
	TimeAltColloCaricatoKey,
	DataColloSpeditoKey,
	TimeAltColloSpeditoKey
)
SELECT
	 FactColloId  	
	, ColloKey  		
	, Tracking  		
	, StatoCollo  	
	, DataColloKey  	
	, TimeAltColloKey  	
	, TipoCollo  		
	, TipologiaCollo  	
	, PesoKG  			
	, CostoCollo  		
	, LunghezzaCM  		
	, LarghezzaCM  		
	, AltezzaCM  		
	, ListaId 	 		
	, ListeNumero  		
	, ClienteKey  		
	, CliRagioneSociale  
	, CliIndirizzo  		
	, CliComune  		
	, CliCap  			
	, CliProvincia  		
	, CliRegione  		
	, DestRagionesociale 
	, DestIndirizzo  	
	, DestCap  			
	, DestComune  		
	, DestProvincia  	
	, DestRegione  		
	, DestNazione  		
	, VettoreKey  		
	, TimeAltKeyPreCutOff  		
	, TimeAltKeyCutOff  			
	, PackingListCode  			
	, DataColloChiusuraKey  		
	, TimeAltColloChiusuraKey  	
	, DataColloCaricatoKey  		
	, TimeAltColloCaricatoKey  	
	, DataColloSpeditoKey  		
	, TimeAltColloSpeditoKey  	
FROM  LogisticaDWH.dbo._FactColli ;

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_DIM_AZIENDE;

INSERT INTO opper.dbo.LOGISTICA_IDIR_DIM_AZIENDE
(  
	AZIENDAKEY ,
	AZIENDA,
	TIPO
)
SELECT  [Codice]
       ,[Azienda]
       ,[Tipo]
FROM [Vision].[dbo].[_PowerBI_OL_Aziende];
  
TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_DIM_ATTIVITA_OPERATORI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_DIM_ATTIVITA_OPERATORI
(  
	ATTIVITAKEY ,
	ATTIVITA
)
SELECT	AttivitaKey,
		Attivita
FROM  [LogisticaDWH].[dbo].[_DimAttivitaOperatori];


TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_RIGHE_REAL_TIME;

INSERT INTO opper.dbo.LOGISTICA_IDIR_RIGHE_REAL_TIME
(  
	ATTIVITA,
	CHIAVE,
	OPERATORE,
	OPERATOREKEY,
	RIGHE
)
Select 'Prelievo' as Attivita,concat('Prelievo-',tabella.OperatoreKey) as Chiave,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  _LogAttivitaOperatori.OperatoreKey,count( DISTINCT DettaglioKey)as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where (CAST(DataAttivita AS date) = CAST(GETDATE() AS date))AND AttivitaKey=1 
GROUP BY _LogAttivitaOperatori.OperatoreKey) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey
Union
Select 'Imballo' as Attivita,concat('Imballo-',tabella.OperatoreKey) as Chiave,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  _LogAttivitaOperatori.OperatoreKey,count( DISTINCT DettaglioKey)as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where (CAST(DataAttivita AS date) = CAST(GETDATE() AS date))AND AttivitaKey=2
GROUP BY _LogAttivitaOperatori.OperatoreKey) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey
Union
Select 'Posizionatura' as Attivita,concat('Posizionatura-',tabella.OperatoreKey) as Chiave,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  _LogAttivitaOperatori.OperatoreKey,count( DISTINCT concat(UnitaCaricoKey,ArticoloKey))as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where (CAST(DataAttivita AS date) = CAST(GETDATE() AS date))AND AttivitaKey=4
GROUP BY _LogAttivitaOperatori.OperatoreKey) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey
Union
Select 'Disimballo' as Attivita,concat('Disimballo-',tabella.OperatoreKey) as Chiave,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  _LogAttivitaOperatori.OperatoreKey,count( DISTINCT concat(UnitaCaricoKey,ArticoloKey))as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where (CAST(DataAttivita AS date) = CAST(GETDATE() AS date))AND AttivitaKey=3
GROUP BY _LogAttivitaOperatori.OperatoreKey) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey;


TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_RIGHE;

INSERT INTO opper.dbo.LOGISTICA_IDIR_RIGHE
(  
	ATTIVITA		
	,DATADA			
	,CODICE_OPERATORE
	,OPERATORE		
	,OPERATOREKEY	
	,RIGHE		 		
)
Select 'Prelievo' as Attivita,tabella.DATAA,_DimOperatori.CodiceOperatore,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  CAST(_LogAttivitaOperatori.DataAttivita AS date) as DATAA,_LogAttivitaOperatori.OperatoreKey,count( DISTINCT DettaglioKey)as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where  AttivitaKey=1 
GROUP BY _LogAttivitaOperatori.OperatoreKey,CAST(_LogAttivitaOperatori.DataAttivita AS date)) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey
Union
Select 'Imballo' as Attivita,tabella.DATAA,_DimOperatori.CodiceOperatore,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  CAST(_LogAttivitaOperatori.DataAttivita AS date) as DATAA,_LogAttivitaOperatori.OperatoreKey,count( DISTINCT DettaglioKey)as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where  AttivitaKey=2
GROUP BY _LogAttivitaOperatori.OperatoreKey,CAST(_LogAttivitaOperatori.DataAttivita AS date)) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey
Union
Select 'Posizionatura' as Attivita,tabella.DATAA,_DimOperatori.CodiceOperatore,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  CAST(_LogAttivitaOperatori.DataAttivita AS date) as DATAA,_LogAttivitaOperatori.OperatoreKey,count( DISTINCT concat(UnitaCaricoKey,ArticoloKey))as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where  AttivitaKey=4
GROUP BY _LogAttivitaOperatori.OperatoreKey,CAST(_LogAttivitaOperatori.DataAttivita AS date)) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey
Union
Select 'Disimballo' as Attivita,tabella.DATAA,_DimOperatori.CodiceOperatore ,_DimOperatori.Operatore, tabella.OperatoreKey,tabella.RIGHE from logisticadwh.dbo._DimOperatori
RIGHT OUTER JOIN (Select  CAST(_LogAttivitaOperatori.DataAttivita AS date) as DATAA,_LogAttivitaOperatori.OperatoreKey,count( DISTINCT concat(UnitaCaricoKey,ArticoloKey))as RIGHE FROM logisticadwh.dbo._LogAttivitaOperatori 
where  AttivitaKey=3
GROUP BY _LogAttivitaOperatori.OperatoreKey,CAST(_LogAttivitaOperatori.DataAttivita AS date)) as tabella ON tabella.OperatoreKey=_DimOperatori.OperatoreKey;


TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_ATTIVITA_OPERATORI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_ATTIVITA_OPERATORI
(  
	OPERATOREKEY	
	,CODICE_OPERATORE
	,ATTIVITA		
	,DATAINIZIO		
	,DURATA			
	,RIGHE		 	
)
SELECT AnaAttivita.OperatoreKey,
       AnaAttivita.CodiceOperatore,
       AnaAttivita.Attivita,
       CONVERT(date, AnaAttivita.DataInizio,102) as DataInizio,
       ISNULL(SUM(DATEDIFF(minute, AnaAttivita.DataInizio, DataFine)), 0) AS Durata,
       CASE
           WHEN AnaAttivita.Attivita = 'Prelievo' THEN ISNULL(AnaGrouping.NumRighePrelevate, 0)
           WHEN AnaAttivita.Attivita = 'Imballo' THEN ISNULL(AnaGrouping.NumRigheImballate, 0)
           WHEN AnaAttivita.Attivita = 'Posizionatura' THEN ISNULL(AnaGrouping.NumRighePosizionate, 0)
           WHEN AnaAttivita.Attivita = 'Disimballo' THEN ISNULL(AnaGrouping.NumRigheDisimballate, 0)
           ELSE 0
       END AS RIGHE
FROM [LogisticaDWH].dbo.OperatoriAttivita AS AnaAttivita
LEFT JOIN (
        SELECT
            Opper_AnaOperatoriAttivita.CodiceOperatore,
            Opper_AnaOperatoriAttivita.Attivita,
            Opper_AnaOperatoriAttivita.DataInizio,
            ISNULL(Opper_AnaImballo.NumRigheImballate, 0) AS NumRigheImballate,
            ISNULL(Opper_AnaImballo.QtaTotImballata, 0) AS QtaTotImballata,
            ISNULL(Opper_AnaPosizionatura.NumRighePosizionate, 0) AS NumRighePosizionate,
            ISNULL(Opper_AnaPosizionatura.QtaTotPosizionatura, 0) AS QtaTotPosizionatura,
            ISNULL(Opper_AnaPrelievo.NumRighePrelevate, 0) AS NumRighePrelevate,
            ISNULL(Opper_AnaPrelievo.QtaTotPrelevata, 0) AS QtaTotPrelevata,
            ISNULL(Opper_AnaDisimballo.NumRigheDisimballate, 0) AS NumRigheDisimballate,
            ISNULL(Opper_AnaDisimballo.QtaTotDisimballata, 0) AS QtaTotDisimballata
        FROM
            [LogisticaDWH].dbo.Opper_AnaOperatoriAttivita
        LEFT OUTER JOIN [LogisticaDWH].dbo.Opper_AnaDisimballo ON Opper_AnaOperatoriAttivita.OperatoreKey = Opper_AnaDisimballo.OperatoreKey AND Opper_AnaOperatoriAttivita.DataInizio = Opper_AnaDisimballo.DisimballoDataKey
        LEFT OUTER JOIN [LogisticaDWH].dbo.Opper_AnaPrelievo ON Opper_AnaOperatoriAttivita.OperatoreKey = Opper_AnaPrelievo.OperatoreKey AND Opper_AnaOperatoriAttivita.DataInizio = Opper_AnaPrelievo.DataAssegnazione
        LEFT OUTER JOIN [LogisticaDWH].dbo.Opper_AnaImballo ON Opper_AnaOperatoriAttivita.OperatoreKey = Opper_AnaImballo.OperatoreKey AND Opper_AnaOperatoriAttivita.DataInizio = Opper_AnaImballo.ImballoDataKey
        LEFT OUTER JOIN [LogisticaDWH].dbo.Opper_AnaPosizionatura ON Opper_AnaOperatoriAttivita.OperatoreKey = Opper_AnaPosizionatura.OperatoreKey AND Opper_AnaOperatoriAttivita.DataInizio = Opper_AnaPosizionatura.PosizionaturaDataKey
    ) AS AnaGrouping
    ON AnaAttivita.CodiceOperatore = AnaGrouping.CodiceOperatore
    AND AnaAttivita.Attivita = AnaGrouping.Attivita
    AND  CONVERT(date, AnaAttivita.DataInizio,102) = CONVERT(date, AnaGrouping.DataInizio,102)
GROUP BY AnaAttivita.OperatoreKey, AnaAttivita.CodiceOperatore, AnaAttivita.Attivita, CONVERT(date, AnaAttivita.DataInizio,102),AnaGrouping.NumRighePrelevate,AnaGrouping.NumRigheImballate,AnaGrouping.NumRighePosizionate,AnaGrouping.NumRigheDisimballate;

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_PRESENZE_OPERATORI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_PRESENZE_OPERATORI
(  
	ID 						
	,DATA 					
	,AZIENDAID 				
	,OPERATOREID 			
	,CODICE 					
	,DESCRIZIONE 			
	,ORELAVOROPREVISTE 		
	,COSTOORA 				
	,COSTOGIORNO 			
	,PERCENTUALERETRIBUZIONE 
	,ORELAVORATE 			
	,ORENONLAVORATE 			
	,ORERETRIBUITE 			
)
select	[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].ID
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].Data
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].AziendaID
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].OperatoreID
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].Codice
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].Descrizione
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].OreLavoroPreviste
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].CostoOra
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].CostoGiorno
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].PercentualeRetribuzione
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].OreLavorate
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].OreNonLavorate
		,[Vision].[dbo].[_PowerBI_OL_Aziende_Presenze].OreRetribuite
FROM [Vision].dbo._PowerBI_OL_Aziende_Presenze;


TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_OPERATORI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_OPERATORI
(  
	OPERATOREID
	,OPERATOREID_WMS
	,OPERATORECODICE
	,COGNOME
	,NOME
	,AZIENDAID
)
SELECT [Vision].[dbo].[_PowerBI_OL_Aziende_Operatori].[ID] as 'ID_ACCESS'
      ,[WMS_OperatoreID] as 'WMS_ID'
      ,[CodiceOperatore]
      ,[Logistica].[dbo].[Operatori].[Cognome]
	  ,[Logistica].[dbo].[Operatori].[Nome]
	  ,[Azienda]
FROM [Vision].[dbo].[_PowerBI_OL_Aziende_Operatori],[Vision].[dbo].[_PowerBI_OL_Aziende], [Logistica].[dbo].[Operatori]
WHERE [AziendaID]=[Vision].[dbo].[_PowerBI_OL_Aziende].[ID] AND [Logistica].[dbo].[Operatori].[Id]=[Vision].[dbo].[_PowerBI_OL_Aziende_Operatori].[WMS_OperatoreID];

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_LIMBO;

INSERT INTO opper.dbo.LOGISTICA_IDIR_LIMBO
(  
	UNITACARICOID	
	,DISIMBALLO	 	
	,CHIUSURA		
	,CREAZIONE		
)
SELECT *
FROM (
    SELECT UdcCeste.UnitaCaricoId,
           UdcCeste.DISIMBALLO,
           UdcCeste.CHIUSURA,
           UnitaCarico.CREAZIONE
    FROM (
        SELECT [UnitaCaricoId],
               MIN([DataInizioDisimballo]) AS DISIMBALLO,
               MAX([DataFinePosizionatura]) AS CHIUSURA
        FROM [Logistica].[dbo].[UdcCeste]
        GROUP BY [UnitaCaricoId]
    ) AS UdcCeste
    LEFT OUTER JOIN (
        SELECT [Id],
               MIN([DataCreazione]) AS CREAZIONE
        FROM [Logistica].[dbo].[UnitaCarico]
        GROUP BY [Id]
    ) AS UnitaCarico ON UdcCeste.UnitaCaricoId = UnitaCarico.Id
) AS Result
WHERE Result.CREAZIONE > '2021-12-31 00:00:00';

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_TAG_GIORNI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_TAG_GIORNI
(  
	 DATA 						
	,RIGHEEVASE 				
	,PEZZIEVASI 				
	,IMPORTOEVASI 				
	,RIGHENONEVASENO 		
	,PEZZINONEVASINO 		
	,IMPORTONONEVASINO 		
	,RIGHENONEVASELIMBO 	
	,PEZZINONEVASILIMBO 	
	,IMPORTONONEVASILIMBO	
	,RIGHENONEVASE 			
	,PEZZINONEVASI 			
	,IMPORTONONEVASI 		
	,TOTRIGHE 				
	,TOTPEZZI 				
	,TOTIMPORTO 			
	,TAGRIGHE 				
	,TAGPEZZI 				
	,TAGIMPORTO 			
	,TALRIGHE 				
	,TALPEZZI 				
	,TALIMPORTO 			
	,TATRIGHE 				
	,TATPEZZI				
	,TATIMPORTO 								
)
SELECT        Data, RigheEvase, PezziEvasi, ImportoEvasi, RigheNonEvaseNo, PezziNonEvasiNo, ImportoNonEvasiNo, RigheNonEvaseLimbo, PezziNonEvasiLimbo, ImportoNonEvasiLimbo, RigheNonEvase, PezziNonEvasi, 
                         ImportoNonEvasi, TotRighe, TotPezzi, TotImporto, TAGRighe, TAGPezzi, TAGImporto, TALRighe, TALPezzi, TALImporto, TATRighe, TATPezzi, TATImporto
FROM            Vision.dbo._wvTag_v2
WHERE        (Data > CONVERT(DATETIME, '2021-12-31 00:00:00', 102));

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_TAG_REAL_TIME;

INSERT INTO opper.dbo.LOGISTICA_IDIR_TAG_REAL_TIME
(  
	 DATA 						
	,RIGHEEVASE 				
	,PEZZIEVASI 				
	,IMPORTOEVASI 				
	,RIGHENONEVASENO 		
	,PEZZINONEVASINO 		
	,IMPORTONONEVASINO 		
	,RIGHENONEVASELIMBO 	
	,PEZZINONEVASILIMBO 	
	,IMPORTONONEVASILIMBO	
	,RIGHENONEVASE 			
	,PEZZINONEVASI 			
	,IMPORTONONEVASI 		
	,TOTRIGHE 				
	,TOTPEZZI 				
	,TOTIMPORTO 			
	,TAGRIGHE 				
	,TAGPEZZI 				
	,TAGIMPORTO 			
	,TALRIGHE 				
	,TALPEZZI 				
	,TALIMPORTO 			
	,TATRIGHE 				
	,TATPEZZI				
	,TATIMPORTO 								
)
SELECT        Data, 
RigheEvase, 
PezziEvasi, 
ImportoEvasi, 
RigheNonEvaseNo, 
PezziNonEvasiNo, 
ImportoNonEvasiNo, 
RigheNonEvaseLimbo, 
PezziNonEvasiLimbo, 
ImportoNonEvasiLimbo,
RigheNonEvase, 
PezziNonEvasi, 
ImportoNonEvasi, 
TotRighe,
TotPezzi,
TotImporto, 
TAGRighe, 
TAGPezzi,
TAGImporto,
TALRighe,
TALPezzi,
TALImporto, 
TATRighe,
TATPezzi, 
TATImporto
FROM            vision.dbo._wvTag_v2
WHERE        (Data = DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0));

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_GIORNO_COSTO_RIGA;

INSERT INTO opper.dbo.LOGISTICA_IDIR_GIORNO_COSTO_RIGA
(  
	DATA
	,COSTO
	,RIGHEPRELEVATE
	,RIGHEPOSIZIONATE
)
SELECT        CONVERT(DateTime, LEFT(Costi.DataKey, 4) + '/' + RIGHT(LEFT(Costi.DataKey, 6), 2) + '/' + RIGHT(Costi.DataKey, 2)) AS Data, 
Costi.Costo, ISNULL(Prelievi.RighePrel, 0) AS RighePrelevate, 
                         ISNULL(Posizionamenti.RighePos, 0) AS RighePosizionate
FROM            (SELECT        DataKey, SUM(CostoGiorno) AS Costo
                          FROM            LogisticaDWH.dbo._FactOperatoriPresenze
                          GROUP BY DataKey) AS Costi LEFT OUTER JOIN
                             (SELECT        PosizionaturaDataKey AS DataKey, COUNT(DISTINCT ArticoloKey) AS RighePos
                               FROM            LogisticaDWH.dbo._FactOperatoriPosizionatura
                               GROUP BY PosizionaturaDataKey) AS Posizionamenti ON Costi.DataKey = Posizionamenti.DataKey LEFT OUTER JOIN
                             (SELECT        PrelievoDataKey AS DataKey, COUNT(DISTINCT DettaglioKey) AS RighePrel
                               FROM            LogisticaDWH.dbo._FactOperatoriPrelievi
                               GROUP BY PrelievoDataKey) AS Prelievi ON Costi.DataKey = Prelievi.DataKey
WHERE        (CONVERT(DateTime, LEFT(Costi.DataKey, 4) + '/' + RIGHT(LEFT(Costi.DataKey, 6), 2) + '/' + RIGHT(Costi.DataKey, 2)) > CONVERT(DATETIME, '2021-12-31 00:00:00', 102));

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_TARGET;

INSERT INTO opper.dbo.LOGISTICA_IDIR_TARGET
(  
	ID			
	,ANNO 		
	,TAG 		
	,LIMBO 		
	,COSTORIGA 	
	,NUMEROLIMBO 	
)
SELECT
	ID,
	Anno,
	Tag,
	Limbo,
	CostoRiga,
	NumeroLimbo
FROM  LogisticaDWH.[dbo].[_TargetLogistica];

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_LIMBO_REAL_TIME;

INSERT INTO opper.dbo.LOGISTICA_IDIR_LIMBO_REAL_TIME
(  		
	DATARILEVAZIONEREALTIME	
	,DATAORARILEVAZIONEREALTIME	
	,VALORELIMBO 				
)
SELECT        DATEADD(day, 0, DATEDIFF(day, 0, GETDATE())) AS DataRilevazioneRealTime, 
GETDATE() AS DataOraRilevazioneRealTime, 
SUM(ListeRighe.Importo * CausaliMagazzinoListeRigheTipo.StatisticheAcquisto) AS ValoreLimbo

FROM            Vision.dbo.liste AS Liste INNER JOIN
                         Vision.dbo.listerighe AS ListeRighe ON Liste.ID = ListeRighe.ListeID INNER JOIN
                         Vision.dbo.listeDocumenti AS ListeDocumenti ON Liste.ID = ListeDocumenti.ListeID INNER JOIN
                         Vision.dbo.CausalimagazzinoListeRigheTipo AS CausaliMagazzinoListeRigheTipo ON ListeRighe.CausaliMagazzinoListeRigheTipoID = CausaliMagazzinoListeRigheTipo.ID
WHERE        (Liste.MagazziniID = 40) AND (Liste.CausaliMagazzinoID = 10);

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_REAL_TIME_OPERATORI_ATTIVITA;

INSERT INTO opper.dbo.LOGISTICA_IDIR_REAL_TIME_OPERATORI_ATTIVITA
(  
	OPERATOREID 	
	,OPERATORECODICE 
	,COGNOME 		
	,NOME 			
	,DATA_INSERIMENTO
	,DATA_FINE		
	,DESCRIZIONE
)
SELECT 	RealTime_Operatori.Id , 
		RealTime_Operatori.CodiceOperatore , 
		RealTime_Operatori.Cognome, 
		RealTime_Operatori.Nome, 
		RealTime_Attivita_Operatori.DataInserimento, 
		RealTime_Attivita_Operatori.DataFine, 
		RealTime_Attivita.Descrizione
FROM
		(SELECT        Id, OperatoreId, AttivitaOperatoreId, DataInserimento, DataFine
		 FROM            logistica.dbo.Operatori_AttivitaOperatori Operatori_AttivitaOperatori_1) RealTime_Attivita_Operatori INNER JOIN
			(SELECT        Id, GuidUtente, Cognome, Nome, CodiceOperatore, NomeUtente, PasswordUtente, Deleted, Foto, ParentOperatoreId
			 FROM            logistica.dbo.operatori operatori_1) RealTime_Operatori ON RealTime_Attivita_Operatori.OperatoreId = RealTime_Operatori.Id INNER JOIN
				(SELECT        Id, Descrizione
				 FROM            logistica.dbo.attivitaoperatorI attivitaoperatore_1) RealTime_Attivita ON RealTime_Attivita_Operatori.AttivitaOperatoreId = RealTime_Attivita.Id
where DataInserimento > =getdate()-2;

TRUNCATE TABLE opper.dbo.LOGISTICA_IDIR_RIGHE_OPERATORI;

INSERT INTO opper.dbo.LOGISTICA_IDIR_RIGHE_OPERATORI
(
	OPERATOREKEY	
	,DATA_OPERATORE 
	,RIGHE			
	,QTA			
	,ATTIVITA		
	,ID_1			
	,WMS_OPERATOREID
	,AZIENDA		
	,ID_2			
	,COGNOME		
	,NOME			
	,OPERATORE		
	,CODICE_OPERATORE
)
Select * From(
select * 

from(
  Select 
	OPERATORE_KEY as 'OPERATOREKEY'
	,STUFF(STUFF( PRELIEVO_DATA_KEY,5, 0, '-'), 8, 0, '-')  as 'DATA'
	,sum(1) as 'RIGHE'
	,sum(QTA) as 'QTA'
	, 'PRELIEVO' as 'ATTIVITA'
	FROM (
  SELECT  
  OPERATORE_KEY,
  PRELIEVO_DATA_KEY,
   [DETTAGLIO_KEY],
	0 as 'QTA'
  FROM [Opper].[dbo].[LOGISTICA_IDIR_PRELIEVI]
  GROUP BY PRELIEVO_DATA_KEY,OPERATORE_KEY,[DETTAGLIO_KEY]
  ) as tab
  GROUP BY PRELIEVO_DATA_KEY,OPERATORE_KEY
 union

  
SELECT tab1.[OperatoreKey] as 'OPERATOREKEY',
STUFF(STUFF( tab1.[ImballoDataKey] ,5, 0, '-'), 8, 0, '-') as 'DATA',
sum(tab1.CONTA) as 'RIGHE',
sum(Quantita) as 'QTA' ,
'IMBALLO' as 'ATTIVITA'
FROM

(SELECT Distinct 
      [DettaglioKey]
      ,[ImballoDataKey]
	  ,[OperatoreKey]
      ,[ArticoloKey]
	  ,1 as 'CONTA'
	  ,sum(Quantita) as 'Quantita'
  FROM [LogisticaDWH].[dbo].[_FactOperatoriImballi]
  group by [DettaglioKey],[ImballoDataKey],[OperatoreKey],[ArticoloKey]
  ) as tab1
  group by tab1.[OperatoreKey],tab1.[ImballoDataKey]

  union
  
  SELECT
      [OperatoreKey] as 'OPERATOREKEY'
      ,STUFF(STUFF( [DisimballoDataKey] ,5, 0, '-'), 8, 0, '-')  as 'DATA'
	  ,sum(1) as 'RIGHE'
, sum(Quantita) as 'QTA'
,'DISIMBALLO' as 'ATTIVITA'
  FROM [LogisticaDWH].[dbo].[_FactOperatoriDisimballo],[LogisticaDWH].[dbo].[_DimTime]
  WHERE [DisimballoTimeKey]=[TimeAltKey]
    group by [DisimballoDataKey],[ArticoloKey],[OperatoreKey],[ORA]


	union
SELECT tab1.[OPERATORE_KEY] as 'OPERATOREKEY',
STUFF(STUFF( tab1.[POSIZIONATURA_DATA_KEY] ,5, 0, '-'), 8, 0, '-') as 'DATA',
sum(tab1.CONTA) as 'RIGHE',
sum(QTA) as 'QTA' 
,'POSIZIONATURA' as 'ATTIVITA'
FROM
(SELECT Distinct 
       [OPERATORE_KEY]
      ,[POSIZIONATURA_DATA_KEY]
      ,[CESTA_KEY]
      ,[ARTICOLO_KEY]
	  ,1 as 'CONTA'
	  ,sum([QUANTITA]) as 'QTA'
  FROM [OPPER].[dbo].[LOGISTICA_IDIR_POSIZIONATURA]
  WHERE [QUANTITA]>0
  group by [OPERATORE_KEY],[POSIZIONATURA_DATA_KEY],[CESTA_KEY],[ARTICOLO_KEY]
  ) as tab1
  group by tab1.[OPERATORE_KEY],tab1.[POSIZIONATURA_DATA_KEY]
  ) as TabRighe, 
  (
  SELECT [Vision].[dbo].[_PowerBI_OL_Aziende_Operatori].[ID]
      ,[WMS_OperatoreID]
	  ,[Azienda]
  FROM [Vision].[dbo].[_PowerBI_OL_Aziende_Operatori],[Vision].[dbo].[_PowerBI_OL_Aziende]
  WHERE 
  [Vision].[dbo].[_PowerBI_OL_Aziende].[ID] =[AziendaID]) as TabAna

  WHERE TabRighe.[OPERATOREKEY]=TabAna.[WMS_OperatoreID]) as TabFin,

 ( SELECT DISTINCT
		[Id]
      ,[Cognome]
      ,[Nome]
	  ,CONCAT([Cognome],' ',[Nome]) as 'OPERATORE'
      ,[CodiceOperatore]
  FROM [Logistica].[dbo].[Operatori]) as TabAna2
  WHERE TabAna2.[Id]=TabFin.[OPERATOREKEY];


TRUNCATE TABLE opper.dbo.LOGISTICA_UBICAZIONI;

INSERT INTO opper.dbo.LOGISTICA_UBICAZIONI
(
	ID_LOGISTICA_UBICAZIONI
	,CODICE					
	,MAGAZZINO				
)
SELECT
Id,
Codice,
CASE
	WHEN Codice LIKE 'A%' THEN 'A'
	WHEN Codice LIKE 'PP%' THEN 'PP'
	WHEN Codice LIKE 'PM%' THEN 'PM'
	WHEN Codice LIKE 'C%' THEN 'C'
	ELSE 'ALTRO'
    END as Magazzino
FROM Logistica.dbo.[Containers];

TRUNCATE TABLE opper.dbo.LOGISTICA_UBICAZIONI_ARTICOLI;

INSERT INTO opper.dbo.LOGISTICA_UBICAZIONI_ARTICOLI
(
	ARTICOLIKEY	
	,UBICAZIONEID	
	,QUANTITA		
	,UBICAZIONE		
)
SELECT
[PreCodice] + '|' + [Articoli].[Codice] as [ArticoloKey]
,[UbicazioneId]
,[Quantita]
,[Containers].[Codice] as 'Ubicazione'
FROM [Logistica].[dbo].[Articoli_Ubicazioni],[Logistica].[dbo].[Articoli],[Logistica].[dbo].[Containers]
WHERE 
Logistica.dbo.[Articoli_Ubicazioni].[ArticoloId]=Logistica.dbo.[Articoli].[Id] AND
Logistica.dbo.[Articoli_Ubicazioni].[UbicazioneId]=Logistica.dbo.[Containers].[Id];

TRUNCATE TABLE opper.dbo.LOGISTICA_RECUPERO_TRASP;

INSERT INTO opper.dbo.LOGISTICA_RECUPERO_TRASP
(
	CODICE_CLIENTE
	,COGNOME
	,MESE
	,ANNO
	,TRASP_TOTALE
)
select cc.Codice As CodiceCliente, c.Cognome, TraspClienti.Mese, TraspClienti.Anno, sum(TraspClienti.Importo) As TraspTotale 
from 
(
	SELECT Vision.dbo.MovimentiContabiliRighe.Importo * Vision.dbo.SezioniContabili.Moltiplicatore *-1 AS Importo,                          
			Year(Vision.dbo.MovimentiContabili.DataRegistrazione) as Anno, 
			Month(Vision.dbo.MovimentiContabili.DataRegistrazione) as Mese, 
			isnull((SELECT m1.ClientiFornitoriID  FROM Vision.dbo.MovimentiContabiliRighe AS m1 
	WHERE 	(m1.ClientiFornitoriID > 0) AND (m1.MovimentiContabiliID = MovimentiContabili.ID)),'') ClientiFornitoriID 
	FROM  	Vision.dbo.MovimentiContabiliRighe INNER JOIN Vision.dbo.ContiCodifiche ON Vision.dbo.MovimentiContabiliRighe.ContiID = Vision.dbo.ContiCodifiche.ContoID INNER JOIN
			Vision.dbo.MovimentiContabili ON Vision.dbo.MovimentiContabiliRighe.MovimentiContabiliID = MovimentiContabili.ID INNER JOIN
			Vision.dbo.SezioniContabili ON Vision.dbo.MovimentiContabiliRighe.SezioniContabiliID = Vision.dbo.SezioniContabili.ID 
	WHERE (Vision.dbo.ContiCodifiche.Codice = '040700002') AND (Vision.dbo.MovimentiContabili.DataRegistrazione >=  CONVERT(DATETIME, '2021-01-01 00:00:00', 102))
) as TraspClienti
Left JOIN Vision.dbo.ContattiContabili  cc 
left JOIN Vision.dbo.ClientiFornitori  cf ON cc.ID = cf.ContattiContabiliID ON TraspClienti.ClientiFornitoriID = cf.ID 
left join Vision.dbo.Contatti c on cc.ContattoID = c.ID
group by TraspClienti.ClientiFornitoriID,TraspClienti.Mese, TraspClienti.Anno, cc.Codice, c.Cognome;


TRUNCATE TABLE opper.dbo.LOGISTICA_FACT_SALES;

INSERT INTO opper.dbo.LOGISTICA_FACT_SALES
(
	LISTEID 					 
	,LISTENUMERO                 
	,ORDINEDATAKEY               
	,ORDINETIMEATLKEY            
	,ORDINECONSEGNADATAKEY       
	,ORDINECONSEGNATIMEATLKEY    
	,ORDINEWMSDATAKEY            
	,ORDINEWMSTIMEATLKEY         
	,CLIENTEKEY                  
	,DESTINATARIO                
	,DEST_INDIRIZZO              
	,DEST_CAP                    
	,DEST_COMUNE                 
	,DEST_PROVINCIA              
	,DESTNAZIONEKEY              
	,VETTOREKEY                  
	,TIMEALTKEYPRECUTOFF         
	,TIMEALTKEYCUTOFF            
	,AGENTEKEY                   
	,AGENTE                      
)
SELECT LogisticaDWH.dbo._FactSales.ListeId, LogisticaDWH.dbo._FactSales.ListeNumero, LogisticaDWH.dbo._FactSales.OrdineDataKey, LogisticaDWH.dbo._FactSales.OrdineTimeAtlkey, LogisticaDWH.dbo._FactSales.OrdineConsegnaDataKey, LogisticaDWH.dbo._FactSales.OrdineConsegnaTimeAtlkey, 
                  LogisticaDWH.dbo._FactSales.OrdineWmsDataKey, LogisticaDWH.dbo._FactSales.OrdineWmsTimeAtlkey, LogisticaDWH.dbo._FactSales.ClienteKey, LogisticaDWH.dbo._FactSales.Destinatario, LogisticaDWH.dbo._FactSales.Dest_Indirizzo, LogisticaDWH.dbo._FactSales.Dest_Cap, LogisticaDWH.dbo._FactSales.Dest_Comune, 
                  LogisticaDWH.dbo._FactSales.Dest_Provincia, LogisticaDWH.dbo._FactSales.DestNazioneKey, LogisticaDWH.dbo._FactSales.VettoreKey, LogisticaDWH.dbo._FactSales.TimeAltKeyPreCutOff, LogisticaDWH.dbo._FactSales.TimeAltKeyCutOff, LogisticaDWH.dbo._DimClienti.AgenteKey, LogisticaDWH.dbo._DimAgenti.Agente
FROM     LogisticaDWH.dbo._DimClienti INNER JOIN
                  LogisticaDWH.dbo._DimAgenti ON LogisticaDWH.dbo._DimClienti.AgenteKey = LogisticaDWH.dbo._DimAgenti.AgenteKey INNER JOIN
                  LogisticaDWH.dbo._FactSales ON LogisticaDWH.dbo._DimClienti.ClienteKey = LogisticaDWH.dbo._FactSales.ClienteKey
GROUP BY LogisticaDWH.dbo._FactSales.ListeId, LogisticaDWH.dbo._FactSales.ListeNumero, LogisticaDWH.dbo._FactSales.OrdineDataKey, LogisticaDWH.dbo._FactSales.OrdineTimeAtlkey, LogisticaDWH.dbo._FactSales.OrdineConsegnaDataKey, LogisticaDWH.dbo._FactSales.OrdineConsegnaTimeAtlkey, 
                  LogisticaDWH.dbo._FactSales.OrdineWmsDataKey, LogisticaDWH.dbo._FactSales.OrdineWmsTimeAtlkey, LogisticaDWH.dbo._FactSales.ClienteKey, LogisticaDWH.dbo._FactSales.Destinatario, LogisticaDWH.dbo._FactSales.Dest_Indirizzo, LogisticaDWH.dbo._FactSales.Dest_Cap, LogisticaDWH.dbo._FactSales.Dest_Comune, 
                  LogisticaDWH.dbo._FactSales.Dest_Provincia, LogisticaDWH.dbo._FactSales.DestNazioneKey, LogisticaDWH.dbo._FactSales.VettoreKey, LogisticaDWH.dbo._FactSales.TimeAltKeyPreCutOff, LogisticaDWH.dbo._FactSales.TimeAltKeyCutOff, LogisticaDWH.dbo._DimClienti.AgenteKey, LogisticaDWH.dbo._DimAgenti.Agente;


TRUNCATE TABLE opper.dbo.LOGISTICA_FATTURE_CORRIERI_PROVENIENZA;

INSERT INTO opper.dbo.LOGISTICA_FATTURE_CORRIERI_PROVENIENZA
(
	CODICEFORNITORE 			 
	,VETTORE                     
	,DATAFATTURA                 
	,NUMFATTURA                  
	,TRACKING                    
	,DATASPEDIZIONE              
	,COLLI                       
	,COSTO_SPEDIZIONE            
	,ERPLISTAID                  
	,LISTENUMERO                 
	,NUMERODOCUMENTO             
	,DATALISTA                   
	,CLICODICE                   
	,DESTRAGIONESOCIALE          
	,DESTNAZIONE                 
	,CLIRAGIONESOCIALE           
	,TRASPORTO                   
	,VENDUTO                     
	,PORTO                       
	,CLIREGIONE                  
	,DESTREGIONE                 
	,DESTPROVINCIA               
	,CUTOFF                      
	,PRECUTOFF                   
	,ERPDESTINATARIOID           
	,ERPVETTOREID                
	,COSTOSTIMATO                
	,PROVENIENZA                 
	,AGENTEKEY                   
	,AGENTE                      
	,MITTENTE                    
	,DESTINAZIONE                
	,CITTADESTINAZIONE	         
)
SELECT Vettori_FattureCorrieriG.CodiceFornitore, Vettori_FattureCorrieriG.Vettore, Vettori_FattureCorrieriG.DataFattura, Vettori_FattureCorrieriG.NumFattura, Vettori_FattureCorrieriG.Tracking, Vettori_FattureCorrieriG.DataSpedizione,
                         Vettori_FattureCorrieriG.Colli, Vettori_FattureCorrieriG.CostoSpedizione /CASE WHEN (select top 1 IsCorriereNazionale from Logistica.dbo.Vettori where CodiceFornitore = Vettori_FattureCorrieriG.CodiceFornitore) = 1 THEN CASE WHEN Isnull ((SELECT        COUNT(DISTINCT (ordineId))
                                 FROM            Logistica.dbo.Colli
                                 WHERE        (Tracking = Vettori_FattureCorrieriG.Tracking)), 1) = 0 THEN 1 ELSE Isnull
                             ((SELECT        COUNT(DISTINCT (ordineId))
                                 FROM            Logistica.dbo.Colli
                                 WHERE        (Tracking = Vettori_FattureCorrieriG.Tracking)), 1) END ELSE CASE WHEN Isnull
                             ((SELECT        COUNT(Logistica.dbo.ColliCosti.Id)
                                 FROM            Logistica.dbo.Colli INNER JOIN
                                                          Logistica.dbo.ColliCosti ON Logistica.dbo.Colli.Id = Logistica.dbo.ColliCosti.ColloId
                                 WHERE        (Logistica.dbo.Colli.Codice = Vettori_FattureCorrieriG.Tracking)), 1) = 0 THEN 1 ELSE Isnull
                             ((SELECT        COUNT(Logistica.dbo.ColliCosti.Id)
                                 FROM            Logistica.dbo.Colli INNER JOIN
                                                          Logistica.dbo.ColliCosti ON Logistica.dbo.Colli.Id = Logistica.dbo.ColliCosti.ColloId
                                 WHERE        (Logistica.dbo.Colli.Codice = Vettori_FattureCorrieriG.Tracking)), 1) END END AS [Costo Spedizione], Logistica.dbo.View_Colli.ErpListaId, Logistica.dbo.View_Colli.ListeNumero, Logistica.dbo.View_Colli.NumeroDocumento, Logistica.dbo.View_Colli.DataLista, Logistica.dbo.View_Colli.CliCodice, 
                         Logistica.dbo.View_Colli.DestRagionesociale, Logistica.dbo.View_Colli.DestNazione, ISNULL(Logistica.dbo.View_Colli.CliRagioneSociale, Vettori_FattureCorrieriG.TipoSpedizione) AS CliRagioneSociale, 
						ISNULL(((SELECT SUM(Valore) AS Expr1
                                 FROM PowerBI.dbo.ListeDocumentiSpeseAccessorie
                                 WHERE (SpeseAccessorieID IN (10, 11, 3)) AND (ListeDocumentiID = PowerBI.dbo.ListeDocumenti.ID)) +
						ISNULL((SELECT SUM(ListeRighe.Importo) AS Expr1 FROM PowerBI.dbo.ListeRighe INNER JOIN
									PowerBI.dbo.CausaliMagazzinoListeRigheTipo ON ListeRighe.CausaliMagazzinoListeRigheTipoID = CausaliMagazzinoListeRigheTipo.ID INNER JOIN
									PowerBI.dbo.ListeRigheTipo ON CausaliMagazzinoListeRigheTipo.ListeRigheTipoID = ListeRigheTipo.ID
									WHERE (ListeRighe.ListeID = PowerBI.dbo.ListeDocumenti.ListeID) AND (ListeRigheTipo.Codice = 42) 
									AND (ListeRighe.Codice IN('TR1010', 'TR1011', 'TR1012', 'IMB1111','TraspAts'))), 0))
									/
						ISNULL((SELECT COUNT(DISTINCT Codice) AS Expr1
								FROM Logistica.dbo.View_Colli AS v1
                                 WHERE (ErpListaId = Logistica.dbo.View_Colli.ErpListaId)), 1), 0) AS Trasporto,
							ISNULL(PowerBI.dbo.ListeDocumenti.TotaleImponibile / ISNULL
                             ((SELECT        COUNT(DISTINCT Codice) AS Expr1
                                 FROM            Logistica.dbo.View_Colli AS v1
                                 WHERE        (ErpListaId = Logistica.dbo.View_Colli.ErpListaId)), 1), 0) AS Venduto,
								Logistica.dbo.View_Colli.Porto, 
								Logistica.dbo.View_Colli.CliRegione, 
								Logistica.dbo.View_Colli.DestRegione, 
								Logistica.dbo.View_Colli.DestProvincia, 
								Logistica.dbo.View_Colli.CutOff, 
								Logistica.dbo.View_Colli.PreCutOff, 
								Logistica.dbo.View_Colli.ErpDestinatarioId, 
								Logistica.dbo.View_Colli.ErpVettoreId, 
								SUM(Logistica.dbo.View_Colli.CostoCollo) AS CostoStimato, 
								PowerBI.dbo.ListeProvenienzaTipo.Descrizione AS Provenienza, 
								LogisticaDWH.dbo.View_FactSales.AgenteKey, 
								LogisticaDWH.dbo.View_FactSales.Agente,
								Vettori_FattureCorrieriG.Mittente,
								Vettori_FattureCorrieriG.Destinazione,
								Vettori_FattureCorrieriG.CittaDestinazione
						FROM 
						(SELECT  CodiceFornitore, Vettore, DataFattura, NumFattura, Tracking, mittente, Destinazione, IndirizzoDestinazione, ProvinciaDestinazione, CapDestinazione, CittaDestinazione, MAX(Volume) AS Volume, MAX(PesoReale) AS PesoReale, 
                         MAX(PesoTassabile) AS PesoTassabile, Colli, SUM(CostoSpedizione) AS CostoSpedizione, DataSpedizione, DataConsegna, Altezza AS Expr2, Larghezza AS Expr3, Profondita AS Expr4, Note, TipoSpedizione
						FROM Logistica.dbo.Vettori_FattureCorrieri
						GROUP BY CodiceFornitore, Vettore, DataFattura, NumFattura, Tracking,  mittente, Destinazione, IndirizzoDestinazione, ProvinciaDestinazione, CapDestinazione, CittaDestinazione, Colli, DataSpedizione, DataConsegna, Altezza, Larghezza, Profondita, Note, TipoSpedizione) as Vettori_FattureCorrieriG  LEFT OUTER JOIN
						Logistica.dbo.View_Colli ON Vettori_FattureCorrieriG.Tracking = Logistica.dbo.View_Colli.Tracking  LEFT OUTER JOIN
                         LogisticaDWH.dbo.View_FactSales ON LogisticaDWH.dbo.View_FactSales.ListeId = Logistica.dbo.View_Colli.ErpListaId  LEFT OUTER JOIN
						PowerBI.dbo.Liste AS Liste_1 ON Liste_1.ID = Logistica.dbo.View_Colli.ErpListaId LEFT OUTER JOIN
						PowerBI.dbo.Liste ON Liste_1.SorgenteListeID = PowerBI.dbo.Liste.ID  LEFT OUTER JOIN
						PowerBI.dbo.ListeDocumenti ON Liste_1.ID = PowerBI.dbo.ListeDocumenti.ListeID LEFT OUTER JOIN
                         PowerBI.dbo.ListeProvenienzaTipo ON PowerBI.dbo.ListeProvenienzaTipo.ID = PowerBI.dbo.Liste.ListeProvenienzaTipoID 
GROUP BY 
Vettori_FattureCorrieriG.CodiceFornitore, 
Vettori_FattureCorrieriG.Vettore, 
Vettori_FattureCorrieriG.DataFattura, 
Vettori_FattureCorrieriG.NumFattura, 
Vettori_FattureCorrieriG.Tracking, 
Vettori_FattureCorrieriG.DataSpedizione,
Vettori_FattureCorrieriG.TipoSpedizione,
Vettori_FattureCorrieriG.Colli,
Vettori_FattureCorrieriG.CostoSpedizione,
Logistica.dbo.View_Colli.ErpListaId, 
Logistica.dbo.View_Colli.ListeNumero, 
Logistica.dbo.View_Colli.NumeroDocumento, 
Logistica.dbo.View_Colli.DataLista, 
Logistica.dbo.View_Colli.CliCodice, 
Logistica.dbo.View_Colli.CliRagioneSociale, 
Logistica.dbo.View_Colli.DestRagionesociale, 
Logistica.dbo.View_Colli.DestNazione, 
Logistica.dbo.View_Colli.Porto,
Logistica.dbo.View_Colli.DestRegione, 
Logistica.dbo.View_Colli.DestProvincia, 
Logistica.dbo.View_Colli.CutOff, 
Logistica.dbo.View_Colli.PreCutOff,
Logistica.dbo.View_Colli.ErpDestinatarioId, 
Logistica.dbo.View_Colli.ErpVettoreId, 
Logistica.dbo.View_Colli.CliRegione, 
PowerBI.dbo.ListeDocumenti.TotaleImponibile,
PowerBI.dbo.ListeProvenienzaTipo.Descrizione,
PowerBI.dbo.ListeDocumenti.ID,
PowerBI.dbo.ListeDocumenti.ListeID,
LogisticaDWH.dbo.View_FactSales.AgenteKey, 
LogisticaDWH.dbo.View_FactSales.Agente,Vettori_FattureCorrieriG.Mittente,Vettori_FattureCorrieriG.Destinazione,
Vettori_FattureCorrieriG.CittaDestinazione;

TRUNCATE TABLE opper.dbo.LOGISTICA_COLLI_SPESE;

INSERT INTO opper.dbo.LOGISTICA_COLLI_SPESE
(
	ID_COLLO				
	,CODICE 			 	
	,DATACOLLO              
	,PACKING_LIST_CODE      
	,TRACKING               
	,TIPOLOGIA_COLLOR       
	,DATA_COLLO_SPEDITO     
	,PSO_KG                 
	,COSTO_COLLO            
	,TIPO_COLLO             
	,LUNGHEZZA_CM           
	,LARGHEZZA_CM           
	,ALTEZZA_CM             
	,ERP_LISTA_ID           
	,LISTE_NUMERO           
	,NUMERO_DOCUMENTO       
	,DATA_LISTA          	
	,ERP_CLI_FOR_ID         
	,CLI_CODICE           	
	,CLI_RAGIONE_SOCIALE    
	,CLI_INDIRIZZO          
	,CLI_COMUNE             
	,CLI_CAP                
	,CLI_PROVINCIA          
	,CLI_REGIONE            
	,ERP_DESTINATARIO_ID    
	,DEST_RAGIONE_SOCIALE   
	,DEST_INDIRIZZO         
	,DEST_CAP               
	,DEST_COMUNE            
	,DEST_PROVINCIA         
	,DEST_REGIONE           
	,DEST_NAZIONE           
	,ERP_VETTORE_ID         
	,VET_CODICE             
	,VET_RAGIONE_SOCIALE    
	,VET_PARTITA_IVA        
	,IS_CORRIERE_NAZIONALE  
	,CUT_OFF           		
	,STATO_COLLO       		
	,MAGAZZINO_ID      		
	,CODICE_FORNITORE  		
	,FORNITORE         		
	,PRE_CUT_OFF       		
	,DATA_CHIUSURA     		
	,CODICE_PORTO      		
	,PORTO	         		
	,TRASPORTO	     		
	,PROVENIENZA	 		
	,IMPORTO_COLLO	 		
	,IMABLLATO	     		
	,TOTALE	         		
	,CODICE_FORNITORE_TOTALE		
	,VETTORE_FATTURA		
)
SELECT 
Logistica.dbo.View_Colli.*,
(ISNULL((SELECT SUM(Valore) AS Expr1
FROM PowerBI.dbo.ListeDocumentiSpeseAccessorie 
WHERE (SpeseAccessorieID IN (10, 11, 3)) AND (ListeDocumentiID = PowerBI.dbo.ListeDocumenti.ID)),0) 
+ ISNULL((SELECT SUM(importo) AS expr1 
FROM PowerBI.dbo.ListeRighe WHERE (Codice IN ('TR1010', 'TR1012', 'TR1111')) AND (ListeID = Logistica.dbo.View_Colli.ErpListaId)),0)) 
/ (CASE WHEN ISNULL((SELECT COUNT(*) AS Expr1 FROM Logistica.dbo.View_Colli AS v1  WHERE (ErpListaId = Logistica.dbo.View_Colli.ErpListaId)), 1) = 0 THEN 1 ELSE ISNULL((SELECT COUNT(*) AS Expr1 FROM Logistica.dbo.View_Colli AS v1  WHERE (ErpListaId = Logistica.dbo.View_Colli.ErpListaId)), 1) END) AS Trasporto, 
PowerBI.dbo.ListeProvenienzaTipo.Descrizione AS Provenienza, 
ROUND(isnull((SELECT (SUM(Logistica.dbo.ColliPrelievi.Quantita * (Logistica.dbo.OrdiniDettagli.Importo / case when Logistica.dbo.OrdiniDettagli.Quantita = 0 then 1 else Logistica.dbo.OrdiniDettagli.Quantita end))) AS ImportoCollo
FROM Logistica.dbo.ColliPrelievi INNER JOIN 
Logistica.dbo.OrdiniDettagliPrelievi ON Logistica.dbo.ColliPrelievi.OrdineDettaglioPrelievoId = Logistica.dbo.OrdiniDettagliPrelievi.Id INNER JOIN 
Logistica.dbo.OrdiniDettagli ON Logistica.dbo.OrdiniDettagliPrelievi.OrdineDettaglioId = Logistica.dbo.OrdiniDettagli.Id 
WHERE (Logistica.dbo.ColliPrelievi.ColloId = Logistica.dbo.View_Colli.id)) / (SELECT COUNT(*) AS Expr1 FROM Logistica.dbo.View_Colli AS v1 WHERE (v1.id = Logistica.dbo.View_Colli.id)) ,0), 4, 2) as ImportoCollo, 
Round(isnull((SELECT (SUM(Logistica.dbo.ColliPrelievi.Quantita)) AS Imballatto
							FROM Logistica.dbo.ColliPrelievi INNER JOIN
                         Logistica.dbo.OrdiniDettagliPrelievi ON Logistica.dbo.ColliPrelievi.OrdineDettaglioPrelievoId = Logistica.dbo.OrdiniDettagliPrelievi.Id INNER JOIN
                         Logistica.dbo.OrdiniDettagli ON Logistica.dbo.OrdiniDettagliPrelievi.OrdineDettaglioId = Logistica.dbo.OrdiniDettagli.Id
							WHERE (Logistica.dbo.ColliPrelievi.ColloId = Logistica.dbo.View_Colli.id)) / (SELECT COUNT(*) AS Expr1 FROM Logistica.dbo.View_Colli AS v1 WHERE (v1.id = Logistica.dbo.View_Colli.id)) ,0), 4, 2) as  Imballatto,					 
						Vettori_FattureCorrieriG.Totale,Vettori_FattureCorrieriG.CodiceFornitore,Vettori_FattureCorrieriG.Vettore As VettoreFattura
                         from Logistica.dbo.View_Colli LEFT OUTER JOIN
						PowerBI.dbo.Liste AS Liste_1 ON Liste_1.ID = Logistica.dbo.View_Colli.ErpListaId LEFT OUTER JOIN
						PowerBI.dbo.Liste ON Liste_1.SorgenteListeID = PowerBI.dbo.Liste.ID  LEFT OUTER JOIN
						PowerBI.dbo.ListeDocumenti ON Liste_1.ID = PowerBI.dbo.ListeDocumenti.ListeID LEFT OUTER JOIN
                         PowerBI.dbo.ListeProvenienzaTipo ON PowerBI.dbo.ListeProvenienzaTipo.ID = PowerBI.dbo.Liste.ListeProvenienzaTipoID left outer join
						(SELECT Tracking, SUM(CostoSpedizione) AS Totale, Vettore, CodiceFornitore
FROM Logistica.dbo.Vettori_FattureCorrieri GROUP BY Tracking, CodiceFornitore, Vettore) as Vettori_FattureCorrieriG on Logistica.dbo.View_Colli.Tracking = Vettori_FattureCorrieriG.Tracking;
