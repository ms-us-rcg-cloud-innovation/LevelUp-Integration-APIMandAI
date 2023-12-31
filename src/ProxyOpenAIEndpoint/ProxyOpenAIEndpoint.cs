using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Net;

namespace ProxyOpenAIEndpoint
{
    public class ProxyOpenAIEndpoint
    {
        const string _openAiUrlPathTemplate = "openai/deployments/{deployment}/chat/completions"; 
        private readonly ILogger _logger;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientFactory _httpClientFactory;

        public ProxyOpenAIEndpoint(ILoggerFactory loggerFactory, IConfiguration configuration, IHttpClientFactory httpClientFactory)
        {
            _logger = loggerFactory.CreateLogger<ProxyOpenAIEndpoint>();
            _configuration = configuration;
            _httpClientFactory = httpClientFactory;
        }

        [Function("ProxyOpenAIEndpoint")]
        public Task<HttpResponseData> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = _openAiUrlPathTemplate)] HttpRequestData req,
                string deployment)
        {
            if (_configuration.GetValue<bool>("RETURN_429"))
            {
                var response429 = req.CreateResponse(HttpStatusCode.TooManyRequests);
                response429.Headers.Add("Content-Type", "text/plain; charset=utf-8");
                return Task.FromResult(response429);
            }

            return ProxyToOpenAIServiceAsync(req, deployment);
        }

        private async Task<HttpResponseData> ProxyToOpenAIServiceAsync(
            HttpRequestData req, string deployment)
        {
            if (!req.Headers.TryGetValues("api-key", out IEnumerable<string>? apiKeyHeaderValues))
            {
                var response400 = req.CreateResponse(HttpStatusCode.BadRequest);
                response400.Headers.Add("Content-Type", "text/plain; charset=utf-8");
                await response400.WriteStringAsync("Missing api key");
                return response400;
            };

            var apiKey = apiKeyHeaderValues.First();
            var body = await req.ReadAsStringAsync();
            if (string.IsNullOrWhiteSpace(body))
            {
                var response400 = req.CreateResponse(HttpStatusCode.BadRequest);
                response400.Headers.Add("Content-Type", "text/plain; charset=utf-8");
                await response400.WriteStringAsync("Missing request body");
                return response400;
            }

            string openAiUrl = GetOpenAIUrl(deployment);

            var content = new StringContent(body);
            content.Headers.Add("api-key", apiKey);
            content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/json");
          

            var httpClient = _httpClientFactory.CreateClient();
            var openAiResponse = await httpClient.PostAsync(openAiUrl, content);
            var openAiResponseContent = await openAiResponse.Content.ReadAsStringAsync();

            var response = req.CreateResponse(openAiResponse.StatusCode);
            response.Headers.Add("Content-Type", "application/json; charset=utf-8");
            await response.WriteStringAsync(openAiResponseContent);
            return response;
        }

        private string GetOpenAIUrl(string deployment)
        {
            string serviceName = _configuration.GetValue<string>("AZURE_OPENAI_SERVICENAME");
            string apiVersion = _configuration.GetValue<string>("AZURE_OPENAI_APIVERSION");
            string urlPath = string.Format(_openAiUrlPathTemplate.Replace("{deployment}", "{0}"), deployment);
            return $"https://{serviceName}.openai.azure.com/{urlPath}?api-version={apiVersion}";
        }
    }
}