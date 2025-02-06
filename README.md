# FIAP EKS - Automação com Terraform

Este repositório tem como objetivo automatizar a infraestrutura do desafio de integração com o AWS EKS usando Terraform, juntamente com uma CI/CD pipeline via GitHub Actions.

### Nota: 
Para melhor uso, é recomendado o terminal do linux. No Windows, use o wsl.

### Passo a Passo para Utilização do Repositório

### 1. Fazer um Fork
Primeiro, faça um fork deste repositório para sua conta do GitHub.

### 1.1 Criar ou alterar as credenciais AWS.

Execute o comando: `nano ~/.aws/config`
Apague as credenciais 
Cole as novas credencias e salve o arquivo (CTRL + X, aperte Y e depois ENTER).

### 1.2 Criar os repositorios no EKS 

aws ecr create-repository --repository-name {nome_projeto_github} --region us-east-1 --profile default

aws ecr create-repository --repository-name auth-php --region us-east-1 --profile default
aws ecr create-repository --repository-name processing-php --region us-east-1 --profile default


### 2. Criar um cluster no serviço da AWS - EKS
    Etapas:
        . Entre no painel da AWS 
        . Amazon Elastic Kubernetes Service
        . Criar Cluster
        . Preencha os dados
        . Salvar

### 2.1 Adicionar o nome do cluster no arquivo deploy.yml

        . aws eks update-kubeconfig --region us-east-1 --name <nome_do_cluster> --profile default
            Ex: aws eks update-kubeconfig --region us-east-1 --name serious-folk-party --profile default

### 3. Cadastrar as Chaves no GitHub

Para que o Terraform e os workflows do GitHub Actions funcionem corretamente, será necessário cadastrar as credenciais da AWS no repositório do GitHub. Siga os passos abaixo:

1. No repositório GitHub, acesse **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
2. Adicione as seguintes chaves e valores:

- `AWS_ACCESS_KEY_ID`: Sua chave de acesso (Access Key ID) da AWS. 
- `AWS_SECRET_ACCESS_KEY`: Sua chave secreta (Secret Access Key) da AWS.
- `AWS_SESSION_TOKEN`: Seu token (Session Token) da AWS.
- `AWS_REGION`: Sua região da AWS. Costuma ser us-east-1 

Essas chaves serão utilizadas para autenticar o Terraform no AWS durante os workflows.

---

## GitHub Actions

Este repositório contém um workflows principais para automatizar a criação e destruição de infraestrutura usando Terraform, além de validar mudanças via pull requests.

### 1. **Deploy (Pull Request)**

Esse workflow é acionado automaticamente sempre que uma pull request é aberta ou modificada na branch `main`. Ele segue as mesmas etapas de inicialização e validação dos outros workflows, mas ao invés de aplicar as mudanças, ele:

- **Checkout do repositório**: Clona o repositório.
- **Configuração da AWS CLI**: Autentica a AWS CLI.
- **Setup Terraform**: Configura o ambiente com a versão especificada do Terraform.
- **Inicializar Terraform**: Executa `terraform init`.
- **Formatar e Validar Configurações**: Formata e valida os arquivos Terraform.
- **Gerar Plano de Execução**: Executa `terraform plan` para exibir o plano de mudanças sem aplicar nada.
