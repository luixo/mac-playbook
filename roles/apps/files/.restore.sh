#!/usr/bin/env zsh

brew services start backrest

# Check RESTIC_PASSWORD
if [[ -z "$RESTIC_PASSWORD" ]]; then
  echo "Error: RESTIC_PASSWORD is not set, you need to restart the shell."
  exit 1
fi

# User selects repository
REPO_CHOICE="$1"
shift

# Set environment variables based on repo choice
case "$REPO_CHOICE" in
  nas)
    export RESTIC_REPOSITORY="sftp:nas:/mnt/user/backups"
    ;;
  yandex)
    export RESTIC_REPOSITORY="s3://storage.yandexcloud.net/luixo-backups"
    if [[ -z "$YA_AWS_ACCESS_KEY_ID" || -z "$YA_AWS_SECRET_ACCESS_KEY" ]]; then
        echo "Error: YA_AWS_ACCESS_KEY_ID or YA_AWS_SECRET_ACCESS_KEY is not set, you need to set them."
        exit 1
    fi
    export AWS_ACCESS_KEY_ID=${YA_AWS_ACCESS_KEY_ID}
    export AWS_SECRET_ACCESS_KEY=${YA_AWS_SECRET_ACCESS_KEY}
    ;;
  scaleway)
    export RESTIC_REPOSITORY="s3://s3.fr-par.scw.cloud/luixo-archive/restic"
    if [[ -z "$SCW_AWS_ACCESS_KEY_ID" || -z "$SCW_AWS_SECRET_ACCESS_KEY" ]]; then
        echo "Error: SCW_AWS_ACCESS_KEY_ID or SCW_AWS_SECRET_ACCESS_KEY is not set, you need to set them."
        exit 1
    fi
    export AWS_ACCESS_KEY_ID=${SCW_AWS_ACCESS_KEY_ID}
    export AWS_SECRET_ACCESS_KEY=${SCW_AWS_SECRET_ACCESS_KEY}
    ;;
  *)
    echo "Invalid repository choice: $REPO_CHOICE. Must be one of: nas, yandex, scaleway"
    exit 1
    ;;
esac

# Parse optional flags
INCLUDE=""
EXCLUDE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --include)
      INCLUDE="$2"
      shift 2
      ;;
    --exclude)
      EXCLUDE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Get list of plans
echo "Fetching available plans from restic..."
plans_json=$(~/.local/share/backrest/restic snapshots --json)
plans=($(echo "$plans_json" | jq -r '.[] | select(.tags | contains(["created-by:laptop"])) | .tags[] | select(test("^plan:")) | sub("^plan:";"")' | sort -u))

echo "Available plans: $plans"

# Apply include/exclude filtering
if [[ -n "$INCLUDE" ]]; then
  IFS=',' read -r -A include_arr <<< "$INCLUDE"
  plans=(${plans[@]#(#m)^$INCLUDE$})
  plans=(${plans[@]#(#i)*}) # Ensure proper filtering
  plans=($(printf "%s\n" "${plans[@]}" | grep -E "$(printf "%s|" "${include_arr[@]}" | sed 's/|$//')"))
elif [[ -n "$EXCLUDE" ]]; then
  IFS=',' read -r -A exclude_arr <<< "$EXCLUDE"
  plans=($(printf "%s\n" "${plans[@]}" | grep -v -E "$(printf "%s|" "${exclude_arr[@]}" | sed 's/|$//')"))
fi

if [[ ${#plans[@]} -eq 0 ]]; then
  echo "No plans to restore after filtering."
  exit 1
fi

echo "Plans to restore: $plans"
# Create target directory
mkdir -p ~/Downloads/restored

# Restore in parallel
for plan in "${plans[@]}"; do
  target_dir=~/Downloads/restored/$plan
  mkdir -p "$target_dir"

  echo "Restoring plan: $plan -> $target_dir"

  ~/.local/share/backrest/restic restore latest --tag "plan:$plan" --target "$target_dir"
done

echo "All restores finished."
