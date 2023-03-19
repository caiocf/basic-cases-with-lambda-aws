
Requirements:
* Docker 20 or Higher [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)
* AWS CLI -  [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 
* AWS SAM - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* Apache Maven 3 or High (Put in Env Path) - [Install Maven](https://maven.apache.org/install.html)
* JDK 11 (Put in Env Path) - [Install the Java 11](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html)



## Up LocalStacker Stack Full
```sh
git clone https://github.com/localstack/localstack.git
docker-compose up -d
```

## Configure Profile LocalStack
Here we create a profile named localstack (we can call it whatever we want).
This will prompt for the AWS Access Key, Secret Access Key, and an AWS region. We can provide any dummy value for the credentials and a valid region name like us-east-1, but we can’t leave any of the values blank.

Unlike AWS, LocalStack does not validate these credentials but complains if no profile is set. So far, it’s just like any other AWS profile which we will use to work with LocalStack.

```sh
aws configure --profile localstack
```

## Up Aplication in LocalStack

### Compile App Java
```sh
mvn clean install -f HelloWorldFunction/pom.xml
```

### Create Role Execution Lambda
```sh
aws --endpoint http://localhost:4566 --profile localstack iam create-role --role-name lambda-execution --assume-role-policy-document "{\"Version\": \"2012-10-17\",\"Statement\": [{ \"Effect\": \"Allow\", \"Principal\": {\"Service\": \"lambda.amazonaws.com\"}, \"Action\": \"sts:AssumeRole\"}]}"
```

### Associated Policy to Role
```sh
aws --endpoint http://localhost:4566 --profile localstack iam attach-role-policy --role-name lambda-execution --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

### Install App Lambda in LocalStack 
```sh
aws --endpoint http://localhost:4566 --profile localstack lambda create-function --function-name HelloWorld --zip-file fileb://HelloWorldFunction\target\HelloWorld-1.0.jar --handler helloworld.App --runtime java11 --role arn:aws:iam::000000000000:role/lambda-execution
```

### Invoker if your Lambda app has been installed correctly

```sh
aws --endpoint http://localhost:4566 --profile localstack lambda invoke --function-name HelloWorld out.txt --log-type Tail
```

If this is correct, the file content will be
```json
{
  "body":"{ \"message\": \"hello world\", \"location\": \"189.15.109.193\" }",
  "headers":{
    "Content-Type":"application/json",
    "X-Custom-Header":"application/json"
  },
  "statusCode":200
}
```


