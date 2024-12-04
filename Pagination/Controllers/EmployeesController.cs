using Pagination.Models;
using Pagination.Repo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Pagination.Controllers
{
    public class EmployeesController : Controller
    {

        private readonly Repository _repo;
        public EmployeesController()
        {
            _repo = new Repository();
        }
        // GET: Employees
        public ActionResult Index()
        {
            return View();
        }


        public JsonResult GetEmployees(string searchQuery, int page = 1, int pageSize = 10)
        {
            int totalRecords;
            var employees = _repo.GetEmployees(searchQuery, page, pageSize, out totalRecords);

            return Json(new
            {
                data = employees,
                totalRecords = totalRecords,
                totalPages = Math.Ceiling((double)totalRecords / pageSize),
                currentPage = page
            }, JsonRequestBehavior.AllowGet);
        }

    }
}