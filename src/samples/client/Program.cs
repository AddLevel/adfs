using Client;
using IdentityModel.Client;
using Newtonsoft.Json.Linq;
using System;
using System.Net.Http;
using System.Threading.Tasks;

namespace Client
{
    public class Program
    {
        public static async Task Main()
        {
            Console.Title = "Console Client Credentials Flow";

            var response = await RequestTokenAsync();

            Console.Write(response.AccessToken);
            Console.ReadLine();

            await CallServiceAsync(response.AccessToken);
            Console.ReadLine();
        }

        static async Task<TokenResponse> RequestTokenAsync()
        {
            var client = new HttpClient();

            var disco = await client.GetDiscoveryDocumentAsync(Constants.Authority);
            if (disco.IsError) throw new Exception(disco.Error);

            var response = await client.RequestClientCredentialsTokenAsync(new ClientCredentialsTokenRequest
            {
                Address = disco.TokenEndpoint,
                ClientId = "54aafa4c-c720-447c-a60a-0e5ccd14782d",
                ClientSecret = "wQJb1xk26WEKlVAT8js4IOI36CLXKAKj0o1Urfnx"
            });

            if (response.IsError) throw new Exception(response.Error);
            return response;
        }

        static async Task CallServiceAsync(string token)
        {
            var baseAddress = Constants.SampleApi;

            var client = new HttpClient
            {
                BaseAddress = new Uri(baseAddress)
            };

            client.SetBearerToken(token);
            var response = await client.GetStringAsync("api/claims");

            Console.WriteLine(JArray.Parse(response));
        }
    }
}
