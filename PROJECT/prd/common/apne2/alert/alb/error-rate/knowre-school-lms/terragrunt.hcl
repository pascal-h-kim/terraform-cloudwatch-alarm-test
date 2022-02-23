terraform {
  source = "../../../../../../../../SERVICE/cloudwatch/metric/alarm/expression_multiple_dimension"
}

include {
  path = "${find_in_parent_folders()}"
}

dependency "sns_topic_common" {
  config_path = "../../../../sns/alarm-to-slack/common"
}

inputs = {
  alarm_name          = "[knowre-school-lms] Error Rate"
  alarm_description   = "[knowre-school-lms] Error Rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  unit                = "Count"
  period              = 60
  datapoints_to_alarm = 1

  cw_namespace        = "AWS/ApplicationELB"
  statistic           = "Sum"

  query = {
    id                = "e1"
    expression        = "((m1+m2)/m3)*100"
    label             = "Error Rate"
  }
  metric_query = [
    {
      metric_name     = "HTTPCode_Target_4XX_Count"
      dimension       = {
        TargetGroup = "targetgroup/knowre-school-lms-prd/bf6a67da8f259520"
        LoadBalancer = "knowre-school-lms-prd/a20e67095faf6ea8"
      }
    },
    {
      metric_name     = "HTTPCode_Target_5XX_Count"
      dimension       = {
        TargetGroup = "targetgroup/knowre-school-lms-prd/bf6a67da8f259520"
        LoadBalancer = "knowre-school-lms-prd/a20e67095faf6ea8"
      }
    },
    {
      metric_name     = "RequestCount"
      dimension       = {
        TargetGroup = "targetgroup/knowre-school-lms-prd/bf6a67da8f259520"
        LoadBalancer = "knowre-school-lms-prd/a20e67095faf6ea8"
      }
    }
  ]

  # enable_info              = false
  # threshold_info           = 0
  # ok_actions_info          = false
  # alarm_actions_info       = []
  
  # enable_warn              = false
  # threshold_warn           = 0
  # ok_actions_warn          = false
  # alarm_actions_warn       = [dependency.sns_topic_common.outputs.sns_topic_arn]

  enable_crit              = true
  threshold_crit           = 10
  ok_actions_crit          = true
  alarm_actions_crit       = [dependency.sns_topic_common.outputs.sns_topic_arn]

}

