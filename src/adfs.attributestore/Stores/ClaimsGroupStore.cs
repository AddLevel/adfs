namespace adfs.attributestore
{
    using System;
    using System.IdentityModel;
    using System.Collections.Generic;
    using Microsoft.IdentityServer.ClaimsPolicy.Engine.AttributeStore;

    public class ClaimsGroupStore : IAttributeStore
    {
        public IAsyncResult BeginExecuteQuery(string query, string[] parameters, AsyncCallback callback, object state)
        {
            //c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"]
            //=> issue(store = "EAClaimsTransformer", types = ("groups"), query = "sn", param = c.Value);

            if (string.IsNullOrEmpty(query))
            {
                throw new AttributeStoreQueryFormatException("No query string.");
            }

            if (null == parameters)
            {
                throw new AttributeStoreQueryFormatException("No query parameters.");
            }

            if (parameters.Length != 1)
            {
                throw new AttributeStoreQueryFormatException("More than one query parameter.");
            }

            if (!query.Equals("sn"))
            {
                throw new AttributeStoreQueryFormatException("The query string is not supported.");
            }

            string inputString = parameters[0];

            if (string.IsNullOrEmpty(inputString))
            {
                throw new AttributeStoreQueryFormatException("Query parameter cannot be null or empty.");
            }

            try
            {
                // Dummy value to illustrate the principle.
                List<string> claimValues = new List<string> { "Group1", "Group2" };
                List<string[]> claimData = new List<string[]>();

                // Each claim value is added to its own string array 
                foreach (string claimVal in claimValues)
                {
                    claimData.Add(new string[1] { claimVal });
                }

                // The claim value string arrays are added to the string [][] that is returned by the Custom Attribute Store EndExecuteQuery()
                string[][] resultData = claimData.ToArray();

                TypedAsyncResult<string[][]> asyncResult = new TypedAsyncResult<string[][]>(callback, state);
                asyncResult.Complete(resultData, true);
                return asyncResult;
            }
            catch (Exception ex)
            {
                String innerMess = "";
                if (ex.InnerException != null)
                {
                    innerMess = ex.InnerException.ToString();
                }

                throw new AttributeStoreQueryExecutionException("CAS exception : " + ex.Message + " " + innerMess);
            }
        }

        public string[][] EndExecuteQuery(IAsyncResult result)
        {
            return TypedAsyncResult<string[][]>.End(result);
        }

        public void Initialize(Dictionary<string, string> config)
        {
            //throw new NotImplementedException();
        }
    }
}
