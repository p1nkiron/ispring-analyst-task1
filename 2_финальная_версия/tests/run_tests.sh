#!/usr/bin/env bash
# Проверка: схема создаётся, отчёт даёт ожидаемый результат, некорректные данные отклоняются.
# Подключение берётся из переменных PGHOST, PGUSER, PGPASSWORD, PGDATABASE.
set -u
cd "$(dirname "$0")/.."
fail=0

psql -q -v ON_ERROR_STOP=1 -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" || exit 1
psql -q -v ON_ERROR_STOP=1 -f sql/01_schema.sql || exit 1
psql -q -v ON_ERROR_STOP=1 -f sql/02_seed.sql   || exit 1

# 1. Отчёт совпадает с эталоном
psql --csv -f sql/03_report.sql > /tmp/actual_report.csv || exit 1
if diff -u tests/expected_report.csv /tmp/actual_report.csv; then
  echo "OK  отчёт совпадает с эталоном"
else
  echo "FAIL отчёт отличается от эталона"; fail=1
fi

# 2. Некорректные данные должны отклоняться (каждая строка - отдельный запрос)
n=0
while IFS= read -r line; do
  case "$line" in INSERT*) ;; *) continue ;; esac
  n=$((n+1))
  if psql -q -v ON_ERROR_STOP=1 -c "$line" >/dev/null 2>&1; then
    echo "FAIL БД приняла некорректные данные: $line"; fail=1
  else
    echo "OK  отклонено ($n): ${line:0:70}..."
  fi
done < tests/negative_data.sql

exit $fail
