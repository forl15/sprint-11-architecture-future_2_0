# sprint-11-architecture-future_2_0

Решение по архитектуре «Будущее 2.0»: целевая архитектура, домены и потоки данных, технологический радар с роадмапом и облачная инфраструктура на Terraform.

## Task 1 — Целевая архитектура

C4-диаграмма контейнеров и приоритизация проблем бизнеса.

| Файл | Назначение |
|---|---|
| [`Task1/architecture-c4-container.drawio`](Task1/architecture-c4-container.drawio) | C4-диаграмма контейнеров целевой архитектуры: портал, домены, платформа данных, интеграция и внешние системы. |
| [`Task1/problems-and-prioritization.md`](Task1/problems-and-prioritization.md) | Бизнес-сценарии, перечень проблем текущей архитектуры и их приоритизация. |

## Task 2 — Домены и потоки данных

Data Flow Diagram и аргументация границ доменов.

| Файл | Назначение |
|---|---|
| [`Task2/data-flow-diagram.drawio`](Task2/data-flow-diagram.drawio) | Диаграмма потоков данных между доменами, источниками и аналитическим контуром. |
| [`Task2/domain-decomposition.md`](Task2/domain-decomposition.md) | Обоснование границ доменов, ответственности владельцев данных и преимуществ декомпозиции. |

## Task 3 — Технологический радар и роадмап

Сводный радар технологий, план изменений по волнам и интерактивный сайт радара.

| Файл | Назначение |
|---|---|
| [`Task3/technology-radar.md`](Task3/technology-radar.md) | Сводное описание радара: технологии по квадрантам, статусы и обоснование выбора. |
| [`Task3/roadmap.md`](Task3/roadmap.md) | Роадмап на 12+ месяцев: волны изменений, результаты, команды и ресурсы, KPI, SLA/RTO/RPO, зависимости и бизнес-обоснование. |
| [`Task3/roadmap.drawio`](Task3/roadmap.drawio) | Визуальная схема роадмапа: 4 волны × 3 оси (портал / независимость подразделений / качество мед- и фин-сервисов). |
| [`Task3/tech_radar/`](Task3/tech_radar/) | Исходники и сборка интерактивного сайта радара. Запуск — `npm run serve`. |

## Task 4 — Облачная инфраструктура (Terraform)

Инфраструктура в Yandex Cloud: VPC с публичной и приватной подсетями, NAT Gateway, Security Groups, Bastion и Data Platform VM с дисками.

| Файл | Назначение |
|---|---|
| [`Task4/main.tf`](Task4/main.tf) | Описание инфраструктуры. |
| [`Task4/variables.tf`](Task4/variables.tf) | Переменные. |
| [`Task4/outputs.tf`](Task4/outputs.tf) | Ключевые параметры после применения. |
| [`Task4/terraform.tfvars`](Task4/terraform.tfvars) | Значения переменных для окружения. |
| [`Task4/diagram.drawio`](Task4/diagram.drawio) | Диаграмма автоматизации. |
| [`Task4/diagram.png`](Task4/diagram.png) | Экспорт диаграммы автоматизации. |
| [`Task4/justification.md`](Task4/justification.md) | Обоснование конфигурации. |
| [`Task4/.terraform.lock.hcl`](Task4/.terraform.lock.hcl) | Lock-файл провайдера `yandex-cloud/yandex` версии `0.244.0` с контрольными суммами для Windows и Linux. |
| [`Task4/terraform_apply_screenshot.png`](Task4/terraform_apply_screenshot.png) | Скриншот успешного `terraform apply`. |
