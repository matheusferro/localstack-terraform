## Runing AWS Services in localstack with terraform

### Requirements

- aws cli (Recommended v2);
- docker;
- docker-compose;
- terraform cli;

### Running

#### AWS CLI

Configure aws cli environment:

```bash
aws configure
AWS Access Key ID [*]: test
AWS Secret Access Key [*]: test
Default region name [sa-east-1]: us-east-1
Default output format [json]: json
```

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

Get cloudwatch logs groups:

```bash
aws --endpoint-url=http://localhost:4566 logs describe-log-groups
```

See logs from lambda function:

```bash
aws --endpoint-url=http://localhost:4566 logs tail /aws/lambda/hello_lambda_func --follow
```

Get step function execution history:

```bash
aws --endpoint-url=http://localhost:4566 stepfunctions get-execution-history --execution-arn {executionArn}
```
