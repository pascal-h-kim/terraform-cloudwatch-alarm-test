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
  alarm_name          = "[trinity-learning-query-rest] Error Rate"
  alarm_description   = "[trinity-learning-query-rest] Error Rate"
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
        TargetGroup   = "targetgroup/trinity-learning-query-rest-prd/aa134f77e0b0dd1e"
        LoadBalancer  = "app/trinity-learning-query-rest-prd/cd05403944090cae"
      }
    },
    {
      metric_name     = "HTTPCode_Target_5XX_Count"
      dimension       = {
        TargetGroup   = "targetgroup/trinity-learning-query-rest-prd/aa134f77e0b0dd1e"
        LoadBalancer  = "app/trinity-learning-query-rest-prd/cd05403944090cae"
      }
    },
    {
      metric_name     = "RequestCount"
      dimension       = {
        TargetGroup   = "targetgroup/trinity-learning-query-rest-prd/aa134f77e0b0dd1e"
        LoadBalancer  = "app/trinity-learning-query-rest-prd/cd05403944090cae"
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

