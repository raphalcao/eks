#!/bin/bash
set -e  # Para interromper a execução se houver erro

# 🏗️ Definição de variáveis
AWS_REGION="us-east-1"
AWS_PROFILE="default"  # Usa explicitamente o perfil default
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text --profile $AWS_PROFILE)

echo "🔑 Fazendo login no AWS ECR usando perfil default..."
aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# 🔍 **Verifica se os repositórios existem antes de tentar fazer push**
echo "🔎 Verificando repositórios no AWS ECR..."
REPO_AUTH=$(aws ecr describe-repositories --query "repositories[?repositoryName=='auth-php'].repositoryName" --output text --profile $AWS_PROFILE)
REPO_PROCESS=$(aws ecr describe-repositories --query "repositories[?repositoryName=='processing-php'].repositoryName" --output text --profile $AWS_PROFILE)

if [[ -z "$REPO_AUTH" ]] || [[ -z "$REPO_PROCESS" ]]; then
    echo "🚨 Erro: Um ou mais repositórios não foram encontrados no ECR!"
    exit 1
fi

# 🔄 Clonar repositórios apenas se ainda não existirem
[[ -d "auth" ]] || git clone https://github.com/raphalcao/auth.git
[[ -d "processing" ]] || git clone https://github.com/raphalcao/processing.git

# 🏗️ **Construir e enviar imagem para o ECR (auth-php)**
echo "🐳 Construindo e enviando imagem auth-php..."
cd auth
docker build -t auth-php -f .infra/docker/Dockerfile .
docker tag auth-php:latest "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/auth-php:latest"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/auth-php:latest"
cd ..

# 🏗️ **Construir e enviar imagem para o ECR (processing-php)**
echo "🐳 Construindo e enviando imagem processing-php..."
cd processing
docker build -t processing-php -f docker/Dockerfile .
docker tag processing-php:latest "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/processing-php:latest"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/processing-php:latest"
cd ..

echo "✅ Imagens enviadas com sucesso para o ECR!"
