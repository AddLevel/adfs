using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using SampleAspNetCore2ApplicationNETFramework.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace SampleAspNetCore2ApplicationNETFramework.Extensions
{
    public class AppClaimsPrincipalFactory : UserClaimsPrincipalFactory<ApplicationUser, IdentityRole>
    {
        public AppClaimsPrincipalFactory(
            UserManager<ApplicationUser> userManager
            , RoleManager<IdentityRole> roleManager
            , IOptions<IdentityOptions> optionsAccessor)
        : base(userManager, roleManager, optionsAccessor)
        { }

        public async override Task<ClaimsPrincipal> CreateAsync(ApplicationUser user)
        {
            var principal = await base.CreateAsync(user);

            //LINK: https://benfoster.io/blog/customising-claims-transformation-in-aspnet-core-identity

            //if (!string.IsNullOrWhiteSpace(user.FirstName))
            //{
            //    ((ClaimsIdentity)principal.Identity).AddClaims(new[] {
            //        new Claim(ClaimTypes.GivenName, user.FirstName)
            //    });
            //}

            //if (!string.IsNullOrWhiteSpace(user.LastName))
            //{
            //    ((ClaimsIdentity)principal.Identity).AddClaims(new[] {
            //        new Claim(ClaimTypes.Surname, user.LastName),
            //    });
            //}

            return principal;
        }
    }
}
