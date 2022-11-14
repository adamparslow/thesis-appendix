resource "datadog_monitor" "new_api_failure_rate" {
  count = var.create_alarms ? 1 : 0
  name = "New Courier API Failures"
  type = "query alert"

  message = <<MESSAGE
{{#is_alert}}
*Description:*
Carrier API Failures Monitor

:green_book:*Runbook:* [Runbook](https://shippit.atlassian.net/wiki/spaces/DEV/pages/1385169436/Courier+API+failure+rate+is+too+high)
:datadog:*Dashboard:* [Dashboard](https://app.datadoghq.eu/dashboard/5fr-w63-iqa/carrier-api-overview)
{{/is_alert}}
{{#is_recovery}}Carrier API Failures Monitor{{/is_recovery}}
Notify: ${var.slack_carrier_squad_monitoring_test_channel_name}
MESSAGE

  query = "sum(last_5m):moving_rollup(clamp_max(default_zero(sum:carriers.external_request.counters{env:prd,response_code:5*,!carrier_name:tollpriority*} by {action,carrier_name}.as_count().rollup(sum, 120).fill(last, 600) / sum:carriers.external_request.counters{env:prd,!carrier_name:tollpriority} by {action,carrier_name}.as_count().rollup(sum, 120).fill(last, 600) * 100), 70), 960, 'sum') > 560"

  monitor_thresholds {
    critical = 560
    critical_recovery = 70
  }

  include_tags = true

  tags = [
    "terraform:monolith-monitors",
    "owner:carriers",
    "env:prd"
  ]
}

