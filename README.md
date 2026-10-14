# 🏃 RunMares

Aplicativo mobile de rastreamento de atividades físicas (corrida, caminhada e bicicleta), desenvolvido em **Flutter** com design profissional inspirado no **Strava** e suporte a **Coach Virtual por Inteligência Artificial (Google Gemini)**.

O RunMares registra o percurso do usuário por **GPS**, calcula distância, tempo e ritmo em tempo real, desenha o trajeto no mapa com **mapa de calor por velocidade (Pace Heatmap)**, narra os marcos de quilometragem por voz (**Audio Cues em Português**) e guarda tudo no aparelho para funcionar **100% offline**. Quando há conexão, as atividades são sincronizadas com a nuvem e enriquecidas com **dados de clima da Open-Meteo API**.

> Projeto da disciplina **Desenvolvimento Mobile** (Projeto 1.1 – Proposta do Aplicativo).

**Protótipo no Figma:** https://www.figma.com/design/PV7OfjBTa9xMMawmeFSMpe/runmarestela

---

## 👥 Integrantes

| Nome | GitHub |
|---|---|
| Gustavson Barros | [@gustavsonmenezes](https://github.com/gustavsonmenezes) |

---

## 🎯 Problema e Proposta

Muitas pessoas querem acompanhar a evolução nos treinos, mas dependem de apps que exigem internet constante ou são complexos demais. Em parques, áreas rurais e trilhas com sinal fraco, o registro de um treino pode falhar. O RunMares oferece um registro simples, confiável e profissional de atividades, com foco em **funcionamento offline**, **estatísticas claras** e **análise personalizada por IA**.

- **Público-alvo:** corredores, caminhantes e ciclistas iniciantes ou amadores.
- **Diferencial:** gravação e consulta offline, mapas Mapbox HD, Pace Heatmap, narração por voz a cada km, estatísticas visuais e Coach de IA sem custos.

---

## ✅ Funcionalidades Implementadas

| ID | Funcionalidade | Situação |
|---|---|---|
| RF01 | Cadastro, login e sessão (e-mail e senha) | Implementado |
| RF02 | Iniciar, pausar, retomar e finalizar uma atividade | Implementado |
| RF03 | Distância, tempo, ritmo médio (pace) e pace atual em tempo real | Implementado |
| RF04 | Trajeto no mapa ao vivo e mapa de calor de velocidade (Pace Heatmap) | Implementado |
| RF05 | Salvar no aparelho (Drift SQLite), sincronizar com a nuvem e recuperar rascunho de atividade interrompida | Implementado |
| RF06 | Listar o histórico, ver detalhes, clima do treino e gerar cards para Instagram/WhatsApp | Implementado |
| RF07 | Estatísticas semanais e mensais com gráficos em pílula (`fl_chart`) | Implementado |
| RF08 | Coach de IA Pessoal (Google Gemini) com análise de treino e dicas de recuperação | Implementado |
| RF09 | Audio Cues em Português (narração de distância, tempo e pace a cada 1 km via TTS) | Implementado |
| RF10 | Seletor de Tema (Modo Escuro Strava / Modo Claro / Sistema) e Seletor de Mapa Mapbox | Implementado |

---

## 🚀 Diferenciais de Destaque do RunMares

- 🤖 **Coach de IA Pessoal (Google Gemini)**: Analisa o ritmo, distância e esforço do treino para gerar feedbacks humanos, motivacionais e dicas de recuperação pós-treino (100% gratuito e com fallback offline).
- 🎙️ **Audio Cues (Feedback por Voz)**: Narração em português do Brasil a cada quilômetro completado (`flutter_tts`) para treino de olhos livres.
- 🗺️ **Pace Heatmap & Mapbox HD**: A rota no mapa é colorida dinamicamente pela velocidade (Verde = Rápido, Laranja = Médio, Vermelho = Lento) com estilos Mapbox (Escuro, Terreno e Satélite).
- 🌤️ **Clima e Temperatura da Corrida (Open-Meteo API)**: Registra automaticamente a temperatura (°C), vento e clima no momento do treino.
- 📸 **Gerador de Cards para Redes Sociais**: Gera uma imagem estilizada da corrida formatada para os Stories do Instagram ou WhatsApp com 1 toque.
- 🌙 **Design System Strava & Dark Mode**: Interface moderna em tom carbono (`#0F172A`), acentos em Laranja Strava (`#FC4C02`) e números tabulares (`FontFeature.tabularFigures()`).

---

## 🛠️ Tecnologias e Pacotes

- **Flutter / Dart** (compatível com Android e iOS).
- **Recursos do dispositivo:** GPS (`geolocator`), Síntese de Voz (`flutter_tts`), Wake Lock (`wakelock_plus`) e Notificação Foreground.
- **APIs externas:** Google Gemini AI API (`google_generative_ai`), Open-Meteo Weather API (`http`), Mapbox Vector Tiles API (`flutter_map`) e Firebase Auth / Cloud Firestore.
- **Armazenamento local:** SQLite tipado com **Drift**.
- **Gráficos e Animações:** `fl_chart`, `flutter_animate`, `google_fonts`.
- **Compartilhamento:** `share_plus`, `screenshot`, `path_provider`.

| Pacote | Uso Principal |
|---|---|
| `geolocator` | Rastreamento GPS e serviço em primeiro plano |
| `flutter_map`, `latlong2` | Renderização de mapas com suporte a Mapbox |
| `fl_chart` | Gráficos de barras interativos com gradiente |
| `flutter_tts` | Narração por voz a cada 1 km em português |
| `google_generative_ai` | Inteligência Artificial do Coach Virtual (Gemini) |
| `http` | Consulta da API de clima Open-Meteo |
| `drift`, `drift_flutter` | Banco de dados SQLite local (Offline-First) |
| `firebase_core`, `firebase_auth`, `cloud_firestore` | Autenticação e sincronização na nuvem |
| `flutter_riverpod` | Gerenciamento de estado reativo |
| `go_router` | Navegação declarativa e proteção de rotas |
| `wakelock_plus` | Manter a tela acesa durante a corrida |
| `share_plus`, `screenshot` | Geração de imagem e compartilhamento nos Stories |

---

## 📱 Telas do Aplicativo (8 Telas)

1. **Abertura / Splash Animada**: Logotipo do RunMares com efeito de iluminação e transição em *fade-out*.
2. **Login**: Autenticação com e-mail e senha no Firebase.
3. **Cadastro**: Criação de nova conta de atleta.
4. **Início (Dashboard)**: Hero Card para iniciar treino, gráfico semanal em pílula e feed de corridas com cards estilo Strava.
5. **Gravar Atividade (Recorder)**: Cronômetro tabular gigante, mapa ao vivo com Pace Heatmap, botão de recentralizar (🎯) e controle de pausar/finalizar.
6. **Histórico**: Lista de todas as corridas gravadas com filtro e badge de status de sincronização.
7. **Detalhes da Atividade**: Mapa de calor por ritmo, métricas completas, badge de clima (`🌤️ 24°C`), Card do Coach IA (Gemini) e botão de compartilhamento social.
8. **Configurações**: Seletor de Tema (Claro / Escuro / Sistema), Unidade de medida (km / mi), Tipo de mapa (Mapbox), liga/desliga Audio Cues e logout.
9. **Perfil**: Estatísticas acumuladas da conta do usuário.

---

## 🗂️ Organização do Código

```
lib/
├── main.dart            # Inicialização e captura de erros globais
├── firebase_options.dart
├── app/                 # Configuração de temas, cores, tipografia e rotas
│   ├── router/
│   └── theme/
├── core/                # Componentes globais e banco de dados
│   ├── constants/
│   ├── database/        # Banco SQLite com Drift (tabelas e migrações)
│   ├── formatters/
│   └── widgets/         # Mapa reutilizável com suporte a Mapbox e Pace Heatmap
└── features/
    ├── ai_coach/        # Coach de Inteligência Artificial (Gemini + Local Engine)
    ├── auth/            # Login, cadastro, sessão e Splash animada
    ├── history/         # Histórico, detalhes e Card de Compartilhamento Social
    ├── home/            # Dashboard inicial e resumo semanal
    ├── profile/         # Perfil e estatísticas
    ├── recording/       # Gravação GPS, Audio Cues (TTS), rascunho e controle
    ├── settings/        # Configurações de tema, mapa, unidades e áudio
    ├── statistics/      # Calculadora e gráficos `fl_chart`
    ├── sync/            # Sincronização em segundo plano com o Firestore
    └── weather/         # Consulta de clima/temperatura da Open-Meteo API

test/                    # Mais de 180 testes automatizados
```

---

## 🚀 Como Rodar o Projeto

```bash
# 1. Clone o repositório
git clone https://github.com/gustavsonmenezes/app-flutter-runmares.git

# 2. Entre na pasta do projeto
cd app-flutter-runmares

# 3. Baixe as dependências
flutter pub get

# 4. Rode o aplicativo
flutter run --dart-define=GEMINI_API_KEY="SUA_CHAVE_GEMINI"
```

---

## 🧪 Testes Automatizados

```bash
dart format .
flutter analyze
flutter test
```

O projeto possui **mais de 180 testes automatizados** cobrindo cálculo de velocidade e pace, gerador de cores de ritmo, rastreador de áudio, banco de dados SQLite em memória, sincronização Firestore, persistência de preferências, validação de formulários e navegação de telas.

---

## 📊 Matriz de Atendimento aos Requisitos Mínimos

| Requisito Mínimo | Como a proposta atende | Onde aparece (tela ou funcionalidade) |
| :--- | :--- | :--- |
| **Pelo menos 6 telas diferentes** | O aplicativo possui 8 telas distintas: Login, Cadastro, Início/Dashboard, Gravação de Atividade, Histórico, Detalhes da Atividade, Configurações e Perfil. | Navegação em todo o app via GoRouter. |
| **Integração com API do dispositivo (GPS, Sensores, etc.)** | Utiliza GPS nativo para rastreamento de rota, Síntese de Voz (TTS) para narração a cada 1 km, Wake Lock para manter a tela acesa e Notificação Foreground. | Tela de Gravação (`RecordingPage`) e serviço de Audio Cues. |
| **Integração com API externa** | Consome a API do Google Gemini para o Coach de IA, a API do Open-Meteo para Clima/Temperatura, a API do Mapbox para mapas HD e Firebase Auth/Firestore. | Tela de Detalhes (`ActivityDetailsPage`), Card Social e `AiCoachService`. |
| **Armazenamento local com acesso offline** | Utiliza banco de dados SQLite nativo através do pacote Drift, gravando corridas e rascunhos com suporte 100% Offline-First antes de sincronizar na nuvem. | Repositório Local (`DriftActivityRepository` / SQLite) e sincronização assíncrona. |
| **Flutter para Android e iOS** | Desenvolvido em Flutter com código limpo em Dart e permissões multiplataforma configuradas em AndroidManifest.xml. | Todo o código-fonte em Dart/Flutter. |
| **Grupo de 3 ou 4 integrantes e repositório no GitHub** | Projeto mantido em repositório no GitHub com versionamento por branches de funcionalidades e Pull Requests. | Repositório no GitHub. |

---

## 📄 Licença

Desenvolvido por Gustavson Barros.
