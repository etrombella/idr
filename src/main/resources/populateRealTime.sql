TRUNCATE TABLE [opper].[dbo].[LOGISTICA_IDIR_ATTIVITA_REALTIME_NEW];

INSERT INTO [opper].[dbo].[LOGISTICA_IDIR_ATTIVITA_REALTIME_NEW](
Id,
OperatoreId,
AttivitaOperatoreId,
Descrizione,
DataInserimento,
DataFine,
Magazzino
)
SELECT [Logistica].[dbo].[Operatori_AttivitaOperatori].[Id]
      ,[Logistica].[dbo].[Operatori_AttivitaOperatori].[OperatoreId]
      ,[Logistica].[dbo].[Operatori_AttivitaOperatori].[AttivitaOperatoreId]
	  ,[Logistica].[dbo].[AttivitaOperatori].[Descrizione]
      ,[Logistica].[dbo].[Operatori_AttivitaOperatori].[DataInserimento]
      ,[Logistica].[dbo].[Operatori_AttivitaOperatori].[DataFine]
 ,'Maddaloni' as Magazzino
  FROM [Logistica].[dbo].[Operatori_AttivitaOperatori]
  left join [Logistica].[dbo].[AttivitaOperatori] on [Logistica].[dbo].[AttivitaOperatori].[id]=[Logistica].[dbo].[Operatori_AttivitaOperatori].[AttivitaOperatoreId]
  where [Logistica].[dbo].[Operatori_AttivitaOperatori].[DataInserimento]<=GETDATE()+1 and 
   [Logistica].[dbo].[Operatori_AttivitaOperatori].[DataInserimento]>GETDATE();
   
TRUNCATE TABLE [Opper].[dbo].[LOGISTICA_IDIR_REALTIME_NEW];

INSERT INTO [Opper].[dbo].[LOGISTICA_IDIR_REALTIME_NEW](
	[Id] ,
	[Data] ,
	[DataAttivita] ,
	[OperatoreKey] ,
	[Cognome] ,
	[Nome] ,
	[CodiceOperatore] ,
	[AttivitaKey] ,
	[DettaglioKey] ,
	[PreCodice] ,
	[Codice] ,
	[ArticoloKey] ,
	[Ubicazione] ,
	[Ubi] ,
	[Quantita] ,
	[UnitaCaricoKey] ,
	[CestaKey] ,
	[ColloKey] ,
	[ErpListaId] ,
	[ErpListaRigaId] ,
	[QuantitaOrdinata] ,
	[DataLista] ,
	[DataListaRiga] ,
	[DataPreCutOff] ,
	[DataCutOff] ,
	[ErpVettoreId] ,
	[ClienteId] ,
	[Operatore] ,
	[Rigedis] ,
	[Rigepos] ,
	[Rigepre] ,
	[Rigeimb] ,
	[Magazzino] 
)
SELECT [Logistica].[dbo].[_LogAttivitaOperatori].[Id]
	  ,format([Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita],'yyyy-MM-dd') as 'Data'
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita]
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[OperatoreKey]
	  ,[Logistica].[dbo].[Operatori].[Cognome]
      ,[Logistica].[dbo].[Operatori].[Nome]
      ,[Logistica].[dbo].[Operatori].[CodiceOperatore]
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[AttivitaKey]
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[DettaglioKey]
	  ,[Logistica].[dbo].[Articoli].[PreCodice]
	  ,[Logistica].[dbo].[Articoli].[Codice]
	  ,CASE [Logistica].[dbo].[_LogAttivitaOperatori].[AttivitaKey]
			WHEN 1 then [Logistica].[dbo].[Articoli].[PreCodice]+'|'+[Logistica].[dbo].[Articoli].[Codice]
			WHEN 2 then [Logistica].[dbo].[Articoli].[PreCodice]+'|'+[Logistica].[dbo].[Articoli].[Codice]
			WHEN 3 then [Logistica].[dbo].[_LogAttivitaOperatori].[ArticoloKey]
			ELSE  [Logistica].[dbo].[_LogAttivitaOperatori].[ArticoloKey]
		end as 'ArticoloKey'
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[Ubicazione]
	  ,left([Logistica].[dbo].[_LogAttivitaOperatori].[Ubicazione],2) as Ubi
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[Quantita]
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[UnitaCaricoKey]
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[CestaKey]
      ,[Logistica].[dbo].[_LogAttivitaOperatori].[ColloKey]

	  ,[Logistica].[dbo].[Ordini].[ErpListaId]
      ,[Logistica].[dbo].[OrdiniDettagli].[ErpListaRigaId]
      ,[Logistica].[dbo].[OrdiniDettagli].[QuantitaOrdinata]
	  ,[Logistica].[dbo].[Ordini].[DataLista]
      ,[Logistica].[dbo].[OrdiniDettagli].[DataListaRiga]



      ,format([Logistica].[dbo].[Ordini].[DataConsegna],'yyyy-MM-dd')+' '+format([Logistica].[dbo].[VettoriOrari].[OraRitiro],'00')+':'+format([Logistica].[dbo].[VettoriOrari].[MinutiRitiro],'00')+':00' as DataPreCutOff
      ,format([Logistica].[dbo].[Ordini].[DataConsegna],'yyyy-MM-dd')+' '+format([Logistica].[dbo].[VettoriOrari].[OraCutOff],'00')+':'+format([Logistica].[dbo].[VettoriOrari].[MinutiCutOff],'00')+':00' as DataCutOff
      ,[Logistica].[dbo].[VettoriOrari].[ErpVettoreId]
	  ,[Logistica].[dbo].[Ordini].[ClienteId]
	  ,[Logistica].[dbo].[Operatori].[Cognome] + ' ' +[Logistica].[dbo].[Operatori].[Nome] as Operatore
	  ,format([Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita],'yyyyMMdd')+str([Logistica].[dbo].[_LogAttivitaOperatori].[OperatoreKey])+str([Logistica].[dbo].[_LogAttivitaOperatori].[UnitaCaricoKey])+ [Logistica].[dbo].[_LogAttivitaOperatori].[ArticoloKey] as 'Rigedis'
	  ,format([Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita],'yyyyMMdd')+str([Logistica].[dbo].[_LogAttivitaOperatori].[OperatoreKey])+str( [Logistica].[dbo].[_LogAttivitaOperatori].[UnitaCaricoKey])+ [Logistica].[dbo].[_LogAttivitaOperatori].[ArticoloKey] as 'Rigepos'
	  ,format([Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita],'yyyyMMdd')+str([Logistica].[dbo].[_LogAttivitaOperatori].[OperatoreKey])+str( [Logistica].[dbo].[_LogAttivitaOperatori].[DettaglioKey]) as 'Rigepre'
	  ,format([Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita],'yyyyMMdd')+str([Logistica].[dbo].[_LogAttivitaOperatori].[OperatoreKey])+ [Logistica].[dbo].[_LogAttivitaOperatori].[ColloKey] as 'Rigeimb'

	  ,'Maddaloni' as Magazzino

  FROM [Logistica].[dbo].[_LogAttivitaOperatori]
  left join [Logistica].[dbo].[Operatori] on [Logistica].[dbo].[_LogAttivitaOperatori].[OperatoreKey]=[Logistica].[dbo].[Operatori].[Id]
  left join [Logistica].[dbo].[OrdiniDettagli] on [Logistica].[dbo].[_LogAttivitaOperatori].[DettaglioKey]=[Logistica].[dbo].[OrdiniDettagli].id
  left join [Logistica].[dbo].[Articoli] on [Logistica].[dbo].[OrdiniDettagli].[ArticoloId]=[Logistica].[dbo].[Articoli].[Id]
  left join [Logistica].[dbo].[Ordini] on [Logistica].[dbo].[Ordini].[Id]=[Logistica].[dbo].[OrdiniDettagli].[OrdineId]
  left join [Logistica].[dbo].[VettoriOrari] on [Logistica].[dbo].[VettoriOrari].[Id] = [Logistica].[dbo].[Ordini].[VettoreOrarioId]
  where [Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita]<=GETDATE()+1 and 
   [Logistica].[dbo].[_LogAttivitaOperatori].[DataAttivita]>GETDATE() ;
   


   

