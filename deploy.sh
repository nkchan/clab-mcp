#!/bin/bash
set -e

echo "Starting deployment..."

# lab.env から環境変数を読み込む
if [ -f "lab.env" ]; then
    # コメント行を除外して環境変数をエクスポート
    export $(grep -v '^#' lab.env | xargs)
else
    echo "Error: lab.env not found. Please setup lab.env from lab.env.example first."
    exit 1
fi

if [ -z "$TARGET_HOST" ] || [ -z "$SSH_USERNAME" ]; then
    echo "Error: TARGET_HOST or SSH_USERNAME is not set in lab.env."
    exit 1
fi

REMOTE_TARGET="${SSH_USERNAME}@${TARGET_HOST}"
REMOTE_DIR="~/clab-mcp"

echo "Syncing files to ${REMOTE_TARGET}:${REMOTE_DIR}..."

# rsyncを使用してファイルを転送 (仮想環境、キャッシュ、環境変数ファイル、Git履歴は除外)
rsync -avz --exclude='.venv' --exclude='__pycache__' --exclude='.git' --exclude='lab.env' ./ "${REMOTE_TARGET}:${REMOTE_DIR}/"

echo "Setting up environment on target host..."

# リモートホスト上で uv の確認と依存関係のインストールを実行
ssh "${REMOTE_TARGET}" << 'EOF'
    cd ~/clab-mcp
    if ! command -v uv &> /dev/null; then
        echo "uv not found on target host. Please install uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
    uv venv
    uv pip install -r requirements.txt
    echo "Deployment and environment setup completed successfully!"
EOF