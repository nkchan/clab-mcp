# clab-mcp
containerlab MCP
# clab-mcp (Containerlab MCP Server)

Containerlab環境を操作・管理するためのPythonベースのMCP (Model Context Protocol) サーバーです。
別ホストからSSH（Fabric）を経由して、ターゲット環境のContainerlabのデプロイやコマンド実行をサポートします。

## 環境構築

パッケージ管理および仮想環境の構築には `uv` を使用します。

### 1. `uv` のインストール
まだインストールしていない場合は、公式の手順に従ってインストールしてください。
(例: `curl -LsSf https://astral.sh/uv/install.sh | sh`)

### 2. 仮想環境の作成と有効化
```bash
uv venv
source .venv/bin/activate
```

### 3. 依存パッケージのインストール
```bash
uv pip install -r requirements.txt
```

### 4. 環境変数の設定
環境変数のテンプレートファイルをコピーし、実際のSSH接続情報を入力してください。
```bash
cp lab.env.example lab.env
```

### 5. 実行方法
Claude Desktop などの MCP クライアントに、このリポジトリの `server.py` を登録して使用します。
