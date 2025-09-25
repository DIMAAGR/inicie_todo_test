# TODO APP TEST

# Todo App — Inicie Educação (Flutter)

## Arquitetura

O projeto adota **Feature-First + MVVM + Clean Architecture**:

- **Feature-First:** cada feature organiza seu próprio domínio, dados e apresentação (ex.: `tasks/`, `auth/`).
- **MVVM:** Views (Widgets) interagem com ViewModels (estado e orquestração), que chamam Casos de Uso (regras de negócio).
- **Clean Architecture:** 
  - Camada **Domain** define entidades, contratos de repositório e casos de uso.
  - Camada **Data** implementa esses contratos (datasources locais/remotos, mappers).
  - Camada **Presentation** contém ViewModels, páginas e widgets.

### Regras de Propriedade e Single Source of Truth

- Cada entidade pertence a uma feature.  
  Ex.: `Task` -> `features/tasks`.
- Casos de uso relacionados à entidade ficam na **feature dona**.  
  Ex.: `DeleteTaskUseCase` sempre em `tasks/domain/usecases`.
- Mesmo que múltiplas telas (ex.: Home e Tasks) possam excluir uma task, **elas reutilizam o mesmo caso de uso**.  
  Não há duplicação.
- Isso garante **Single Source of Truth**:
  - Regras centralizadas -> consistência em todo o app.
  - Testes de regra em um único lugar.
  - UI desacoplada (sem lógica de negócio).
  - Evolução fácil (alterar storage ou regra sem quebrar a apresentação).

  ---

## Decisões

- **Riverpod**: gerência de estado e injeção de dependência (testável, escalável).
- **Não microapp/module-based** neste momento:
  - Não há reuso entre apps; microapps adicionariam complexidade sem benefício.
  - Caso o produto evolua para white-label/multi-app, a migração é incremental pois já existe separação por feature.
- **L10n** configurado (PT/ES via gen-l10n).
- **Casos de Uso únicos por regra** (reuso entre telas; propriedade definida pela feature).

### Erros e Resultados (`Either`)
Os casos de uso e repositórios retornam `Either<Failure, T>` (via dartz).  
Motivação: fluxo explícito de falhas sem exceções não-checadas, melhor testabilidade e composição.
Na apresentação, `Either` é convertido para estados de UI (`Loading/Success/Error`).

### Design Patterns adotados

- **MVVM** (Presentation): ViewModels orquestram Casos de Uso e expõem estado imutável para a View.
- **Clean Architecture**: Domínio (contratos/regras) isolado de Data (SDK/IO) via **Repository Pattern**.
- **Factory** (Domínio): construção de entidades garantindo invariantes (ex.: `Task.create(...)`).
- **Mapper** (Data): DTO ↔ Entity sem “vazar” detalhes de serialização para o domínio.
- **Strategy** (Domínio): filtros e ordenações de tarefas como estratégias pluggáveis.
- **Adapter** (DataSource (Infra)): encapsula SDKs (Firestore, Local Notifications) atrás de interfaces.
- **Value Object** (Domínio): tipos para valores com validação embutida (ex.: `TaskTitle`, `DueDate`).

### Performance
- Uso de `compute` para serialização/deserialização JSON em isolates.
- Evita travar o main thread em listas grandes.
- Estratégia simples mas escalável (offline-first + sync no futuro).

## Futuro

- Offline-first (migrar repo impl para local/remote + sync).
- Firebase (auth, firestore, fcm) via providers de infra (troca sem afetar UI).
- Notificações locais → `core/services/notifications` ou `features/notifications` se houver UI própria.

## Como rodar

```bash
flutter pub get
flutter run
```

## 📷 Imagens

<div align="center">
    <img src="/images/1.png" width="400px"</img> 
    <img src="/images/2.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/3.png" width="400px"</img> 
    <img src="/images/4.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/5.png" width="400px"</img> 
    <img src="/images/6.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/7.png" width="400px"</img> 
    <img src="/images/8.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/9.png" width="400px"</img> 
    <img src="/images/10.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/11.png" width="400px"</img> 
    <img src="/images/12.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/13.png" width="400px"</img> 
    <img src="/images/14.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/15.png" width="400px"</img> 
    <img src="/images/16.png" width="400px"</img> 
</div>
<div align="center">
    <img src="/images/17.png" width="400px"</img> 
</div>


Feito com 💙 usando Flutter.