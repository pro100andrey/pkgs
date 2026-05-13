# scripts/ — система обновления пакетов

- `update` — главный скрипт, принимает имя пакета или all
- `<pkg>/update.sh` — логика обновления для каждого пакета

## Пример использования

    ./scripts/update llama-pkg
    ./scripts/update visual-studio-code
    ./scripts/update all

## Как добавить новый пакет
1. Создайте папку scripts/<pkg>/
2. Добавьте update.sh с логикой обновления
3. Сделайте скрипт исполняемым: chmod +x scripts/<pkg>/update.sh
