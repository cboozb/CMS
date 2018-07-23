using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.Script.Services;
using Telerik.Web.UI;
using CPP.NewPlatform.Data.Client.Entities;
using CPP.NewPlatform.Data.Client.Entities.Repositories;

namespace CPP.NewPlatform.Cms.WebApplication.umbraco.services
{
    public class SimpleObject
    { }
    /// <summary>
    /// Summary description for GridService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [ScriptService]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class GridService : System.Web.Services.WebService
    {
        private readonly DataEntities db = DataEntities.Create();

        [WebMethod(EnableSession = true)]
        public Dictionary<string, object> GetDataAndCount(int startRowIndex, int maximumRows, List<GridSortExpression> sortExpression, List<GridFilterExpression> filterExpression)
        {
            Dictionary<string, object> data = new Dictionary<string, object>();
            data.Add("Data", GetGrid(startRowIndex, maximumRows, sortExpression, filterExpression));
            data.Add("Count", (int)Session["Count"]);
            return data;
        }

        [WebMethod]
        public List<Product> GetGrid(int startIndex, int maximumRows, List<GridSortExpression> sortExpressions, List<GridFilterExpression> filterExpressions)
        {
            List<Product> products = new List<Product>();
            if (filterExpressions.Count() != 0)
            {
                foreach (var filterExpression in filterExpressions)
                {
                    if (filterExpression.FieldName == "Name")
                    {
                        products = ProductRepository.Current.Where(p => p.Name.Contains(filterExpression.FieldValue)).ToList();
                    }
                    else if (filterExpression.FieldName == "Code")
                    {
                        products = ProductRepository.Current.Where(p => p.Code.Contains(filterExpression.FieldValue)).ToList();
                    }
                }
            }
            else
            {
                products = ProductRepository.Current.ToList();
            }
            Session["Count"] = products.Count;
            return products.Skip(startIndex).Take(maximumRows).ToList();
        }
    }
}
