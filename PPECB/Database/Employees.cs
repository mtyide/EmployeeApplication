/* Developer: Yandisa Mtyide
 * Date: 18 December 2019
 * The class implements data store functionality required by the web service using Entity Framework (DB First)
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PPECB.Database
{
    public class Employees
    {
        /// <summary>
        /// Save employee object to the database using EF
        /// </summary>
        /// <param name="employee">Employee</param>
        /// <returns>0 = Failed</returns>
        public long Save(Employee employee)
        {
            try
            {
                var res = Exist(employee.Id);
                using (var entity = new EmployeesEntities())
                {
                    if (!res)
                    {
                        var id = entity.CreateEmployee(DateTime.Now, employee.Firstname, employee.Lastname, employee.DOB, employee.Gender, employee.Department, employee.Active).First().Value;
                        return id;
                    }
                    else
                    {
                        var query = from item in entity.Employees
                                    where (item.Id.Equals(employee.Id))
                                    select item;

                        var current = query.FirstOrDefault<Employee>();
                        if (current != null)
                        {
                            current.Active = employee.Active;
                            current.Department = employee.Department;
                            current.DOB = employee.DOB;
                            current.Firstname = employee.Firstname;
                            current.Gender = employee.Gender;
                            current.Lastname = employee.Lastname;

                            var id = entity.SaveChanges();
                            return id;
                        }

                        return 0;
                    }
                }
            }
            catch { return 0; }
        }

        /// <summary>
        /// This method retrieves a collection of employees from the database
        /// </summary>
        /// <returns>Employee Collection</returns>
        public List<Employee> GetEmployees()
        {
            try
            {
                using (var entity = new EmployeesEntities())
                {
                    var query = from item in entity.Employees
                                select item;

                    return query.ToList();
                }
            }
            catch { return null; }
        }

        /// <summary>
        /// This method retrievs a single employee entity from the database
        /// </summary>
        /// <param name="id">Integer value ID of the employee</param>
        /// <returns>Employee</returns>
        public Employee GetEmployee(long id)
        {
            try
            {
                using (var entity = new EmployeesEntities())
                {
                    var query = from item in entity.Employees
                                where (item.Id.Equals(id))
                                select item;

                    return query.First();
                }
            }
            catch { return null; }
        }

        /// <summary>
        /// Optional: This method uses the stored procedure to retrieve a single employee from the database
        /// </summary>
        /// <param name="id">Integer value ID of the employee</param>
        /// <param name="useStoredProcedure">true = Yes</param>
        /// <returns>Employee</returns>
        public Employee GetEmployee(long id, bool useStoredProcedure)
        {
            try
            {
                using (var entity = new EmployeesEntities())
                {
                    if (useStoredProcedure)
                    {
                        var current = entity.GetEmployee(id).First();
                        return new Employee
                        {
                            Active = current.Active,
                            Department = current.Department,
                            DOB = current.DOB,
                            Firstname = current.Firstname,
                            Gender = current.Gender,
                            Id = current.Id,
                            Lastname = current.Lastname
                        };
                    }
                    else { return GetEmployee(id); }
                }
            }
            catch { return null; }
        }

        /// <summary>
        /// This method removes a single employee from the database
        /// </summary>
        /// <param name="id">Integer value ID of the employee</param>
        /// <returns>0 = Failed</returns>
        public long Delete(long id)
        {
            try
            {
                using (var entity = new EmployeesEntities())
                {
                    var query = from item in entity.Employees
                                where (item.Id.Equals(id))
                                select item;

                    var employee = query.First();

                    entity.Employees.Remove(employee);
                    id = entity.SaveChanges();
                    return id;
                }
            }
            catch { return 0; }
        }

        /// <summary>
        /// This method checks for an existing employee from the database
        /// </summary>
        /// <param name="id">Integer value ID of the employee</param>
        /// <returns>bool</returns>
        private bool Exist(long id)
        {
            try
            {
                return GetEmployee(id, true) == null ? false : true;
            }
            catch { return false; }
        }
    }
}