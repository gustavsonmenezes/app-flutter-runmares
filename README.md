# 🏃 RunMares

Aplicativo mobile de rastreamento de atividades físicas (corrida, caminhada e bicicleta), desenvolvido em **Flutter**.

O RunMares registra o percurso do usuário por **GPS**, calcula distância, tempo e ritmo em tempo real, desenha o trajeto no mapa e guarda tudo no aparelho, para funcionar mesmo **sem internet**. Quando há conexão, as atividades são sincronizadas com a nuvem.

> Projeto da disciplina **Desenvolvimento Mobile** (Projeto 1.1 – Proposta do Aplicativo).

**Protótipo no Figma:** https://www.figma.com/design/PV7OfjBTa9xMMawmeFSMpe/runmarestela

---

## 👥 Integrantes

| Nome | GitHub |
|---|---|
| Gustavson Barros | [@gustavsonmenezes](https://github.com/gustavsonmenezes) |

---

## 🎯 Problema e proposta

Muitas pessoas querem acompanhar a evolução nos treinos, mas dependem de apps que exigem internet constante ou são complexos demais. Em parques, áreas rurais e trilhas, com sinal fraco, o registro de um treino pode falhar. O RunMares oferece um registro simples e confiável de atividades, com foco em **funcionamento offline** e **estatísticas claras**.

- **Público-alvo:** corredores, caminhantes e ciclistas iniciantes ou amadores.
- **Diferencial:** gravação e consulta de atividades sem depender de conexão.

---

## ✅ Funcionalidades

| ID | Funcionalidade | Situação |
|---|---|---|
| RF01 | Cadastro, login e sessão (e-mail e senha) | Implementado |
| RF02 | Iniciar, pausar, retomar e finalizar uma atividade | Implementado, validação em celular real pendente |
| RF03 | Distância, tempo e ritmo médio em tempo real | Implementado, validação em celular real pendente |
| RF04 | Trajeto no mapa, ao vivo e depois de finalizada a atividade | Implementado, validação em celular real pendente |
| RF05 | Salvar no aparelho, sincronizar com a nuvem e recuperar atividade interrompida | Implementado |
| RF06 | Listar o histórico e ver os detalhes de cada atividade | Implementado |
| RF07 | Estatísticas semanais e mensais | Implementado |

Além dos requisitos, o app tem uma tela **Início** com o resumo da semana e as últimas atividades.

### Como cada parte funciona

- **Gravação:** o GPS é lido continuamente. Pontos imprecisos (precisão pior que 25 m), saltos impossíveis (acima de 72 km/h) e tremidas menores que 3 m são descartados. Cada pausa abre um trecho novo, para o deslocamento durante a pausa não entrar na conta. No Android, um serviço em primeiro plano (com notificação) mantém a gravação com a tela apagada.
- **Armazenamento local:** a atividade e os pontos do trajeto são salvos em um banco SQLite (Drift), em uma única transação. Cada atividade pertence a um usuário, e o histórico mostra só as do usuário logado.
- **Atividade interrompida:** durante a gravação, cada ponto aceito também vai para um rascunho no banco. Se o app for fechado no meio de uma atividade, a tela Início oferece salvar o que foi registrado.
- **Sincronização:** as atividades pendentes são enviadas ao Cloud Firestore ao finalizar, ao abrir o app, a cada minuto e quando o app volta ao primeiro plano. O identificador de cada atividade é o horário de início, então reenviar não duplica. O histórico mostra se cada atividade já foi sincronizada.
- **Estatísticas:** totais de distância, tempo e número de atividades por semana (segunda a domingo) ou por mês, com gráfico de barras. São calculadas do banco local, então não dependem de internet.

---

## 🛠️ Tecnologias

- **Flutter** (Dart). Testado com Flutter 3.41.3 e Dart 3.11.1.
- **Recurso do dispositivo:** GPS (`geolocator`)
- **API externa:** Firebase Authentication e Cloud Firestore
- **Armazenamento local:** SQLite com Drift
- **Mapa:** `flutter_map` com tiles do OpenStreetMap

| Pacote | Uso |
|---|---|
| `geolocator` | Localização por GPS e serviço em primeiro plano |
| `flutter_map`, `latlong2` | Mapa e trajeto |
| `drift`, `drift_flutter` | Banco de dados local |
| `firebase_core`, `firebase_auth`, `cloud_firestore` | Login e sincronização |
| `flutter_riverpod` | Gerenciamento de estado |
| `go_router` | Navegação e proteção das rotas |

---

## 📱 Telas

1. Login e cadastro
2. Início (resumo da semana e últimas atividades)
3. Gravar atividade (mapa ao vivo, distância, tempo e ritmo)
4. Histórico
5. Detalhes da atividade (trajeto no mapa e métricas)
6. Perfil e estatísticas (semana e mês)
7. Configurações

---

## 🗂️ Organização do código

O código é organizado por funcionalidade. Cada uma tem as suas camadas (`domain`, `data` e `presentation`) quando precisa delas.

```
lib/
├── main.dart
├── firebase_options.dart
├── app/                 # App, tema e rotas
│   ├── router/
│   └── theme/
├── core/                # Código compartilhado
│   ├── constants/
│   ├── database/        # Banco Drift (tabelas e migrações)
│   ├── formatters/
│   └── widgets/         # Mapa reutilizável
└── features/
    ├── auth/            # Login, cadastro e sessão
    ├── history/         # Histórico e detalhes
    ├── home/            # Tela Início
    ├── profile/         # Perfil
    ├── recording/       # Gravação, GPS e rascunho
    ├── settings/        # Configurações
    ├── statistics/      # Estatísticas
    └── sync/            # Sincronização com o Firestore

test/                    # Espelha a estrutura de lib/
```

---

## 🚀 Como rodar o projeto

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal *stable*)
- [Android Studio](https://developer.android.com/studio) com o plugin do Flutter e o Android SDK
- Um **celular Android** com depuração USB ativada (recomendado) ou um emulador
- Git

Confira se está tudo certo:

```bash
flutter doctor
```

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/gustavsonmenezes/app-flutter-runmares.git

# 2. Entre na pasta do projeto
cd app-flutter-runmares

# 3. Baixe as dependências
flutter pub get

# 4. Veja os dispositivos disponíveis
flutter devices

# 5. Rode o app
flutter run
```

### Observações

- **O app já vem configurado para o projeto Firebase da equipe** (`android/app/google-services.json` e `lib/firebase_options.dart` estão no repositório). Essas chaves identificam o app e não são segredos: a proteção dos dados está nas regras de segurança do Firestore (veja abaixo). Para usar outro projeto Firebase, rode `flutterfire configure`.
- **O primeiro login precisa de internet.** Depois, a sessão fica salva e o app abre offline.
- **O mapa precisa de internet** para baixar o fundo. O trajeto, as métricas e o histórico funcionam sem conexão, mas sem sinal o fundo do mapa fica cinza.
- **Teste o GPS em um celular real.** O emulador simula rotas, mas não representa bem o GPS, a bateria nem a gravação com a tela apagada.
- Ao abrir a gravação pela primeira vez, **permita o acesso à localização**.
- O arquivo `lib/core/database/app_database.g.dart` é gerado pelo Drift e fica no repositório. Só é preciso regerá-lo ao mudar as tabelas: `dart run build_runner build`.
- **iOS:** as permissões estão no `Info.plist`, mas o Firebase foi configurado apenas para Android. Compilar para iPhone exige um Mac com Xcode.

### 🧪 Testes

```bash
dart format .
flutter analyze
flutter test
```

O projeto tem mais de 120 testes automatizados (cálculo de distância e ritmo, banco de dados em memória, sincronização, recuperação de atividade, estatísticas e navegação).

---

## ☁️ Dados na nuvem

As atividades ficam no Cloud Firestore, separadas por usuário:

```
users/{uid}/activities/{id da atividade}
users/{uid}/activities/{id}/routeChunks/{0000, 0001, ...}
```

O trajeto vai em partes de 500 pontos (`routeChunks`), por causa do limite de 1 MiB por documento do Firestore. As regras de segurança permitem que cada usuário leia e escreva somente os próprios dados:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---


## 🗂️ Organização do trabalho

- **Quadro:** aba *Projects* deste repositório (Kanban: Backlog, Ready, In progress, In review, Done)
- **Tarefas:** aba *Issues* (uma issue por requisito funcional)
- **Sprints:** *Milestones* de 15 dias
- **Branches:** `main` (estável) e uma branch por tarefa (`feature/nome-da-funcionalidade`), integrada por pull request

---

## 📌 Status

🚧 Em desenvolvimento. Todos os requisitos funcionais estão implementados; faltam a validação em celular real e os ajustes finais.

---

## 📄 Licença

Projeto acadêmico, sem fins comerciais.