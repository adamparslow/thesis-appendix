resource "datadog_monitor" "label_failure_invalid_postcode_suburb" {
  count = var.create_alarms ? 1 : 0
  name  = "Courier Label failure"
  type  = "log alert"

  message = <<MESSAGE
{{#is_alert}}
*Description:*
TNT labelling failed due to invalid postcode/suburb combination
:green_book:*Runbook:* [Courier- Label failure due to postcode suburb mismatch](https://shippit.atlassian.net/wiki/spaces/DEV/pages/1971421186/TNT+-+Label+failure+due+to+postcode+suburb+mismatch)
:datadog:*Dashboard:* [Dashboard]()
:datadog:*Logs:* [Logs](https://app.datadoghq.eu/logs?query=env%3Aprd%20service%3Amonolith%20%22%5BTNT%5D%20Get%20Label%20failed%22%20-status%3Ainfo%20%20%40error_message%3ASuburb%5C%3A%2A&agg_q=%40error_message&cols=host%2Cservice&index=&messageDisplay=inline&sort_m=&sort_t=&stream_sort=time%2Cdesc&top_n=10&top_o=top&viz=pattern&x_missing=true)
{{/is_alert}}
{{#is_recovery}}Courier labelling Recovered{{/is_recovery}}
Notify: ${var.slack_carrier_squad_monitoring_channel_name}
MESSAGE

  query = "logs(\"env:prd service:monolith \\\"Get Label failed\\\" -status:info @error_message:Suburb\\:*\").index(\"*\").rollup(\"count\").by(\"@error_message\").last(\"4h\") > 0"

  renotify_interval = 0
  timeout_h         = 0
  include_tags = true

  monitor_thresholds {
    critical        = 0
  }

  tags = [
    "env:prd",
    "service:monolith",
    "terraform:monolith-monitors",
    "owner:carrier-squad"
  ]
}