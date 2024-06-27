USE SCMS02

EXECUTE  SP_HELPTEXT USP_SCMS_SYNCDCDATA
SELECT * FROM [S_SCMS_DCGENERATECAPTURETABLE]
SELECT * FROM T_SCMS_DeliveryCertificateDetails
SELECT * FROM M_SCMS_ChallanMaster
SELECT * FROM M_SCMS_LotReceive WHERE intKMS = 2023
SELECT * FROM T_SCMS_ReceiveChallanDetails
SELECT * FROM T_SCMS_ReceiveStackDetails
SELECT * FROM T_SCMS_QualityDetails
SELECT * FROM M_SCMS_QualityMaster
SELECT * FROM T_SCMS_StackTransactDetails
SELECT * FROM M_SCMS_Stock

select intBag,decQty from M_SCMS_ChallanMaster


SELECT * FROM ItemTable


SELECT IIF(intCategoryID = 1 , 'PB','RAW') FROM M_SCMS_LotReceive

--  580 bags = approx 290 Qntl

 

 

SELECT * FROM S_SCMS_DCGENERATECAPTURETABLE

SELECT * FROM S_SCMS_DCGENERATECAPTURETABLE A WITH (NOLOCK)
INNER JOIN T_SCMS_DeliveryCertificateDetails B WITH (NOLOCK) ON B.VCHDEPOTCODE=A.VCHDEPOTCODE AND B.VCHMILLERCODE=A.VCHMILLERCODE 
AND B.VCHDCNO=A.VCHDCNO AND B.INTKMS=A.INTKMS

SELECT * FROM M_SCMS_ChallanMaster WHERE intDCId IN (SELECT ID FROM T_SCMS_DeliveryCertificateDetails) 

SELECT * FROM M_SCMS_ChallanMaster A WITH (NOLOCK)
INNER JOIN T_SCMS_ReceiveChallanDetails B WITH (NOLOCK) ON B.intChallanID = A.intChallanID
INNER JOIN M_SCMS_LotReceive C WITH (NOLOCK) ON C.intReceiveID = B.intReceiveID
INNER JOIN T_SCMS_ReceiveStackDetails D WITH (NOLOCK) ON D.intReceiveID = C.intReceiveID
INNER JOIN T_SCMS_QualityDetails E WITH (NOLOCK) ON E.intReceiveID = C.intReceiveID

SELECT A.intChallanID,vchChallanNo,dtmChallanDt,C.intKMS,intProcuredDist,C.vchDepoCode,intCommodity,vchComodity,vchVehicleNo,vchDriverName,
intDCId,C.vchDCNo,C.vchLotNo,D.intBag,D.int_CreatedBy,D.dtm_CreatedOn,D.int_UpdatedBy,D.dtm_UpdatedOn,A.intBlockCode,A.intReceiveStatus,A.V FROM M_SCMS_ChallanMaster A WITH (NOLOCK)
INNER JOIN T_SCMS_ReceiveChallanDetails B WITH (NOLOCK) ON B.intChallanID = A.intChallanID
INNER JOIN M_SCMS_LotReceive C WITH (NOLOCK) ON C.intReceiveID = B.intReceiveID
INNER JOIN T_SCMS_ReceiveStackDetails D WITH (NOLOCK) ON D.intReceiveID = C.intReceiveID
INNER JOIN T_SCMS_QualityDetails E WITH (NOLOCK) ON E.intReceiveID = C.intReceiveID