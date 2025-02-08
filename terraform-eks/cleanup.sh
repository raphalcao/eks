#!/bin/bash
set -e  # Para interromper a execução em caso de erro crítico

AWS_REGION="us-east-1"
AWS_PROFILE="default"

echo "🚀 Iniciando a remoção dos containers e infraestrutura na AWS..."

# 1️⃣ **Verificar Conexão com o Cluster (EKS)**
echo "🔍 Verificando conexão com o cluster..."
if ! kubectl get nodes &>/dev/null; then
    echo "⚠️ Aviso: Cluster inacessível! Continuando o cleanup..."
else
    echo "✅ Cluster acessível! Continuando a remoção..."
fi

# 2️⃣ **Remover Deployments e Serviços do Kubernetes (EKS)**
echo "🛑 Removendo deployments do Kubernetes..."
kubectl delete deployment auth-php --ignore-not-found=true || echo "⚠️ Aviso: Erro ao remover auth-php"
kubectl delete deployment processing-php --ignore-not-found=true || echo "⚠️ Aviso: Erro ao remover processing-php"

echo "🛑 Removendo serviços do Kubernetes..."
kubectl delete svc auth-php --ignore-not-found=true || echo "⚠️ Aviso: Erro ao remover serviço auth-php"
kubectl delete svc processing-php --ignore-not-found=true || echo "⚠️ Aviso: Erro ao remover serviço processing-php"

echo "🗑️ Limpando volumes não utilizados..."
kubectl delete pvc --all --ignore-not-found=true || echo "⚠️ Nenhum volume persistente encontrado"

echo "✅ Todos os recursos do Kubernetes foram removidos!"

# 3️⃣ **Remover Imagens do AWS ECR**
echo "🗑️ Removendo imagens do ECR..."

REPO_AUTH=$(aws ecr describe-repositories --query "repositories[?repositoryName=='auth-php'].repositoryName" --output text --profile $AWS_PROFILE || echo "")
REPO_PROCESS=$(aws ecr describe-repositories --query "repositories[?repositoryName=='processing-php'].repositoryName" --output text --profile $AWS_PROFILE || echo "")

if [[ -n "$REPO_AUTH" ]]; then
    echo "🔥 Apagando todas as imagens do repositório auth-php..."
    IMAGES=$(aws ecr list-images --repository-name auth-php --query 'imageIds[*]' --output json --profile $AWS_PROFILE)
    if [[ "$IMAGES" != "[]" ]]; then
        aws ecr batch-delete-image --repository-name auth-php --image-ids "$IMAGES" --region $AWS_REGION --profile $AWS_PROFILE || echo "⚠️ Nenhuma imagem encontrada em auth-php!"
    else
        echo "⚠️ Nenhuma imagem encontrada em auth-php!"
    fi
else
    echo "⚠️ Repositório auth-php não encontrado!"
fi

if [[ -n "$REPO_PROCESS" ]]; then
    echo "🔥 Apagando todas as imagens do repositório processing-php..."
    IMAGES=$(aws ecr list-images --repository-name processing-php --query 'imageIds[*]' --output json --profile $AWS_PROFILE)
    if [[ "$IMAGES" != "[]" ]]; then
        aws ecr batch-delete-image --repository-name processing-php --image-ids "$IMAGES" --region $AWS_REGION --profile $AWS_PROFILE || echo "⚠️ Nenhuma imagem encontrada em processing-php!"
    else
        echo "⚠️ Nenhuma imagem encontrada em processing-php!"
    fi
else
    echo "⚠️ Repositório processing-php não encontrado!"
fi

echo "✅ Todas as imagens do ECR foram removidas!"

# 4️⃣ **Destruir a Infraestrutura com Terraform**
echo "⚠️ ATENÇÃO: Iniciando destruição da infraestrutura Terraform..."

if [[ -d "terraform-eks" ]]; then
    cd terraform-eks
    terraform destroy -auto-approve || echo "⚠️ Aviso: Erro ao destruir infraestrutura Terraform!"
    cd ..
else
    echo "❌ Erro: Diretório terraform-eks não encontrado! Pulando destruição."
fi

echo "✅ Infraestrutura destruída com sucesso!"
echo "🎉 Cleanup completo! Todos os recursos foram removidos."
