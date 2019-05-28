using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace SampleAspNetCore2ApplicationNETFramework.Pages
{
    public class ClaimsModel : PageModel
    {
        public string Message { get; set; }
        public IEnumerable<Claim> Claims { get; set; }

        public void OnGet()
        {
            Message = "Your claims page.";
            var testClaims = User.Claims;

            var identity = (ClaimsPrincipal)Thread.CurrentPrincipal;
            Claims = identity.Claims;
        }
    }
}