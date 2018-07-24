using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.Controllers;
using Umbraco.Web.WebApi;
using System.Web.Mvc;

//https://our.umbraco.com/documentation/Umbraco-Cloud/Set-Up/Working-With-Visual-Studio/#using-umbraco-namespaces-in-your-core-project

//https://umbraco.tv/videos/umbraco-v7/developer/fundamentals/api-controllers/understanding-routing/
// ~/Umbraco/Api/[YourControllerName-WithoutControllerSuffix]/[YourMethodName]
namespace CMS.Core.Controllers
{
    public class ContentApiController : UmbracoApiController
    {

        [System.Web.Http.HttpGet]
        public string Republishall()
        {
            var contentService = Services.ContentService;
            contentService.RePublishAll();
            umbraco.library.RefreshContent();
            return "success";
        }
    }
}
