#!/bin/bash
set -euo pipefail

# ============================================================
# Vercel プロジェクト作成 & GitHub連携 セットアップスクリプト
# ============================================================
# 使い方:
#   1. npx vercel login  でログイン済みであること
#   2. ./scripts/setup-vercel.sh を実行
# ============================================================

REPO_OWNER="yosuke1998kida"
REPO_NAME="client-dashboard"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Vercel セットアップ開始 ==="
echo "プロジェクトディレクトリ: $PROJECT_DIR"
echo ""

# Step 1: Vercel認証チェック
echo "[1/4] Vercel認証を確認中..."
if ! npx vercel whoami 2>/dev/null; then
  echo "❌ Vercel未ログイン。先に npx vercel login を実行してください。"
  exit 1
fi
echo "✅ Vercel認証OK"
echo ""

# Step 2: Vercelプロジェクト作成（リンク）
echo "[2/4] Vercelプロジェクトを作成中..."
cd "$PROJECT_DIR"

# --yes で対話なしでプロジェクトをリンク/作成
npx vercel link --yes 2>&1
echo "✅ Vercelプロジェクト作成完了"
echo ""

# Step 3: GitHub連携の確認
echo "[3/4] GitHub連携を確認中..."
echo "リポジトリ: https://github.com/${REPO_OWNER}/${REPO_NAME}"
echo ""
echo "📌 Vercelダッシュボードで以下を確認してください:"
echo "   1. https://vercel.com にログイン"
echo "   2. プロジェクト > Settings > Git"
echo "   3. Connected Git Repository が ${REPO_OWNER}/${REPO_NAME} であること"
echo "   4. Production Branch が 'main' であること"
echo ""

# Step 4: 初回デプロイ（プロダクション）
echo "[4/4] 初回プロダクションデプロイを実行中..."
npx vercel --prod --yes 2>&1

echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "📋 デプロイ設定:"
echo "   フレームワーク: Next.js"
echo "   ビルドコマンド: npm run build"
echo "   出力ディレクトリ: .next"
echo "   自動デプロイ: mainブランチpush時"
echo ""
echo "🔗 次のステップ:"
echo "   - Vercelダッシュボードでドメイン設定"
echo "   - 環境変数の追加（必要に応じて）"
echo "   - mainブランチにpushして自動デプロイを確認"
