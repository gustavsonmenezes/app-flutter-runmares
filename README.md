# 🏃 RunMares

Aplicativo mobile de rastreamento de atividades físicas (corrida, caminhada e bicicleta), desenvolvido em **Flutter** para **Android e iOS**.

O RunMares registra o percurso do usuário por **GPS**, calcula distância, tempo e ritmo em tempo real, desenha o trajeto no mapa e guarda tudo no aparelho, para funcionar mesmo **sem internet**.

> Projeto da disciplina **Desenvolvimento Mobile** 

---

## 👥 Integrantes

| Nome | GitHub |
|---|---|
| Gustavson Barros | [@usuario](https://github.com/gustavsonmenezes) |


---

## 🎯 Problema e proposta

Muitas pessoas querem acompanhar a evolução nos treinos, mas dependem de apps que exigem internet constante ou são complexos demais. O RunMares oferece um registro simples e confiável de atividades, com foco em **funcionamento offline** e **estatísticas claras**.

- **Público-alvo:** corredores, caminhantes e ciclistas iniciantes ou amadores.
- **Diferencial:** gravação e consulta de atividades sem depender de conexão.

---

## ✅ Funcionalidades 

| ID | Funcionalidade |
|---|---|
| RF01 | Cadastro e login do usuário |
| RF02 | Iniciar, pausar e finalizar uma atividade |
| RF03 | Calcular distância, tempo e ritmo em tempo real |
| RF04 | Exibir o trajeto no mapa |
| RF05 | Salvar atividades localmente e sincronizar com a nuvem |
| RF06 | Listar o histórico e ver os detalhes de cada atividade |
| RF07 | Mostrar estatísticas semanais e mensais |

---

## 🛠️ Tecnologias

- **Flutter** (Dart) – Android e iOS
- **Recurso do dispositivo:** GPS
- **API externa:** Supabase ou Firebase (login e sincronização) e OpenStreetMap (mapa)
- **Armazenamento local:** Drift (SQLite)


## 📱 Telas previstas

1. Login / Cadastro
2. Início (Home)
3. Gravar atividade
4. Mapa do trajeto
5. Histórico e detalhes da atividade
6. Perfil e estatísticas
7. Configurações

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
git clone https://github.com/gustavsonmenezes/runmares.git

# 2. Entre na pasta do projeto
cd runmares

# 3. Baixe as dependências
flutter pub get

# 4. Veja os dispositivos disponíveis
flutter devices

# 5. Rode o app
flutter run
```

### Observações

- **Teste o GPS em um celular real.** O emulador simula rotas, mas não representa bem o GPS e a bateria.
- Ao abrir o app pela primeira vez, **permita o acesso à localização**.
- Se o projeto usar Supabase ou Firebase, as chaves de acesso ficam em um arquivo de configuração **que não é enviado ao GitHub**. Peça o modelo (`.env.example`) a um integrante.
- Para iOS é necessário um Mac com Xcode. As permissões ficam no `Info.plist`.

---

## 🗂️ Organização do projeto

- **Quadro:** aba *Projects* deste repositório (Kanban: A fazer, Fazendo, Em revisão, Feito)
- **Tarefas:** aba *Issues* (uma issue por requisito funcional)
- **Sprints:** *Milestones* de 15 dias
- **Branches:** `main` (estável) e `feature/nome-da-funcionalidade`

---

## 📌 Status

🚧 Em desenvolvimento – fase de proposta.

---

## 📄 Licença

Projeto acadêmico, sem fins comerciais.
