# Minha Lista

Aplicativo de lista de compras desenvolvido com Flutter.

O objetivo do projeto é facilitar a organização de compras, permitindo criar listas e adicionar itens de forma simples e prática.

## Funcionalidades

- Criação de listas de compras
- Adição e visualização de itens em cada lista
- Organização de itens por lista
- Marcação de itens como comprados, retirados ou concluídos
- Desmarcação de itens quando necessário
- Armazenamento local de dados
- Interface compatível com Android, iOS e Web

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite
- Sqflite

## Observação sobre a versão Web

A versão web está disponível para demonstração e testes da interface.

No navegador, o banco de dados é recriado sempre que o aplicativo é iniciado novamente. Por esse motivo, as listas e os itens cadastrados não são mantidos entre diferentes execuções do app.

Durante a mesma execução, incluindo o uso de hot reload, os dados permanecem disponíveis.

## Como executar o projeto

### Pré-requisitos

Antes de começar, é necessário ter o Flutter instalado e configurado no computador.

Verifique a instalação com:

```bash
flutter doctor
```

### Instalação

Clone este repositório:

```bash
git clone [https://github.com/bfritschrenan-jpg/app-minha-lista.git](https://github.com/bfritschrenan-jpg/app-minha-lista.git)
```

Entre na pasta do projeto:

```bash
cd app-minha-lista
```

Instale as dependências:

```bash
flutter pub get
```

Execute o aplicativo em um dispositivo ou emulador:

```bash
flutter run
```

## Executar no navegador

Para testar a versão web no Google Chrome:

```bash
flutter run -d chrome
```

## Estrutura do projeto

```text
lib/
├── assets/         # Recursos visuais do aplicativo
├── database/       # Banco de dados e persistência local
├── page/           # Telas do aplicativo
├── card_item.dart  # Componente visual de cada item da lista, incluindo
│                   # nome do item e controle para marcar como concluído
└── main.dart       # Ponto de entrada do app
```

## Autor

Desenvolvido por Renan Fritsch.

## Licença

Projeto desenvolvido para fins de estudo e aprendizado.