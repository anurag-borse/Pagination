using Pagination.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Pagination.Repo
{
    public class Repository
    {
        private readonly string _connectionString;

        public Repository()
        {
          //  _connectionString = "User ID=DRONAADMIN;Password=admin#123;Integrated Security=False;database=Prac;server=10.3.48.51";
            _connectionString = "Server=.;Database=Practise;Trusted_Connection=True;TrustServerCertificate = True";
        }

        private SqlConnection GetConnection()
        {
            return new SqlConnection(_connectionString);
        }
        public List<Employees> GetEmployees(string searchQuery, int pageNumber, int pageSize, out int totalRecords)
        {
            List<Employees> employees = new List<Employees>();
            using (SqlConnection connection = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand("getEmployees", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SearchQuery", searchQuery ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);
                    cmd.Parameters.Add("@TotalRecords", SqlDbType.Int).Direction = ParameterDirection.Output;

                    connection.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            employees.Add(new Employees
                            {
                                id = Convert.ToInt32(reader["id"]),
                                Name = reader["Name"].ToString(),
                                Details = reader["Details"].ToString(),
                                Salary = Convert.ToInt32(reader["Salary"]),
                                Age = Convert.ToInt32(reader["Age"])
                            });
                        }
                    }

                    totalRecords = Convert.ToInt32(cmd.Parameters["@TotalRecords"].Value);
                }
            }
            return employees;
        }
    }
}