terraform {
  source = "../../../../../../../SERVICE/chatbot/slack"
}

terraform_version_constraint = ">= 0.13"

include {
  path = "${find_in_parent_folders()}"
}

dependency "sns_topic_alb" {
  config_path = "../../../../apne2/sns/alarm-to-slack/alb"
}

dependency "sns_topic_us_alb" {
  config_path = "../../../../usea1/sns/alarm-to-slack/alb"
}

inputs = {
  name                = "slack-alb"
  enabled             = "true"
  org_name            = "knowredev"
  slack_channel_id    = "C03508FTHAB"
  slack_workspace_id  = "T024UHAGF"
  workspace_name      = "slack-alb"
  alarm_sns_topic_arns = [dependency.sns_topic_alb.outputs.sns_topic_arn, dependency.sns_topic_us_alb.outputs.sns_topic_arn]
}
