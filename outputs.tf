output "aws_instance_public_dns"{
    value=aws_instance.rsg-api.private_dns
}