##
# GG Instance IAM Role
##
resource "aws_iam_role" "ec2_profile" {
  name = "ec2-profile"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

##
# GG Instance IAM Instance Profile
##
resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_profile.name
}

##
# Attact SSM Policy to GG Instance IAM Role
##
resource "aws_iam_role_policy_attachment" "ec2_profile_ssm" {
  role       = aws_iam_role.ec2_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
