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
SELECT	AziendaKey as AziendaKey,
		Azienda,
		Tipo 	
FROM  [LogisticaDWH].[dbo].[_DimAziende];

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
select	[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].ID
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].Data
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].AziendaID
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].OperatoreID
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].Codice
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].Descrizione
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].OreLavoroPreviste
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].CostoOra
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].CostoGiorno
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].PercentualeRetribuzione
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].OreLavorate
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].OreNonLavorate
		,[PowerBI].[dbo].[_PowerBI_OL_Aziende_Presenze].OreRetribuite
FROM [PowerBI].dbo._PowerBI_OL_Aziende_Presenze;


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
