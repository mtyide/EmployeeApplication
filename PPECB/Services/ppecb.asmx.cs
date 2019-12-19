/* Developer: Yandisa Mtyide
 * Date: 18 December 2019
 * The service provides crud methods to be consumed by the client
 */

using PPECB.Database;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using Newtonsoft.Json;

namespace PPECB.Services
{
    /// <summary>
    /// The service provides crud methods to be consumed by the client
    /// </summary>
    [ScriptService]
    [Serializable]
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ppecb : System.Web.Services.WebService
    {
        [WebMethod]
        public long Save(Employee employee)
        {
            var employees = new Employees();
            return employees.Save(employee);
        }

        [WebMethod]
        public string GetEmployees()
        {
            var employees = new Employees();
            var serialize = JsonConvert.SerializeObject(employees.GetEmployees());
            return serialize;
        }

        [WebMethod]
        public string Get(long id)
        {
            var employees = new Employees();
            var serialize = JsonConvert.SerializeObject(employees.GetEmployee(id));
            return serialize;
        }

        [WebMethod]
        public long Delete(long id)
        {
            var employees = new Employees();
            return employees.Delete(id);
        }
    }
}
