### AWS EventBridget Events ###
# Event rule: Runs at 9am during working days
resource "aws_scheduler_schedule" "start_instances_schedule" {
  name = "start_instances_schedule"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.ec2_start_scheduler_lambda.arn
    role_arn = aws_iam_role.scheduler_execution_role.arn
  }

  description                  = "Starts stopped EC2 instances"
  schedule_expression          = "cron(0 9 ? * MON-FRI *)"
  schedule_expression_timezone = "Asia/Tokyo"
}

# Runs at 7pm during working days
resource "aws_scheduler_schedule" "stop_instances_schedule" {
  name = "stop_instances_schedule"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.ec2_stop_scheduler_lambda.arn
    role_arn = aws_iam_role.scheduler_execution_role.arn
  }

  description                  = "Stops running EC2 instances"
  schedule_expression          = "cron(0 19 ? * MON-FRI *)"
  schedule_expression_timezone = "Asia/Tokyo"
}

# Event target: Associates a rule with a function to run
# resource "aws_cloudwatch_event_target" "start_instances_event_target" {
#   target_id = "start_instances_lambda_target"
#   rule      = aws_cloudwatch_event_rule.start_instances_event_rule.name
#   arn       = aws_lambda_function.ec2_start_scheduler_lambda.arn
# }

# resource "aws_cloudwatch_event_target" "stop_instances_event_target" {
#   target_id = "stop_instances_lambda_target"
#   rule      = aws_cloudwatch_event_rule.stop_instances_event_rule.name
#   arn       = aws_lambda_function.ec2_stop_scheduler_lambda.arn
# }

# AWS Lambda Permissions: Allow CloudWatch to execute the Lambda Functions
# resource "aws_lambda_permission" "allow_cloudwatch_to_call_start_scheduler" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ec2_start_scheduler_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.start_instances_event_rule.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_scheduler" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ec2_stop_scheduler_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.stop_instances_event_rule.arn
# }