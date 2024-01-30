provider "aws" {
    region = "us-east-1"

  
}

# plan - execute
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-s3-bucket-coconut-bucket-0809"
    versioning {
        enabled = true
    }
}

resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user_abc_updated"
}

output "my_s3_bucket_complete_details" {
    value =  aws_s3_bucket.my_s3_bucket
}

output "my_iam_user_complete_details" {
    value = aws_iam_user.my_iam_user
}


# STATE
# DESIRED - KNOWN - ACTUAL