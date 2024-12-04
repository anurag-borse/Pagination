CREATE DATABASE Practise;
GO

USE Practise;
GO

CREATE TABLE Employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Details NVARCHAR(255),
    Salary INT,
    Age INT
);
GO

INSERT INTO Employees (Name, Details, Salary, Age) 
VALUES 
('John Doe', 'Software Engineer', 60000, 30),
('Jane Smith', 'HR Manager', 55000, 29),
('Michael Brown', 'Developer', 50000, 25),
('Emily Davis', 'Marketing Specialist', 45000, 28),
('Daniel Wilson', 'Project Manager', 65000, 35),
('Sophia Johnson', 'Designer', 48000, 26),
('James Anderson', 'Data Analyst', 52000, 27),
('Olivia Taylor', 'QA Tester', 40000, 24),
('William Thomas', 'Consultant', 62000, 32),
('Isabella Moore', 'Sales Executive', 43000, 31),
('Ethan Martin', 'Support Engineer', 47000, 28),
('Mia Thompson', 'Network Administrator', 50000, 30),
('Lucas White', 'System Engineer', 55000, 33),
('Emma Harris', 'Product Owner', 60000, 34),
('Alexander Lewis', 'Business Analyst', 53000, 29),
('Charlotte Hall', 'Technical Lead', 64000, 36),
('Aiden Young', 'Intern', 30000, 22),
('Amelia King', 'Customer Service', 42000, 28),
('Mason Scott', 'UX Designer', 49000, 27),
('Aria Green', 'Content Writer', 40000, 26),
('Elijah Adams', 'DevOps Engineer', 57000, 30),
('Sofia Perez', 'Security Analyst', 56000, 31),
('Logan Hill', 'Scrum Master', 63000, 35),
('Liam Wright', 'Database Administrator', 52000, 29),
('Ava Torres', 'Backend Developer', 51000, 26),
('Benjamin Lopez', 'Frontend Developer', 48000, 27),
('Harper Rivera', 'Technical Writer', 44000, 28),
('Noah Phillips', 'SEO Specialist', 46000, 29),
('Abigail Carter', 'UI Designer', 47000, 30),
('Jayden Mitchell', 'Cloud Engineer', 59000, 32),
('Ella Rodriguez', 'IT Support', 41000, 25),
('Carter Martinez', 'Blockchain Developer', 65000, 31),
('Scarlett Diaz', 'Game Developer', 48000, 27),
('Sebastian Hernandez', 'AI Engineer', 70000, 35),
('Zoe Hughes', 'Mobile App Developer', 50000, 26),
('Oliver Murphy', 'Big Data Specialist', 54000, 29),
('Riley Sullivan', 'Cybersecurity Specialist', 60000, 33),
('Lucas Foster', 'Embedded Systems Engineer', 52000, 30),
('Aubrey Gray', 'Electronics Engineer', 58000, 28),
('Matthew Baker', 'Full Stack Developer', 62000, 34),
('Ella Morris', 'Game Designer', 47000, 27),
('Henry Collins', 'Machine Learning Engineer', 69000, 32),
('Layla Bell', 'RPA Developer', 54000, 30),
('Jack Ward', 'Web Developer', 50000, 26),
('Mila Cooper', 'DevOps Consultant', 59000, 31),
('Wyatt Reed', 'IT Consultant', 63000, 34),
('Grace Bailey', 'Product Designer', 51000, 27),
('Lily Stewart', 'AI Consultant', 68000, 35),
('Andrew Carter', 'Software Tester', 45000, 25);
GO
	

-- search only for name 
create procedure getEmployees
 @SearchQuery NVARCHAR(50),
    @PageNumber INT,
    @PageSize INT,
    @TotalRecords INT OUTPUT
	AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartRow INT;
    SET @StartRow = (@PageNumber - 1) * @PageSize;

    SELECT @TotalRecords = COUNT(*)
    FROM Employees
    WHERE (@SearchQuery IS NULL OR Name LIKE '%' + @SearchQuery + '%');

    SELECT id, Name, Details, coalesce(Salary,0) as Salary, coalesce(Age,0) as Age
    FROM Employees
    WHERE (@SearchQuery IS NULL OR Name LIKE '%' + @SearchQuery + '%')
    ORDER BY id
    OFFSET @StartRow ROWS FETCH NEXT @PageSize ROWS ONLY;
END



-- search on all colums for search operation
alter PROCEDURE getEmployees
    @SearchQuery NVARCHAR(50),
    @PageNumber INT,
    @PageSize INT,
    @TotalRecords INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartRow INT;
    SET @StartRow = (@PageNumber - 1) * @PageSize;

    -- Calculate total records matching the search criteria
    SELECT @TotalRecords = COUNT(*)
    FROM Employees
    WHERE (@SearchQuery IS NULL 
           OR Name LIKE '%' + @SearchQuery + '%'
           OR Details LIKE '%' + @SearchQuery + '%'
           OR CAST(Salary AS NVARCHAR) LIKE '%' + @SearchQuery + '%'
           OR CAST(Age AS NVARCHAR) LIKE '%' + @SearchQuery + '%');

    -- Retrieve paginated records
    SELECT id, Name, Details, COALESCE(Salary, 0) AS Salary, COALESCE(Age, 0) AS Age
    FROM Employees
    WHERE (@SearchQuery IS NULL 
           OR Name LIKE '%' + @SearchQuery + '%'
           OR Details LIKE '%' + @SearchQuery + '%'
           OR CAST(Salary AS NVARCHAR) LIKE '%' + @SearchQuery + '%'
           OR CAST(Age AS NVARCHAR) LIKE '%' + @SearchQuery + '%')
    ORDER BY id
    OFFSET @StartRow ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO



