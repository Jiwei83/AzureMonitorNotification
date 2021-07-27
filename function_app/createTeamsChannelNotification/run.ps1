using namespace System.Net

param($Request, $TriggerMetadata)

$body = ConvertTo-Json -Depth 4 @{
    summary  = $Request.body.data.essentials.alertRule
    sections = @(
        @{
            activityTitle    = $Request.body.data.essentials.alertRule
            activitySubtitle = $Request.body.data.essentials.description
            activityText     = "Alert $($Request.body.data.essentials.alertRule) has fired"
        },
        @{
            title = 'Details'
            facts = @(
                @{
                    name  = 'Link To Search Results'

                    value = "[Link](https://ms.portal.azure.com/#blade/Microsoft_Azure_Monitoring/AlertDetailsTemplateBlade/alertId/$(($Request.body.data.essentials.alertId).Replace('/', '%2f')))"
                },
                @{
                    name  = 'severity'
                    value = $Request.body.data.essentials.severity
                },
                @{
                    name  = 'alertRule'
                    value = $Request.body.data.essentials.alertRule
                },
                @{
                    name  = 'alertId'
                    value = $Request.body.data.essentials.alertId
                },
                @{
                    name  = 'monitorCondition'
                    value = $Request.body.data.essentials.monitorCondition
                },
                @{
                    name  = 'originAlertId'
                    value = $Request.body.data.essentials.originAlertId
                },
                @{
                    name  = 'firedDateTime'
#                   
                    value = $(([TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]$Request.body.data.essentials.firedDateTime, 'Tokyo Standard Time')).ToString("yyyy-MM-ddTHH:mm:ss"))
                },
                @{
                    name  = 'threshold'
                    value = $Request.body.data.alertContext.condition.allOf.threshold
                },
                @{
                    name  = 'metricValue'
                    value = $Request.body.data.alertContext.condition.allOf.metricValue
                }
            )
        }
    )
}

Invoke-RestMethod -uri $env:teams_webhook_url -Method Post -body $body -ContentType 'application/json'

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })
