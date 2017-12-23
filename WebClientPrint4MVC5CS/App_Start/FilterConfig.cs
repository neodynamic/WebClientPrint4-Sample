using System.Web;
using System.Web.Mvc;

namespace WebClientPrint4MVC5CS
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
