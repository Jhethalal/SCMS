USE SCMS02;

/* Object: Trigger [dbo].[trgT_SCMS_FPSWISE_DISTRIBUTION_POS] Script Date: */

-- ============================================================
 /*
       CREATED BY RAHUL KUMAR [01-3101] ON 2023-07-21 15:43:53.023

	   -- PRODUCTION SCHEMA : AuditSCMS02

	      DEPENDENCY GRAPH
		  1. T_SCMS_FPSWISE_DISTRIBUTION_POS_TransactionLog      TABLE OF [SCMS02]  DATABASE
		  2. T_SCMS_FPSWISE_DISTRIBUTION_POS                     TABLE OF [SCMS02]  DATBASE

		  TRIGGER INFORMATION
		  1. trgT_SCMS_FPSWISE_DISTRIBUTION_POS       [SCMS02] DATABASE

		  DDL STATEMENT
           CREATE TABLE T_SCMS_FPSWISE_DISTRIBUTION_POS_TransactionLog
			(
			   RecordNumber INT PRIMARY KEY IDENTITY(1,1),
			   INT_ID        INT,
			   FORM_FPSCODE      VARCHAR(32) NULL,
			   TO_FPSCODE        VARCHAR(32) NULL,
			   INT_COMMODITY     INT NULL,
			   QTY_PRE           DECIMAL(18,5) NULL,
			   QTY_CURR          DECIMAL(18,5) NULL,
			   QTY_ADJUSTED_PRE  DECIMAL(18,2) NULL,
			   QTY_ADJUSTED_CURR DECIMAL(18,5) NULL,
			   INT_MONTH         INT NULL,
			   INT_YEAR          INT NULL,
			   IS_ADJUSTED_PRE   DECIMAL(18,5) NULL,
			   IS_ADJUSTED_CURR  DECIMAL(18,5) NULL,
			   RecordCreatedOn   DATETIME DEFAULT GETDATE()
			)

-----------------------------------------PRIVILEGE TO BE GRANTED
   USE [SCM02]
   GO
     
   GRANT INSERT ON [dbo].[T_SCMS_FPSWISE_DISTRIBUTION_POS_TransactionLog] TO [SCMS02]

   GRANT SELECT ON [dbo]. [T_SCMS_FPSWISE_DISTRIBUTION_POS_TransactionLog] TO [SCMS02]

   GO


   DROP TRIGGER [trgT_SCMS_FPSWISE_DISTRIBUTION_POS]




 */
-- ============================================================

ALTER TRIGGER trgT_SCMS_FPSWISE_DISTRIBUTION_POS
ON T_SCMS_FPSWISE_DISTRIBUTION_POS
FOR UPDATE

AS

BEGIN
      SET NOCOUNT ON;

	  DECLARE @ActualUpdateStatus BIT = 0; -- ADDED ON 2023-07-21 15:43:53.023 BY RAHUL KUMAR [01-3101]

	  IF (UPDATE (QTY)  OR  UPDATE(QTY_ADJUSTED)  OR UPDATE(IS_ADJUSTED))

	  BEGIN
	      --[ADDED ON 2023-07-21 15:43:53.023 BY RAHUL KUMAR [01-3101] TO TRACK FALSE UPDATE STATEMENT 
		  SELECT @ActualUpdateStatus = 1 
		  FROM DELETED D
		  JOIN INSERTED I
		  ON D.INT_ID = I.INT_ID
		  AND
		  (
		         I.QTY <> D.QTY OR
				 I.QTY_ADJUSTED <> D.QTY_ADJUSTED OR
				 I.IS_ADJUSTED <> D.IS_ADJUSTED
		  );

		  IF @ActualUpdateStatus = 1
		  BEGIN
		   
		      INSERT INTO T_SCMS_FPSWISE_DISTRIBUTION_POS_TransactionLog
			  (

			     [INT_ID],

				 [FORM_FPSCODE],
				 [TO_FPSCODE],

				 [INT_COMMODITY],
				 
				 [QTY_PRE],
				 [QTY_CURR],

				 [QTY_ADJUSTED_PRE],
				 [QTY_ADJUSTED_CURR],

				 [INT_MONTH],
				 [INT_YEAR],

				 [IS_ADJUSTED_PRE],
				 [IS_ADJUSTED_CURR]

			  )
			  SELECT 
			    
				I.[INT_ID],

				I.[FROM_FPSCODE],
				I.[TO_FPSCODE],

				I.[INT_COMMODITY],

				D.[QTY],
				I.[QTY],

				D.[QTY_ADJUSTED],
				I.[QTY_ADJUSTED],

				I.[INT_MONTH],
                I.[INT_YEAR],

				D.[IS_ADJUSTED],
				I.[IS_ADJUSTED]
			  
			   FROM deleted D
			     JOIN inserted I
				 ON D.INT_ID = I.INT_ID

		  END;

	  END;

END;

--]
