# Projetomodulo4ADA - IAC 
> O projeto tem como objetivo subir duas aplicações e 3 serviços (cache, armazenamento e filas)
>
- Configuração:
- - Instalar e configura o Terraform
  
- - Fazer o download dos arquivos ou realizar o clone
- - Inserir os dados de acesso a conta AWS e demais informações no terraform.tfvars
    
- - Abrir o terminal (sugestão o vscode)
  - Acessar o diretorio onde foram salvos/clonados os arquivos .tf

Dentro do terminal executar o comando

    $ terraform init

Validar o codigo

    $ terraform validate
    
Executar o comando para verificar quais ações serão realizadas

    $ terraform plan
    
Executar o comando, confirmar suas ações e aguardar a conclusão e verificar na console da AWS os recursos criados e configurados

    $ terraform apply
    
Comandos para deletar os recursos criados

    $ terraform destroy 
