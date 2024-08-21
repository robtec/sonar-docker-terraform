provider "aws" {
  region = var.region
}

data "archive_file" "codezip" {

  type        = "zip"
  output_path = "docker_code.zip"

  source_dir = "files/"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_elastic_beanstalk_application" "sonar" {
  name = var.application_name
}

resource "aws_s3_bucket" "sonar_bucket" {
  bucket = "${var.application_name}-versions"
}

resource "aws_s3_object" "code" {
  key    = "sonar-docker-code"
  bucket = aws_s3_bucket.sonar_bucket.id
  source = data.archive_file.codezip.output_path
  etag = filemd5(data.archive_file.codezip.output_path)
}

resource "aws_elastic_beanstalk_application_version" "sonar_version" {
  name        = "sonar-docker-compose-version"
  application = aws_elastic_beanstalk_application.sonar.name
  bucket      = aws_s3_bucket.sonar_bucket.id
  key         = aws_s3_object.code.key
}


resource "aws_elastic_beanstalk_environment" "sonar_env" {

  name                = "${var.application_name}"
  application         = aws_elastic_beanstalk_application.sonar.name
  solution_stack_name = "${var.solution_stack_name}"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SONAR_JDBC_URL"
    value     = "jdbc:postgresql://${aws_db_instance.sonar_pg_db.address}:5432/${aws_db_instance.sonar_pg_db.db_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SONAR_JDBC_USERNAME"
    value     = "sonar"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SONAR_JDBC_PASSWORD"
    value     = random_password.pg_password.result
  }
}