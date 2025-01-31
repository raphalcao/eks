#!/bin/bash

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_REGION="us-east-1"

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

git clone https://github.com/raphalcao/auth.git
git clone https://github.com/raphalcao/processing.git

cd auth
docker build -t auth-php .
docker tag auth-php:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/auth-php:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/auth-php:latest
cd ..

cd processing
docker build -t processing-php .
docker tag processing-php:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/processing-php:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/processing-php:latest
cd ..