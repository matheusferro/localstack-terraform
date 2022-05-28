## Runing AWS Services in localstack with terraform

### Requirements

- docker;
- docker-compose;
- terraform cli;

### Running

#### Localstack

Start localstack with AWS Services:

```bash
docker-compose up --build
```

Verify if localstack started successfully;

```
docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}'
```

#### Terraform

With terraform installed:

```
yay -S terraform
```

Execute following command to apply terraform in localstack:

```
terraform apply
```

The ask `Do you want to perform these actions` should appear. Confirm that you want to continue typing `yes`

IIIIIIIIIIIT'S DONE!!!! \o/

### Configurations

The configuration to connect directly with localstack is in `main.tf`

### Utils

See logs from lambda function:

```
aws --endpoint-url=http://localhost:4566 logs tail /aws/lambda/hello_lambda_func --follow
```
