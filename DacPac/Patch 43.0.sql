GO
/****** Object:  StoredProcedure [dbo].[_prEmployeeLeaveTypesFetchEmployeeLeaveTypesByEmployee]    Script Date: 23-06-2023 16:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--     [dbo].[_prEmployeeLeaveTypesFetchEmployeeLeaveTypesByEmployee]10384, '2023-01-01','2023-12-31'

ALTER PROCEDURE [dbo].[_prEmployeeLeaveTypesFetchEmployeeLeaveTypesByEmployee]--30505, '2020-04-01','2021-03-31',0
    (
    @Employee BIGINT
    ,@StartDate DatetIme,
    @EndDate DateTime

 

    )
AS
BEGIN
DECLARE @CompOffLeave Nvarchar(10) = 
(SELECT answer FROM RuleValues rv INNER JOIN Rules r ON r.Rules = rv.Rules
 WHERE RuleNameId = 'Q5_C1')

 

DECLARE @ExemptedEmployeeCompOff Nvarchar(MAX) = 
(SELECT answer FROM RuleValues rv INNER JOIN Rules r ON r.Rules = rv.Rules 
WHERE RuleNameId = 'ExemptedEmployeeCompOff')

 

DECLARE @TotalDays INT = 
(SELECT answer
        FROM RuleValues rv
        INNER JOIN Rules r ON r.Rules = rv.Rules
        WHERE RuleNameId = 'Q5_T1')

 

DECLARE @Consumed int =(SELECT CAST(ISNULL(SUM(LeaveDays), 0) AS FLOAT) FROM EmployeeLeaveDetails(NOLOCK) a
     INNER JOIN LeaveType(NOLOCK) ats ON ats.LeaveType = a.LeaveType
     WHERE ats.LeaveType = (SELECT TOP 1 leavetype FROM leavetype WHERE [type] = 'COM')
       AND a.Employee = @Employee
       AND StartDate BETWEEN @StartDate AND @EndDate
       AND a.IsDeleted = 0)

 

DECLARE @Datestbl TABLE (
    startdate date
)

 


INSERT INTO @Datestbl (startdate)  
select DATEADD(day,@TotalDays, startdate) as startdate from AttendanceRequests
WHERE Employeeid = @Employee
    AND ExtraDay IN (
        SELECT attendancestatus
        FROM attendancestatus
        WHERE startdate >= (SELECT OrganizationFinanceStartDate
                                             FROM organization) and attendancecode IN ('ED', 'EDH')
    )
    AND Status = 'approved' and startdate < CAST(GETDATE() AS date)
except
select top( @Consumed) DATEADD(day,@TotalDays, startdate) as startdate from AttendanceRequests


WHERE Employeeid = @Employee
    AND ExtraDay IN (
        SELECT attendancestatus
        FROM attendancestatus
        WHERE startdate >= (SELECT OrganizationFinanceStartDate
                                             FROM organization) and attendancecode IN ('ED', 'EDH')
    )
    AND Status = 'approved' and startdate < CAST(GETDATE() AS date)

 

     


 

    
        SELECT elt.[EmployeeLeaveTypes]
            --,elt.[Employee]
            ,Cast(elt.[Quota] as Nvarchar(10))Quota

            ,elt.[IsDeleted]
            ,elt.[LeaveType]
            ,elt.LeavesForYear
            ,lt.LeaveTypeName AS LeaveName
            ,lt.LeaveTypeName   AS LeaveTypeName 
            ,(
                CONVERT(VARCHAR(10), +(SELECT Cast(isnull(Sum(LeaveDays), 0) as float)
                FROM EmployeeLeaveDetails a
                INNER JOIN LeaveType ats ON ats.LeaveType = a.LeaveType
                WHERE ats.LeaveType = lt.LeaveType
                    AND Employee = @Employee
                    AND StartDate Between @StartDate and @EndDate  and a.IsDeleted=0
                ))) AS Consumed
            ,

 

            CASE
    WHEN (@CompOffLeave = 'True' and lt.Type = 'COM' AND Cast(@Employee AS NVARCHAR(100)) NOT IN (
                            SELECT part
                            FROM SplitString(@ExemptedEmployeeCompOff, ',')
                            )) THEN 
    case when elt.Quota > (
    (SELECT COUNT(startdate)
     FROM @Datestbl where startdate < cast(getdate() as date)
     )
    +
    (SELECT CAST(ISNULL(SUM(LeaveDays), 0) AS FLOAT)
     FROM EmployeeLeaveDetails (NOLOCK) a
     INNER JOIN LeaveType (NOLOCK) ats ON ats.LeaveType = a.LeaveType
     WHERE ats.LeaveType = lt.LeaveType
       AND a.Employee = @Employee
       AND StartDate BETWEEN @StartDate and @EndDate
       AND a.IsDeleted = 0)
    )
    then
    (elt.Quota - (
    (SELECT COUNT(startdate)
     FROM @Datestbl where startdate < cast(getdate() as date)
     )
    +
    (SELECT CAST(ISNULL(SUM(LeaveDays), 0) AS FLOAT)
     FROM EmployeeLeaveDetails (NOLOCK) a
     INNER JOIN LeaveType (NOLOCK) ats ON ats.LeaveType = a.LeaveType
     WHERE ats.LeaveType = lt.LeaveType
       AND a.Employee = @Employee
       AND StartDate BETWEEN @StartDate and @EndDate
       AND a.IsDeleted = 0)
    )
    )
    else 0 end


    ELSE ( elt.Quota - (
                    SELECT CAST(isnull(Sum(LeaveDays), 0) as Float)
                    FROM EmployeeLeaveDetails(NOLOCK) a
                    INNER JOIN LeaveType(NOLOCK) ats ON ats.LeaveType = a.LeaveType
                    WHERE ats.LeaveType = lt.LeaveType
                        AND a.Employee = @Employee
                        AND StartDate Between @StartDate and @EndDate  and a.IsDeleted=0
                    )
                ) 
END as  Available


 

                ,(Select Sum(Quota) from EmployeeLeaveTypes eelt Where eelt.Employee = @Employee AND eelt.StartDate = @StartDate and Enddate > GetDate() )TotalLeaveQuota 

                ,(SELECT CAST(isnull(Sum(LeaveDays), 0) as Float)
                    FROM EmployeeLeaveDetails(NOLOCK) a
                    --INNER JOIN LeaveType(NOLOCK) ats ON ats.LeaveType = a.LeaveType
                    WHERE 
                         a.Employee = @Employee
                        AND StartDate Between @StartDate and @EndDate  and a.IsDeleted=0) TotalConsumedQuota

 

                ,(Select Sum(Quota)-
                (SELECT CAST(isnull(Sum(LeaveDays), 0) as Float)
                    FROM EmployeeLeaveDetails(NOLOCK) a
                    --INNER JOIN LeaveType(NOLOCK) ats ON ats.LeaveType = a.LeaveType
                    WHERE 
                         a.Employee = @Employee
                        AND StartDate Between @StartDate and @EndDate  and a.IsDeleted=0)
                from EmployeeLeaveTypes eelt Where eelt.Employee = @Employee AND eelt.StartDate = @StartDate and Enddate > GetDate() )TotalAvailableQuota

 

 


                ,(SELECT cast(isnull(DATEDIFF(MINUTE, OfficeTimingTimeFrom, OfficeTimingTimeTo)/60,0) as float) FROM Users(NOLOCK) u
                    JOIN OfficeTiming(NOLOCK) ot ON ot.OfficeTiming = u.[Shift]
                    JOIN Employee(NOLOCK) e ON e.Users = u.Users AND e.Employee = @Employee) as TotalWorkingHours

 

        FROM EmployeeLeaveTypes elt
        JOIN LeaveType lt ON lt.LeaveType = elt.LeaveType
        WHERE elt.Employee = @Employee

            AND elt.StartDate = @StartDate and Enddate > GetDate()
    END

 
