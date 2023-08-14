CREATE PROCEDURE [dbo].[_prGatePassUpdate]
(
 @GatePass BIGINT,
 @Employee bigint
,@RequestDate DateTime
,@Reason nvarchar(MAX)
,@Approver nvarchar(100)
,@Status nvarchar(20)
,@TimeFrom DateTime
,@TimeTo DateTime 
,@UpdatedBy bigint
,@CreatedBy bigint

)
AS
BEGIN

UPDATE [dbo].[GatePass] SET
[Employee] = @Employee
,[RequestDate] = @RequestDate
,[Reason] = @Reason
,[Approver] = @Approver
,[Status] = @Status
,[TimeFrom] = @TimeFrom
,[TimeTo] = @TimeTo
,[UpdatedBy] = @UpdatedBy
,[UpdatedOn] = GETDATE()

WHERE GatePass = @GatePass and IsDeleted=0

END




GO
-------------------------------------------------------------13/07/2023----------------------


GO
create TABLE [dbo].[OrganizationLocation]
ADD Latitude NVARCHAR(50) NULL,
Longitude NVARCHAR(50) NULL



GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationInsert]    Script Date: 7/13/2023 11:33:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[_prOrganizationLocationInsert]

@Location nvarchar (500),
@AddressLine1 nvarchar (500),
@AddressLine2 nvarchar (500),
@Country bigint ,
@State nvarchar (120),
@Region bigint,
@City nvarchar (120),
@ZipCode nvarchar (11),
@LocationStartDate date,
@LocationEndDate date,
@Latitude nvarchar(50),
@Longitude nvarchar(50),
@CreatedBy bigint


AS BEGIN

INSERT INTO OrganizationLocation
(
Location,
AddressLine1,
AddressLine2,
Country,
State,
Region ,
City,
ZipCode,
LocationStartDate,
LocationEndDate,
Latitude,
Longitude,
IsDeleted,
CreatedBy,
UpdatedBy,
CreatedOn,
UpdatedOn


)
values
(
@Location,
@AddressLine1 ,
@AddressLine2 ,
@Country ,
@State ,
@Region ,
@City ,
@ZipCode ,
@LocationStartDate,
@LocationEndDate,
@Latitude,
@Longitude,
0 ,
@CreatedBy ,
null ,
null ,
null

)

RETURN SCOPE_IDENTITY()
end





GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationUpdate]    Script Date: 7/13/2023 11:36:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[_prOrganizationLocationUpdate]
(
@OrganizationLocation bigint,
@Location nvarchar (500),
@AddressLine1 nvarchar (500),
@AddressLine2 nvarchar (500),
@Country bigint  ,
@State nvarchar (120),
@Region bigint,
@City nvarchar (120),
@ZipCode nvarchar (11),
@LocationStartDate date,
@LocationEndDate date,
@Latitude nvarchar(50),
@Longitude nvarchar(50),
@CreatedBy bigint,
@UpdatedBy bigint

)

AS BEGIN

UPDATE  OrganizationLocation set
Location = @Location,
AddressLine1=@AddressLine1,
AddressLine2=@AddressLine2,
Country=@Country,
State=@State,
Region=@Region,
City=@City,
ZipCode=@ZipCode,
LocationStartDate=@LocationStartDate,
LocationEndDate=@LocationEndDate,
Latitude = @Latitude,
Longitude = @Longitude,
UpdatedBy =@UpdatedBy,
CreatedOn =null,
UpdatedOn =@UpdatedBy
WHERE OrganizationLocation = @OrganizationLocation

END




GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationFetch]    Script Date: 7/13/2023 11:58:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[_prOrganizationLocationFetch] --58
(
   @OrganizationLocation   bigint
)
As
BEGIN
Select
       O.OrganizationLocation,
	   O.Location,
       O.AddressLine1,
       O.AddressLine2, 
	   c.Country,
	   c.CountryName,
	   O.State,
	   O.City,
	   O.ZipCode,
	   O.LocationStartDate,
	   O.LocationEndDate,
	   O.Latitude,
	   O.Longitude,
	   O.IsDeleted,
	   O.CreatedBy,
	   O.UpdatedBy,
	   O.CreatedOn,
	   O.UpdatedOn,
	   R.Region,
	   R.RegionName
FROM
   OrganizationLocation O
   left join Region R on R.Region = O.Region and R.IsDeleted=0
   left join Country c on c.Country=o.Country 
WHERE
   OrganizationLocation = @OrganizationLocation and O.IsDeleted=0

Select olt.*, lt.LocationType, lt.LocationTypeName From LocationType lt 
JOIN OrganizationLocationtype olt on olt.LocationType = lt.LocationType and olt.IsDeleted = 0 and olt.OrganizationLocation = @OrganizationLocation
WHERE lt.IsDeleted  = 0

END

 

GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationFetchAll]    Script Date: 7/13/2023 11:59:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[_prOrganizationLocationFetchAll]

 as
 begin
 select
 O.OrganizationLocation,
	   O.Location,
       O.AddressLine1,
       O.AddressLine2, 
	    c.CountryName Country,
	   O.State,
	   O.City,
	   O.ZipCode,
	   O.LocationStartDate,
	   O.LocationEndDate,
	   O.Latitude,
	   O.Longitude,
	   (AddressLine1 +' '+ AddressLine2 + ', '+ City + ' '+ State + ' '+ ZipCode+ ' '+ c.CountryName) Address,
	   O.IsDeleted,
	   O.CreatedBy,
	   O.UpdatedBy,
	   O.CreatedOn,
	   O.UpdatedOn,
	   R.Region,
	   R.RegionName
	  
	   
FROM
   OrganizationLocation O
   left join Region R on R.Region = O.Region and R.IsDeleted=0
   inner join Country c on c.Country=o.Country 
   
WHERE
   O.IsDeleted=0

 end

 



 
GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationInsert]    Script Date: 7/13/2023 11:33:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[prOrganizationLocationInsert]

@Location nvarchar (500),
@AddressLine1 nvarchar (500),
@AddressLine2 nvarchar (500),
@Country bigint ,
@State nvarchar (120),
@Region bigint,
@City nvarchar (120),
@ZipCode nvarchar (11),
@LocationStartDate date,
@LocationEndDate date,
@Latitude nvarchar(50),
@Longitude nvarchar(50),
@CreatedBy bigint




AS BEGIN

INSERT INTO OrganizationLocation
(
Location,
AddressLine1,
AddressLine2,
Country,
State,
Region ,
City,
ZipCode,
LocationStartDate,
LocationEndDate,
Latitude,
Longitude,
IsDeleted,
CreatedBy,
UpdatedBy,
CreatedOn,
UpdatedOn


)
values
(
@Location,
@AddressLine1 ,
@AddressLine2 ,
@Country ,
@State ,
@Region ,
@City ,
@ZipCode ,
@LocationStartDate,
@LocationEndDate,
@Latitude,
@Longitude,
0 ,
@CreatedBy ,
null ,
null ,
null

)

RETURN SCOPE_IDENTITY()
end




GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationFetch]    Script Date: 7/13/2023 11:58:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Proc [dbo].[prOrganizationLocationFetch] --58
(
   @OrganizationLocation   bigint
)
As
BEGIN
Select
       O.OrganizationLocation,
	   O.Location,
       O.AddressLine1,
       O.AddressLine2, 
	   c.Country,
	   c.CountryName,
	   O.State,
	   O.City,
	   O.ZipCode,
	   O.LocationStartDate,
	   O.LocationEndDate,
	   O.Latitude,
	   O.Longitude,
	   O.IsDeleted,
	   O.CreatedBy,
	   O.UpdatedBy,
	   O.CreatedOn,
	   O.UpdatedOn,
	   R.Region,
	   R.RegionName
FROM
   OrganizationLocation O
   left join Region R on R.Region = O.Region and R.IsDeleted=0
   left join Country c on c.Country=o.Country 
WHERE
   OrganizationLocation = @OrganizationLocation and O.IsDeleted=0

Select olt.*, lt.LocationType, lt.LocationTypeName From LocationType lt 
JOIN OrganizationLocationtype olt on olt.LocationType = lt.LocationType and olt.IsDeleted = 0 and olt.OrganizationLocation = @OrganizationLocation
WHERE lt.IsDeleted  = 0

END

 

GO
/****** Object:  StoredProcedure [dbo].[prOrganizationLocationFetchAll]    Script Date: 7/13/2023 11:59:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Proc [dbo].[prOrganizationLocationFetchAll]

 as
 begin
 select
 O.OrganizationLocation,
	   O.Location,
       O.AddressLine1,
       O.AddressLine2, 
	    c.CountryName Country,
	   O.State,
	   O.City,
	   O.ZipCode,
	   O.LocationStartDate,
	   O.LocationEndDate,
	   O.Latitude,
	   O.Longitude,
	   (AddressLine1 +' '+ AddressLine2 + ', '+ City + ' '+ State + ' '+ ZipCode+ ' '+ c.CountryName) Address,
	   O.IsDeleted,
	   O.CreatedBy,
	   O.UpdatedBy,
	   O.CreatedOn,
	   O.UpdatedOn,
	   R.Region,
	   R.RegionName
	  
	   
FROM
   OrganizationLocation O
   left join Region R on R.Region = O.Region and R.IsDeleted=0
   inner join Country c on c.Country=o.Country 
   
WHERE
   O.IsDeleted=0

 end

 

 ----------------------------------------Gate pass issues--------------------------

 
GO
/****** Object:  StoredProcedure [dbo].[_prGatePassFetchByApprover]    Script Date: 7/13/2023 2:44:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object: StoredProcedure [dbo].[Announcements] Script Date: 09/28/2013 10:41:32 ******/

create PROC  [dbo].[_prGatePassFetchByApprover]-- 20287
(
@Approver bigint
)
AS
BEGIN

SELECT
     [GatePass]
	,g.[Employee]
	,[RequestDate]
	,[Reason]
	,[Approver]
	,[Status]
	,u.FirstName + ' ' + u.LastName as  FullName,
	CONVERT(date, RequestDate) [Date]
	,FORMAT(DATEADD(mi, 0, TimeFrom), 'hh:mm tt')[TimeFrom]
	,FORMAT(DATEADD(mi, 0, TimeTo), 'hh:mm tt')[TimeTo]
	,g.CreatedBy
	,g.UpdatedBy
	,g.DeletedBy
	,g.CreatedOn
	,g.UpdatedOn
	,g.DeletedOn
	,g.IsDeleted



FROM 
GatePass  g
INNER JOIN Employee e on e.Employee = g.Employee
 INNER JOIN USERS u on u.Users = e.Users 
 
where
g.Approver = @Approver
and
ISNULL(g.IsDeleted,0) !=1 and Status='Pending'

End





GO
/****** Object:  StoredProcedure [dbo].[prDocumentAssignmentFetchHeaderNotificationCount]    Script Date: 7/13/2023 2:26:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[prDocumentAssignmentFetchHeaderNotificationCount]-- 20474,'Weekly'
(
    @Employee bigint,
    @TimeSheetType Nvarchar(100)
)

 

AS
BEGIN

 

Declare @Users bigint
Set @Users = ( Select Users from employee (nolock) where Employee=@Employee)
DECLARE @LeaveLevelSetting INT = ISNULL((Select Top 1 LeaveLevel From Organization), 0)

 

Declare @PendingPoliciesCount  int = (Select Count(1)  from DocumentAssignment (nolock) da 
JOIN DocumentManager (nolock) dm ON dm.DocumentManager = da.DocumentManager AND dm.IsDeleted = 0 
Where AssignedToEmployee = @Employee AND da.IsDeleted = 0 and Responded=0 and DueDate >= GETDATE())

 

Declare @PendingTimesheetCount int = (select Count(1) from timesheet (nolock) ts
JOIN TimeSheetDetails (nolock) td on ts.TimeSheet = td.TimeSheet and td.IsDeleted = 0
JOIN Employee (nolock) em on ts.Employee = em.Employee and em.IsDeleted = 0
JOIN Users (nolock) us on em.Users = us.Users and us.IsDeleted = 0  --and us.ReportingTo = @Users
where (ts.Status = 'Sent') and ts.IsDeleted = 0 and ts.TimeSheetType=@TimeSheetType --group by ts.TimeSheet, ts.Employee, ts.Status, ts.PayRollWeek, ts.Approver, us.FirstName, us.LastName 
 and (
(us.ReportingTo = @Users and ts.AltApprover = @Users) OR 
(ts.AltApprover IS NULL and us.ReportingTo = @Users) OR
(ts.AltApprover = @Users and us.ReportingTo != @Users)
) )

 

Declare @AttendanceCount int = (Select count(1) from
(
SELECT  distinct ar.AttendanceRequests
From AttendanceRequests (nolock) ar
inner join Attendance (nolock) a on a.AttendanceRequests= ar.AttendanceRequests and a.IsDeleted=0
inner join AttendanceStatus (nolock) ats on ats.AttendanceStatus = ar.RequestType and ats.Status NOT IN ('Present', 'Extra Day', 'Extra Day Half')


 Where
(ar.ApproverId = CONVERT(varchar(10), @Users) or ApproverId like '%,'+CONVERT(varchar(10), @Users) or ApproverId like CONVERT(varchar(10), @Users)+',%'  or ApproverId like '%,'+CONVERT(varchar(10), @Users)+',%') and ar.Status = 'Pending' and ar.IsDeleted=0 
 and YEAR(StartDate) >= Year(GetDate()-15)
 )a)

 Declare @ExtraDayCount int = (Select count(1) from
(
SELECT distinct ar.AttendanceRequests
From AttendanceRequests (nolock) ar
inner join Attendance (nolock) a on a.AttendanceRequests= ar.AttendanceRequests and a.IsDeleted=0 and ( ExtraDay Is NULL OR ExtraDay =0)
inner join AttendanceStatus (nolock) ats on ats.AttendanceStatus = ar.ExtraDay and ats.Status IN ('Extra Day', 'Extra Day Half')
Where
(ar.ApproverId = CONVERT(varchar(10), @Users) or ApproverId like '%,'+CONVERT(varchar(10), @Users) or ApproverId like CONVERT(varchar(10), @Users)+',%' or ApproverId like '%,'+CONVERT(varchar(10), @Users)+',%') and ar.Status = 'Pending' 
and ar.IsDeleted=0  and YEAR(StartDate) >= Year(GetDate()-15)
)a)

 

 Declare @LeaveCount int = (Select count(1) from
(
SELECT  distinct ar.LeaveRequests
From LeaveRequests (nolock) ar
inner join EmployeeLeaveDetails (nolock) a on a.LeaveRequests= ar.LeaveRequests and a.IsDeleted=0
Join ShortLeaveType slt on slt.ShortLeaveType = a.ShortLeaveType
inner join LeaveType (nolock) lt on lt.LeaveType=ar.LeaveType
 Where
 (ar.ApproverId = CONVERT(varchar(10), @Users) or ApproverId like '%,'+CONVERT(varchar(10), @Users) or ApproverId like CONVERT(varchar(10), @Users)+',%'  
 or ApproverId like '%,'+CONVERT(varchar(10), @Users)+',%') and ar.Status = '0' and ar.IsDeleted=0 
 )a)

  Declare @LeaveLevelCount int = 0
  
  IF @LeaveLevelSetting = 1
BEGIN
 SET @LeaveLevelCount =  (Select count(1) from
(
SELECT  distinct ar.LeaveRequests
From LeaveRequests (nolock) ar
inner join EmployeeLeaveDetails (nolock) a on a.LeaveRequests= ar.LeaveRequests and a.IsDeleted=0
inner join LeaveType (nolock) lt on lt.LeaveType=ar.LeaveType
 Where
 (ar.ApproverId = CONVERT(varchar(10), @Users) or ApproverId like '%,'+CONVERT(varchar(10), @Users) or ApproverId like CONVERT(varchar(10), @Users)+',%' 
  or ApproverId like '%,'+CONVERT(varchar(10), @Users)+',%') and ar.MANAGERSTATUS = '0' and ar.Status != 0 and ar.IsDeleted=0 
 )a)
 END
 Declare @ExpenseCount int =(SELECT count(1)
FROM Employee e 
    join Expense ex on e.Employee = ex.Employee 
    join Users u on e.Users=u.Users and u.IsDeleted=0
    Where  ((u.ReportingTo=@Users AND AltApprover IS NULL) OR AltApprover = @Users) 
	AND ((ex.Flag=1 AND Status != 'Approved' AND Status != 'Rejected' and Status != 'Processed' and ex.IsDeleted = 0)  OR (ex.Flag=1 AND Status is null and ex.IsDeleted = 0))
	)
  
Declare @PayrollCount int = (select Count(1)
from ProcessPayroll (nolock) pr
JOIN Employee (nolock) em on pr.PayrollApprovedBy = em.Employee and em.IsDeleted = 0 
JOIN Users (nolock) us on em.Users = us.Users and us.IsDeleted = 0  and us.Users = @Users
where pr.Status = 'Sent'  )


Declare @GatePassCount int = (select Count(1)
from GatePass (nolock) gp
--JOIN Employee (nolock) em on gp.Employee = em.Employee and em.IsDeleted = 0 
JOIN Users (nolock) us on us.Users = gp.Approver and us.IsDeleted = 0  and us.Users = @Users
where gp.Status = 'Pending'  )


Declare @EmployeeDocumentsCount int=(select COUNT (1 ) from DocumentManager (nolock)docs 
	where docs.Employee =@Employee 
	and docs.IsDeleted=0 
	and (docs.DocumentType='EmployeeDocuments' OR docs.DocumentType = 'EmployeeFundsDocument'))  


 Declare @ReviewCount int = (Select count(1) from 

--select * from EmployeePerformanceReview (nolock) ar 
  PerformanceReviewDetail pd
join PerformanceReview ppr on ppr.PerformanceReview=pd.PerformanceReview and ppr.IsDeleted = 0
left join ExternalUsers ext on ext.ExternalUsers = ppr.ReviewerID
left join EmployeePerformanceReview pr on pd.EmployeePerformanceReview=pr.EmployeePerformanceReview
 
Where 
 (pr.Manager = CONVERT(varchar(10), @Users) or Manager like '%,'+CONVERT(varchar(10), @Users) or Manager like CONVERT(varchar(10), @Users)+',%'  or Manager like '%,'+CONVERT(varchar(10), @Users)+',%') 
 and (pr.IsComplete is null or pr.IsComplete=0) and (pr.IsAcknowledged is null or pr.IsAcknowledged=0) and (pr.IsReviewComplete is null or pr.IsReviewComplete=0)

 )
 

Declare @EmployeeAddressCount int=(select COUNT (1 ) from Address (nolock)docs where docs.Employee =@Employee and docs.IsDeleted=0) 
Declare @EmployeeDependentCount int=(select COUNT (1 ) from Dependent (nolock)docs where docs.Employee =@Employee and docs.IsDeleted=0) 
SELECT  @AttendanceCount+ISNULL(@ExtraDayCount,0) RequestCount, @LeaveCount + ISNULL(@LeaveLevelCount, 0) LeaveRequestCount, @PendingPoliciesCount PolicyCount, @PendingTimesheetCount TimeSheetCount
, @ExpenseCount ExpenseCount, @PayrollCount ProcessPayrollCount,@EmployeeDocumentsCount  EmployeeDocumentsCount,@EmployeeAddressCount  EmployeeAddressCount,
@EmployeeDependentCount  EmployeeDependentCount,@ReviewCount ReviewCount, @GatePassCount GatePassCount

 

END



GO
/****** Object:  StoredProcedure [dbo].[_prGatePassUpdateStatus]    Script Date: 7/13/2023 5:47:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ============================================= drop _prCafeProductsAndCategorieInsert  
create PROCEDURE [dbo].[_prGatePassUpdateStatus] --'1,2' , 'Approved', 'test'
      @Gatepass Nvarchar(Max)
	,@Status NVARCHAR(50)
	,@ReasonOfRejection NVARCHAR(MAX)
AS
BEGIN
	UPDATE GatePass
	SET STATUS = @Status
		,ReasonForRejection = @ReasonOfRejection
	WHERE GatePass IN (
					SELECT part
					FROM SplitString(@Gatepass, ',')
					)  
END




GO
/****** Object:  StoredProcedure [dbo].[_prGatePassFetchByApprover]    Script Date: 7/21/2023 5:38:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object: StoredProcedure [dbo].[Announcements] Script Date: 09/28/2013 10:41:32 ******/

create PROC  [dbo].[_prGatePassFetchByApprover] --10197
(
@Approver bigint
)
AS
BEGIN

SELECT
     [GatePass]
	,g.[Employee]
	,[RequestDate]
	,[Reason]
	,[Approver]
	,[Status]
	,u.FirstName + ' ' + u.LastName as  FullName,
	CONVERT(date, RequestDate) [Date]
	,FORMAT(DATEADD(mi, 0, TimeFrom), 'hh:mm tt')[TimeFrom]
	,FORMAT(DATEADD(mi, 0, TimeTo), 'hh:mm tt')[TimeTo]
	,g.CreatedBy
	,g.UpdatedBy
	,g.DeletedBy
	,g.CreatedOn
	,g.UpdatedOn
	,g.DeletedOn
	,g.IsDeleted



FROM 
GatePass  g
INNER JOIN Employee e on e.Employee = g.Employee
 INNER JOIN USERS u on u.Users = e.Users 
 
where
g.Approver = @Approver
and
ISNULL(g.IsDeleted,0) !=1 and Status='Pending'
order by g.Employee desc
End

















		

	







