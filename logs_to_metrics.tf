resource "datadog_logs_metric" "carriers_ext_req_duration" {
  count        = var.create_alarms ? 1 : 0
  name = "carriers.external_request.duration"
  
  compute {
    aggregation_type = "distribution"
    path             = "@duration"
  }
  filter {
    query = "service:monolith \\\"Requesting External Service\\\""
  }
  group_by {
    path     = "env"
    tag_name = "env"
  }
  group_by {
    path     = "@api_log_name"
    tag_name = "api_log_name"
  }
}

resource "datadog_logs_metric" "carriers_ext_req_count" {
  count        = var.create_alarms ? 1 : 0
  name = "carriers.external_request.counters"

  compute {
    aggregation_type = "count"
  }
  filter {
    query = "service:monolith \\\"Requesting External Service\\\""
  }
  group_by {
    path     = "env"
    tag_name = "env"
  }
  group_by {
    path     = "@api_log_name"
    tag_name = "api_log_name"
  }
  group_by {
    path     = "@carrier"
    tag_name = "carrier_name"
  }
  group_by {
    path     = "@action"
    tag_name = "action"
  }
  group_by {
    path     = "@level"
    tag_name = "level"
  }
  group_by {
    path     = "@klass"
    tag_name = "klass"
  }
  group_by {
    path     = "@http.status_code"
    tag_name = "response_code"
  }
}