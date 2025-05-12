DROP TABLE opper.dbo.IDIR_ScorteMinMax;

CREATE TABLE opper.dbo.IDIR_ScorteMinMax
(
	ID_KEY bigint IDENTITY(1,1),
	ARTICOLO_ID [bigint] NULL,
	ID_MAGAZZINO [bigint] NULL,
	SCORTA_MIN_CALCOLATA [bigint] NULL,
	SCORTA_MAX_CALCOLATA [bigint] NULL
);

INSERT INTO opper.dbo.IDIR_ScorteMinMax
(  
)
SELECT	ArticoliID as ARTICOLO_ID,
		MagazziniID as ID_MAGAZZINO,
		ScortaMinimaCalcolata as SCORTA_MIN_CALCOLATA,
		ScortaMaxCalcolata as SCORTA_MAX_CALCOLATA
FROM Vision.dbo.ArticoliMagazzino
