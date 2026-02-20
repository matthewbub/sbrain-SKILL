#!/usr/bin/env sh
set -eu

API_URL="${SBRAIN_API_URL:-https://sbrain-production.up.railway.app}"
TITLE=""
CONTEXT=""
PROJECT=""
COMMITS=""
TAGS=""

usage() {
  cat <<'USAGE'
Usage:
  sbrain.sh --title "..." --context "..." [options]

Required:
  --title        Brain entry title
  --context      Brain entry context/body
  --project      Project name (optional; defaults to current directory name)

Options:
  --commits      Optional commits metadata
  --tags         Optional tags metadata
  --api-url      Override API base URL (default: SBRAIN_API_URL or https://sbrain-production.up.railway.app)
  -h, --help     Show this help
USAGE
}

json_escape() {
  printf '%s' "$1" | awk '
    BEGIN { ORS = "" }
    {
      gsub(/\\/, "\\\\");
      gsub(/"/, "\\\"");
      gsub(/\r/, "\\r");
      gsub(/\t/, "\\t");
      if (NR > 1) printf "\\n";
      printf "%s", $0;
    }'
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --title)
      TITLE="${2-}"
      shift 2
      ;;
    --context)
      CONTEXT="${2-}"
      shift 2
      ;;
    --project)
      PROJECT="${2-}"
      shift 2
      ;;
    --commits)
      COMMITS="${2-}"
      shift 2
      ;;
    --tags)
      TAGS="${2-}"
      shift 2
      ;;
    --api-url)
      API_URL="${2-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

# Default project to current working directory when not provided.
if [ -z "$PROJECT" ]; then
  PROJECT="$(basename "$PWD")"
fi

if [ -z "$TITLE" ] || [ -z "$CONTEXT" ]; then
  echo "Error: --title and --context are required." >&2
  usage >&2
  exit 1
fi

payload='{"title":"'"$(json_escape "$TITLE")"'","context":"'"$(json_escape "$CONTEXT")"'","project":"'"$(json_escape "$PROJECT")"'","commits":"'"$(json_escape "$COMMITS")"'","tags":"'"$(json_escape "$TAGS")"'"}'

response="$(curl -sS -X POST "${API_URL%/}/brain" \
  -H "content-type: application/json" \
  -d "$payload" \
  -w '\n%{http_code}')"

status_code="$(printf '%s\n' "$response" | tail -n 1)"
response_body="$(printf '%s\n' "$response" | sed '$d')"

case "$status_code" in
  2??)
    printf '%s\n' "$response_body"
    ;;
  *)
    echo "Request failed with HTTP ${status_code}" >&2
    printf '%s\n' "$response_body" >&2
    exit 1
    ;;
esac
