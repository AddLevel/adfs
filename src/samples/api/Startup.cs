using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc()
                .SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

            services.AddAuthentication("Bearer")
                      .AddJwtBearer("Bearer", options =>
                      {
                          options.Authority = "https://adfs.auth.local/adfs";
                          options.RequireHttpsMetadata = false;
                          options.Audience = "urn:microsoft:userinfo"; //This looks wierd in OIDC, might be ADFS stuff?
                          options.TokenValidationParameters = new TokenValidationParameters()
                          {
                              ValidIssuer = "http://adfs.auth.local/adfs/services/trust"
                          };

                          options.Events = new JwtBearerEvents
                          {
                              OnTokenValidated = async ctx =>
                              {
                                //Extend custom claims to use in authz filters for example.
                                var claims = new List<Claim>
                                {
                                    new Claim("GivenType", "GivenValue")
                                };

                                ctx.Principal.AddIdentity(new ClaimsIdentity(claims));

                              }
                          };

                      });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseAuthentication();

            app.UseHttpsRedirection();
            app.UseMvc();
        }
    }
}
