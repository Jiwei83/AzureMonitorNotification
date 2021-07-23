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
                    value = "[Link]($($Request.body.data.alertContext.LinkToFilteredSearchResultsUI))"
                },
                @{
                    name  = 'Search Fired Time - UTC'
                    value = $Request.body.data.alertContext.firedDateTime
                },
                @{
                    name  = 'Search Resolved Time - UTC'
                    value = $Request.body.data.alertContext.resolvedDateTime
                },
                @{
                    name  = 'Condition Type'
                    value = $Request.body.data.alertContext.conditionType
                },
                @{
                    name  = 'Metric Name'
                    value = $Request.body.data.alertContext.condition.allof.metricName
                }
            )
        }
    )
}

Invoke-RestMethod -uri $env:teams_webhook_url -Method Post -body $body -ContentType 'application/json'

$Request.body.data

Write-Host $body

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })
