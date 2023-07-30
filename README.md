<h1>Rebase Labs</h1> 

<p align="center">

  <img src="http://img.shields.io/static/v1?label=Ruby&message=2.6.3&color=red&style=for-the-badge&logo=ruby"/>
  <img src="http://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=RED&style=for-the-badge"/>
</p>


### Tech Stack

* Docker
* Ruby
* Javascript
* HTML

### Tópicos 

:small_blue_diamond: [Descrição do projeto](#descrição-do-projeto)

:small_blue_diamond: [Pré-requisitos](#pré-requisitos)

:small_blue_diamond: [Como rodar a aplicação](#como-rodar-a-aplicação-arrow_forward)

## Descrição do projeto 

<p align="justify">
 
Uma app web para listagem de exames médicos, o usuário pode acessar detalhes de cada exame (que possui um token único). O usuário também pode pesquisar por um token e ser redirecionado para a página de detalhes deste token. Além disso o usuário pode importar um arquivo csv, este arquivo será processado de forma assíncrona pelo sidekiq.

  O projeto possui 3 endpoints:
1) O primeiro lê os dados de um arquivo CSV e renderiza no formato JSON:
![jsontests](https://github.com/BrunoSGuima/rebase-labs/assets/105590450/0aff64f9-b7cb-46a5-9799-fb047b7c546a)

2) O segundo endpoint devolve uma listagem dos exames em JSON já agrupada:
![jsonexamstoken](https://github.com/BrunoSGuima/rebase-labs/assets/105590450/aa939738-4ded-4a97-9309-c03c568a6e20)

3) O terceiro endpoint devolve um exame específico a partir do token:
![jsonexamstoken](https://github.com/BrunoSGuima/rebase-labs/assets/105590450/f5653eb5-04d9-469b-ac28-b0bd48ca0c4b)

Então temos a index que lista todos os pacientes, médicos e exames:
![index](https://github.com/BrunoSGuima/rebase-labs/assets/105590450/c1125d39-e65a-4308-ae89-73d1159c4ddf)

Ao clicar em detalhes em um exame específico, o usuário é retornado para outra página com mais detalhes do paciente, médico e exame:
![exam_details](https://github.com/BrunoSGuima/rebase-labs/assets/105590450/c02ecd1d-8157-4fe5-afab-b140fc947c8a)

Caso o resultado do exame esteja dentro dos limites, o usuário verá um ícone (check) verde. Caso esteja abaixo ou acima dos limites, o usuário verá um ícone (exclamação) vermelho.

  
## Pré-requisitos

Ruby 2.7.0 ou superior
Gem sinatra
Gem rack
Gem puma
Gem sidekiq
Gem redis
Gem pg

## Como rodar a aplicação :arrow_forward:

1. Clone o repositório para o seu local de trabalho:

git clone https://github.com/BrunoSGuima/rebase-labs.git

2. Navegue até a pasta do projeto:

cd rebase-labs

3. Instale as dependências do projeto:

bundle install

4. Rode o docker-compose:
docker-compose up

5. Abra o [local](http://localhost:3000/)
Clique em 'browse', na página do projeto selecione o arquivo "data.csv", e então clique em 'Importar CSV'.
Aguarde enquanto o Sidekiq processa o arquivo.
Atualize a página.


## Licença 

The [MIT License]() (MIT)

Copyright :copyright: 2023 - Rebase Labs
