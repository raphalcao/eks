# FIAP EKS - Automação com Terraform

Este repositório tem como objetivo automatizar a infraestrutura do desafio de integração com o AWS EKS usando Terraform, juntamente com uma CI/CD pipeline via GitHub Actions.

## Passo a Passo para Utilização do Repositório

### 1. Fazer um Fork
Primeiro, faça um fork deste repositório para sua conta do GitHub.

### 2. Criar um cluster no serviço da AWS - EKS

Criar um cluster no EKS 

### 3. Cadastrar as Chaves no GitHub

Para que o Terraform e os workflows do GitHub Actions funcionem corretamente, será necessário cadastrar as credenciais da AWS no repositório do GitHub. Siga os passos abaixo:

1. No repositório GitHub, acesse **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
2. Adicione as seguintes chaves e valores:

- `AWS_ACCESS_KEY_ID`: Sua chave de acesso (Access Key ID) da AWS. 
- `AWS_SECRET_ACCESS_KEY`: Sua chave secreta (Secret Access Key) da AWS.
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
