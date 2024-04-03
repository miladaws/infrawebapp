# modules/networking/outputs.tf

output "vpc_id" {
    value       = aws_vpc.InfraWebAppVPC.id
    description = "The ID of the VPC"
}

output "subnet_id_a" {
    value       = aws_subnet.InfraWebAppSubnet_a.id
    description = "The ID of the first subnet"
}

output "subnet_id_b" {
    value       = aws_subnet.InfraWebAppSubnet_b.id
    description = "The ID of the second subnet"
}