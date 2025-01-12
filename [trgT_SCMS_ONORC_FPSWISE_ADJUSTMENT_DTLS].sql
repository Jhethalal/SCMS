USE [SCMS02]
GO
/****** Object:  Trigger [dbo].[trgT_SCMS_ONORC_FPSWISE_ADJUSTMENT_DTLS]    Script Date: 2023-07-12 11:02:25.337 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================================
/*
       CREATED BY RAHUL KUMAR [01-3101] ON 2023-07-12 10:51:33

	   -- PRODUCTION SCHEMA : AuditSCMS02

	      DEPENDENCY GRAPH
		  1.T_SCMS_ONORC_FPWISE_ADJUSTMENT_DTLS_TransactionLog        TABLE OF [SCMS02]  DATABASE
		  2.T_SCMS_ONORC_FPSWISE_ADJUSTMENT_DTLS                      TABLE OF [SCMS02]  DATABASE

		  TRIGGER INFORMATION
		  1.trgT_SCMS_ONORC_FPSWISE_ADJUSTMENT_DTLS          [SCMS02] DATABASE

		  DDL STATEMENT
		  CREATE TABLE T_SCMS_ONORC_FPWISE_ADJUSTMENT_DTLS_TransactionLog
          (
			  RecordNumber BIGINT PRIMARY KEY IDENTITY(1,1),
			  INT_ID INT ,
			  ACTUAL_ALLOTMENT_PRE     DECIMAL(18,2) NULL,
			  ACTUAL_ALLOTMENT_CURR    DECIMAL(18,2) NULL,

			  ALLOTMENT_QTY_PRE        DECIMAL(18,2) NULL,
			  ALLOTMENT_QTY_CURR       DECIMAL(18,2) NULL,

			  BUFFER_QTY_PRE           DECIMAL(18,2) NULL,
			  BUFFER_QTY_CURR          DECIMAL(18,2) NULL,

			  APPROVED_QTY_PRE         DECIMAL(18,2) NULL,
			  APPORVED_QTY_CURR        DECIMAL(18,2) NULL,

			  PREVIOUS_APPROVED_QTY_PRE  DECIMAL(18,2) NULL,
			  PREVIOUS_APPROVED_QTY_CURR DECIMAL(18,2) NULL,

			  LAST_UPDATED_DATE   DATETIME,

			  ADJUSTED_QTY_PRE          DECIMAL(18,2) NULL,
			  ADJUSTED_QTY_CURR         DECIMAL(18,2) NULL,

			  PENDING_ADJUSTED_QTY_PRE DECIMAL(18,2) NULL,
			  PENDING_ADJUSTED_QTY_CURR DECIMAL(18,2) NULL,

			  RecordCreatedOn DATETIME DEFAULT GETDATE()
)
--------------------------------------------PRIVILEGE TO BE GRANTED	
	USE [SCMS02]
	GO

	GRANT INSERT ON [dbo].[T_SCMS_ONORC_FPWISE_ADJUSTMENT_DTLS_TransactionLog] TO [ppas]


	GRANT SELECT ON [dbo].[T_SCMS_ONORC_FPWISE_ADJUSTMENT_DTLS_TransactionLog] TO [ppas]
	GO
	
	DROP TRIGGER [trgT_SCMS_ONORC_FPSWISE_ADJUSTMENT_DTLS];
*/
-- ============================================================================================================
ALTER TRIGGER [dbo].[trgT_SCMS_ONORC_FPSWISE_ADJUSTMENT_DTLS]
ON [dbo].[T_SCMS_ONORC_FPSWISE_ADJUSTMENT_DTLS]
FOR UPDATE

AS

BEGIN
     SET NOCOUNT ON;
	 
	    DECLARE @ActualUpdateStatus BIT = 0; -- ADDED ON 2023-07-12 11:02:25.337 BY RAHUL KUMAR [01-3101]

		 IF (UPDATE(ACTUAL_ALLOTMENT) OR UPDATE(ALLOTMENT_QTY) OR UPDATE(BUFFER_QTY) OR UPDATE(APPROVED_QTY) OR UPDATE(PREVIOUS_APPROVED_QTY) 
		      OR UPDATE(ADJUSTED_QTY) OR UPDATE(PENDING_ADJUSTED_QTY))

	     BEGIN
		 --[ ADDED ON 2023-07-12 11:02:25.337 BY RAHUL KUMAR [01-3101] TO TRACK FALSE UPDATE STATEMENT

		   SELECT @ActualUpdateStatus = 1
		   FROM deleted D
		   JOIN 
		   inserted I
		   ON D.INT_ID = I.INT_ID
		   AND
		      (
                  I.ACTUAL_ALLOTMENT <> D.ACTUAL_ALLOTMENT OR
				  I.ALLOTMENT_QTY <> D.ALLOTMENT_QTY OR
				  I.BUFFER_QTY <> D.BUFFER_QTY OR
				  I.APPROVED_QTY <> D.APPROVED_QTY OR 
				  I.PREVIOUS_APPROVED_QTY <> D.PREVIOUS_APPROVED_QTY OR
				  I.ADJUSTED_QTY <> D.ADJUSTED_QTY OR
				  I.PENDING_ADJUSTED_QTY <> D.PENDING_ADJUSTED_QTY
			  );
			  
             IF @ActualUpdateStatus = 1
			 BEGIN

			       INSERT INTO T_SCMS_ONORC_FPWISE_ADJUSTMENT_DTLS_TransactionLog
				     (
					    [INT_ID],

						[ACTUAL_ALLOTMENT_PRE],
						[ACTUAL_ALLOTMENT_CURR],

						[ALLOTMENT_QTY_PRE],
						[ALLOTMENT_QTY_CURR],

						[BUFFER_QTY_PRE],
						[BUFFER_QTY_CURR],

						[APPROVED_QTY_PRE],
						[APPORVED_QTY_CURR],

						[PREVIOUS_APPROVED_QTY_PRE],
						[PREVIOUS_APPROVED_QTY_CURR],

						[LAST_UPDATED_DATE],

						[ADJUSTED_QTY_PRE],
						[ADJUSTED_QTY_CURR],

						[PENDING_ADJUSTED_QTY_PRE],
						[PENDING_ADJUSTED_QTY_CURR]

					 )
					 SELECT 
					    I.[INT_ID],

						D.ACTUAL_ALLOTMENT,
						I.ACTUAL_ALLOTMENT,

						D.ALLOTMENT_QTY,
						I.ALLOTMENT_QTY,

						D.BUFFER_QTY,
						I.BUFFER_QTY,

						D.APPROVED_QTY,
						I.APPROVED_QTY,

						D.PREVIOUS_APPROVED_QTY,
						I.PREVIOUS_APPROVED_QTY,

						I.LAST_UPDATED_DATE,

						D.ADJUSTED_QTY,
						I.ADJUSTED_QTY,

						D.PENDING_ADJUSTED_QTY,
						I.PENDING_ADJUSTED_QTY

					     FROM  deleted D
						 JOIN inserted I
						 ON D.INT_ID = I.INT_ID
			 END;

        END;
END;

