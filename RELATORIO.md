# Relatório - Aplicativo de livros

## Ideia escolhida

Escolhi a ideia D: gerenciar livros lidos, desejados e Top 5, com imagem do ranking para compartilhar.

## Aula 1 - 16/11/2026

### Passo 1: criação do projeto

- Abri a pasta do projeto no VS Code e confirmei que o Flutter estava disponível.
- Rodei `flutter create .` para criar a base do app dentro da pasta atual.
- Verifiquei os pacotes instalados no `pubspec.yaml` e confirmei a necessidade deles para o app.

### Passo 2: organização e estrutura

- Criei as pastas pedidas: `lib/models`, `lib/services`, `lib/screens` e `lib/widgets`.
- Separamos a lógica do modelo, dos serviços e da interface.
- Mantive a estrutura simples e direta, como um estudante faria.

### Passo 3: persistência local

- Usei `shared_preferences` para salvar a lista de livros em formato JSON.
- A operação funciona na web e no celular, porque o Flutter trata isso de forma compatível.
- Cada livro guarda id, título, autor, status, nota, data de leitura e observação opcional.

### Passo 4: telas principais

- Criei a tela de lista com abas para Lidos e Desejados.
- Adicionei barra de busca por título ou autor.
- Criei a tela de cadastro e edição de livros.
- Incluí confirmação antes da exclusão.
- Criei a tela de Top 5, com card visual e botão de compartilhamento.

### Passo 5: compartilhamento da imagem

- Usei `RepaintBoundary` para capturar o ranking visual.
- Gerei PNG em memória com `toImage` e `XFile.fromData`.
- Usei `SharePlus.instance.share` com `ShareParams`.
- No navegador, quando o compartilhamento não é suportado, usei fallback com download da imagem pela web.

### Passo 6: análise e correção

- Rodei `flutter analyze` e corrigi os erros reais do projeto.
- Apliquei a correção do `RenderRepaintBoundary`, ajustes de null safety e o uso correto do `BuildContext` em async.
- Também corrigi o widget de seleção de status para que a análise ficasse limpa.

### Passo 7: testes

- Criei um teste simples do widget para verificar que a app inicializa.
- Rodei `flutter test` e o resultado foi positivo.

## Configurações e comandos usados

### Comandos principais

```bash
flutter create .
flutter pub add shared_preferences share_plus path_provider
flutter analyze
flutter test
flutter run -d chrome
```

### Configurações importantes

- `pubspec.yaml` com Flutter SDK e dependências confirmadas.
- `ThemeData(useMaterial3: true)` para visual em Material 3.
- Persistência com `SharedPreferences` e conversão JSON manual.
- `RepaintBoundary` para exportar imagem do Top 5.

## Pacotes e motivo de uso

| Pacote | Versão instalada | Motivo |
|---|---:|---|
| `shared_preferences` | `^2.5.6` | Salvar a lista de livros localmente em JSON |
| `share_plus` | `^13.3.1` | Compartilhar a imagem do ranking |
| `path_provider` | `^2.1.6` | Mantém a estrutura de suporte para arquivos locais e compatibilidade do app |

## Estrutura de pastas

```text
lib/
  main.dart
  models/
    livro.dart
  services/
    livro_service.dart
    compartilhamento_imagem.dart
    compartilhamento_imagem_web.dart
  screens/
    lista_livros_screen.dart
    edicao_livro_screen.dart
    top5_screen.dart
  widgets/
    livro_card.dart
    ranking_card.dart
```

## Explicação da programação

### Modelo de livro

O arquivo `lib/models/livro.dart` cria a estrutura principal do objeto. Ele guarda:

- id
- título
- autor
- status
- nota
- data de leitura
- observação

A classe também converte o objeto para JSON e volta do JSON para o objeto, necessário para salvar no `shared_preferences`.

### Serviço de persistência

`lib/services/livro_service.dart` faz a leitura e a gravação da lista no armazenamento local. A lista é salva como texto JSON e lida ao abrir o app.

### Tela de listagem

`lib/screens/lista_livros_screen.dart` monta a aplicação principal com:

- abas para Lidos e Desejados
- campo de busca
- cadastro, edição e exclusão
- listagem em cards
- navegação para a tela de Top 5

### Edição do livro

`lib/screens/edicao_livro_screen.dart` guarda o formulário com os campos de título, autor, status, nota, data e observação. Ao salvar, ele devolve o objeto pronto para a lista.

### Ranking

`lib/screens/top5_screen.dart` filtra só os livros lidos, ordena pela nota e mostra os cinco melhores. O botão de compartilhar gera a imagem do card e envia para o app de compartilhamento.

### Card visual

`lib/widgets/livro_card.dart` e `lib/widgets/ranking_card.dart` deixam a tela mais bonita e organizada, sem exagerar na complexidade.

## Prompts utilizados

### Prompt principal

> Contexto: sou estudante e estou fazendo uma tarefa de Flutter. A tarefa original é:
>
> "Escolha uma das ideias abaixo para fazer um aplicativo FLUTTER. Crie e envie o app para um repositório GIT. Envie o link do repositório na tarefa. Todo fim de aula o git deve ter ao menos um commit. Produzir um relatório RELATORIO.md de tarefas realizadas, sempre atualizado no git, contendo prompts/configurações/programação/etc.
> A) Gerenciar itens usados disponíveis. Compartilhar imagem para WhatsApp com itens disponíveis
> B) Gerenciar remédios para idosos. Compartilhar imagem da agenda de remédios do dia
> C) Gerenciar datas importantes/aniversários. Compartilhar imagem com datas do mês
> D) Gerenciar livros lidos/desejados/top 5. Compartilhar imagem de ranking
> E) Gerenciar games/avaliação/top 5. Compartilhar imagem de ranking de games"
>
> Escolhi a ideia D (livros lidos / desejados / top 5, com imagem de ranking para compartilhar).
>
> Estado atual do projeto:
> - Projeto criado com `flutter create .` na pasta aberta
> - Pacotes instalados: shared_preferences, share_plus (13.x), path_provider
> - Testo no Chrome (`flutter run -d chrome`), pois estou em computador da escola
> - test/widget_test.dart aponta para o MyApp antigo e gera erro; remova ou reescreva
>
> Estilo do código (importante):
> - Escreva como um estudante de nível intermediário escreveria: simples, direto, sem sofisticação desnecessária.
> - Nomes de classes, variáveis e funções em português, curtos e claros.
> - Comentários curtos em português, só onde ajudam a entender. Sem comentários em toda linha.
> - Sem emojis no código, sem cabeçalhos ou frases do tipo "gerado por IA" e sem textos de marketing.
> - Evite abstrações complexas (nada de injeção de dependência, gerenciadores de estado avançados ou padrões pesados). Use StatefulWidget e setState.
>
> O que quero que você faça:
> 1. Organize em pastas: lib/models, lib/services, lib/screens e lib/widgets.
> 2. Modelo Livro: id, título, autor, status (lido/desejado), nota de 1 a 5, data de leitura e observação opcional.
> 3. Persistência local com shared_preferences (JSON), funcionando na web e no celular.
> 4. Telas: lista com abas (Lidos / Desejados), cadastro e edição, exclusão com confirmação, busca por título ou autor e tela Top 5.
> 5. Top 5: ranking dos 5 livros lidos com maior nota em um card visual, com botão Compartilhar que gera PNG com RepaintBoundary.
> 6. Compartilhamento sem dart:io e sem File: bytes em memória com XFile.fromData e ShareParams. Se o navegador não suportar, fazer fallback baixando a imagem.
> 7. Visual com Material 3: tema, cores, ícones e estado vazio com mensagem amigável.
> 8. Rode `flutter analyze` e corrija tudo.
> 9. Crie e mantenha o RELATORIO.md na raiz com: ideia escolhida, passo a passo de cada aula (com data), configurações e comandos usados, pacotes e motivo de cada um, estrutura de pastas, explicação da programação, prompts utilizados (incluindo este prompt completo), ferramentas utilizadas (inclusive a IA do VS Code) e problemas encontrados com as soluções.
>
> Git e GitHub:
> - Eu mesmo vou criar o repositório vazio no GitHub pelo site e publicar. Você não tem acesso à minha conta.
> - Prepare o repositório local: confira se o .gitignore do Flutter está correto e rode `git init` se ainda não existir.
> - Faça o commit local com a mensagem "Aula 1: projeto Flutter com cadastro de livros e Top 5".
> - Ao final, me mostre os comandos exatos para conectar ao GitHub (git remote add origin ... e git push) e uma seção "Como publicar" no RELATORIO.md.
> - Nas próximas aulas, sempre que eu pedir, atualize o RELATORIO.md e prepare um novo commit.
>
> Regras:
> - Explique brevemente cada etapa em português.
> - Não invente pacotes nem APIs; confirme na versão instalada.
> - Ao final, liste os arquivos criados/alterados e os comandos para testar.
>
> corrige os erros

### Prompt de correção

> corrige os erros

## Ferramentas utilizadas

- VS Code
- Flutter SDK
- Git
- GitHub
- GitHub Copilot (IA do VS Code)

## Problemas encontrados e soluções

- O projeto veio com estrutura padrão e o teste antigo apontava para `MyApp`; foi substituído por um teste funcionando.
- O `RepaintBoundary` precisou de import correto e checagem de `null` antes do `toImage`.
- O compartilhamento no web exigiu um fallback em memória com download da imagem, já que o navegador não sempre suporta `SharePlus`.
- A análise final foi ajustada até ficar sem issues.

## Como publicar

1. Crie um repositório vazio no GitHub.
2. No terminal do projeto, rode:

```bash
git status
git add .
git commit -m "Aula 1: projeto Flutter com cadastro de livros e Top 5"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git push -u origin main
```

> Troque o link pelo do seu usuário e do repositório que você criou no GitHub.

## Arquivos criados e alterados

- `lib/main.dart`
- `lib/models/livro.dart`
- `lib/services/livro_service.dart`
- `lib/services/compartilhamento_imagem.dart`
- `lib/services/compartilhamento_imagem_web.dart`
- `lib/screens/lista_livros_screen.dart`
- `lib/screens/edicao_livro_screen.dart`
- `lib/screens/top5_screen.dart`
- `lib/widgets/livro_card.dart`
- `lib/widgets/ranking_card.dart`
- `test/widget_test.dart`
- `RELATORIO.md`

## Comandos para testar

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Estado final do Git

O repositório local foi preparado e o commit foi criado com a mensagem:

```bash
git commit -m "Aula 1: projeto Flutter com cadastro de livros e Top 5"
```

Se você quiser continuar nas próximas aulas, basta abrir o projeto, atualizar o relatório e criar outro commit no mesmo padrão.